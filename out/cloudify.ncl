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
      "_js2n__-:definitions/ansiblePlaybookConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  additional_args =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  additional_playbook_files =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  ansible_become =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                  ansible_env_vars =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              ANSIBLE_HOST_KEY_CHECKING =
                                _js2n__-prdslib.isType '"Bool",
                              ANSIBLE_INVALID_TASK_ATTRIBUTE_FAILED =
                                _js2n__-prdslib.isType '"Bool",
                            } {} true _js2n__-prdslib.always
                        ],
                  ansible_playbook_executable_path =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  debug_level =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate",
                  options_config = _js2n__-prdslib.isType 'Record,
                  playbook_path =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  playbook_source_path =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  remerge_sources =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                  run_data = _js2n__-prdslib.isType 'Record,
                  save_playbook =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                  scp_extra_args =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  sensitive_keys =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  sftp_extra_args =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  site_yaml_path =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  sources =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  ssh_common_args =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  ssh_extra_args =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  start_at_task =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  timeout =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/ansiblePlaybookInputs!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  additional_args = _js2n__-prdslib.isType '"String",
                  ansible_env_vars = _js2n__-prdslib.isType '"String",
                  ansible_playbook_executable_path =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Record
                        ],
                  debug_level = _js2n__-prdslib.isType '"String",
                  options_config = _js2n__-prdslib.isType '"String",
                  playbook_path = _js2n__-prdslib.isType '"String",
                  playbook_source_path =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Record
                        ],
                  remerge_sources = _js2n__-prdslib.isType '"String",
                  run_data = _js2n__-prdslib.isType '"String",
                  save_playbook = _js2n__-prdslib.isType '"String",
                  scp_extra_args = _js2n__-prdslib.isType '"String",
                  sensitive_keys = _js2n__-prdslib.isType '"String",
                  sftp_extra_args = _js2n__-prdslib.isType '"String",
                  site_yaml_path = _js2n__-prdslib.isType '"String",
                  sources = _js2n__-prdslib.isType '"String",
                  ssh_common_args = _js2n__-prdslib.isType '"String",
                  ssh_extra_args = _js2n__-prdslib.isType '"String",
                  start_at_task = _js2n__-prdslib.isType '"String",
                  timeout = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/awsClientConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  aws_access_key_id =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  aws_secret_access_key =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  region_name =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/awsConnectionConfig!predicate"
        | doc "A dictionary of values to pass to authenticate with the AWS API."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  aws_access_key_id =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  aws_secret_access_key =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  region_name =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyGetStringOrAwsRegion!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/awsRegion!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "us-east-1",
                  "us-east-2",
                  "us-west-1",
                  "us-west-2",
                  "af-south-1",
                  "ap-east-1",
                  "ap-south-1",
                  "ap-southeast-1",
                  "ap-northeast-2",
                  "ap-northeast-3",
                  "ap-northeast-1",
                  "ap-southeast-2",
                  "ca-central-1",
                  "cn-north-1",
                  "cn-northwest-1",
                  "eu-central-1",
                  "eu-west-1",
                  "eu-west-2",
                  "eu-south-1",
                  "eu-west-3",
                  "eu-north-1",
                  "me-south-1",
                  "sa-east-1",
                  "us-gov-east-1",
                  "us-gov-west-1"
                ]
            ],
      "_js2n__-:definitions/awsResourceId!predicate"
        | doc m%"
          The AWS resource ID of the external resource, if
          use_external_resource is true. Otherwise it is an empty string.
        "%
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType '"Bool",
              _js2n__-refsenv."_js2n__-:definitions/cloudifyGetIntrinsicFunction!predicate"
            ],
      "_js2n__-:definitions/cloudifyDataTypesAgentConfig!predicate"
        | doc "Cloudify agent configuration schema."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "install_method" ],
              _js2n__-prdslib.records.record
                {
                  disable_requiretty =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                  env = _js2n__-prdslib.always,
                  extra = _js2n__-prdslib.isType 'Record,
                  heartbeat =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate",
                  install_method =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  key =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  max_workers =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate",
                  min_workers =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate",
                  network =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  password =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  port =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate",
                  process_management = _js2n__-prdslib.isType 'Record,
                  service_name =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  user =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/cloudifyDatatypesAzureComputeAvailabilitySetConfig!predicate"
        | doc "See https://msdn.microsoft.com/en-us/library/mt163607.aspx"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  platformFaultDomainCount =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate",
                  platformUpdateDomainCount =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate",
                  sku = _js2n__-prdslib.isType 'Record,
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/cloudifyDatatypesAzureComputeManagedClusterConfig!predicate"
        | doc "See https://docs.microsoft.com/en-us/rest/api/aks/managedclusters"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  addon_profiles = _js2n__-prdslib.isType 'Record,
                  agent_pool_profiles =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.record
                                      {
                                        availabilityZones =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType '"Array",
                                                _js2n__-prdslib.arrays.arrayOf
                                                  (_js2n__-prdslib.isType
                                                    '"String")
                                              ],
                                        count =
                                          _js2n__-prdslib.isType '"Number",
                                        enableNodePublicIP =
                                          _js2n__-prdslib.isType '"Bool",
                                        name = _js2n__-prdslib.isType 'Record,
                                        osType =
                                          _js2n__-prdslib.isType '"String",
                                        vmSize =
                                          _js2n__-prdslib.isType '"String",
                                      } {} true _js2n__-prdslib.always
                                  ]
                              ])
                        ],
                  dns_prefix =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  enable_rbac =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                  kubernetes_version =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  linux_profile = _js2n__-prdslib.isType 'Record,
                  location =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  network_profile = _js2n__-prdslib.isType 'Record,
                  service_principal_profile = _js2n__-prdslib.isType 'Record,
                  tags = _js2n__-prdslib.isType 'Record,
                  windows_profile = _js2n__-prdslib.isType 'Record,
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/cloudifyDatatypesAzureComputeVirtualMachineConfig!predicate"
        | doc "https://msdn.microsoft.com/en-us/library/azure/mt163591.aspx"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  hardwareProfile =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  osProfile = _js2n__-prdslib.isType 'Record,
                  spot_instance =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureComputeVirtualMachineSpotConfig!predicate",
                  storageProfile =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/cloudifyDatatypesAzureComputeVirtualMachineSpotConfig!predicate"
        | doc "check the parameters from this link : https://www.shorturl.at/wHTU2"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  billing_profile = _js2n__-prdslib.isType 'Record,
                  eviction_policy =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  is_spot_instance =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                  "priority" =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/cloudifyDatatypesAzureConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  certificate =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  client_id =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  client_secret =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  cloud_environment =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  endpoint_resource =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  endpoint_verify =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                  endpoints_active_directory =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  endpoints_resource_manager =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  scale_name_separator =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  scale_name_suffix_chars =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  subscription_id =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  tenant_id =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  thumbprint =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/cloudifyDatatypesAzureNetworkIPConfigurationConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "privateIPAllocationMethod" ],
              _js2n__-prdslib.records.record
                {
                  privateIPAddress =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  privateIPAllocationMethod =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/cloudifyDatatypesAzureNetworkLoadBalancerConfig!predicate"
        | doc "See https://msdn.microsoft.com/en-us/library/mt163574.aspx"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  backendAddressPools =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  frontendIPConfigurations =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  inboundNatRules =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  loadBalancingRules =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  probes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/cloudifyDatatypesAzureNetworkLoadBalancerIncomingNATRuleConfig!predicate"
        | doc "See https://msdn.microsoft.com/en-us/library/mt163574.aspx"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "backendPort", "frontendPort", "protocol" ],
              _js2n__-prdslib.records.record
                {
                  backendPort =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate",
                  frontendPort =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate",
                  protocol =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/cloudifyDatatypesAzureNetworkLoadBalancerProbeConfig!predicate"
        | doc "See https://msdn.microsoft.com/en-us/library/mt163574.aspx"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "port" ],
              _js2n__-prdslib.records.record
                {
                  intervalInSeconds =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate",
                  numberOfProbes =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate",
                  port =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate",
                  protocol =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  requestPath =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/cloudifyDatatypesAzureNetworkLoadBalancerRuleConfig!predicate"
        | doc "See https://msdn.microsoft.com/en-us/library/mt163574.aspx"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "backendPort", "frontendPort", "protocol" ],
              _js2n__-prdslib.records.record
                {
                  backendPort =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate",
                  enableFloatingIP =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                  frontendPort =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate",
                  idleTimeoutInMinutes =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate",
                  loadDistribution =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  protocol =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/cloudifyDatatypesAzureNetworkNetworkInterfaceCardConfig!predicate"
        | doc "See https://msdn.microsoft.com/en-us/library/mt163668.aspx"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  dnsSettings =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  ipConfigurations =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  networkSecurityGroups =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/cloudifyDatatypesAzureNetworkNetworkSecurityGroupConfig!predicate"
        | doc "See https://msdn.microsoft.com/en-us/library/mt163656.aspx"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  securityRules =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType 'Record)
                            ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/cloudifyDatatypesAzureNetworkNetworkSecurityRuleConfig!predicate"
        | doc "See https://msdn.microsoft.com/en-us/library/mt163645.aspx"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [
                  "access",
                  "destinationAddressPrefix",
                  "direction",
                  "priority",
                  "protocol",
                  "sourceAddressPrefix"
                ],
              _js2n__-prdslib.records.record
                {
                  access =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  description =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  destinationAddressPrefix =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  destinationPortRange =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  direction =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  "priority" =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate",
                  protocol =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  sourceAddressPrefix =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  sourcePortRange =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/cloudifyDatatypesAzureNetworkPublicIPAddressConfig!predicate"
        | doc "See https://msdn.microsoft.com/en-us/library/mt163590.aspx"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "publicIPAllocationMethod" ],
              _js2n__-prdslib.records.record
                {
                  domainNameLabel =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  idleTimeoutInMinutes =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate",
                  publicIPAllocationMethod =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  reverseFqdn =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/cloudifyDatatypesAzureNetworkRouteConfig!predicate"
        | doc "See https://msdn.microsoft.com/en-us/library/mt459110.aspx"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "addressPrefix", "nextHopType" ],
              _js2n__-prdslib.records.record
                {
                  addressPrefix =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Record
                        ],
                  nextHopIpAddress = _js2n__-prdslib.isType '"String",
                  nextHopType = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/cloudifyDatatypesAzureNetworkRouteTableConfig!predicate"
        | doc "See https://msdn.microsoft.com/en-us/library/mt502548.aspx"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  routes =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/cloudifyDatatypesAzureNetworkSubnetConfig!predicate"
        | doc "See https://msdn.microsoft.com/en-us/library/mt163621.aspx"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  addressPrefix =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  networkSecurityGroup =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate",
                  routeTable =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/cloudifyDatatypesAzureNetworkVirtualNetworkConfig!predicate"
        | doc "See https://msdn.microsoft.com/en-us/library/mt163661.aspx"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "addressSpace" ],
              _js2n__-prdslib.records.record
                {
                  addressSpace = _js2n__-prdslib.isType 'Record,
                  dhcpOptions = _js2n__-prdslib.isType 'Record,
                  subnets = _js2n__-prdslib.isType 'Record,
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/cloudifyDatatypesAzureStorageDataDiskConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "size" ],
              _js2n__-prdslib.records.record
                {
                  container_name =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  force_delete =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                  size =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/cloudifyDatatypesAzureStorageFileShareConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  fail_on_exist =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                  metadata = _js2n__-prdslib.isType 'Record,
                  quota =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/cloudifyDatatypesAzureStorageStorageAccountConfig!predicate"
        | doc "See https://msdn.microsoft.com/en-us/library/mt163564.aspx"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  accountType =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  encryption = _js2n__-prdslib.isType 'Record,
                  keySource = _js2n__-prdslib.isType 'Record,
                  networkAcls = _js2n__-prdslib.isType 'Record,
                  supportsHttpsTrafficOnly = _js2n__-prdslib.isType 'Record,
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/cloudifyDatatypesBlueprint!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  blueprint_archive =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  external_resource =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                  id = _js2n__-prdslib.always,
                  main_file_name =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/cloudifyDatatypesDeployment!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  all_outputs =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                  external_resource =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                  id =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  inputs = _js2n__-prdslib.isType 'Record,
                  logs = _js2n__-prdslib.isType 'Record,
                  outputs = _js2n__-prdslib.isType 'Record,
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/cloudifyDatatypesDeploymentProxy!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "blueprint", "deployment" ],
              _js2n__-prdslib.records.record
                {
                  blueprint =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesBlueprint!predicate",
                  deployment =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesDeployment!predicate",
                  executions_start_args = _js2n__-prdslib.isType 'Record,
                  reexecute =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/cloudifyDatatypesFile!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "file_path", "mode", "owner", "resource_path" ],
              _js2n__-prdslib.records.record
                {
                  allow_failure =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                  file_path =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  mode =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate",
                  owner =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  resource_path =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  template_variables = _js2n__-prdslib.isType 'Record,
                  use_sudo =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/cloudifyDatatypesFtpAuth!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  ignore_host =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                  ip =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  password =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  port =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate",
                  tls =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                  user =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/cloudifyDatatypesHelmApiOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  api_key =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  host =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/cloudifyDatatypesHelmAuthenticationVariant!predicate"
        | doc m%"
          Type representing all authentication variants.
           for different Kubernetes cloud providers.
           Each property represents separate supported variant of authentication.
           You should choose one variant and fill in only on property.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  gcp_service_account =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/cloudifyDatatypesHelmClientConfig!predicate"
        | doc m%"
          Configuration properties for Helm to interact with kubernetes cluster.
           If kube_config file not provided then kube_token and kube_api_server should provided.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  authentication =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesHelmAuthenticationVariant!predicate",
                  configuration =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesHelmConfigurationVariant!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/cloudifyDatatypesHelmConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  executable_path =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/cloudifyDatatypesHelmConfigurationVariant!predicate"
        | doc m%"
          Type representing all Kubernetes API configuration variants. Each property represents separate supported variant of configuration. For now, until Helm support "--insecure" one of "blueprint_file_name",
                "manager_file_path" and "file_content" must be used.
                "api_key" inputs will override kubeconfig data.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  api_options =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesHelmApiOptions!predicate",
                  blueprint_file_name =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  file_content =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  manager_file_path =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/cloudifyDatatypesHelmReleaseConfig!predicate"
        | doc "configuration properties for release node type."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "chart", "name" ],
              _js2n__-prdslib.records.record
                {
                  chart =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  flags =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesHelmSetFlagsList!predicate",
                  name =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  set_values =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesHelmSetFlagsList!predicate",
                  values_file =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/cloudifyDatatypesHelmRepoConfig!predicate"
        | doc "configuration properties for repo node type."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name", "repo_url" ],
              _js2n__-prdslib.records.record
                {
                  flags =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesHelmSetFlagsList!predicate",
                  name =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  repo_url =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/cloudifyDatatypesHelmSetFlagsList!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        name = _js2n__-prdslib.isType '"String",
                        value = _js2n__-prdslib.always,
                      } {} true _js2n__-prdslib.always
                  ]),
              _js2n__-prdslib.records.record {} {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/cloudifyDatatypesKey!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  algorithm =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  bits =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate",
                  comment =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  key_name =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  openssh_format =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                  passphrase =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  private_key_path =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  public_key_path =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  unvalidated = _js2n__-prdslib.always,
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/cloudifyDatatypesNode!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  id =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/cloudifyDatatypesNodeInstance!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  id =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  node =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesNode!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/cloudifyDatatypesNodeInstanceProxy!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "blueprint", "deployment" ],
              _js2n__-prdslib.records.record
                {
                  blueprint =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesBlueprint!predicate",
                  deployment =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesDeployment!predicate",
                  executions_start_args = _js2n__-prdslib.isType 'Record,
                  node_instance =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesNodeInstance!predicate",
                  reexecute =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/cloudifyDatatypesTerminalAuth!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  criticals =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  errors =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  exit_command =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  ip =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  key_content =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  password =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  port =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate",
                  promt_check =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  smart_device =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                  store_logs =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                  user =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  warnings =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/cloudifyGetAttribute!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  get_attribute =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/cloudifyGetInput!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  get_input =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/cloudifyGetIntrinsicFunction!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/cloudifyGetInput!predicate",
              _js2n__-refsenv."_js2n__-:definitions/cloudifyGetSecret!predicate",
              _js2n__-refsenv."_js2n__-:definitions/cloudifyGetAttribute!predicate",
              _js2n__-refsenv."_js2n__-:definitions/cloudifyGetProperty!predicate"
            ],
      "_js2n__-:definitions/cloudifyGetProperty!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  get_property =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/cloudifyGetSecret!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  get_secret =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/cloudifyGetStringOrAwsRegion!predicate"
        | doc m%"
          The server region name, such as us-east-1.
          (Not us-east-1b, which is an availability zone, or
          US East, which is a Region.)
          US East (N. Virginia) - us-east-1
          US East (Ohio) - us-east-2
          US West (N. California) - us-west-1
          US West (Oregon) - us-west-2
          Africa (Cape Town) - af-south-1
          Asia Pacific (Hong Kong) - ap-east-1
          Asia Pacific (Mumbai) - ap-south-1
          Asia Pacific (Seoul) - ap-northeast-2
          Asia Pacific (Osaka-Local) - ap-northeast-3
          Asia Pacific (Singapore) - ap-southeast-1
          Asia Pacific (Sydney) - ap-southeast-2
          Asia Pacific (Tokyo) - ap-northeast-1
          Canada (Central) - ca-central-1
          China (Beijing) - cn-north-1
          China (Ningxia) - cn-northwest-1
          Europe (Frankfurt) - eu-central-1
          Europe (Ireland) - eu-west-1
          Europe (London) - eu-west-2
          Europe (Milan) - eu-south-1
          Europe (Paris) - eu-west-3
          Europe (Stockholm) - eu-north-1
          Middle East (Bahrain) - me-south-1
          South America (São Paulo) - sa-east-1
          AWS GovCloud (US-East) - us-gov-east-1
          AWS GovCloud (US) - us-gov-west-1
        "%
        = _js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/awsRegion!predicate",
              _js2n__-refsenv."_js2n__-:definitions/cloudifyGetInput!predicate"
            ],
      "_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType 'Integer,
              _js2n__-refsenv."_js2n__-:definitions/cloudifyGetIntrinsicFunction!predicate"
            ],
      "_js2n__-:definitions/cloudifyStringOrGetInput!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-refsenv."_js2n__-:definitions/cloudifyGetIntrinsicFunction!predicate"
            ],
      "_js2n__-:definitions/dataType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  derived_from = _js2n__-prdslib.isType '"String",
                  description = _js2n__-prdslib.isType '"String",
                  properties = _js2n__-prdslib.isType 'Record,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/dataTypes!contract"
        | doc "To use data_types, the definitions version must be cloudify_dsl_1_2 or higher."
        = _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType 'Record,
                _js2n__-prdslib.records.record {}
                  {
                    "" =
                      _js2n__-refsenv."_js2n__-:definitions/dataType!predicate",
                  } true _js2n__-prdslib.always
              ]),
      "_js2n__-:definitions/dockerClientConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  docker_host =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  docker_rest_port =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/dockerInstallationConfig!predicate"
        | doc "Docker Installation type"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  install_script =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  install_url =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/dockerMachine!predicate"
        | doc "Docker Machine IP,User,Private_key"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  container_volume =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  docker_ip =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  docker_key =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  docker_user =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/gcpExternalResource!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { use_external_resource = _js2n__-prdslib.isType '"Bool", } {}
                true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/gcpResourceId!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { resource_id = _js2n__-prdslib.isType '"String", } {} true
                _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/inputProperty!predicate"
        | doc "inputs are parameters that are injected into a blueprint when a deployment is created. These parameters can be referenced by using the get_input intrinsic function."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  constraints =
                    _js2n__-refsenv."_js2n__-:definitions/inputPropertyConstraints!predicate",
                  "default" = _js2n__-prdslib.always,
                  description = _js2n__-prdslib.isType '"String",
                  required = _js2n__-prdslib.isType '"Bool",
                  type =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [
                                  "string",
                                  "integer",
                                  "float",
                                  "boolean",
                                  "list",
                                  "dict",
                                  "regex"
                                ]
                            ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/inputPropertyConstraints!predicate"
        | doc "The constraints the input value must comply with. Read more details about the format and usage of the constraints in the Constraints section below."
        = _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      equal =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Number",
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.isType 'Integer
                            ],
                      greater_or_equal =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Number",
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.isType 'Integer
                            ],
                      greater_than =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Number",
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.isType 'Integer
                            ],
                      less_or_equal =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Number",
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.isType 'Integer
                            ],
                      less_than =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Number",
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.isType 'Integer
                            ],
                    } {} true _js2n__-prdslib.always
                ],
              _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/kubernetesTypesAbstractResource!predicate"
        | doc m%"
          Type defining common base structure for any Kubernetes resource
          It is some kind of wrapper for native Kubernetes YAML definition
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "kind" ],
              _js2n__-prdslib.records.record
                {
                  apiVersion =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  kind =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  metadata = _js2n__-prdslib.isType 'Record,
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/kubernetesTypesApiMapping!predicate"
        | doc "Type containing python Kubernetes API objects and methods definitions for all supported operations"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  create =
                    _js2n__-refsenv."_js2n__-:definitions/kubernetesTypesApiMappingEntry!predicate",
                  delete =
                    _js2n__-refsenv."_js2n__-:definitions/kubernetesTypesApiMappingEntry!predicate",
                  read =
                    _js2n__-refsenv."_js2n__-:definitions/kubernetesTypesApiMappingEntry!predicate",
                  update =
                    _js2n__-refsenv."_js2n__-:definitions/kubernetesTypesApiMappingEntry!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/kubernetesTypesApiMappingEntry!predicate"
        | doc "Type defining python Kubernetes API objects and methods definitions for particular operation"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "api", "method" ],
              _js2n__-prdslib.records.record
                {
                  api =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  method =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  payload =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/kubernetesTypesAuthenticationVariant!predicate"
        | doc m%"
          Type representing all authentication variants
          for different Kubernetes cloud providers.
          Each property represents separate supported variant of authentication.
          You should choose one variant and fill in only on property.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  gcp_service_account =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/kubernetesTypesClientConfig!predicate"
        | doc m%"
          Configuration properties of kubernetes API and
          authentication properties of Kubernetes Cloud providers.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  authentication =
                    _js2n__-refsenv."_js2n__-:definitions/kubernetesTypesAuthenticationVariant!predicate",
                  configuration =
                    _js2n__-refsenv."_js2n__-:definitions/kubernetesTypesConfigurationVariant!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/kubernetesTypesClusterRoleDefinitio!predicate"
        | doc m%"
          Type defining single Kubernetes resource e.g. ClusterRole, ...
          It is some kind of wrapper for native Kubernetes YAML definition
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-refsenv."_js2n__-:definitions/kubernetesTypesAbstractResource!predicate"
            ],
      "_js2n__-:definitions/kubernetesTypesConfigClassResourceDefinition!predicate"
        | doc m%"
          Type defining Kubernetes resource for storing data.
          It is some kind of wrapper for native Kubernetes YAML definition
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/kubernetesTypesResourceDefinition!predicate",
                  _js2n__-prdslib.records.record
                    { data = _js2n__-prdslib.isType 'Record, } {} true
                    _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/kubernetesTypesConfigurationVariant!predicate"
        | doc m%"
          Type representing all Kubernetes API configuration variants.
          Each property represents separate supported variant of configuration.
          You should choose one variant and fill in only on property.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  api_options =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              api_key =
                                _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                              cert_file =
                                _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                              debug =
                                _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                              host =
                                _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                              key_file =
                                _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                              ssl_ca_cert =
                                _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                              verify_ssl =
                                _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                            } {} true _js2n__-prdslib.always
                        ],
                  blueprint_file_name =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  file_content =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  manager_file_path =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/kubernetesTypesFileResource!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  resource_path =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  target_path =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  template_variables = _js2n__-prdslib.isType 'Record,
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/kubernetesTypesResourceDefinition!predicate"
        | doc m%"
          Type defining single Kubernetes resource e.g. Pod, Service, ...
          It is some kind of wrapper for native Kubernetes YAML definition
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/kubernetesTypesAbstractResource!predicate",
                  _js2n__-prdslib.records.record
                    { spec = _js2n__-prdslib.isType 'Record, } {} true
                    _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/kubernetesTypesRoleBindingDefinitio!predicate"
        | doc m%"
          Type defining single Kubernetes resource e.g. Pod, Service, ...
          It is some kind of wrapper for native Kubernetes YAML definition
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/kubernetesTypesAbstractResource!predicate",
                  _js2n__-prdslib.records.record
                    {
                      roleRef = _js2n__-prdslib.isType 'Record,
                      subjects =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate"
                            ],
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/kubernetesTypesRoleDefinitio!predicate"
        | doc m%"
          Type defining single Kubernetes resource e.g. Role, ...
          It is some kind of wrapper for native Kubernetes YAML definition
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/kubernetesTypesAbstractResource!predicate",
                  _js2n__-prdslib.records.record
                    {
                      rules =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate"
                            ],
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/kubernetesTypesSecretDefinition!predicate"
        | doc m%"
          Secret holds secret data of a certain type.
          The total bytes of the values in the Data field must be less than MaxSecretSize bytes
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/kubernetesTypesAbstractResource!predicate",
                  _js2n__-prdslib.records.record
                    {
                      data = _js2n__-prdslib.isType 'Record,
                      stringData = _js2n__-prdslib.isType 'Record,
                      type =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/kubernetesTypesServiceAccountDefinition!predicate"
        | doc m%"
          ServiceAccount binds together: a name, understood by users,
          and perhaps by peripheral systems, for an identity a principal
          that can be authenticated and authorized * a set of secrets
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/kubernetesTypesAbstractResource!predicate",
                  _js2n__-prdslib.records.record
                    {
                      automountServiceAccountToken =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                      imagePullSecrets =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate"
                            ],
                      secrets =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate"
                            ],
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/kubernetesTypesStorageClassResourceDefinition!predicate"
        | doc m%"
          Type defining single Kubernetes resource e.g. StorageClass
          It is some kind of wrapper for native Kubernetes YAML definition
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/kubernetesTypesAbstractResource!predicate",
                  _js2n__-prdslib.records.record
                    {
                      parameters = _js2n__-prdslib.isType 'Record,
                      provisioner = _js2n__-prdslib.isType 'Record,
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/nodeTemplate!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const "cloudify.nodes.aws.ec2.Vpc",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeAWSEC2VPC!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.nodes.aws.ec2.InternetGateway",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeAWSInternetGateway!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const "cloudify.nodes.aws.ec2.Subnet",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeAWSEC2Subnet!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.nodes.aws.ec2.RouteTable",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeAWSEC2RouteTable!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const "cloudify.nodes.aws.ec2.Route",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeAWSEC2Route!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.nodes.aws.ec2.ElasticIP",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeAWSEC2ElasticIP!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.nodes.aws.ec2.NATGateway",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeAWSEC2NATGateway!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.nodes.aws.ec2.SecurityGroup",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeAWSEC2SecurityGroup!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.nodes.aws.ec2.SecurityGroupRuleIngress",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeAWSEC2SecurityGroupRuleIngress!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.nodes.aws.ec2.Interface",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeAWSEC2Interface!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const "cloudify.nodes.aws.ec2.Image",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeAWSEC2Image!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.nodes.aws.ec2.Instances",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeAWSEC2Instances!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.nodes.aws.ec2.EBSVolume",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeAWSEC2EBSVolume!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.nodes.aws.ec2.EBSAttachment",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeAWSEC2EBSAttachment!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const "cloudify.nodes.docker.images",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeDockerImagesInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeDockerImagesProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.nodes.docker.containers",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeDockerContainersInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeDockerContainersProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const "cloudify.nodes.docker.host",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeDockerHostInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeDockerHostProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.nodes.docker.host_details",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeDockerHostDetailsInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeDockerHostDetailsProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const "cloudify.nodes.docker.image",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeDockerImageInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeDockerImageProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.nodes.docker.container",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeDockerContainerInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeDockerContainerProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.nodes.docker.container_files",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeDockerContainerFilesInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeDockerContainerFilesProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.nodes.docker.ansible_playbook",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeDockerAnsiblePlaybookInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeDockerAnsiblePlaybookProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.nodes.docker.terraform_module",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeDockerTerraformModuleInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeDockerTerraformModuleProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.kubernetes.nodes.Master",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesNodesMasterProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.kubernetes.resources.ResourceBase",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesResourceBase!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.kubernetes.resources.ResourceWithValidateStatus",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesResourceWithValidateStatus!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.kubernetes.resources.BlueprintDefinedResource",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesBlueprintDefinedResourceInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesBlueprintDefinedResource!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.kubernetes.resources.ClusterRoleBinding",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesBlueprintDefinedResourceInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesClusterRoleBindingProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.kubernetes.resources.RoleBinding",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesBlueprintDefinedResourceInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesRoleBinding!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.kubernetes.resources.Role",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesBlueprintDefinedResourceInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesRoleProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.kubernetes.resources.ClusterRole",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesBlueprintDefinedResourceInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesClusterRoleProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.kubernetes.resources.Secret",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesBlueprintDefinedResourceInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesSecretProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.kubernetes.resources.ServiceAccount",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesBlueprintDefinedResourceInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesServiceAccountProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.kubernetes.resources.Deployment",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesBlueprintDefinedResourceInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesDeploymentProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.kubernetes.resources.Node",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesBlueprintDefinedResourceInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesNodeProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.kubernetes.resources.Namespace",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesBlueprintDefinedResourceInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesNamespaceProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.kubernetes.resources.Pod",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesBlueprintDefinedResourceInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesPodProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.kubernetes.resources.ReplicaSet",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesBlueprintDefinedResourceInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesReplicaSetProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.kubernetes.resources.ReplicationController",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesBlueprintDefinedResourceInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesReplicationControllerProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.kubernetes.resources.DaemonSet",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesBlueprintDefinedResourceInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesDaemonSetProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.kubernetes.resources.CustomResourceDefinition",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesBlueprintDefinedResourceInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesCustomResourceDefinitionProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.kubernetes.resources.Service",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesBlueprintDefinedResourceInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesServiceProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.kubernetes.resources.PersistentVolume",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesBlueprintDefinedResourceInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesPersistentVolumeProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.kubernetes.resources.ConfigMap",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesBlueprintDefinedResourceInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesConfigMapProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.kubernetes.resources.StorageClass",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesBlueprintDefinedResourceInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesStorageClassProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.kubernetes.resources.StatefulSet",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesBlueprintDefinedResourceInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesStatefulSetProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.kubernetes.resources.PodSecurityPolicy",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesBlueprintDefinedResourceInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesPodSecurityPolicyProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.kubernetes.resources.NetworkPolicy",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesBlueprintDefinedResourceInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesNetworkPolicyProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.kubernetes.resources.Ingress",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesBlueprintDefinedResourceInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesIngressProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.kubernetes.resources.PersistentVolumeClaim",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesBlueprintDefinedResourceInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesPersistentVolumeClaimProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.kubernetes.resources.CustomBlueprintDefinedResource",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesCustomBlueprintDefinedResourceInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesCustomBlueprintDefinedResourceProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.kubernetes.resources.CustomBlueprintDefinedResource",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesCustomBlueprintDefinedResourceInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesCustomBlueprintDefinedResourceProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.kubernetes.resources.FileDefinedResource",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesFileDefinedResourceInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesFileDefinedResourceProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.kubernetes.resources.MultipleFileDefinedResources",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesMultipleFileDefinedResourcesInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesMultipleFileDefinedResourcesProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type = _js2n__-prdslib.const "cloudify.nodes.terraform",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeTerraformInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeTerraformProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.nodes.terraform.Module",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeTerraformModuleInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeTerraformModuleProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.nodes.terraform.Module",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeTerraformModuleInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeTerraformModuleProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.nodes.ansible.Executor",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeAnsibleExecutorInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeAnsibleExecutorProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.nodes.openstack.NetworkBase",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeOpenstackNetworkBaseProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.nodes.openstack.Network",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeOpenstackNetworkInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeOpenstackNetworkProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.nodes.openstack.Subnet",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeOpenstackSubnetInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeOpenstackSubnetProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const "cloudify.nodes.openstack.Port",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeOpenstackPortInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeOpenstackPortProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.nodes.openstack.Router",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeOpenstackRouterInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeOpenstackRouterProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.nodes.openstack.FloatingIP",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeOpenstackFloatingIPInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeOpenstackFloatingIPProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.nodes.openstack.SecurityGroup",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeOpenstackSecurityGroupInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeOpenstackSecurityGroupProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.nodes.openstack.SecurityGroupRule",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeOpenstackSecurityGroupRuleInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeOpenstackSecurityGroupRuleProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.nodes.openstack.RBACPolicy",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeOpenstackRBACPolicyProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.nodes.openstack.Server",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeOpenstackServerProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.nodes.openstack.WindowsServer",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeOpenstackWindowsServerProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.nodes.openstack.KeyPair",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeOpenstackKeyPairInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeOpenstackKeyPairProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.nodes.openstack.HostAggregate",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeOpenstackHostAggregateInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeOpenstackHostAggregateProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.nodes.openstack.Image",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeOpenstackImageInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeOpenstackImageProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.nodes.openstack.Flavor",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeOpenstackFlavorInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeOpenstackFlavorProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const "cloudify.nodes.openstack.User",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeOpenstackUserInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeOpenstackUserProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.nodes.openstack.Group",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeOpenstackGroupInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeOpenstackGroupProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const "cloudify.nodes.openstack.Role",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeOpenstackRoleInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeOpenstackRoleProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.nodes.openstack.Project",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeOpenstackProjectInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeOpenstackProjectProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.nodes.openstack.Volume",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeOpenstackVolumeInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeOpenstackVolumeProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.nodes.openstack.VolumeType",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeOpenstackVolumeTypeInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeOpenstackVolumeTypeProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const "cloudify.nodes.openstack.Zone",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeOpenstackZoneInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeOpenstackZoneProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.nodes.openstack.RecordSet",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeOpenstackRecordSetInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeOpenstackRecordSetProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.nodes.DeploymentProxy",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyNodesDeploymentProxyInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyNodesDeploymentProxyProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.nodes.NodeInstanceProxy",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyNodesNodeInstanceProxyProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.nodes.CloudInit.CloudConfig",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyNodesCloudInitCloudConfigInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyNodesCloudInitCloudConfigProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const "cloudify.keys.nodes.RSAKey",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyNodesRSAKeyInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyNodesRSAKeyProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      { type = _js2n__-prdslib.const "cloudify.terminal.raw", }
                      {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyTerminalRawInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyTerminalRawProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      { type = _js2n__-prdslib.const "cloudify.nodes.File", } {}
                      true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyNodesFileInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyNodesFileProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      { type = _js2n__-prdslib.const "cloudify.nodes.ftp", } {}
                      true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyNodesFTPInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyNodesFTPProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      { type = _js2n__-prdslib.const "cloudify.rest.Requests", }
                      {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyRestRequestsInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyRestRequestsProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const "cloudify.rest.BunchRequests",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyRestBunchRequestsInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyRestBunchRequestsProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const "cloudify.nodes.secrets.Writer",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyNodesSecretsWriterInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyNodesSecretsWriterProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const "cloudify.nodes.secrets.Reader",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyNodesSecretsReaderInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyNodesSecretsReaderProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.azure.nodes.ResourceGroup",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyAzureNodesResourceGroupInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyAzureNodesResourceGroupProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.azure.nodes.storage.StorageAccount",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyAzureNodesStorageStorageAccountInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyAzureNodesStorageStorageAccountProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.azure.nodes.storage.DataDisk",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyAzureNodesStorageDataDisktInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyAzureNodesStorageDataDiskProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.azure.nodes.storage.FileShare",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyAzureNodesStorageFileShareInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyAzureNodesStorageFileShareProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.azure.nodes.network.VirtualNetwork",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyAzureNodesNetworkVirtualNetworkInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyAzureNodesNetworkVirtualNetworkProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.azure.nodes.network.NetworkSecurityGroup",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyAzureNodesNetworkNetworkSecurityGroupInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyAzureNodesNetworkNetworkSecurityGroupProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.azure.nodes.network.NetworkSecurityRule",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyAzureNodesNetworkNetworkSecurityRuleInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyAzureNodesNetworkNetworkSecurityRuleProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.azure.nodes.network.Subnet",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyAzureNodesNetworkSubnetInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyAzureNodesNetworkSubnetProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.azure.nodes.network.RouteTable",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyAzureNodesNetworkRouteTableInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyAzureNodesNetworkRouteTableProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.azure.nodes.network.Route",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyAzureNodesNetworkRouteInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyAzureNodesNetworkRouteProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.azure.nodes.network.NetworkInterfaceCard",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyAzureNodesNetworkNetworkInterfaceCardInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyAzureNodesNetworkNetworkInterfaceCardProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.azure.nodes.network.IPConfiguration",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyAzureNodesNetworkIPConfigurationProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.azure.nodes.network.PublicIPAddress",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyAzureNodesNetworkPublicIPAddressInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyAzureNodesNetworkPublicIPAddressProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.azure.nodes.compute.AvailabilitySet",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyAzureNodesComputeAvailabilitySetInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyAzureNodesComputeAvailabilitySetProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.azure.nodes.compute.VirtualMachine",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyAzureNodesComputeVirtualMachineInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyAzureNodesComputeVirtualMachineProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.azure.nodes.compute.WindowsVirtualMachine",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyAzureNodesComputeWindowsVirtualMachineInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyAzureNodesComputeWindowsVirtualMachineProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.azure.nodes.compute.VirtualMachineExtension",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyAzureNodesComputeVirtualMachineExtensionInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyAzureNodesComputeVirtualMachineExtensionProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.azure.nodes.network.LoadBalancer",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyAzureNodesNetworkLoadBalancerInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyAzureNodesNetworkLoadBalancerProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.azure.nodes.network.LoadBalancer.BackendAddressPool",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyAzureNodesNetworkLoadBalancerBackendAddressPoolInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyAzureNodesNetworkLoadBalancerBackendAddressPoolProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.azure.nodes.network.LoadBalancer.Probe",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyAzureNodesNetworkLoadBalancerProbeInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyAzureNodesNetworkLoadBalancerProbeProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.azure.nodes.network.LoadBalancer.IncomingNATRule",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyAzureNodesNetworkLoadBalancerIncomingNATRuleInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyAzureNodesNetworkLoadBalancerIncomingNATRuleProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.azure.nodes.network.LoadBalancer.Rule",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyAzureNodesNetworkLoadBalancerRuleInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyAzureNodesNetworkLoadBalancerRuleProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const "cloudify.azure.Deployment",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyAzureDeploymentInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyAzureDeploymentProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.azure.nodes.compute.ContainerService",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyAzureNodesComputeContainerServiceInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyAzureNodesComputeContainerServiceProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const "cloudify.azure.nodes.Plan",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyAzureNodesPlanInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyAzureNodesPlanProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const "cloudify.azure.nodes.WebApp",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyAzureNodesWebAppInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyAzureNodesWebAppProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.azure.nodes.PublishingUser",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyAzureNodesPublishingUserInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyAzureNodesPublishingUserProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const
                              "cloudify.azure.nodes.compute.ManagedCluster",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyAzureNodesComputeManagedClusterInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyAzureNodesComputeManagedClusterProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      { type = _js2n__-prdslib.const "cloudify.gcp.project", }
                      {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyGCPProjectInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyGCPProjectProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const "cloudify.gcp.nodes.Instance",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyGCPNodesInstanceInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyGCPNodesInstanceProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const "cloudify.nodes.helm.Binary",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeHelmBinaryProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type =
                          _js2n__-prdslib.const "cloudify.nodes.helm.Release",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeHelmReleaseInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeHelmReleaseProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        type = _js2n__-prdslib.const "cloudify.nodes.helm.Repo",
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        interfaces =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeHelmRepoInterfaces!predicate",
                        properties =
                          _js2n__-refsenv."_js2n__-:definitions/nodeTypeHelmRepoProperties!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always
                ],
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  capabilities = _js2n__-prdslib.isType 'Record,
                  instances = _js2n__-prdslib.isType 'Record,
                  interfaces =
                    _js2n__-refsenv."_js2n__-:definitions/nodeTemplateInterfaces!predicate",
                  properties = _js2n__-prdslib.isType 'Record,
                  relationships =
                    _js2n__-refsenv."_js2n__-:definitions/nodeTemplateRelationships!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.enum
                                    [
                                      "cloudify.nodes.Root",
                                      "cloudify.nodes.Tier",
                                      "cloudify.nodes.Compute",
                                      "cloudify.nodes.Container",
                                      "cloudify.nodes.Network",
                                      "cloudify.nodes.Subnet",
                                      "cloudify.nodes.Router",
                                      "cloudify.nodes.Port",
                                      "cloudify.nodes.VirtualIP",
                                      "cloudify.nodes.SecurityGroup",
                                      "cloudify.nodes.LoadBalancer",
                                      "cloudify.nodes.Volume",
                                      "cloudify.nodes.FileSystem",
                                      "cloudify.nodes.ObjectStorage",
                                      "cloudify.nodes.SoftwareComponent",
                                      "cloudify.nodes.WebServer",
                                      "cloudify.nodes.ApplicationServer",
                                      "cloudify.nodes.DBMS",
                                      "cloudify.nodes.MessageBugServer",
                                      "cloudify.nodes.ApplicationModule",
                                      "cloudify.nodes.Component",
                                      "cloudify.nodes.ServiceComponent",
                                      "cloudify.nodes.SharedResource",
                                      "cloudify.nodes.aws.dynamodb.Table",
                                      "cloudify.nodes.aws.iam.Group",
                                      "cloudify.nodes.aws.iam.AccessKey",
                                      "cloudify.nodes.aws.iam.LoginProfile",
                                      "cloudify.nodes.aws.iam.User",
                                      "cloudify.nodes.aws.iam.Role",
                                      "cloudify.nodes.aws.iam.RolePolicy",
                                      "cloudify.nodes.aws.iam.InstanceProfile",
                                      "cloudify.nodes.aws.iam.Policy",
                                      "cloudify.nodes.aws.lambda.Function",
                                      "cloudify.nodes.aws.lambda.Invoke",
                                      "cloudify.nodes.aws.lambda.Permission",
                                      "cloudify.nodes.aws.rds.Instance",
                                      "cloudify.nodes.aws.rds.InstanceReadReplica",
                                      "cloudify.nodes.aws.rds.SubnetGroup",
                                      "cloudify.nodes.aws.rds.OptionGroup",
                                      "cloudify.nodes.aws.rds.Option",
                                      "cloudify.nodes.aws.rds.ParameterGroup",
                                      "cloudify.nodes.aws.rds.Parameter",
                                      "cloudify.nodes.aws.route53.HostedZone",
                                      "cloudify.nodes.aws.route53.RecordSet",
                                      "cloudify.nodes.aws.SQS.Queue",
                                      "cloudify.nodes.aws.SNS.Topic",
                                      "cloudify.nodes.aws.SNS.Subscription",
                                      "cloudify.nodes.aws.elb.LoadBalancer",
                                      "cloudify.nodes.aws.elb.Classic.LoadBalancer",
                                      "cloudify.nodes.aws.elb.Classic.HealthCheck",
                                      "cloudify.nodes.aws.elb.Listener",
                                      "cloudify.nodes.aws.elb.Classic.Listener",
                                      "cloudify.nodes.aws.elb.Rule",
                                      "cloudify.nodes.aws.elb.TargetGroup",
                                      "cloudify.nodes.aws.elb.Classic.Policy",
                                      "cloudify.nodes.aws.elb.Classic.Policy.Stickiness",
                                      "cloudify.nodes.aws.s3.BaseBucket",
                                      "cloudify.nodes.aws.s3.BaseBucketObject",
                                      "cloudify.nodes.aws.s3.Bucket",
                                      "cloudify.nodes.aws.s3.BucketPolicy",
                                      "cloudify.nodes.aws.s3.BucketLifecycleConfiguration",
                                      "cloudify.nodes.aws.s3.BucketTagging",
                                      "cloudify.nodes.aws.s3.BucketObject",
                                      "cloudify.nodes.aws.ec2.BaseType",
                                      "cloudify.nodes.aws.ec2.Vpc",
                                      "cloudify.nodes.aws.ec2.VpcPeering",
                                      "cloudify.nodes.aws.ec2.VpcPeeringRequest",
                                      "cloudify.nodes.aws.ec2.VpcPeeringAcceptRequest",
                                      "cloudify.nodes.aws.ec2.VpcPeeringRejectRequest",
                                      "cloudify.nodes.aws.ec2.Subnet",
                                      "cloudify.nodes.aws.ec2.SecurityGroup",
                                      "cloudify.nodes.aws.ec2.SecurityGroupRuleIngress",
                                      "cloudify.nodes.aws.ec2.SecurityGroupRuleEgress",
                                      "cloudify.nodes.aws.ec2.NATGateway",
                                      "cloudify.nodes.aws.ec2.Interface",
                                      "cloudify.nodes.aws.ec2.Instances",
                                      "cloudify.nodes.aws.ec2.Keypair",
                                      "cloudify.nodes.aws.ec2.ElasticIP",
                                      "cloudify.nodes.aws.ec2.NetworkACL",
                                      "cloudify.nodes.aws.ec2.NetworkAclEntry",
                                      "cloudify.nodes.aws.ec2.DHCPOptions",
                                      "cloudify.nodes.aws.ec2.VPNGateway",
                                      "cloudify.nodes.aws.ec2.VPNConnection",
                                      "cloudify.nodes.aws.ec2.VPNConnectionRoute",
                                      "cloudify.nodes.aws.ec2.CustomerGateway",
                                      "cloudify.nodes.aws.ec2.InternetGateway",
                                      "cloudify.nodes.aws.ec2.RouteTable",
                                      "cloudify.nodes.aws.ec2.Route",
                                      "cloudify.nodes.aws.ec2.Image",
                                      "cloudify.nodes.aws.ec2.Tags",
                                      "cloudify.nodes.aws.ec2.EBSVolume",
                                      "cloudify.nodes.aws.ec2.EBSAttachment",
                                      "cloudify.nodes.aws.autoscaling.Group",
                                      "cloudify.nodes.aws.autoscaling.LaunchConfiguration",
                                      "cloudify.nodes.aws.autoscaling.Policy",
                                      "cloudify.nodes.aws.autoscaling.LifecycleHook",
                                      "cloudify.nodes.aws.autoscaling.NotificationConfiguration",
                                      "cloudify.nodes.aws.cloudwatch.Alarm",
                                      "cloudify.nodes.aws.cloudwatch.Rule",
                                      "cloudify.nodes.aws.cloudwatch.Event",
                                      "cloudify.nodes.aws.cloudwatch.Target",
                                      "cloudify.nodes.aws.efs.FileSystem",
                                      "cloudify.nodes.aws.efs.MountTarget",
                                      "cloudify.nodes.aws.efs.FileSystemTags",
                                      "cloudify.nodes.aws.kms.CustomerMasterKey",
                                      "cloudify.nodes.aws.kms.Alias",
                                      "cloudify.nodes.aws.kms.Grant",
                                      "cloudify.nodes.aws.CloudFormation.Stack",
                                      "cloudify.nodes.aws.ecs.Cluster",
                                      "cloudify.nodes.aws.ecs.Service",
                                      "cloudify.nodes.aws.ecs.TaskDefinition",
                                      "cloudify.nodes.swift.s3.Bucket",
                                      "cloudify.nodes.swift.s3.BucketObject",
                                      "cloudify.nodes.aws.eks.Cluster",
                                      "cloudify.nodes.aws.eks.NodeGroup",
                                      "cloudify.azure.nodes.storage.StorageAccount",
                                      "cloudify.azure.nodes.storage.DataDisk",
                                      "cloudify.azure.nodes.storage.FileShare",
                                      "cloudify.azure.nodes.network.VirtualNetwork",
                                      "cloudify.azure.nodes.network.NetworkSecurityGroup",
                                      "cloudify.azure.nodes.network.NetworkSecurityRule",
                                      "cloudify.azure.nodes.network.Subnet",
                                      "cloudify.azure.nodes.network.RouteTable",
                                      "cloudify.azure.nodes.network.Route",
                                      "cloudify.azure.nodes.network.NetworkInterfaceCard",
                                      "cloudify.azure.nodes.network.IPConfiguration",
                                      "cloudify.azure.nodes.network.PublicIPAddress",
                                      "cloudify.azure.nodes.compute.AvailabilitySet",
                                      "cloudify.azure.nodes.compute.VirtualMachine",
                                      "cloudify.azure.nodes.compute.WindowsVirtualMachine",
                                      "cloudify.azure.nodes.compute.VirtualMachineExtension",
                                      "cloudify.azure.nodes.network.LoadBalancer",
                                      "cloudify.azure.nodes.network.LoadBalancer.BackendAddressPool",
                                      "cloudify.azure.nodes.network.LoadBalancer.Probe",
                                      "cloudify.azure.nodes.network.LoadBalancer.IncomingNATRule",
                                      "cloudify.azure.nodes.network.LoadBalancer.Rule",
                                      "cloudify.azure.Deployment",
                                      "cloudify.azure.nodes.compute.ContainerService",
                                      "cloudify.azure.nodes.Plan",
                                      "cloudify.azure.nodes.WebApp",
                                      "cloudify.azure.nodes.PublishingUser",
                                      "cloudify.azure.nodes.compute.ManagedCluster",
                                      "cloudify.gcp.project",
                                      "cloudify.gcp.nodes.Instance",
                                      "cloudify.gcp.nodes.InstanceGroup",
                                      "cloudify.gcp.nodes.Volume",
                                      "cloudify.gcp.nodes.Snapshot",
                                      "cloudify.gcp.nodes.Network",
                                      "cloudify.gcp.nodes.SubNetwork",
                                      "cloudify.gcp.nodes.VPCNetworkPeering",
                                      "cloudify.gcp.nodes.Route",
                                      "cloudify.gcp.nodes.FirewallRule",
                                      "cloudify.gcp.nodes.SecurityGroup",
                                      "cloudify.gcp.nodes.Access",
                                      "cloudify.gcp.nodes.KeyPair",
                                      "cloudify.gcp.nodes.ExternalIP",
                                      "cloudify.gcp.nodes.GlobalAddress",
                                      "cloudify.gcp.nodes.StaticIP",
                                      "cloudify.gcp.nodes.Address",
                                      "cloudify.gcp.nodes.Image",
                                      "cloudify.gcp.nodes.HealthCheck",
                                      "cloudify.gcp.nodes.BackendService",
                                      "cloudify.gcp.nodes.RegionBackendService",
                                      "cloudify.gcp.nodes.UrlMap",
                                      "cloudify.gcp.nodes.TargetProxy",
                                      "cloudify.gcp.nodes.SslCertificate",
                                      "cloudify.gcp.nodes.ForwardingRule",
                                      "cloudify.gcp.nodes.GlobalForwardingRule",
                                      "cloudify.gcp.nodes.DNSZone",
                                      "cloudify.gcp.nodes.DNSRecord",
                                      "cloudify.gcp.nodes.DNSAAAARecord",
                                      "cloudify.gcp.nodes.DNSMXRecord",
                                      "cloudify.gcp.nodes.DNSNSRecord",
                                      "cloudify.gcp.nodes.DNSTXTRecord",
                                      "cloudify.gcp.nodes.KubernetesCluster",
                                      "cloudify.gcp.nodes.KubernetesNodePool",
                                      "cloudify.gcp.nodes.KubernetesClusterMonitoring",
                                      "cloudify.gcp.nodes.KubernetesClusterlegacyAbac",
                                      "cloudify.gcp.nodes.KubernetesClusterNetworkPolicy",
                                      "cloudify.gcp.nodes.Topic",
                                      "cloudify.gcp.nodes.TopicPolicy",
                                      "cloudify.gcp.nodes.TopicMessage",
                                      "cloudify.gcp.nodes.Subscription",
                                      "cloudify.gcp.nodes.SubscriptionPolicy",
                                      "cloudify.gcp.nodes.Acknowledge",
                                      "cloudify.gcp.nodes.PullRequest",
                                      "cloudify.gcp.nodes.StackDriverGroup",
                                      "cloudify.gcp.nodes.StackDriverTimeSeries",
                                      "cloudify.gcp.nodes.StackDriverUpTimeCheckConfig",
                                      "cloudify.gcp.nodes.LoggingSink",
                                      "cloudify.gcp.nodes.LoggingExclusion",
                                      "cloudify.gcp.nodes.Logging.BillingAccounts.sinks",
                                      "cloudify.gcp.nodes.Logging.Folders.sinks",
                                      "cloudify.gcp.nodes.Logging.Organizations.sinks",
                                      "cloudify.gcp.nodes.Logging.Projects.sinks",
                                      "cloudify.gcp.nodes.Logging.BillingAccounts.exclusions",
                                      "cloudify.gcp.nodes.Logging.Folders.exclusions",
                                      "cloudify.gcp.nodes.Logging.Organizations.exclusions",
                                      "cloudify.gcp.nodes.Logging.Projects.exclusions",
                                      "cloudify.gcp.nodes.Logging.Projects.metrics",
                                      "cloudify.kubernetes.resources.StatefulSet",
                                      "cloudify.nodes.helm.Binary",
                                      "cloudify.nodes.helm.Release",
                                      "cloudify.nodes.helm.Repo"
                                    ]
                                ]
                            ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/nodeTemplateInterface!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  configure =
                    _js2n__-refsenv."_js2n__-:definitions/nodeTemplateInterfaceAction!predicate",
                  delete =
                    _js2n__-refsenv."_js2n__-:definitions/nodeTemplateInterfaceAction!predicate",
                }
                {
                  "" =
                    _js2n__-refsenv."_js2n__-:definitions/nodeTemplateInterfaceAction!predicate",
                } true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTemplateInterfaceAction!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      executor =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [ "central_deployment_agent", "host_agent" ]
                            ],
                      implementation = _js2n__-prdslib.isType '"String",
                      inputs = _js2n__-prdslib.isType 'Record,
                      max_retries = _js2n__-prdslib.isType '"Number",
                      retry_interval = _js2n__-prdslib.isType '"Number",
                      timeone = _js2n__-prdslib.isType '"Number",
                      timeout_recoverable = _js2n__-prdslib.isType '"Bool",
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:definitions/nodeTemplateInterfaces!predicate"
        | doc "Interfaces enable you to map logical tasks to executable operations."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  "" =
                    _js2n__-refsenv."_js2n__-:definitions/nodeTemplateInterface!predicate",
                } true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTemplateRelationship!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  connection_type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "all_to_all", "all_to_one" ]
                        ],
                  source_interfaces = _js2n__-prdslib.isType 'Record,
                  target = _js2n__-prdslib.isType '"String",
                  target_interfaces = _js2n__-prdslib.isType 'Record,
                  type = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/nodeTemplateRelationships!predicate"
        | doc "relationships enable you to define how nodes relate to one another. For example, a web_server node can be contained_in a vm node or an application node can be connected_to a database node."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/nodeTemplateRelationship!predicate"
            ],
      "_js2n__-:definitions/nodeTemplates!contract"
        | doc "node_templates represent the actual instances of node types that eventually represent the running application/service, as described in the blueprint. node_templates are more commonly referred to as nodes. Nodes can comprise more than one instance. For example, you might define a node that contains two VMs. Each VM is a node_instance."
        = _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType 'Record,
                _js2n__-prdslib.records.record {}
                  {
                    "" =
                      _js2n__-refsenv."_js2n__-:definitions/nodeTemplate!predicate",
                  } true _js2n__-prdslib.always
              ]),
      "_js2n__-:definitions/nodeType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  derived_from = _js2n__-prdslib.isType '"String",
                  interfaces = _js2n__-prdslib.isType 'Record,
                  properties = _js2n__-prdslib.isType 'Record,
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeAWSEC2Base!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  Tags = _js2n__-refsenv."_js2n__-:definitions/tags!predicate",
                  client_config =
                    _js2n__-refsenv."_js2n__-:definitions/awsConnectionConfig!predicate",
                  resource_id =
                    _js2n__-refsenv."_js2n__-:definitions/awsResourceId!predicate",
                  use_external_resource = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeAWSEC2EBSAttachment!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  client_config =
                    _js2n__-refsenv."_js2n__-:definitions/awsConnectionConfig!predicate",
                  resource_config =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              kwargs =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.required
                                        [ "Device", "InstanceId", "VolumeId" ],
                                      _js2n__-prdslib.records.record
                                        {
                                          Device =
                                            _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                                          DryRun =
                                            _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                                          InstanceId =
                                            _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                                          VolumeId =
                                            _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  resource_id =
                    _js2n__-refsenv."_js2n__-:definitions/awsResourceId!predicate",
                  use_external_resource = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeAWSEC2EBSVolume!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/nodeTypeAWSEC2Base!predicate",
                  _js2n__-prdslib.records.record
                    {
                      resource_config =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.required
                                [ "AvailabilityZone" ],
                              _js2n__-prdslib.records.record
                                {
                                  AvailabilityZone =
                                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                                  Size =
                                    _js2n__-refsenv."_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate",
                                  kwargs =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.record
                                            {
                                              DryRun =
                                                _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                                              Encrypted =
                                                _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                                              Iops =
                                                _js2n__-refsenv."_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate",
                                              KmsKeyId =
                                                _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                                              OutpostArn =
                                                _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                                              Size =
                                                _js2n__-refsenv."_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate",
                                              SnapshotId =
                                                _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                                              TagSpecifications =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"Array",
                                                      _js2n__-prdslib.arrays.arrayOf
                                                        (_js2n__-prdslib.allOf
                                                          [
                                                            _js2n__-prdslib.isType
                                                              'Record,
                                                            _js2n__-prdslib.records.record
                                                              {
                                                                ResourceType =
                                                                  _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                                                                Tags =
                                                                  _js2n__-prdslib.allOf
                                                                      [
                                                                        _js2n__-prdslib.isType
                                                                          '"Array",
                                                                        _js2n__-prdslib.arrays.arrayOf
                                                                          (_js2n__-prdslib.allOf
                                                                            [
                                                                              _js2n__-prdslib.isType
                                                                                'Record,
                                                                              _js2n__-prdslib.records.record
                                                                                {
                                                                                  Key =
                                                                                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                                                                                  Value =
                                                                                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                                                                                }
                                                                                {}
                                                                                true
                                                                                _js2n__-prdslib.always
                                                                            ])
                                                                      ],
                                                              } {} true
                                                              _js2n__-prdslib.always
                                                          ])
                                                    ],
                                              VolumeType =
                                                _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                                            } {} true _js2n__-prdslib.always
                                        ],
                                } {} true _js2n__-prdslib.always
                            ],
                      use_available_zones = _js2n__-prdslib.isType '"Bool",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/nodeTypeAWSEC2ElasticIP!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  client_config =
                    _js2n__-refsenv."_js2n__-:definitions/awsClientConfig!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeAWSEC2Image!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/nodeTypeAWSEC2Base!predicate",
                  _js2n__-prdslib.records.record
                    {
                      resource_config =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  kwargs =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.record
                                            {
                                              Filters =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"Array",
                                                      _js2n__-prdslib.arrays.arrayOf
                                                        (_js2n__-prdslib.allOf
                                                          [
                                                            _js2n__-prdslib.isType
                                                              'Record,
                                                            _js2n__-prdslib.records.record
                                                              {
                                                                Name =
                                                                  _js2n__-prdslib.isType
                                                                      '"String",
                                                                Values =
                                                                  _js2n__-prdslib.allOf
                                                                      [
                                                                        _js2n__-prdslib.isType
                                                                          '"Array",
                                                                        _js2n__-prdslib.arrays.arrayOf
                                                                          (_js2n__-prdslib.isType
                                                                            '"String")
                                                                      ],
                                                              } {} true
                                                              _js2n__-prdslib.always
                                                          ])
                                                    ],
                                            } {} true _js2n__-prdslib.always
                                        ],
                                } {} true _js2n__-prdslib.always
                            ],
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/nodeTypeAWSEC2Instances!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/nodeTypeAWSEC2Base!predicate",
                  _js2n__-prdslib.records.record
                    {
                      agent_config =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  install_method =
                                    _js2n__-prdslib.isType '"String",
                                } {} true _js2n__-prdslib.always
                            ],
                      resource_config =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.required
                                [ "MaxCount", "MinCount" ],
                              _js2n__-prdslib.records.record
                                {
                                  ImageId =
                                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                                  InstanceType =
                                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                                  LaunchTemplate =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.record
                                            {
                                              LaunchTemplateId =
                                                _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                                              LaunchTemplateName =
                                                _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                                              Version =
                                                _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                                            } {} true _js2n__-prdslib.always
                                        ],
                                  MaxCount =
                                    _js2n__-refsenv."_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate",
                                  MinCount =
                                    _js2n__-refsenv."_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate",
                                  kwargs =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.record
                                            {
                                              BlockDeviceMappings =
                                                _js2n__-prdslib.isType 'Record,
                                              Ipv6AddressCount =
                                                _js2n__-refsenv."_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate",
                                              KernelId =
                                                _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                                              KeyName =
                                                _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                                              SecondaryPrivateIpAddressCount =
                                                _js2n__-refsenv."_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate",
                                              SecurityGroupIds =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"Array",
                                                      _js2n__-prdslib.arrays.arrayOf
                                                        _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate"
                                                    ],
                                              SubnetId =
                                                _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                                            } {} true _js2n__-prdslib.always
                                        ],
                                } {} true _js2n__-prdslib.always
                            ],
                      use_ipv6_ip = _js2n__-prdslib.isType '"Bool",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/nodeTypeAWSEC2Interface!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/nodeTypeAWSEC2Base!predicate",
                  _js2n__-prdslib.records.record
                    {
                      resource_config =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  kwargs =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.required
                                            [ "SubnetId" ],
                                          _js2n__-prdslib.records.record
                                            {
                                              Description =
                                                _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                                              Groups =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"Array",
                                                      _js2n__-prdslib.arrays.arrayOf
                                                        _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate"
                                                    ],
                                              InterfaceType =
                                                _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                                              Ipv6AddressCount =
                                                _js2n__-refsenv."_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate",
                                              PrivateIpAddress =
                                                _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                                              SecondaryPrivateIpAddressCount =
                                                _js2n__-refsenv."_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate",
                                              SubnetId =
                                                _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                                            } {} true _js2n__-prdslib.always
                                        ],
                                } {} true _js2n__-prdslib.always
                            ],
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/nodeTypeAWSEC2NATGateway!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  Tags = _js2n__-refsenv."_js2n__-:definitions/tags!predicate",
                  client_config =
                    _js2n__-refsenv."_js2n__-:definitions/awsClientConfig!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeAWSEC2Route!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  client_config =
                    _js2n__-refsenv."_js2n__-:definitions/awsClientConfig!predicate",
                  resource_config =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              kwargs =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          DestinationCidrBlock =
                                            _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeAWSEC2RouteTable!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  Tags = _js2n__-refsenv."_js2n__-:definitions/tags!predicate",
                  client_config =
                    _js2n__-refsenv."_js2n__-:definitions/awsClientConfig!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeAWSEC2SecurityGroup!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/nodeTypeAWSEC2Base!predicate",
                  _js2n__-prdslib.records.record
                    {
                      resource_config =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.required
                                [ "Description", "GroupName" ],
                              _js2n__-prdslib.records.record
                                {
                                  Description =
                                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                                  GroupName =
                                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                                  VpcId =
                                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                                  kwargs = _js2n__-prdslib.isType 'Record,
                                } {} true _js2n__-prdslib.always
                            ],
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/nodeTypeAWSEC2SecurityGroupRuleIngress!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/nodeTypeAWSEC2Base!predicate",
                  _js2n__-prdslib.records.record
                    {
                      resource_config =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  IpPermissions =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType 'Record,
                                                _js2n__-prdslib.records.record
                                                  {
                                                    FromPort =
                                                      _js2n__-prdslib.isType
                                                          'Integer,
                                                    IpProtocol =
                                                      _js2n__-prdslib.isType
                                                          '"String",
                                                    IpRanges =
                                                      _js2n__-prdslib.allOf
                                                          [
                                                            _js2n__-prdslib.isType
                                                              '"Array",
                                                            _js2n__-prdslib.records.record
                                                              {
                                                                CidrIp =
                                                                  _js2n__-prdslib.isType
                                                                      '"String",
                                                              } {} true
                                                              _js2n__-prdslib.always
                                                          ],
                                                    ToPort =
                                                      _js2n__-prdslib.isType
                                                          'Integer,
                                                  } {} true
                                                  _js2n__-prdslib.always
                                              ])
                                        ],
                                  kwargs = _js2n__-prdslib.isType 'Record,
                                } {} true _js2n__-prdslib.always
                            ],
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/nodeTypeAWSEC2Subnet!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  Tags = _js2n__-refsenv."_js2n__-:definitions/tags!predicate",
                  client_config =
                    _js2n__-refsenv."_js2n__-:definitions/awsClientConfig!predicate",
                  resource_config =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              AvailabilityZone =
                                _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                              CidrBlock =
                                _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                              kwargs =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          Ipv6CidrBlock =
                                            _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeAWSEC2VPC!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  Tags = _js2n__-refsenv."_js2n__-:definitions/tags!predicate",
                  client_config =
                    _js2n__-refsenv."_js2n__-:definitions/awsClientConfig!predicate",
                  resource_config =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              CidrBlock =
                                _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                              kwargs =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          AmazonProvidedIpv6CidrBlock =
                                            _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeAWSInternetGateway!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  client_config =
                    _js2n__-refsenv."_js2n__-:definitions/awsClientConfig!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeAnsibleExecutorInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "cloudify.interfaces.lifecycle" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              delete =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "ansible.cloudify_ansible.tasks.cleanup"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              start =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "ansible.cloudify_ansible.tasks.run"
                                                    ]
                                                ],
                                          inputs =
                                            _js2n__-refsenv."_js2n__-:definitions/ansiblePlaybookInputs!predicate",
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeAnsibleExecutorProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-refsenv."_js2n__-:definitions/ansiblePlaybookConfig!predicate"
            ],
      "_js2n__-:definitions/nodeTypeCloudifyAzureDeploymentInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "cloudify.interfaces.lifecycle" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              create =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [
                                          "azure.cloudify_azure.resources.deployment.create"
                                        ]
                                    ],
                              delete =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [
                                          "azure.cloudify_azure.resources.deployment.delete"
                                        ]
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyAzureDeploymentProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "location", "name" ],
              _js2n__-prdslib.records.record
                {
                  azure_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureConfig!predicate",
                  client_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureConfig!predicate",
                  location =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  name =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  params = _js2n__-prdslib.isType 'Record,
                  template =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                          _js2n__-prdslib.isType 'Record
                        ],
                  template_file =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  use_external_resource =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyAzureNodesComputeAvailabilitySetInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "cloudify.interfaces.lifecycle" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              create =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [
                                          "azure.cloudify_azure.resources.compute.availabilityset.create"
                                        ]
                                    ],
                              delete =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [
                                          "azure.cloudify_azure.resources.compute.availabilityset.delete"
                                        ]
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyAzureNodesComputeAvailabilitySetProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  api_version =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  azure_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureConfig!predicate",
                  client_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureConfig!predicate",
                  location =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  name =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  resource_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureComputeAvailabilitySetConfig!predicate",
                  resource_group_name =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  retry_after =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate",
                  tags = _js2n__-prdslib.isType 'Record,
                  use_external_resource =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyAzureNodesComputeContainerServiceInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "cloudify.interfaces.lifecycle" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              create =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "azure.cloudify_azure.resources.compute.container_service.create"
                                                    ]
                                                ],
                                          inputs = _js2n__-prdslib.always,
                                        } {} true _js2n__-prdslib.always
                                    ],
                              delete =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "azure.cloudify_azure.resources.compute.container_service.delete"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyAzureNodesComputeContainerServiceProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name", "resource_group" ],
              _js2n__-prdslib.records.record
                {
                  azure_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureConfig!predicate",
                  client_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureConfig!predicate",
                  container_service_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  name =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  resource_group =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyAzureNodesComputeManagedClusterInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "cloudify.interfaces.lifecycle" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              create =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "azure.cloudify_azure.resources.compute.managed_cluster.create"
                                                    ]
                                                ],
                                          inputs =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      azure_config =
                                                        _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureConfig!predicate",
                                                      client_config =
                                                        _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureConfig!predicate",
                                                      cluster_name =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      resource_config =
                                                        _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureComputeManagedClusterConfig!predicate",
                                                      resource_group =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              delete =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "azure.cloudify_azure.resources.compute.managed_cluster.delete"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyAzureNodesComputeManagedClusterProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [
                  "cluster_name",
                  "resource_config",
                  "resource_group",
                  "store_kube_config_in_runtime"
                ],
              _js2n__-prdslib.records.record
                {
                  azure_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureConfig!predicate",
                  client_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureConfig!predicate",
                  cluster_name =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  resource_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureComputeManagedClusterConfig!predicate",
                  resource_group =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  store_kube_config_in_runtime =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyAzureNodesComputeVirtualMachineExtensionInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "cloudify.interfaces.lifecycle" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              "create:" =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "azure.cloudify_azure.resources.compute.virtualmachineextension.create"
                                                    ]
                                                ],
                                          inputs =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      resource_config =
                                                        _js2n__-prdslib.isType
                                                            'Record,
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              delete =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [
                                          "azure.cloudify_azure.resources.compute.virtualmachineextension.delete"
                                        ]
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyAzureNodesComputeVirtualMachineExtensionProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  api_version =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  azure_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureConfig!predicate",
                  client_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureConfig!predicate",
                  location =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  name =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  resource_group_name =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  retry_after =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate",
                  tags = _js2n__-prdslib.isType 'Record,
                  use_external_resource =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                  virtual_machine_name =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyAzureNodesComputeVirtualMachineInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "cloudify.interfaces.lifecycle" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              configure =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "azure.cloudify_azure.resources.compute.virtualmachine.configure"
                                                    ]
                                                ],
                                          inputs =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      command_to_execute =
                                                        _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                                                      file_uris =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                '"Array",
                                                              _js2n__-prdslib.arrays.arrayOf
                                                                (_js2n__-prdslib.isType
                                                                  '"String")
                                                            ],
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyAzureNodesComputeVirtualMachineProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "resource_config" ],
              _js2n__-prdslib.records.record
                {
                  agent_config =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-refsenv."_js2n__-:definitions/cloudifyDataTypesAgentConfig!predicate"
                        ],
                  api_version =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  azure_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureConfig!predicate",
                  client_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureConfig!predicate",
                  ip =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  location =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  name =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  os_family =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  plan = _js2n__-prdslib.isType 'Record,
                  resource_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureComputeVirtualMachineConfig!predicate",
                  resource_group_name =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  retry_after =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate",
                  storage_endpoint =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  tags = _js2n__-prdslib.isType 'Record,
                  use_external_resource =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                  use_public_ip =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyAzureNodesComputeWindowsVirtualMachineInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "cloudify.interfaces.lifecycle" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              configure =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "azure.cloudify_azure.resources.compute.virtualmachine.configure"
                                                    ]
                                                ],
                                          inputs =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      command_to_execute =
                                                        _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                                                      file_uris =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                '"Array",
                                                              _js2n__-prdslib.arrays.arrayOf
                                                                (_js2n__-prdslib.isType
                                                                  '"String")
                                                            ],
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyAzureNodesComputeWindowsVirtualMachineProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyAzureNodesComputeWindowsVirtualMachineProperties!predicate",
                  _js2n__-prdslib.records.record
                    {
                      agent_config = _js2n__-prdslib.isType 'Record,
                      os_family =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/nodeTypeCloudifyAzureNodesNetworkIPConfigurationProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  api_version =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  azure_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureConfig!predicate",
                  client_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureConfig!predicate",
                  location =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  name =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  resource_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureNetworkIPConfigurationConfig!predicate",
                  resource_group_name =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  retry_after =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate",
                  tags = _js2n__-prdslib.isType 'Record,
                  use_external_resource =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyAzureNodesNetworkLoadBalancerBackendAddressPoolInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "cloudify.interfaces.lifecycle" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              create =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [
                                          "azure.cloudify_azure.resources.network.loadbalancer.create_backend_pool"
                                        ]
                                    ],
                              delete =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [
                                          "azure.cloudify_azure.resources.network.loadbalancer.delete_backend_pool"
                                        ]
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyAzureNodesNetworkLoadBalancerBackendAddressPoolProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  api_version =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  azure_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureConfig!predicate",
                  client_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureConfig!predicate",
                  load_balancer_name =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  location =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  name =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  resource_group_name =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  retry_after =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate",
                  tags = _js2n__-prdslib.always,
                  use_external_resource =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyAzureNodesNetworkLoadBalancerIncomingNATRuleInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "cloudify.interfaces.lifecycle" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              create =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [
                                          "azure.cloudify_azure.resources.network.loadbalancer.create_incoming_nat_rule"
                                        ]
                                    ],
                              delete =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [
                                          "azure.cloudify_azure.resources.network.loadbalancer.delete_incoming_nat_rule"
                                        ]
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyAzureNodesNetworkLoadBalancerIncomingNATRuleProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  api_version =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  azure_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureConfig!predicate",
                  client_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureConfig!predicate",
                  load_balancer_name =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  location =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  name =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  resource_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureNetworkLoadBalancerIncomingNATRuleConfig!predicate",
                  resource_group_name =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  retry_after =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate",
                  tags = _js2n__-prdslib.isType 'Record,
                  use_external_resource =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyAzureNodesNetworkLoadBalancerInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "cloudify.interfaces.lifecycle" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              configure =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [
                                          "azure.cloudify_azure.resources.network.loadbalancer.configure"
                                        ]
                                    ],
                              create =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [
                                          "azure.cloudify_azure.resources.network.loadbalancer.create"
                                        ]
                                    ],
                              delete =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [
                                          "azure.cloudify_azure.resources.network.loadbalancer.delete"
                                        ]
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyAzureNodesNetworkLoadBalancerProbeInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "cloudify.interfaces.lifecycle" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              create =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [
                                          "azure.cloudify_azure.resources.network.loadbalancer.create_probe"
                                        ]
                                    ],
                              delete =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.enum
                                        [
                                          "azure.cloudify_azure.resources.network.loadbalancer.delete_probe"
                                        ]
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyAzureNodesNetworkLoadBalancerProbeProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  api_version =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  azure_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureConfig!predicate",
                  client_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureConfig!predicate",
                  load_balancer_name =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  location =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  name =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  resource_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureNetworkLoadBalancerProbeConfig!predicate",
                  resource_group_name =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  retry_after =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate",
                  tags = _js2n__-prdslib.isType 'Record,
                  use_external_resource =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyAzureNodesNetworkLoadBalancerProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  api_version =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  azure_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureConfig!predicate",
                  client_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureConfig!predicate",
                  location =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  name =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  resource_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureNetworkLoadBalancerConfig!predicate",
                  resource_group_name =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  retry_after =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate",
                  tags = _js2n__-prdslib.isType 'Record,
                  use_external_resource =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyAzureNodesNetworkLoadBalancerRuleInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "cloudify.interfaces.lifecycle" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              create =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [
                                          "azure.cloudify_azure.resources.network.loadbalancer.create_rule"
                                        ]
                                    ],
                              delete =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [
                                          "azure.cloudify_azure.resources.network.loadbalancer.delete_rule"
                                        ]
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyAzureNodesNetworkLoadBalancerRuleProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  api_version =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  azure_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureConfig!predicate",
                  client_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureConfig!predicate",
                  load_balancer_name =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  location =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  name =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  resource_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureNetworkLoadBalancerRuleConfig!predicate",
                  resource_group_name =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  retry_after =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate",
                  tags = _js2n__-prdslib.isType 'Record,
                  use_external_resource =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyAzureNodesNetworkNetworkInterfaceCardInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "cloudify.interfaces.lifecycle" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              configure =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [
                                          "azure.cloudify_azure.resources.network.networkinterfacecard.configure"
                                        ]
                                    ],
                              create =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [
                                          "azure.cloudify_azure.resources.network.networkinterfacecard.create"
                                        ]
                                    ],
                              delete =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [
                                          "azure.cloudify_azure.resources.network.networkinterfacecard.delete"
                                        ]
                                    ],
                              start =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [
                                          "azure.cloudify_azure.resources.network.networkinterfacecard.start"
                                        ]
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyAzureNodesNetworkNetworkInterfaceCardProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  api_version =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  azure_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureConfig!predicate",
                  client_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureConfig!predicate",
                  location =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  name =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  primary = _js2n__-prdslib.always,
                  resource_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureNetworkNetworkInterfaceCardConfig!predicate",
                  resource_group_name =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  retry_after =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate",
                  tags = _js2n__-prdslib.isType 'Record,
                  use_external_resource =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyAzureNodesNetworkNetworkSecurityGroupInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "cloudify.interfaces.lifecycle" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              create =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [
                                          "azure.cloudify_azure.resources.network.networksecuritygroup.create"
                                        ]
                                    ],
                              delete =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [
                                          "azure.cloudify_azure.resources.network.networksecuritygroup.delete"
                                        ]
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyAzureNodesNetworkNetworkSecurityGroupProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  api_version =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  azure_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureConfig!predicate",
                  client_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureConfig!predicate",
                  location =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  name =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  resource_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureNetworkNetworkSecurityGroupConfig!predicate",
                  resource_group_name =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  retry_after =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate",
                  tags = _js2n__-prdslib.isType 'Record,
                  use_external_resource =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyAzureNodesNetworkNetworkSecurityRuleInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "cloudify.interfaces.lifecycle" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              create =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [
                                          "azure.cloudify_azure.resources.network.networksecurityrule.create"
                                        ]
                                    ],
                              delete =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [
                                          "azure.cloudify_azure.resources.network.networksecurityrule.delete"
                                        ]
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyAzureNodesNetworkNetworkSecurityRuleProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  api_version =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  azure_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureConfig!predicate",
                  client_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureConfig!predicate",
                  location =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  name =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  network_security_group_name =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  resource_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureNetworkNetworkSecurityRuleConfig!predicate",
                  resource_group_name =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  retry_after =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate",
                  tags = _js2n__-prdslib.isType 'Record,
                  use_external_resource =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyAzureNodesNetworkPublicIPAddressInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "cloudify.interfaces.lifecycle" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              create =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [
                                          "azure.cloudify_azure.resources.network.publicipaddress.create"
                                        ]
                                    ],
                              delete =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [
                                          "azure.cloudify_azure.resources.network.publicipaddress.delete"
                                        ]
                                    ],
                              start =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [
                                          "azure.cloudify_azure.resources.network.publicipaddress.start"
                                        ]
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyAzureNodesNetworkPublicIPAddressProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  api_version =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  azure_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureConfig!predicate",
                  client_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureConfig!predicate",
                  location =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  name =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  resource_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureNetworkPublicIPAddressConfig!predicate",
                  resource_group_name =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  retry_after =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate",
                  tags = _js2n__-prdslib.isType 'Record,
                  use_external_resource =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyAzureNodesNetworkRouteInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "cloudify.interfaces.lifecycle" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              create =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [
                                          "azure.cloudify_azure.resources.network.route.create"
                                        ]
                                    ],
                              delete =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [
                                          "azure.cloudify_azure.resources.network.route.delete"
                                        ]
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyAzureNodesNetworkRouteProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  api_version =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  azure_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureConfig!predicate",
                  client_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureConfig!predicate",
                  location =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  name =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  resource_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureNetworkRouteConfig!predicate",
                  resource_group_name =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  retry_after =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate",
                  route_table_name =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  tags = _js2n__-prdslib.isType 'Record,
                  use_external_resource =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyAzureNodesNetworkRouteTableInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "cloudify.interfaces.lifecycle" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              create =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [
                                          "azure.cloudify_azure.resources.network.routetable.create"
                                        ]
                                    ],
                              delete =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [
                                          "azure.cloudify_azure.resources.network.routetable.delete"
                                        ]
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyAzureNodesNetworkRouteTableProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  api_version =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  azure_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureConfig!predicate",
                  client_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureConfig!predicate",
                  "location:" =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  name =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  resource_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureNetworkRouteTableConfig!predicate",
                  resource_group_name =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  retry_after =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate",
                  tags = _js2n__-prdslib.isType 'Record,
                  use_external_resource =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyAzureNodesNetworkSubnetInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { "cloudify.interfaces.lifecycle" = _js2n__-prdslib.always, } {}
                true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyAzureNodesNetworkSubnetProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  api_version =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  azure_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureConfig!predicate",
                  client_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureConfig!predicate",
                  location =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  name =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  resource_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureNetworkSubnetConfig!predicate",
                  resource_group_name =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  retry_after =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate",
                  tags = _js2n__-prdslib.always,
                  use_external_resource =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                  virtual_network_name =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyAzureNodesNetworkVirtualNetworkInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "cloudify.interfaces.lifecycle" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              create =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [
                                          "azure.cloudify_azure.resources.network.virtualnetwork.create"
                                        ]
                                    ],
                              delete =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [
                                          "azure.cloudify_azure.resources.network.virtualnetwork.delete"
                                        ]
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyAzureNodesNetworkVirtualNetworkProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  api_version =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  azure_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureConfig!predicate",
                  client_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureConfig!predicate",
                  location =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  name =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  resource_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureNetworkVirtualNetworkConfig!predicate",
                  resource_group_name =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  retry_after =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate",
                  tags = _js2n__-prdslib.isType 'Record,
                  use_external_resource =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyAzureNodesPlanInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "cloudify.interfaces.lifecycle" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              create =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "azure.cloudify_azure.resources.app_service.plan.create"
                                                    ]
                                                ],
                                          inputs =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      azure_config =
                                                        _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureConfig!predicate",
                                                      client_config =
                                                        _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureConfig!predicate",
                                                      name =
                                                        _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                                                      resource_group =
                                                        _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                                                      sku =
                                                        _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              delete =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "azure.cloudify_azure.resources.app_service.plan.delete"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyAzureNodesPlanProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name", "resource_group" ],
              _js2n__-prdslib.records.record
                {
                  azure_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureConfig!predicate",
                  client_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureConfig!predicate",
                  name =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  resource_group =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  sku =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  use_external_resource = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyAzureNodesPublishingUserInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "cloudify.interfaces.lifecycle" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              create =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "azure.cloudify_azure.resources.app_service.publishing_user.set_user"
                                                    ]
                                                ],
                                          inputs =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      azure_config =
                                                        _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureConfig!predicate",
                                                      client_config =
                                                        _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureConfig!predicate",
                                                      user_details =
                                                        _js2n__-prdslib.isType
                                                            'Record,
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyAzureNodesPublishingUserProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "user_details" ],
              _js2n__-prdslib.records.record
                {
                  azure_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureConfig!predicate",
                  client_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureConfig!predicate",
                  user_details = _js2n__-prdslib.isType 'Record,
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyAzureNodesResourceGroupInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "cloudify.interfaces.lifecycle" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              create =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [
                                          "azure.cloudify_azure.resources.resourcegroup.create"
                                        ]
                                    ],
                              delete =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [
                                          "azure.cloudify_azure.resources.resourcegroup.delete"
                                        ]
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyAzureNodesResourceGroupProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  api_version =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  azure_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureConfig!predicate",
                  client_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureConfig!predicate",
                  location =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  name =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  retry_after =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate",
                  tags = _js2n__-prdslib.isType 'Record,
                  use_external_resource =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyAzureNodesStorageDataDiskProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  azure_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureConfig!predicate",
                  client_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureConfig!predicate",
                  location =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  name =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  resource_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureStorageDataDiskConfig!predicate",
                  retry_after =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate",
                  use_external_resource =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyAzureNodesStorageDataDisktInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "cloudify.interfaces.lifecycle" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              create =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [
                                          "azure.cloudify_azure.resources.storage.disk.create_data_disk"
                                        ]
                                    ],
                              delete =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [
                                          "azure.cloudify_azure.resources.storage.disk.delete_data_disk"
                                        ]
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyAzureNodesStorageFileShareInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { "cloudify.interfaces.lifecycle" = _js2n__-prdslib.always, } {}
                true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyAzureNodesStorageFileShareProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  azure_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureConfig!predicate",
                  client_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureConfig!predicate",
                  location =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  name =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  resource_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureStorageFileShareConfig!predicate",
                  retry_after =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate",
                  use_external_resource =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyAzureNodesStorageStorageAccountInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "cloudify.interfaces.lifecycle" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              create =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [
                                          "azure.cloudify_azure.resources.storage.storageaccount.create"
                                        ]
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyAzureNodesStorageStorageAccountProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  api_version =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  azure_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureConfig!predicate",
                  client_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureConfig!predicate",
                  location =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  name =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  resource_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureStorageStorageAccountConfig!predicate",
                  resource_group_name =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  retry_after =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate",
                  sku =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  tags = _js2n__-prdslib.isType 'Record,
                  use_external_resource =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyAzureNodesWebAppInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "cloudify.interfaces.lifecycle" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              create =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "azure.cloudify_azure.resources.app_service.webapp.create"
                                                    ]
                                                ],
                                          inputs = _js2n__-prdslib.always,
                                        } {} true _js2n__-prdslib.always
                                    ],
                              delete =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "azure.cloudify_azure.resources.app_service.webapp.delete"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyAzureNodesWebAppProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name", "resource_group" ],
              _js2n__-prdslib.records.record
                {
                  app_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  azure_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureConfig!predicate",
                  client_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesAzureConfig!predicate",
                  name =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  resource_group =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyGCPNodesInstanceInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "cloudify.interfaces.lifecycle" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              configure =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "gcp_plugin.cloudify_gcp.compute.instance.create"
                                                    ]
                                                ],
                                          inputs =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      additional_settings =
                                                        _js2n__-prdslib.isType
                                                            'Record,
                                                      can_ip_forward =
                                                        _js2n__-prdslib.isType
                                                            '"Bool",
                                                      external_ip =
                                                        _js2n__-prdslib.isType
                                                            '"Bool",
                                                      image_id =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      instance_type =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      name =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      scopes =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                '"Array",
                                                              _js2n__-prdslib.arrays.arrayOf
                                                                (_js2n__-prdslib.isType
                                                                  '"String")
                                                            ],
                                                      startup_script =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      tags =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      zone =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              delete =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "gcp_plugin.cloudify_gcp.compute.instance.delete"
                                                    ]
                                                ],
                                          inputs =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      name =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      zone =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              start =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "gcp_plugin.cloudify_gcp.compute.instance.start"
                                                    ]
                                                ],
                                          inputs =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      name =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyGCPNodesInstanceProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/gcpExternalResource!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/gcpResourceId!predicate",
                  _js2n__-prdslib.records.record
                    {
                      additional_settings = _js2n__-prdslib.isType 'Record,
                      block_project_ssh_keys = _js2n__-prdslib.isType '"Bool",
                      can_ip_forward = _js2n__-prdslib.isType '"Bool",
                      external_ip = _js2n__-prdslib.isType '"Bool",
                      gcp_config = _js2n__-prdslib.isType 'Record,
                      image_id = _js2n__-prdslib.isType '"String",
                      instance_type = _js2n__-prdslib.isType '"String",
                      name = _js2n__-prdslib.isType '"String",
                      scopes =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                      startup_script = _js2n__-prdslib.isType '"String",
                      tags = _js2n__-prdslib.isType '"String",
                      use_public_ip = _js2n__-prdslib.isType '"Bool",
                      zone = _js2n__-prdslib.isType '"String",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/nodeTypeCloudifyGCPProjectInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "cloudify.interfaces.lifecycle" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              create =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "gcp_plugin.cloudify_gcp.admin.projects.create"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              delete =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "gcp_plugin.cloudify_gcp.admin.projects.delete"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyGCPProjectProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/gcpExternalResource!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/gcpResourceId!predicate",
                  _js2n__-prdslib.records.record
                    {
                      gcp_config = _js2n__-prdslib.isType 'Record,
                      name = _js2n__-prdslib.isType '"String",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/nodeTypeCloudifyNodesCloudInitCloudConfigInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "cloudify.interfaces.lifecycle" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              configure =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "cloudinit.cloudify_cloudinit.tasks.update"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              create =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "cloudinit.cloudify_cloudinit.tasks.update"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              delete =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "cloudinit.cloudify_cloudinit.tasks.delete"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              start =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "cloudinit.cloudify_cloudinit.tasks.update"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              stop =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "cloudinit.cloudify_cloudinit.tasks.update"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyNodesCloudInitCloudConfigProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  encode_base64 =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                  header =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  resource_config = _js2n__-prdslib.isType 'Record,
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyNodesDeploymentProxyInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "cloudify.interfaces.lifecycle" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              configure =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "cfy_util.cloudify_deployment_proxy.tasks.create_deployment"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              create =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "cfy_util.cloudify_deployment_proxy.tasks.upload_blueprint"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              delete =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "cfy_util.cloudify_deployment_proxy.tasks.delete_deployment"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              start =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "cfy_util.cloudify_deployment_proxy.tasks.execute_start"
                                                    ]
                                                ],
                                          inputs =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      interval =
                                                        _js2n__-prdslib.isType
                                                            'Integer,
                                                      timeout =
                                                        _js2n__-prdslib.isType
                                                            'Integer,
                                                      workflow_id =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              stop =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "cfy_util.cloudify_deployment_proxy.tasks.execute_start"
                                                    ]
                                                ],
                                          inputs =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      resource_config =
                                                        _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesDeploymentProxy!predicate",
                                                      workflow_id =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyNodesDeploymentProxyProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  client =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              host = _js2n__-prdslib.isType '"String",
                              password = _js2n__-prdslib.isType '"String",
                              tenant = _js2n__-prdslib.isType '"String",
                              username = _js2n__-prdslib.isType '"String",
                            } {} true _js2n__-prdslib.always
                        ],
                  plugins =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  resource_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesDeploymentProxy!predicate",
                  secrets = _js2n__-prdslib.isType 'Record,
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyNodesFTPInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "cloudify.interfaces.lifecycle" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              create =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "cfy_ftp.cloudify_ftp.tasks.create"
                                                    ]
                                                ],
                                          inputs =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      files =
                                                        _js2n__-prdslib.isType
                                                            'Record,
                                                      raw_files =
                                                        _js2n__-prdslib.isType
                                                            'Record,
                                                      resource_config =
                                                        _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesFtpAuth!predicate",
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              delete =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "cfy_ftp.cloudify_ftp.tasks.delete"
                                                    ]
                                                ],
                                          inputs = _js2n__-prdslib.always,
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyNodesFTPProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  files = _js2n__-prdslib.isType 'Record,
                  raw_files = _js2n__-prdslib.isType 'Record,
                  resource_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesFtpAuth!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyNodesFileInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "cloudify.interfaces.lifecycle" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              create =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "cfy_files.cloudify_files.tasks.create"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              delete =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "cfy_files.cloudify_files.tasks.delete"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyNodesFileProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  resource_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesFile!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyNodesNodeInstanceProxyProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/nodeTypeCloudifyNodesDeploymentProxyProperties!predicate",
                  _js2n__-prdslib.records.record
                    {
                      resource_config =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesNodeInstanceProxy!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/nodeTypeCloudifyNodesRSAKeyInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "cloudify.interfaces.lifecycle" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              create =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "keys.cloudify_ssh_key.operations.create"
                                                    ]
                                                ],
                                          inputs = _js2n__-prdslib.always,
                                        } {} true _js2n__-prdslib.always
                                    ],
                              delete =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "keys.cloudify_ssh_key.operations.delete"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyNodesRSAKeyProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  key_name =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  resource_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesKey!predicate",
                  use_secret_store =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                  use_secrets_if_exist =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyNodesSecretsReaderInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "cloudify.interfaces.lifecycle" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              create =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "secrets.cloudify_secrets.tasks.read"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  "cloudify.interfaces.operations" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              update =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "secrets.cloudify_secrets.tasks.read"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyNodesSecretsReaderProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  keys =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  separator =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  variant =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyNodesSecretsWriterInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "cloudify.interfaces.lifecycle" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              create =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "secrets.cloudify_secrets.tasks.create"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              delete =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "secrets.cloudify_secrets.tasks.delete"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  "cloudify.interfaces.operations" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              update =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "secrets.cloudify_secrets.tasks.update"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyNodesSecretsWriterProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  do_not_delete =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                  entries = _js2n__-prdslib.isType 'Record,
                  separator =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  variant =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyRestBunchRequestsInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "cloudify.interfaces.lifecycle" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              configure =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "rest.cloudify_rest.tasks.bunch_execute"
                                                    ]
                                                ],
                                          inputs =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      auth =
                                                        _js2n__-prdslib.isType
                                                            'Record,
                                                      templates =
                                                        _js2n__-prdslib.isType
                                                            'Record,
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              create =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "rest.cloudify_rest.tasks.bunch_execute"
                                                    ]
                                                ],
                                          inputs =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      auth =
                                                        _js2n__-prdslib.isType
                                                            'Record,
                                                      templates =
                                                        _js2n__-prdslib.isType
                                                            'Record,
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              delete =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "rest.cloudify_rest.tasks.bunch_execute"
                                                    ]
                                                ],
                                          inputs =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      auth =
                                                        _js2n__-prdslib.isType
                                                            'Record,
                                                      templates =
                                                        _js2n__-prdslib.isType
                                                            'Record,
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              start =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "rest.cloudify_rest.tasks.bunch_execute"
                                                    ]
                                                ],
                                          inputs =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      auth =
                                                        _js2n__-prdslib.isType
                                                            'Record,
                                                      templates =
                                                        _js2n__-prdslib.isType
                                                            'Record,
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              stop =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "rest.cloudify_rest.tasks.bunch_execute"
                                                    ]
                                                ],
                                          inputs =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      auth =
                                                        _js2n__-prdslib.isType
                                                            'Record,
                                                      templates =
                                                        _js2n__-prdslib.isType
                                                            'Record,
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyRestBunchRequestsProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  cert =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  host =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  hosts =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  params = _js2n__-prdslib.isType 'Record,
                  port =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate",
                  proxies = _js2n__-prdslib.isType 'Record,
                  ssl =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                  timeout =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate",
                  verify =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyRestRequestsInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "cloudify.interfaces.lifecycle" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              configure =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "rest.cloudify_rest.tasks.execute"
                                                    ]
                                                ],
                                          inputs =
                                            _js2n__-refsenv."_js2n__-:definitions/restTemplateInputs!predicate",
                                        } {} true _js2n__-prdslib.always
                                    ],
                              create =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "rest.cloudify_rest.tasks.execute"
                                                    ]
                                                ],
                                          inputs =
                                            _js2n__-refsenv."_js2n__-:definitions/restTemplateInputs!predicate",
                                        } {} true _js2n__-prdslib.always
                                    ],
                              delete =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "rest.cloudify_rest.tasks.execute"
                                                    ]
                                                ],
                                          inputs =
                                            _js2n__-refsenv."_js2n__-:definitions/restTemplateInputs!predicate",
                                        } {} true _js2n__-prdslib.always
                                    ],
                              start =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "rest.cloudify_rest.tasks.execute"
                                                    ]
                                                ],
                                          inputs =
                                            _js2n__-refsenv."_js2n__-:definitions/restTemplateInputs!predicate",
                                        } {} true _js2n__-prdslib.always
                                    ],
                              stop =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "rest.cloudify_rest.tasks.execute"
                                                    ]
                                                ],
                                          inputs =
                                            _js2n__-refsenv."_js2n__-:definitions/restTemplateInputs!predicate",
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyRestRequestsProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  cert =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  host =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  hosts =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  params = _js2n__-prdslib.isType 'Record,
                  port =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate",
                  proxies = _js2n__-prdslib.isType 'Record,
                  ssl =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                  timeout =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate",
                  verify =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyTerminalRawInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "cloudify.interfaces.lifecycle" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              configure =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "terminal.cloudify_terminal.tasks.run"
                                                    ]
                                                ],
                                          inputs =
                                            _js2n__-prdslib.isType 'Record,
                                        } {} true _js2n__-prdslib.always
                                    ],
                              create =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "terminal.cloudify_terminal.tasks.run"
                                                    ]
                                                ],
                                          inputs =
                                            _js2n__-prdslib.isType 'Record,
                                        } {} true _js2n__-prdslib.always
                                    ],
                              delete =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "terminal.cloudify_terminal.tasks.run"
                                                    ]
                                                ],
                                          inputs =
                                            _js2n__-prdslib.isType 'Record,
                                        } {} true _js2n__-prdslib.always
                                    ],
                              start =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "terminal.cloudify_terminal.tasks.run"
                                                    ]
                                                ],
                                          inputs =
                                            _js2n__-prdslib.isType 'Record,
                                        } {} true _js2n__-prdslib.always
                                    ],
                              stop =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "terminal.cloudify_terminal.tasks.run"
                                                    ]
                                                ],
                                          inputs =
                                            _js2n__-prdslib.isType 'Record,
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeCloudifyTerminalRawProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  terminal_auth =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesTerminalAuth!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeDockerAnsiblePlaybookInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "cloudify.interfaces.lifecycle" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              create =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "docker.cloudify_docker.ansible.create_ansible_playbook"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              delete =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "docker.cloudify_docker.ansible.remove_ansible_playbook"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              precreate =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "docker.cloudify_docker.ansible.set_playbook_config"
                                                    ]
                                                ],
                                          inputs =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      additional_args =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      ansible_env_vars =
                                                        _js2n__-prdslib.isType
                                                            'Record,
                                                      ansible_playbook_executable_path =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      debug_level =
                                                        _js2n__-prdslib.isType
                                                            'Integer,
                                                      options_config =
                                                        _js2n__-prdslib.isType
                                                            'Record,
                                                      playbook_path =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      playbook_source_path =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      remerge_sources =
                                                        _js2n__-prdslib.isType
                                                            '"Bool",
                                                      run_data =
                                                        _js2n__-prdslib.isType
                                                            'Record,
                                                      save_playbook =
                                                        _js2n__-prdslib.isType
                                                            '"Bool",
                                                      sensitive_keys =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                '"Array",
                                                              _js2n__-prdslib.arrays.arrayOf
                                                                (_js2n__-prdslib.isType
                                                                  '"String")
                                                            ],
                                                      site_yaml_path =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      sources =
                                                        _js2n__-prdslib.isType
                                                            'Record,
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeDockerAnsiblePlaybookProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  additional_args = _js2n__-prdslib.isType '"String",
                  additional_playbook_files =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  ansible_become = _js2n__-prdslib.isType '"Bool",
                  ansible_env_vars =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              ANSIBLE_HOST_KEY_CHECKING =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum [ "True", "False" ]
                                    ],
                              ANSIBLE_INVALID_TASK_ATTRIBUTE_FAILED =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum [ "True", "False" ]
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  ansible_playbook_executable_path =
                    _js2n__-prdslib.isType '"String",
                  debug_level = _js2n__-prdslib.isType 'Integer,
                  docker_machine =
                    _js2n__-refsenv."_js2n__-:definitions/dockerMachine!predicate",
                  options_config = _js2n__-prdslib.isType 'Record,
                  playbook_path = _js2n__-prdslib.isType '"String",
                  playbook_source_path = _js2n__-prdslib.isType '"String",
                  remerge_sources = _js2n__-prdslib.isType '"Bool",
                  run_data = _js2n__-prdslib.isType 'Record,
                  save_playbook = _js2n__-prdslib.isType '"Bool",
                  sensitive_keys =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  site_yaml_path = _js2n__-prdslib.isType '"String",
                  sources = _js2n__-prdslib.isType 'Record,
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeDockerContainerFilesInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "cloudify.interfaces.lifecycle" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              create =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "docker.cloudify_docker.tasks.prepare_container_files"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              delete =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "docker.cloudify_docker.tasks.remove_container_files"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeDockerContainerFilesProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  resource_config =
                    _js2n__-prdslib.records.record
                        {
                          ansible_sources = _js2n__-prdslib.isType 'Record,
                          destination = _js2n__-prdslib.isType '"String",
                          docker_machine =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      ansible_sources =
                                        _js2n__-prdslib.isType 'Record,
                                      destination =
                                        _js2n__-prdslib.isType '"String",
                                      docker_machine =
                                        _js2n__-refsenv."_js2n__-:definitions/dockerMachine!predicate",
                                      extra_files =
                                        _js2n__-prdslib.isType '"String",
                                      source = _js2n__-prdslib.isType '"String",
                                      terraform_sources =
                                        _js2n__-prdslib.isType 'Record,
                                    } {} true _js2n__-prdslib.always
                                ],
                          extra_files =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    (_js2n__-prdslib.isType '"String")
                                ],
                          source = _js2n__-prdslib.isType '"String",
                          terraform_sources = _js2n__-prdslib.isType 'Record,
                        } {} true _js2n__-prdslib.always,
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeDockerContainerInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "cloudify.interfaces.lifecycle" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              create =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "docker.cloudify_docker.tasks.create_container"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              delete =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "docker.cloudify_docker.tasks.remove_container"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              stop =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "docker.cloudify_docker.tasks.remove_container"
                                                    ]
                                                ],
                                          inputs =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      stop_command =
                                                        _js2n__-prdslib.anyOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                '"String",
                                                              _js2n__-prdslib.isType
                                                                'Record
                                                            ],
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeDockerContainerProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  client_config =
                    _js2n__-refsenv."_js2n__-:definitions/dockerClientConfig!predicate",
                  resource_config =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              container_args = _js2n__-prdslib.isType 'Record,
                              image_tag =
                                _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeDockerContainersInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "cloudify.interfaces.lifecycle" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              create =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "docker.cloudify_docker.tasks.list_containers"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeDockerContainersProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  client_config =
                    _js2n__-refsenv."_js2n__-:definitions/dockerClientConfig!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeDockerHostDetailsInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "cloudify.interfaces.lifecycle" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              create =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "docker.cloudify_docker.tasks.list_host_details"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeDockerHostDetailsProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  client_config =
                    _js2n__-refsenv."_js2n__-:definitions/dockerClientConfig!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeDockerHostInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "cloudify.interfaces.lifecycle" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              create =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "docker.cloudify_docker.tasks.install_docker"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              delete =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "docker.cloudify_docker.tasks.uninstall_docker"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeDockerHostProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  docker_machine =
                    _js2n__-refsenv."_js2n__-:definitions/dockerMachine!predicate",
                  resource_config =
                    _js2n__-refsenv."_js2n__-:definitions/dockerInstallationConfig!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeDockerImageInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "cloudify.interfaces.lifecycle" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              create =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "docker.cloudify_docker.tasks.build_image"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              delete =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "docker.cloudify_docker.tasks.remove_image"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeDockerImageProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  client_config =
                    _js2n__-refsenv."_js2n__-:definitions/dockerClientConfig!predicate",
                  resource_config =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              image_content =
                                _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                              tag =
                                _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeDockerImagesInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "cloudify.interfaces.lifecycle" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              create =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "docker.cloudify_docker.tasks.list_images"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeDockerImagesProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  client_config =
                    _js2n__-refsenv."_js2n__-:definitions/dockerClientConfig!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeDockerTerraformModuleInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "cloudify.interfaces.lifecycle" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              create =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "docker.cloudify_docker.terraform.prepare_terraform_files"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              delete =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "docker.cloudify_docker.terraform.remove_terraform_files"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeDockerTerraformModuleProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "resource_config", "terraform_plugins" ],
              _js2n__-prdslib.records.record
                {
                  docker_machine =
                    _js2n__-refsenv."_js2n__-:definitions/dockerMachine!predicate",
                  resource_config =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.required [ "source" ],
                          _js2n__-prdslib.records.record
                            {
                              backend =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          name =
                                            _js2n__-prdslib.isType '"String",
                                          options =
                                            _js2n__-prdslib.isType 'Record,
                                        } {} true _js2n__-prdslib.always
                                    ],
                              environment_variables =
                                _js2n__-prdslib.isType 'Record,
                              source =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.required
                                            [ "location" ],
                                          _js2n__-prdslib.records.record
                                            {
                                              location =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              password =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              username =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                            } {} true _js2n__-prdslib.always
                                        ]
                                    ],
                              variables = _js2n__-prdslib.isType 'Record,
                            } {} true _js2n__-prdslib.always
                        ],
                  terraform_plugins =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeHelmBinaryProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  helm_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesHelmConfig!predicate",
                  installation_source =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  use_existing_resource =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeHelmReleaseInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "cloudify.interfaces.lifecycle" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              delete =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "helm.cloudify_helm.tasks.uninstall_release"
                                                    ]
                                                ],
                                          inputs =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      flags =
                                                        _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesHelmSetFlagsList!predicate",
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              start =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "helm.cloudify_helm.tasks.install_release"
                                                    ]
                                                ],
                                          inputs =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      flags =
                                                        _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesHelmSetFlagsList!predicate",
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeHelmReleaseProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "client_config", "resource_config" ],
              _js2n__-prdslib.records.record
                {
                  client_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesHelmClientConfig!predicate",
                  helm_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesHelmConfig!predicate",
                  resource_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesHelmReleaseConfig!predicate",
                  use_external_resource =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeHelmRepoInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "cloudify.interfaces.lifecycle" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              delete =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "helm.cloudify_helm.tasks.remove_repo"
                                                    ]
                                                ],
                                          inputs =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      flags =
                                                        _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesHelmSetFlagsList!predicate",
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              start =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "helm.cloudify_helm.tasks.add_repo"
                                                    ]
                                                ],
                                          inputs =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      flags =
                                                        _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesHelmSetFlagsList!predicate",
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeHelmRepoProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  helm_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesHelmConfig!predicate",
                  resource_config =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyDatatypesHelmRepoConfig!predicate",
                  use_external_resource =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeKubernetesNodesMasterProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  authentication =
                    _js2n__-refsenv."_js2n__-:definitions/kubernetesTypesAuthenticationVariant!predicate",
                  configuration =
                    _js2n__-refsenv."_js2n__-:definitions/kubernetesTypesConfigurationVariant!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeKubernetesResourcesBlueprintDefinedResource!predicate"
        | doc ""
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesResourceWithValidateStatus!predicate",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          definition =
                            _js2n__-refsenv."_js2n__-:definitions/kubernetesTypesResourceDefinition!predicate",
                          options = _js2n__-prdslib.isType 'Record,
                          use_external_resource =
                            _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                        } {} true _js2n__-prdslib.always
                    ]
                ]
            ],
      "_js2n__-:definitions/nodeTypeKubernetesResourcesBlueprintDefinedResourceInterfaces!predicate"
        | doc ""
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "cloudify.interfaces.lifecycle" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              create =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "kubernetes.cloudify_kubernetes.tasks.resource_create"
                                                    ],
                                                  _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate"
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              delete =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "kubernetes.cloudify_kubernetes.tasks.resource_delete"
                                                    ],
                                                  _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate"
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              poststart =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "kubernetes.cloudify_kubernetes.tasks.resource_read"
                                                    ],
                                                  _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate"
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              update =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "kubernetes.cloudify_kubernetes.tasks.resource_update"
                                                    ],
                                                  _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate"
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeKubernetesResourcesClusterRoleBindingProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesBlueprintDefinedResource!predicate",
                  _js2n__-prdslib.records.record
                    {
                      definition =
                        _js2n__-refsenv."_js2n__-:definitions/kubernetesTypesRoleBindingDefinitio!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/nodeTypeKubernetesResourcesClusterRoleProperties!predicate"
        | doc "Definition of cluster role using native Kubernetes YAML spec"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesRoleProperties!predicate",
                  _js2n__-prdslib.records.record
                    {
                      definition =
                        _js2n__-refsenv."_js2n__-:definitions/kubernetesTypesClusterRoleDefinitio!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/nodeTypeKubernetesResourcesConfigMapProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesBlueprintDefinedResource!predicate",
                  _js2n__-prdslib.records.record
                    {
                      definition =
                        _js2n__-refsenv."_js2n__-:definitions/kubernetesTypesConfigClassResourceDefinition!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/nodeTypeKubernetesResourcesCustomBlueprintDefinedResourceInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesBlueprintDefinedResourceInterfaces!predicate",
                  _js2n__-prdslib.records.record
                    {
                      "cloudify.interfaces.lifecycle" =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  create =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.record
                                            {
                                              implementation =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.enum
                                                        [
                                                          "kubernetes.cloudify_kubernetes.tasks.custom_resource_create"
                                                        ],
                                                      _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate"
                                                    ],
                                            } {} true _js2n__-prdslib.always
                                        ],
                                  delete =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.record
                                            {
                                              implementation =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.enum
                                                        [
                                                          "kubernetes.cloudify_kubernetes.tasks.custom_resource_delete"
                                                        ],
                                                      _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate"
                                                    ],
                                            } {} true _js2n__-prdslib.always
                                        ],
                                } {} true _js2n__-prdslib.always
                            ],
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/nodeTypeKubernetesResourcesCustomBlueprintDefinedResourceProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesBlueprintDefinedResource!predicate",
                  _js2n__-prdslib.records.record
                    {
                      api_mapping =
                        _js2n__-refsenv."_js2n__-:definitions/kubernetesTypesApiMapping!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/nodeTypeKubernetesResourcesCustomResourceDefinitionProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesBlueprintDefinedResource!predicate"
            ],
      "_js2n__-:definitions/nodeTypeKubernetesResourcesDaemonSetProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesBlueprintDefinedResource!predicate"
            ],
      "_js2n__-:definitions/nodeTypeKubernetesResourcesDeploymentProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesBlueprintDefinedResource!predicate",
                  _js2n__-prdslib.records.record
                    {
                      validate_resource_status =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/nodeTypeKubernetesResourcesFileDefinedResourceInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "cloudify.interfaces.lifecycle" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              create =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "kubernetes.cloudify_kubernetes.tasks.file_resource_create"
                                                    ],
                                                  _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate"
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              delete =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "kubernetes.cloudify_kubernetes.tasks.file_resource_delete"
                                                    ],
                                                  _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate"
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              poststart =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "kubernetes.cloudify_kubernetes.tasks.file_resource_read"
                                                    ],
                                                  _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate"
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeKubernetesResourcesFileDefinedResourceProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesResourceWithValidateStatus!predicate",
                  _js2n__-prdslib.records.record
                    {
                      allow_node_redefinition =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                      file =
                        _js2n__-refsenv."_js2n__-:definitions/kubernetesTypesFileResource!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/nodeTypeKubernetesResourcesIngressProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesBlueprintDefinedResource!predicate",
                  _js2n__-prdslib.records.record
                    { definition = _js2n__-prdslib.isType 'Record, } {} true
                    _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/nodeTypeKubernetesResourcesMultipleFileDefinedResourcesInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "cloudify.interfaces.lifecycle" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              create =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "kubernetes.cloudify_kubernetes.tasks.multiple_file_resource_create"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              delete =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "kubernetes.cloudify_kubernetes.tasks.custom_resource_delete"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              poststart =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "kubernetes.cloudify_kubernetes.tasks.multiple_file_resource_delete"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeKubernetesResourcesMultipleFileDefinedResourcesProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesResourceWithValidateStatus!predicate",
                  _js2n__-prdslib.records.record
                    {
                      allow_node_redefinition =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                      files =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/nodeTypeKubernetesResourcesNamespaceProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesBlueprintDefinedResource!predicate",
                  _js2n__-prdslib.records.record
                    {
                      use_external_resource =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/nodeTypeKubernetesResourcesNetworkPolicyProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesBlueprintDefinedResource!predicate",
                  _js2n__-prdslib.records.record
                    { definition = _js2n__-prdslib.isType 'Record, } {} true
                    _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/nodeTypeKubernetesResourcesNodeProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesBlueprintDefinedResource!predicate",
                  _js2n__-prdslib.records.record
                    {
                      use_external_resource =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/nodeTypeKubernetesResourcesPersistentVolumeClaimProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesBlueprintDefinedResource!predicate",
                  _js2n__-prdslib.records.record
                    { definition = _js2n__-prdslib.isType 'Record, } {} true
                    _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/nodeTypeKubernetesResourcesPersistentVolumeProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesBlueprintDefinedResource!predicate",
                  _js2n__-prdslib.records.record
                    {
                      validate_resource_status =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/nodeTypeKubernetesResourcesPodProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesBlueprintDefinedResource!predicate",
                  _js2n__-prdslib.records.record
                    {
                      use_external_resource =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/nodeTypeKubernetesResourcesPodSecurityPolicyProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesBlueprintDefinedResource!predicate",
                  _js2n__-prdslib.records.record
                    { definition = _js2n__-prdslib.isType 'Record, } {} true
                    _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/nodeTypeKubernetesResourcesReplicaSetProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesBlueprintDefinedResource!predicate",
                  _js2n__-prdslib.records.record
                    {
                      use_external_resource =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/nodeTypeKubernetesResourcesReplicationControllerProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesBlueprintDefinedResource!predicate",
                  _js2n__-prdslib.records.record
                    {
                      use_external_resource =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/nodeTypeKubernetesResourcesResourceBase!predicate"
        | doc ""
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  allow_node_redefinition =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                  client_config =
                    _js2n__-refsenv."_js2n__-:definitions/kubernetesTypesClientConfig!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeKubernetesResourcesResourceWithValidateStatus!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesResourceBase!predicate",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          validate_resource_status =
                            _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                        } {} true _js2n__-prdslib.always
                    ]
                ]
            ],
      "_js2n__-:definitions/nodeTypeKubernetesResourcesRoleBinding!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesBlueprintDefinedResource!predicate",
                  _js2n__-prdslib.records.record
                    {
                      definition =
                        _js2n__-refsenv."_js2n__-:definitions/kubernetesTypesRoleBindingDefinitio!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/nodeTypeKubernetesResourcesRoleProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesBlueprintDefinedResource!predicate",
                  _js2n__-prdslib.records.record
                    {
                      definition =
                        _js2n__-refsenv."_js2n__-:definitions/kubernetesTypesRoleDefinitio!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/nodeTypeKubernetesResourcesSecretProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesBlueprintDefinedResource!predicate",
                  _js2n__-prdslib.records.record
                    {
                      definitions =
                        _js2n__-refsenv."_js2n__-:definitions/kubernetesTypesSecretDefinition!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/nodeTypeKubernetesResourcesServiceAccountProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesBlueprintDefinedResource!predicate",
                  _js2n__-prdslib.records.record
                    {
                      definitions =
                        _js2n__-refsenv."_js2n__-:definitions/kubernetesTypesServiceAccountDefinition!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/nodeTypeKubernetesResourcesServiceProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesBlueprintDefinedResource!predicate",
                  _js2n__-prdslib.records.record
                    {
                      validate_resource_status =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/nodeTypeKubernetesResourcesStatefulSetProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesBlueprintDefinedResource!predicate",
                  _js2n__-prdslib.records.record
                    { definition = _js2n__-prdslib.isType 'Record, } {} true
                    _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/nodeTypeKubernetesResourcesStorageClassProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/nodeTypeKubernetesResourcesBlueprintDefinedResource!predicate",
                  _js2n__-prdslib.records.record
                    {
                      definition =
                        _js2n__-refsenv."_js2n__-:definitions/kubernetesTypesStorageClassResourceDefinition!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/nodeTypeOpenstackFlavorInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "cloudify.interfaces.lifecycle" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              create =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.compute.flavor.create"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              delete =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.compute.flavor.delete"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  "cloudify.interfaces.operations" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              list =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.compute.flavor.list_flavors"
                                                    ]
                                                ],
                                          inputs =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      details =
                                                        _js2n__-prdslib.isType
                                                            '"Bool",
                                                      query =
                                                        _js2n__-prdslib.isType
                                                            'Record,
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              update =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.compute.flavor.update"
                                                    ]
                                                ],
                                          inputs =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      args =
                                                        _js2n__-prdslib.isType
                                                            'Record,
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeOpenstackFlavorProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/openstackExternalResource!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackCreateIfMissing!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackClientConfig!predicate",
                  _js2n__-prdslib.records.record
                    {
                      extra_specs = _js2n__-prdslib.isType 'Record,
                      resource_config =
                        _js2n__-refsenv."_js2n__-:definitions/openstackTypesFlavor!predicate",
                      tenants =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/nodeTypeOpenstackFloatingIPInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "cloudify.interfaces.lifecycle" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              create =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.network.floating_ip.create"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              delete =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.network.floating_ip.delete"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  "cloudify.interfaces.operations" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              list =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.network.floating_ip.list_floating_ips"
                                                    ]
                                                ],
                                          inputs =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      query =
                                                        _js2n__-prdslib.isType
                                                            'Record,
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              update =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.network.floating_ip.update"
                                                    ]
                                                ],
                                          inputs =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      args =
                                                        _js2n__-prdslib.isType
                                                            'Record,
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  "cloudify.interfaces.validation" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              creation =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.network.floating_ip.creation_validation"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeOpenstackFloatingIPProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/openstackExternalResource!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackCreateIfMissing!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackClientConfig!predicate",
                  _js2n__-prdslib.records.record
                    {
                      allow_reallocation =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                      resource_config =
                        _js2n__-refsenv."_js2n__-:definitions/openstackTypesFloatingIP!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/nodeTypeOpenstackGroupInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "cloudify.interfaces.lifecycle" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              create =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.identity.group.create"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              delete =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.identity.group.delete"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  "cloudify.interfaces.operations" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              list =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.identity.group.list_groups"
                                                    ]
                                                ],
                                          inputs =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      query =
                                                        _js2n__-prdslib.isType
                                                            'Record,
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              update =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.identity.group.update"
                                                    ]
                                                ],
                                          inputs =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      args =
                                                        _js2n__-prdslib.isType
                                                            'Record,
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeOpenstackGroupProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/openstackExternalResource!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackCreateIfMissing!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackClientConfig!predicate",
                  _js2n__-prdslib.records.record
                    {
                      resource_config =
                        _js2n__-refsenv."_js2n__-:definitions/openstackTypesGroup!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/nodeTypeOpenstackHostAggregateInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "cloudify.interfaces.lifecycle" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              configure =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.compute.host_aggregate.configure"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              create =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.compute.host_aggregate.create"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              delete =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.compute.host_aggregate.delete"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  "cloudify.interfaces.operations" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              add_hosts =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.compute.host_aggregate.add_hosts"
                                                    ]
                                                ],
                                          inputs =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      hosts =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                '"Array",
                                                              _js2n__-prdslib.arrays.arrayOf
                                                                (_js2n__-prdslib.isType
                                                                  '"String")
                                                            ],
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              list =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.compute.host_aggregate.list_aggregates"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              remove_hosts =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.compute.host_aggregate.remove_hosts"
                                                    ]
                                                ],
                                          inputs =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      hosts =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                '"Array",
                                                              _js2n__-prdslib.arrays.arrayOf
                                                                (_js2n__-prdslib.isType
                                                                  '"String")
                                                            ],
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              update =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.compute.host_aggregate.update"
                                                    ]
                                                ],
                                          inputs =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      args =
                                                        _js2n__-prdslib.isType
                                                            'Record,
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeOpenstackHostAggregateProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/openstackExternalResource!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackCreateIfMissing!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackClientConfig!predicate",
                  _js2n__-prdslib.records.record
                    {
                      hosts =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                      metadata = _js2n__-prdslib.isType 'Record,
                      resource_config =
                        _js2n__-refsenv."_js2n__-:definitions/openstackTypesHostAggregate!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/nodeTypeOpenstackImageInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "cloudify.interfaces.lifecycle" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              create =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.compute.image.create"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              delete =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.compute.image.delete"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              start =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.compute.image.start"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  "cloudify.interfaces.operations" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              list =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.compute.image.list_images"
                                                    ]
                                                ],
                                          inputs =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      query =
                                                        _js2n__-prdslib.isType
                                                            'Record,
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              update =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.compute.image.update"
                                                    ]
                                                ],
                                          inputs =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      args =
                                                        _js2n__-prdslib.isType
                                                            'Record,
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  "cloudify.interfaces.validation" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              creation =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.compute.image.creation_validation"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeOpenstackImageProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/openstackExternalResource!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackCreateIfMissing!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackClientConfig!predicate",
                  _js2n__-prdslib.records.record
                    {
                      image_url =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                      resource_config =
                        _js2n__-refsenv."_js2n__-:definitions/openstackTypesImage!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/nodeTypeOpenstackKeyPairInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "cloudify.interfaces.lifecycle" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              create =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.compute.keypair.create"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              delete =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.compute.keypair.delete"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  "cloudify.interfaces.operations" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              list =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.compute.keypair.list_keypairs"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  "cloudify.interfaces.validation" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              creation =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.compute.keypair.creation_validation"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeOpenstackKeyPairProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/openstackExternalResource!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackCreateIfMissing!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackClientConfig!predicate",
                  _js2n__-prdslib.records.record
                    {
                      resource_config =
                        _js2n__-refsenv."_js2n__-:definitions/openstackTypesKeyPair!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/nodeTypeOpenstackNetworkBaseProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/openstackExternalResource!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackCreateIfMissing!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackClientConfig!predicate"
                ]
            ],
      "_js2n__-:definitions/nodeTypeOpenstackNetworkInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "cloudify.interfaces.lifecycle" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              create =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.network.network.create"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              delete =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.network.network.delete"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  "cloudify.interfaces.operations" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              list =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.network.network.list_networks"
                                                    ]
                                                ],
                                          inputs =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      query =
                                                        _js2n__-prdslib.isType
                                                            'Record,
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              update =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.network.network.update"
                                                    ]
                                                ],
                                          inputs =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      args =
                                                        _js2n__-prdslib.isType
                                                            'Record,
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  "cloudify.interfaces.validation" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              creation =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.network.network.creation_validation"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeOpenstackNetworkProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/nodeTypeOpenstackNetworkBaseProperties!predicate",
                  _js2n__-prdslib.records.record
                    {
                      resource_config =
                        _js2n__-refsenv."_js2n__-:definitions/openstackTypesNetwork!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/nodeTypeOpenstackPortInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "cloudify.interfaces.lifecycle" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              create =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.network.port.create"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              delete =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.network.port.delete"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  "cloudify.interfaces.operations" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              list =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.network.port.list_ports"
                                                    ]
                                                ],
                                          inputs =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      query =
                                                        _js2n__-prdslib.isType
                                                            'Record,
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              update =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.network.port.update"
                                                    ]
                                                ],
                                          inputs =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      args =
                                                        _js2n__-prdslib.isType
                                                            'Record,
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  "cloudify.interfaces.validation" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              creation =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.network.port.creation_validation"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeOpenstackPortProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/openstackExternalResource!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackCreateIfMissing!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackClientConfig!predicate",
                  _js2n__-prdslib.records.record
                    {
                      fixed_ip =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                      resource_config =
                        _js2n__-refsenv."_js2n__-:definitions/openstackTypesPort!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/nodeTypeOpenstackProjectInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "cloudify.interfaces.lifecycle" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              create =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.identity.project.create"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              delete =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.identity.project.delete"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              start =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.identity.project.start"
                                                    ]
                                                ],
                                          inputs =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      quota_dict =
                                                        _js2n__-prdslib.isType
                                                            'Record,
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  "cloudify.interfaces.operations" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              get_quota =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.identity.project.get_project_quota"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              list =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.identity.project.list_projects"
                                                    ]
                                                ],
                                          inputs =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      query =
                                                        _js2n__-prdslib.isType
                                                            'Record,
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              update_project =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.identity.project.update"
                                                    ]
                                                ],
                                          inputs =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      args =
                                                        _js2n__-prdslib.isType
                                                            'Record,
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              update_quota =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.identity.project.update_project_quota"
                                                    ]
                                                ],
                                          inputs =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      quota =
                                                        _js2n__-prdslib.isType
                                                            'Record,
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  "cloudify.interfaces.validation" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              creation =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [
                                          "openstack.openstack_plugin.resources.identity.project.creation_validation"
                                        ]
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeOpenstackProjectProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/openstackExternalResource!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackCreateIfMissing!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackClientConfig!predicate",
                  _js2n__-prdslib.records.record
                    {
                      groups =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                      quota = _js2n__-prdslib.isType 'Record,
                      resource_config =
                        _js2n__-refsenv."_js2n__-:definitions/openstackTypesProject!predicate",
                      users =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/nodeTypeOpenstackRBACPolicyProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/openstackDataTypeId!predicate",
                  _js2n__-prdslib.records.record
                    {
                      action =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                      object_id =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                      object_type =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                      target_tenant =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/nodeTypeOpenstackRecordSetInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "cloudify.interfaces.lifecycle" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              create =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.dns_service.record_set.create"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              delete =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.dns_service.record_set.delete"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeOpenstackRecordSetProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/openstackClientConfig!predicate",
                  _js2n__-prdslib.records.record
                    {
                      resource_config =
                        _js2n__-refsenv."_js2n__-:definitions/openstackRecordSetType!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/nodeTypeOpenstackRoleInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "cloudify.interfaces.lifecycle" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              create =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.identity.role.create"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              delete =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.identity.role.delete"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  "cloudify.interfaces.operations" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              list =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.identity.role.list_roles"
                                                    ]
                                                ],
                                          inputs =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      query =
                                                        _js2n__-prdslib.isType
                                                            'Record,
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              update =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.identity.role.update"
                                                    ]
                                                ],
                                          inputs =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      args =
                                                        _js2n__-prdslib.isType
                                                            'Record,
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeOpenstackRoleProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/openstackExternalResource!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackCreateIfMissing!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackClientConfig!predicate",
                  _js2n__-prdslib.records.record
                    {
                      resource_config =
                        _js2n__-refsenv."_js2n__-:definitions/openstackTypesRole!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/nodeTypeOpenstackRouterInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "cloudify.interfaces.lifecycle" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              create =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.network.router.create"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              delete =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.network.router.delete"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              start =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.network.router.start"
                                                    ]
                                                ],
                                          inputs =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      routes =
                                                        _js2n__-prdslib.isType
                                                            'Record,
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              stop =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.network.router.stop"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  "cloudify.interfaces.operations" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              list =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.network.router.list_routers"
                                                    ]
                                                ],
                                          inputs =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      query =
                                                        _js2n__-prdslib.isType
                                                            'Record,
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              update =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.network.router.update"
                                                    ]
                                                ],
                                          inputs =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      args =
                                                        _js2n__-prdslib.isType
                                                            'Record,
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  "cloudify.interfaces.validation" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              creation =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.network.router.creation_validation"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeOpenstackRouterProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/openstackExternalResource!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackCreateIfMissing!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackClientConfig!predicate",
                  _js2n__-prdslib.records.record
                    {
                      external_network =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                      resource_config =
                        _js2n__-refsenv."_js2n__-:definitions/openstackTypesRouter!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/nodeTypeOpenstackSecurityGroupInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "cloudify.interfaces.lifecycle" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              configure =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.network.security_group.configure"
                                                    ]
                                                ],
                                          inputs =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      security_group_rules =
                                                        _js2n__-prdslib.anyOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                '"Array",
                                                              _js2n__-prdslib.isType
                                                                'Record
                                                            ],
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              create =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.network.security_group.create"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              delete =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.network.security_group.delete"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  "cloudify.interfaces.operations" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              list =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.network.security_group.list_security_groups"
                                                    ]
                                                ],
                                          inputs =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      query =
                                                        _js2n__-prdslib.isType
                                                            'Record,
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              update =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.network.security_group.update"
                                                    ]
                                                ],
                                          inputs =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      args =
                                                        _js2n__-prdslib.isType
                                                            'Record,
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  "cloudify.interfaces.validation" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              creation =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.network.security_group.creation_validation"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeOpenstackSecurityGroupProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/openstackExternalResource!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackCreateIfMissing!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackClientConfig!predicate",
                  _js2n__-prdslib.records.record
                    {
                      disable_default_egress_rules =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                      resource_config =
                        _js2n__-refsenv."_js2n__-:definitions/openstackTypesSecurityGroup!predicate",
                      security_group_rules =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/nodeTypeOpenstackSecurityGroupRuleInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/nodeTypeOpenstackSecurityGroupInterfaces!predicate",
                  _js2n__-prdslib.records.record
                    {
                      "cloudify.interfaces.lifecycle" =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  create =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.record
                                            {
                                              implementation =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"String",
                                                      _js2n__-prdslib.enum
                                                        [
                                                          "openstack.openstack_plugin.resources.network.security_group_rule.create"
                                                        ]
                                                    ],
                                            } {} true _js2n__-prdslib.always
                                        ],
                                  delete =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.record
                                            {
                                              implementation =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"String",
                                                      _js2n__-prdslib.enum
                                                        [
                                                          "openstack.openstack_plugin.resources.network.security_group_rule.delete"
                                                        ]
                                                    ],
                                            } {} true _js2n__-prdslib.always
                                        ],
                                } {} true _js2n__-prdslib.always
                            ],
                      "cloudify.interfaces.operations" =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  list =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.record
                                            {
                                              implementation =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"String",
                                                      _js2n__-prdslib.enum
                                                        [
                                                          "openstack.openstack_plugin.resources.network.security_group_rule.list_security_group_rules"
                                                        ]
                                                    ],
                                              inputs =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        'Record,
                                                      _js2n__-prdslib.records.record
                                                        {
                                                          query =
                                                            _js2n__-prdslib.isType
                                                                'Record,
                                                        } {} true
                                                        _js2n__-prdslib.always
                                                    ],
                                            } {} true _js2n__-prdslib.always
                                        ],
                                } {} true _js2n__-prdslib.always
                            ],
                      "cloudify.interfaces.validation" =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  creation =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.record
                                            {
                                              implementation =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"String",
                                                      _js2n__-prdslib.enum
                                                        [
                                                          "openstack.openstack_plugin.resources.network.security_group_rule.creation_validation"
                                                        ]
                                                    ],
                                            } {} true _js2n__-prdslib.always
                                        ],
                                } {} true _js2n__-prdslib.always
                            ],
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/nodeTypeOpenstackSecurityGroupRuleProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/nodeTypeOpenstackSecurityGroupProperties!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackExternalResource!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackCreateIfMissing!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackClientConfig!predicate",
                  _js2n__-prdslib.records.record
                    {
                      resource_config =
                        _js2n__-refsenv."_js2n__-:definitions/openstackTypesSecurityGroupRule!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/nodeTypeOpenstackServerProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/openstackDataTypeKwargs!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackDataTypeName!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackDataTypeId!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackDataTypeDescription!predicate",
                  _js2n__-prdslib.records.record
                    {
                      availability_zone =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                      flavor_id =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                      image_id =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                      key_name =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                      metadata = _js2n__-prdslib.isType 'Record,
                      networks =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                      security_groups =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                      user_data =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/nodeTypeOpenstackSubnetInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "cloudify.interfaces.lifecycle" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              create =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.network.subnet.create"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              delete =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.network.subnet.delete"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  "cloudify.interfaces.operations" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              list =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.network.subnet.list_subnets"
                                                    ]
                                                ],
                                          inputs =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      query =
                                                        _js2n__-prdslib.isType
                                                            'Record,
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              update =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.network.subnet.update"
                                                    ]
                                                ],
                                          inputs =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      args =
                                                        _js2n__-prdslib.isType
                                                            'Record,
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  "cloudify.interfaces.validation" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              creation =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.network.subnet.creation_validation"
                                                    ]
                                                ],
                                          inputs =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      args =
                                                        _js2n__-prdslib.isType
                                                            'Record,
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeOpenstackSubnetProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/nodeTypeOpenstackNetworkBaseProperties!predicate",
                  _js2n__-prdslib.records.record
                    {
                      resource_config =
                        _js2n__-refsenv."_js2n__-:definitions/openstackTypesSubnet!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/nodeTypeOpenstackUserInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "cloudify.interfaces.lifecycle" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              create =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.identity.user.create"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              delete =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.identity.user.delete"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  "cloudify.interfaces.operations" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              list =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.identity.user.list_users"
                                                    ]
                                                ],
                                          inputs =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      query =
                                                        _js2n__-prdslib.isType
                                                            'Record,
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              update =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.identity.user.update"
                                                    ]
                                                ],
                                          inputs =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      args =
                                                        _js2n__-prdslib.isType
                                                            'Record,
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeOpenstackUserProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/openstackExternalResource!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackCreateIfMissing!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackClientConfig!predicate",
                  _js2n__-prdslib.records.record
                    {
                      resource_config =
                        _js2n__-refsenv."_js2n__-:definitions/openstackTypesUser!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/nodeTypeOpenstackVolumeInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "cloudify.interfaces.lifecycle" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              create =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.volume.volume.create"
                                                    ]
                                                ],
                                          inputs =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      args =
                                                        _js2n__-prdslib.isType
                                                            'Record,
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              delete =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.volume.volume.delete"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              start =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.volume.volume.start"
                                                    ]
                                                ],
                                          inputs =
                                            _js2n__-prdslib.isType 'Record,
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  "cloudify.interfaces.operations" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              list =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.volume.volume.list_volumes"
                                                    ]
                                                ],
                                          inputs =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      query =
                                                        _js2n__-prdslib.isType
                                                            'Record,
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  "cloudify.interfaces.snapshot" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              apply =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.volume.volume.snapshot_apply"
                                                    ]
                                                ],
                                          inputs =
                                            _js2n__-prdslib.isType 'Record,
                                        } {} true _js2n__-prdslib.always
                                    ],
                              create =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.volume.volume.snapshot_create"
                                                    ]
                                                ],
                                          inputs =
                                            _js2n__-prdslib.isType 'Record,
                                        } {} true _js2n__-prdslib.always
                                    ],
                              delete =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.volume.volume.snapshot_delete"
                                                    ]
                                                ],
                                          inputs =
                                            _js2n__-prdslib.isType 'Record,
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  "cloudify.interfaces.validation" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              creation =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.volume.volume.creation_validation"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeOpenstackVolumeProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/openstackExternalResource!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackCreateIfMissing!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackClientConfig!predicate",
                  _js2n__-prdslib.records.record
                    {
                      device_name =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                      resource_config =
                        _js2n__-refsenv."_js2n__-:definitions/openstackTypesVolume!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/nodeTypeOpenstackVolumeTypeInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "cloudify.interfaces.lifecycle" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              create =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.volume.volume_type.create"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              delete =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.volume.volume_type.delete"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeOpenstackVolumeTypeProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/openstackExternalResource!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackCreateIfMissing!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackClientConfig!predicate",
                  _js2n__-prdslib.records.record
                    {
                      resource_config =
                        _js2n__-refsenv."_js2n__-:definitions/openstackTypesVolumeType!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/nodeTypeOpenstackWindowsServerProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/nodeTypeOpenstackServerProperties!predicate",
                  _js2n__-prdslib.records.record
                    {
                      agent_config =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyDataTypesAgentConfig!predicate",
                      os_family =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/nodeTypeOpenstackZoneInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "cloudify.interfaces.lifecycle" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              create =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.dns_service.zone.create"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              delete =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "openstack.openstack_plugin.resources.dns_service.zone.delete"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeOpenstackZoneProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/openstackClientConfig!predicate",
                  _js2n__-prdslib.records.record
                    {
                      resource_config =
                        _js2n__-refsenv."_js2n__-:definitions/openstackTypesZoneType!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/nodeTypeTerraformDirectoryConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  executable_path =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  plugins_dir =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  storage_path =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeTerraformInstallConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "use_existing_resource" ],
              _js2n__-prdslib.records.record
                {
                  installation_source =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  plugins =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  use_existing_resource =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeTerraformInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "cloudify.interfaces.lifecycle" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              create =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "tf.cloudify_tf.tasks.install"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              delete =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "tf.cloudify_tf.tasks.uninstall"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeTerraformModuleInterfaces!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "cloudify.interfaces.lifecycle" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              delete =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "tf.cloudify_tf.tasks.destroy"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              start =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "tf.cloudify_tf.tasks.apply"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  terraform =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              refresh =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "tf.cloudify_tf.tasks.state_pull"
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              reload =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          implementation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "tf.cloudify_tf.tasks.reload_template"
                                                    ]
                                                ],
                                          inputs =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      destroy_previous =
                                                        _js2n__-prdslib.isType
                                                            '"Bool",
                                                      source =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeTerraformModuleProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  resource_config =
                    _js2n__-refsenv."_js2n__-:definitions/terraformTypesRootModule!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nodeTypeTerraformProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/terraformConfig!predicate",
                  _js2n__-prdslib.records.record
                    {
                      resource_config =
                        _js2n__-refsenv."_js2n__-:definitions/nodeTypeTerraformInstallConfig!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/nodeTypes!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType 'Record,
                _js2n__-prdslib.records.record {}
                  {
                    "" =
                      _js2n__-refsenv."_js2n__-:definitions/nodeType!predicate",
                  } true _js2n__-prdslib.always
              ]),
      "_js2n__-:definitions/openstackClientConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  client_config =
                    _js2n__-refsenv."_js2n__-:definitions/openstackTypeClientConfig!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/openstackCreateIfMissing!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  create_if_missing =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/openstackDataTypeDescription!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  description =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/openstackDataTypeId!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  id =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/openstackDataTypeKwargs!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { "kwargs:" = _js2n__-prdslib.isType 'Record, } {} true
                _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/openstackDataTypeName!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  name =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/openstackExternalResource!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  use_external_resource =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/openstackRecordSetType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/openstackDataTypeKwargs!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackDataTypeName!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackDataTypeDescription!predicate",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "records", "zone_id" ],
                      _js2n__-prdslib.records.record
                        {
                          records =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    (_js2n__-prdslib.isType '"String")
                                ],
                          ttl =
                            _js2n__-refsenv."_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate",
                          type =
                            _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                          zone_id =
                            _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                        } {} true _js2n__-prdslib.always
                    ]
                ]
            ],
      "_js2n__-:definitions/openstackTypeClientConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  auth_url =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  ca_cert =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  insecure =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate",
                  kwargs = _js2n__-prdslib.isType 'Record,
                  logging =
                    _js2n__-refsenv."_js2n__-:definitions/openstackTypesLogging!predicate",
                  password =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  project_domain_id =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  project_domain_name =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  project_name =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  region_name =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  tenant_name =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  user_domain_id =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  user_domain_name =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  username =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/openstackTypesFlavor!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/openstackDataTypeKwargs!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackDataTypeName!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackDataTypeId!predicate",
                  _js2n__-prdslib.records.record
                    {
                      disk =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate",
                      ram =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate",
                      vcpus =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/openstackTypesFloatingIP!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/openstackDataTypeKwargs!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackDataTypeName!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackDataTypeId!predicate",
                  _js2n__-prdslib.records.record
                    {
                      dns_domain =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                      dns_name =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                      fixed_ip_address =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                      floating_ip_address =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                      floating_network_id =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                      floating_network_name =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                      port_id =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                      subnet_id =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/openstackTypesGroup!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/openstackDataTypeKwargs!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackDataTypeName!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackDataTypeId!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackDataTypeDescription!predicate",
                  _js2n__-prdslib.records.record
                    {
                      domain_id =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/openstackTypesHostAggregate!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/openstackDataTypeName!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackDataTypeId!predicate",
                  _js2n__-prdslib.records.record
                    {
                      availability_zone =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/openstackTypesImage!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/openstackDataTypeKwargs!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackDataTypeName!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackDataTypeId!predicate",
                  _js2n__-prdslib.records.record
                    {
                      container_format =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                      disk_format =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                      tags =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/openstackTypesKeyPair!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/openstackDataTypeKwargs!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackDataTypeName!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackDataTypeId!predicate",
                  _js2n__-prdslib.records.record
                    {
                      public_key =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/openstackTypesLogging!predicate"
        | doc m%"
          For logging groups' configuration. Each level can be one of the following values:
          critical/error/warning/info/debug/notset
        "%
        = _js2n__-prdslib.records.record
            {
              openstack =
                _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
            } {} true _js2n__-prdslib.always,
      "_js2n__-:definitions/openstackTypesNetwork!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/openstackDataTypeKwargs!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackDataTypeName!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackDataTypeId!predicate",
                  _js2n__-prdslib.records.record
                    {
                      admin_state_up =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/openstackTypesPort!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/openstackDataTypeKwargs!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackDataTypeName!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackDataTypeId!predicate",
                  _js2n__-prdslib.records.record
                    {
                      allowed_address_pairs =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                      device_id =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                      device_owner =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                      fixed_ips =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                      network_id =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                      security_groups =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/openstackTypesProject!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/openstackDataTypeKwargs!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackDataTypeName!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackDataTypeId!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackDataTypeDescription!predicate",
                  _js2n__-prdslib.records.record
                    {
                      domain_id =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                      is_domain =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                      parent_id =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                      tags =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/openstackTypesRole!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/openstackDataTypeKwargs!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackDataTypeName!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackDataTypeId!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackDataTypeDescription!predicate",
                  _js2n__-prdslib.records.record
                    {
                      domain_id =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/openstackTypesRouter!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/openstackDataTypeKwargs!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackDataTypeName!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackDataTypeId!predicate"
                ]
            ],
      "_js2n__-:definitions/openstackTypesSecurityGroup!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/openstackDataTypeKwargs!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackDataTypeName!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackDataTypeId!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackDataTypeDescription!predicate"
                ]
            ],
      "_js2n__-:definitions/openstackTypesSecurityGroupRule!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/openstackDataTypeKwargs!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackDataTypeId!predicate",
                  _js2n__-prdslib.records.record
                    {
                      direction =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                      port_range_max =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate",
                      port_range_min =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate",
                      protocol =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                      remote_group_id =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                      remote_ip_prefix =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                      security_group_id =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/openstackTypesSubnet!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/openstackDataTypeKwargs!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackDataTypeName!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackDataTypeId!predicate",
                  _js2n__-prdslib.records.record
                    {
                      allocation_pools =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                      cidr =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                      dns_nameservers =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                      enable_dhcp =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                      gateway_ip =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                      host_routes =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                      ip_version =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                      ipv6_address_mode =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                      ipv6_ra_mode =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                      network_id =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                      prefixlen =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/openstackTypesUser!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/openstackDataTypeKwargs!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackDataTypeName!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackDataTypeId!predicate",
                  _js2n__-prdslib.records.record
                    {
                      default_project_id =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                      domain_id =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                      email =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                      enabled =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                      password =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/openstackTypesVolume!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/openstackDataTypeKwargs!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackDataTypeName!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackDataTypeId!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackDataTypeDescription!predicate",
                  _js2n__-prdslib.records.record
                    {
                      availability_zone =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                      imageRef =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                      project_id =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                      size =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate",
                      snapshot_id =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                      volume_type =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/openstackTypesVolumeType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/openstackDataTypeKwargs!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackDataTypeName!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackDataTypeId!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackDataTypeDescription!predicate",
                  _js2n__-prdslib.records.record
                    {
                      extra_specs = _js2n__-prdslib.isType 'Record,
                      project_id =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/openstackTypesZoneType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/openstackDataTypeKwargs!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackDataTypeName!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/openstackDataTypeDescription!predicate",
                  _js2n__-prdslib.records.record
                    {
                      attributes = _js2n__-prdslib.isType 'Record,
                      email =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                      masters =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                      ttl =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate",
                      type =
                        _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/restTemplateInputs!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  force_rerun =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                  params = _js2n__-prdslib.isType 'Record,
                  prerender =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                  remove_calls =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                  retry_count =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate",
                  retry_sleep =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyIntegerOrGetInput!predicate",
                  save_path =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyBooleanOrGetInput!predicate",
                  template_file =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/tags!predicate"
        | doc "Tags to add to an EC2 resource"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        Key =
                          _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                        Value =
                          _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                      } {} true _js2n__-prdslib.always
                  ])
            ],
      "_js2n__-:definitions/terraformConfig!predicate"
        | doc "Terraform directories for executions."
        = _js2n__-refsenv."_js2n__-:definitions/nodeTypeTerraformDirectoryConfig!predicate",
      "_js2n__-:definitions/terraformTypesBackend!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  name =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  options = _js2n__-prdslib.isType 'Record,
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/terraformTypesRootModule!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "source" ],
              _js2n__-prdslib.records.record
                {
                  backend =
                    _js2n__-refsenv."_js2n__-:definitions/terraformTypesBackend!predicate",
                  environment_variables = _js2n__-prdslib.isType 'Record,
                  source =
                    _js2n__-refsenv."_js2n__-:definitions/cloudifyStringOrGetInput!predicate",
                  variables = _js2n__-prdslib.isType 'Record,
                } {} true _js2n__-prdslib.always
            ],
    }
    in
  {
      data_types
        | _js2n__-refsenv."_js2n__-:definitions/dataTypes!contract"
        | optional,
      dsl_definitions | {  .. } | optional,
      imports
        | Array (
          _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.anyOf
              [
                _js2n__-prdslib.isType '"String",
                _js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.enum
                      [
                        "http://www.getcloudify.org/spec/cloudify/4.5/types.yaml",
                        "plugin:cloudify-ansible-plugin",
                        "plugin:cloudify-aws-plugin",
                        "plugin:cloudify-azure-plugin",
                        "plugin:cloudify-cloudstack-plugin",
                        "plugin:cloudify-diamond-plugin",
                        "plugin:cloudify-fabric-plugin",
                        "plugin:cloudify-gcp-plugin",
                        "plugin:cloudify-host-pool-plugin",
                        "plugin:cloudify-kubernetes-plugin",
                        "plugin:cloudify-openstack-plugin",
                        "plugin:cloudify-utilities-plugin",
                        "plugin:cloudify-vsphere-plugin",
                        "plugin:cloudify-terraform-plugin",
                        "plugin:cloudify-helm-plugin"
                      ]
                  ]
              ])
        )
        | doc "imports enable the author of a blueprint to reuse blueprint files, or parts of them, and to use predefined types (e.g. from the types.yaml file)."
        | optional,
      inputs
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  aws_access_key_id =
                    _js2n__-refsenv."_js2n__-:definitions/inputProperty!predicate",
                  aws_account_id =
                    _js2n__-refsenv."_js2n__-:definitions/inputProperty!predicate",
                  aws_cloudwatch_log_arn =
                    _js2n__-refsenv."_js2n__-:definitions/inputProperty!predicate",
                  aws_region_name =
                    _js2n__-refsenv."_js2n__-:definitions/inputProperty!predicate",
                  aws_region_zone1 =
                    _js2n__-refsenv."_js2n__-:definitions/inputProperty!predicate",
                  aws_region_zone2 =
                    _js2n__-refsenv."_js2n__-:definitions/inputProperty!predicate",
                  aws_secret_access_key =
                    _js2n__-refsenv."_js2n__-:definitions/inputProperty!predicate",
                }
                {
                  "" =
                    _js2n__-refsenv."_js2n__-:definitions/inputProperty!predicate",
                } true _js2n__-prdslib.always
            ])
        | doc "inputs are parameters that are injected into a blueprint when a deployment is created. These parameters can be referenced by using the get_input intrinsic function."
        | optional,
      node_templates
        | _js2n__-refsenv."_js2n__-:definitions/nodeTemplates!contract"
        | optional,
      node_types
        | _js2n__-refsenv."_js2n__-:definitions/nodeTypes!contract"
        | optional,
      tosca_definitions_version
        | std.enum.TagOrString
        | [|
          'cloudify_dsl_1_3,
          'cloudify_dsl_1_2,
          'cloudify_dsl_1_1,
          'cloudify_dsl_1_0
        |]
        | doc "tosca_definitions_version is a top level property of the blueprint which is used to specify the DSL version used. For Cloudify, the versions that are currently defined are cloudify_dsl_1_0, cloudify_dsl_1_1, cloudify_dsl_1_2 and cloudify_dsl_1_3."
        | optional,
      ..
    }