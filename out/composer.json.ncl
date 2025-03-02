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
      "_js2n__-:definitions/artifact-repository!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "type", "url" ],
              _js2n__-prdslib.records.record
                {
                  canonical = _js2n__-prdslib.isType '"Bool",
                  exclude =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  only =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "artifact" ]
                        ],
                  url = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/authors!contract"
        | doc "List of authors that contributed to the package. This is typically the main maintainers, not the full list."
        = Array
            {
              email | String | doc "Email address of the author." | optional,
              homepage | String | doc "Homepage URL for the author." | optional,
              name | String | doc "Full name of the author.",
              role | String | doc "Author's role in the project." | optional,
            },
      "_js2n__-:definitions/authors!predicate"
        | doc "List of authors that contributed to the package. This is typically the main maintainers, not the full list."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.required [ "name" ],
                    _js2n__-prdslib.records.record
                      {
                        email = _js2n__-prdslib.isType '"String",
                        homepage = _js2n__-prdslib.isType '"String",
                        name = _js2n__-prdslib.isType '"String",
                        role = _js2n__-prdslib.isType '"String",
                      } {} false _js2n__-prdslib.never
                  ])
            ],
      "_js2n__-:definitions/autoload!contract"
        | doc "Description of how the package can be autoloaded."
        = {
            classmap
              | Array Dyn
              | doc "This is an array of paths that contain classes to be included in the class-map generation process."
              | optional,
            exclude-from-classmap
              | Array Dyn
              | doc "This is an array of patterns to exclude from autoload classmap generation. (e.g. \"exclude-from-classmap\": [\"/test/\", \"/tests/\", \"/Tests/\"]"
              | optional,
            files
              | Array Dyn
              | doc "This is an array of files that are always required on every request."
              | optional,
            psr-0
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record {} {} true
                      (_js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType '"Array"
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ])
                  ])
              | doc "This is an object of namespaces (keys) and the directories they can be found in (values, can be arrays of paths) by the autoloader."
              | optional,
            psr-4
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record {} {} true
                      (_js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType '"Array"
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ])
                  ])
              | doc "This is an object of namespaces (keys) and the PSR-4 directories they can map to (values, can be arrays of paths) by the autoloader."
              | optional,
            ..
          },
      "_js2n__-:definitions/autoload!predicate"
        | doc "Description of how the package can be autoloaded."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  classmap = _js2n__-prdslib.isType '"Array",
                  exclude-from-classmap = _js2n__-prdslib.isType '"Array",
                  files = _js2n__-prdslib.isType '"Array",
                  psr-0 =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.anyOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.isType '"Array"
                                  ],
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.isType '"String")
                              ])
                        ],
                  psr-4 =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.anyOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.isType '"Array"
                                  ],
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.isType '"String")
                              ])
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/composer-repository!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "type", "url" ],
              _js2n__-prdslib.records.record
                {
                  allow_ssl_downgrade = _js2n__-prdslib.isType '"Bool",
                  canonical = _js2n__-prdslib.isType '"Bool",
                  exclude =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  force-lazy-providers = _js2n__-prdslib.isType '"Bool",
                  only =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  options =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-prdslib.always
                        ],
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "composer" ]
                        ],
                  url = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/dist!contract" =
        {
            mirrors | Array Dyn | optional,
            reference | String | optional,
            shasum | String | optional,
            type | String,
            url | String,
            ..
          },
      "_js2n__-:definitions/dist!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "type", "url" ],
              _js2n__-prdslib.records.record
                {
                  mirrors = _js2n__-prdslib.isType '"Array",
                  reference = _js2n__-prdslib.isType '"String",
                  shasum = _js2n__-prdslib.isType '"String",
                  type = _js2n__-prdslib.isType '"String",
                  url = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/inline-package!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name", "version" ],
              _js2n__-prdslib.records.record
                {
                  archive =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [ _js2n__-prdslib.isType 'Record ],
                          _js2n__-prdslib.records.record
                            { exclude = _js2n__-prdslib.isType '"Array", } {}
                            true _js2n__-prdslib.always
                        ],
                  authors =
                    _js2n__-refsenv."_js2n__-:definitions/authors!predicate",
                  autoload =
                    _js2n__-refsenv."_js2n__-:definitions/autoload!predicate",
                  bin =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType '"Array"
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  conflict =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  description = _js2n__-prdslib.isType '"String",
                  dist = _js2n__-refsenv."_js2n__-:definitions/dist!predicate",
                  extra =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.isType '"Array"
                            ],
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-prdslib.always
                        ],
                  homepage = _js2n__-prdslib.isType '"String",
                  include-path =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [ _js2n__-prdslib.isType '"Array" ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  keywords =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  license =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Array"
                        ],
                  name = _js2n__-prdslib.isType '"String",
                  provide =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  replace =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  require =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  require-dev =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  source =
                    _js2n__-refsenv."_js2n__-:definitions/source!predicate",
                  suggest =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  target-dir = _js2n__-prdslib.isType '"String",
                  time = _js2n__-prdslib.isType '"String",
                  type = _js2n__-prdslib.isType '"String",
                  version = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/package-repository!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "package", "type" ],
              _js2n__-prdslib.records.record
                {
                  canonical = _js2n__-prdslib.isType '"Bool",
                  exclude =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  only =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  package =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/inline-package!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/inline-package!predicate"
                            ]
                        ],
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "package" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/path-repository!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "type", "url" ],
              _js2n__-prdslib.records.record
                {
                  canonical = _js2n__-prdslib.isType '"Bool",
                  exclude =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  only =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  options =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              symlink =
                                _js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.isType '"Bool",
                                      _js2n__-prdslib.isType 'Null
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "path" ]
                        ],
                  url = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/pear-repository!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "type", "url" ],
              _js2n__-prdslib.records.record
                {
                  canonical = _js2n__-prdslib.isType '"Bool",
                  exclude =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  only =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "pear" ]
                        ],
                  url = _js2n__-prdslib.isType '"String",
                  vendor-alias = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/repository!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.anyOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/composer-repository!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/vcs-repository!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/path-repository!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/artifact-repository!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/pear-repository!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/package-repository!predicate"
                ]
            ],
      "_js2n__-:definitions/source!contract" =
        {
            mirrors | Array Dyn | optional,
            reference | String,
            type | String,
            url | String,
            ..
          },
      "_js2n__-:definitions/source!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "reference", "type", "url" ],
              _js2n__-prdslib.records.record
                {
                  mirrors = _js2n__-prdslib.isType '"Array",
                  reference = _js2n__-prdslib.isType '"String",
                  type = _js2n__-prdslib.isType '"String",
                  url = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/vcs-repository!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "type", "url" ],
              _js2n__-prdslib.records.record
                {
                  branch = _js2n__-prdslib.isType '"String",
                  branches-path =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Bool"
                        ],
                  canonical = _js2n__-prdslib.isType '"Bool",
                  depot = _js2n__-prdslib.isType '"String",
                  exclude =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  no-api = _js2n__-prdslib.isType '"Bool",
                  only =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  p4password = _js2n__-prdslib.isType '"String",
                  p4user = _js2n__-prdslib.isType '"String",
                  package-path = _js2n__-prdslib.isType '"String",
                  secure-http = _js2n__-prdslib.isType '"Bool",
                  svn-cache-credentials = _js2n__-prdslib.isType '"Bool",
                  tags-path =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Bool"
                        ],
                  trunk-path =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Bool"
                        ],
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "vcs",
                              "github",
                              "git",
                              "gitlab",
                              "bitbucket",
                              "git-bitbucket",
                              "hg",
                              "fossil",
                              "perforce",
                              "svn"
                            ]
                        ],
                  unique_perforce_client_name =
                    _js2n__-prdslib.isType '"String",
                  url = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
    }
    in
  {
      _comment
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.isType '"String"
            ])
        | doc "A key to store comments in"
        | optional,
      abandoned
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType '"Bool",
              _js2n__-prdslib.isType '"String"
            ])
        | doc "Indicates whether this package has been abandoned, it can be boolean or a package name/URL pointing to a recommended alternative. Defaults to false."
        | optional,
      archive
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf [ _js2n__-prdslib.isType 'Record ],
              _js2n__-prdslib.records.record
                {
                  exclude = _js2n__-prdslib.isType '"Array",
                  name = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ])
        | doc "Options for creating package archives for distribution."
        | optional,
      authors
        | _js2n__-refsenv."_js2n__-:definitions/authors!contract"
        | optional,
      autoload
        | _js2n__-refsenv."_js2n__-:definitions/autoload!contract"
        | optional,
      autoload-dev
        | {
          classmap
            | Array Dyn
            | doc "This is an array of paths that contain classes to be included in the class-map generation process."
            | optional,
          files
            | Array Dyn
            | doc "This is an array of files that are always required on every request."
            | optional,
          psr-0
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record {} {} true
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.isType '"String",
                            _js2n__-prdslib.isType '"Array"
                          ],
                        _js2n__-prdslib.arrays.arrayOf
                          (_js2n__-prdslib.isType '"String")
                      ])
                ])
            | doc "This is an object of namespaces (keys) and the directories they can be found into (values, can be arrays of paths) by the autoloader."
            | optional,
          psr-4
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record {} {} true
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.isType '"String",
                            _js2n__-prdslib.isType '"Array"
                          ],
                        _js2n__-prdslib.arrays.arrayOf
                          (_js2n__-prdslib.isType '"String")
                      ])
                ])
            | doc "This is an object of namespaces (keys) and the PSR-4 directories they can map to (values, can be arrays of paths) by the autoloader."
            | optional,
          ..
        }
        | doc "Description of additional autoload rules for development purpose (eg. a test suite)."
        | optional,
      bin
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.isType '"Array"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "A set of files, or a single file, that should be treated as binaries and symlinked into bin-dir (from config)."
        | optional,
      config
        | {
          allow-missing-requirements
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.anyOf [ _js2n__-prdslib.isType '"Bool" ])
            | doc "Defaults to false. If set to true, Composer will allow install when lock file is not up to date with the latest changes in composer.json."
            | optional,
          allow-plugins
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.anyOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.isType '"Bool"
                    ],
                  _js2n__-prdslib.records.record {} {} true
                    (_js2n__-prdslib.anyOf [ _js2n__-prdslib.isType '"Bool" ])
                ])
            | doc "This is an object of {\"pattern\": true|false} with packages which are allowed to be loaded as plugins, or true to allow all, false to allow none. Defaults to {} which prompts when an unknown plugin is added."
            | optional,
          apcu-autoloader
            | Bool
            | doc "If true, the Composer autoloader will check for APCu and use it to cache found/not-found classes when the extension is enabled, defaults to false."
            | optional,
          archive-dir
            | String
            | doc "The default archive path when not provided on cli, defaults to \".\"."
            | optional,
          archive-format
            | String
            | doc "The default archiving format when not provided on cli, defaults to \"tar\"."
            | optional,
          audit
            | {
              abandoned
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.enum [ "ignore", "report", "fail" ])
                | doc "Whether abandoned packages should be ignored, reported as problems or cause an audit failure."
                | optional,
              ignore
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.anyOf
                    [
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType '"String"
                              ])
                        ],
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ]
                    ])
                | optional,
              ..
            }
            | doc "Security audit configuration options"
            | optional,
          autoloader-suffix
            | String
            | doc "Optional string to be used as a suffix for the generated Composer autoloader. When null a random one will be generated."
            | optional,
          bearer
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record {} {} true
                    (_js2n__-prdslib.isType '"String")
                ])
            | doc "An object of domain name => bearer authentication token, for example {\"example.com\":\"<token>\"}."
            | optional,
          bin-compat
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.enum [ "auto", "full", "proxy", "symlink" ])
            | doc "The compatibility of the binaries, defaults to \"auto\" (automatically guessed), can be \"full\" (compatible with both Windows and Unix-based systems) and \"proxy\" (only bash-style proxy)."
            | optional,
          bin-dir
            | String
            | doc "The location where all binaries are linked, defaults to \"vendor/bin\"."
            | optional,
          bitbucket-oauth
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record {} {} true
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.required
                          [ "consumer-key", "consumer-secret" ],
                        _js2n__-prdslib.records.record
                          {
                            access-token = _js2n__-prdslib.isType '"String",
                            access-token-expiration =
                              _js2n__-prdslib.isType 'Integer,
                            consumer-key = _js2n__-prdslib.isType '"String",
                            consumer-secret = _js2n__-prdslib.isType '"String",
                          } {} true _js2n__-prdslib.always
                      ])
                ])
            | doc "An object of domain name => {\"consumer-key\": \"...\", \"consumer-secret\": \"...\"}."
            | optional,
          bump-after-update
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.isType '"Bool"
                ])
            | doc "Defaults to false and can be any of true, false, \"dev\"` or \"no-dev\"`. If set to true, Composer will run the bump command after running the update command. If set to \"dev\" or \"no-dev\" then only the corresponding dependencies will be bumped."
            | optional,
          cache-dir
            | String
            | doc "The location where all caches are located, defaults to \"~/.composer/cache\" on *nix and \"%LOCALAPPDATA%\\Composer\" on windows."
            | optional,
          cache-files-dir
            | String
            | doc "The location where files (zip downloads) are cached, defaults to \"{$cache-dir}/files\"."
            | optional,
          cache-files-maxsize
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.isType 'Integer
                ])
            | doc "The cache max size for the files cache, defaults to \"300MiB\"."
            | optional,
          cache-files-ttl
            | std.number.Integer
            | doc "The cache time-to-live for files, defaults to the value of cache-ttl."
            | optional,
          cache-read-only
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.anyOf [ _js2n__-prdslib.isType '"Bool" ])
            | doc "Whether to use the Composer cache in read-only mode."
            | optional,
          cache-repo-dir
            | String
            | doc "The location where repo (git/hg repo clones) are cached, defaults to \"{$cache-dir}/repo\"."
            | optional,
          cache-ttl
            | std.number.Integer
            | doc "The default cache time-to-live, defaults to 15552000 (6 months)."
            | optional,
          cache-vcs-dir
            | String
            | doc "The location where vcs infos (git clones, github api calls, etc. when reading vcs repos) are cached, defaults to \"{$cache-dir}/vcs\"."
            | optional,
          cafile
            | String
            | doc "A way to set the path to the openssl CA file. In PHP 5.6+ you should rather set this via openssl.cafile in php.ini, although PHP 5.6+ should be able to detect your system CA file automatically."
            | optional,
          capath
            | String
            | doc "If cafile is not specified or if the certificate is not found there, the directory pointed to by capath is searched for a suitable certificate. capath must be a correctly hashed certificate directory."
            | optional,
          classmap-authoritative
            | Bool
            | doc "If true, the composer autoloader will not scan the filesystem for classes that are not found in the class map, defaults to false."
            | optional,
          data-dir
            | String
            | doc "The location where old phar files are stored, defaults to \"$home\" except on XDG Base Directory compliant unixes."
            | optional,
          disable-tls
            | Bool
            | doc "Defaults to `false`. If set to true all HTTPS URLs will be tried with HTTP instead and no network level encryption is performed. Enabling this is a security risk and is NOT recommended. The better way is to enable the php_openssl extension in php.ini."
            | optional,
          discard-changes
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.isType '"Bool"
                ])
            | doc "The default style of handling dirty updates, defaults to false and can be any of true, false or \"stash\"."
            | optional,
          github-domains
            | Array (String)
            | doc "A list of domains to use in github mode. This is used for GitHub Enterprise setups, defaults to [\"github.com\"]."
            | optional,
          github-expose-hostname
            | Bool
            | doc "Defaults to true. If set to false, the OAuth tokens created to access the github API will have a date instead of the machine hostname."
            | optional,
          github-oauth
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record {} {} true
                    (_js2n__-prdslib.isType '"String")
                ])
            | doc "An object of domain name => github API oauth tokens, typically {\"github.com\":\"<token>\"}."
            | optional,
          github-protocols
            | Array (String)
            | doc "A list of protocols to use for github.com clones, in priority order, defaults to [\"https\", \"ssh\", \"git\"]."
            | optional,
          gitlab-domains
            | Array (String)
            | doc "A list of domains to use in gitlab mode. This is used for custom GitLab setups, defaults to [\"gitlab.com\"]."
            | optional,
          gitlab-oauth
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record {} {} true
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.isType '"String",
                            _js2n__-prdslib.isType 'Record
                          ],
                        _js2n__-prdslib.records.required [ "token" ],
                        _js2n__-prdslib.records.record
                          {
                            expires-at = _js2n__-prdslib.isType 'Integer,
                            refresh-token = _js2n__-prdslib.isType '"String",
                            token = _js2n__-prdslib.isType '"String",
                          } {} true _js2n__-prdslib.always
                      ])
                ])
            | doc "An object of domain name => gitlab API oauth tokens, typically {\"gitlab.com\":{\"expires-at\":\"<expiration date>\", \"refresh-token\":\"<refresh token>\", \"token\":\"<token>\"}}."
            | optional,
          gitlab-protocol
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.enum [ "git", "http", "https" ])
            | doc "A protocol to force use of when creating a repository URL for the `source` value of the package metadata. One of `git` or `http`. By default, Composer will generate a git URL for private repositories and http one for public repos."
            | optional,
          gitlab-token
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record {} {} true
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.isType '"String",
                            _js2n__-prdslib.isType 'Record
                          ],
                        _js2n__-prdslib.records.required
                          [ "token", "username" ],
                        _js2n__-prdslib.records.record
                          {
                            token = _js2n__-prdslib.isType '"String",
                            username = _js2n__-prdslib.isType '"String",
                          } {} true _js2n__-prdslib.always
                      ])
                ])
            | doc "An object of domain name => gitlab private tokens, typically {\"gitlab.com\":\"<token>\"}, or an object with username and token keys."
            | optional,
          htaccess-protect
            | Bool
            | doc "Defaults to true. If set to false, Composer will not create .htaccess files in the composer home, cache, and data directories."
            | optional,
          http-basic
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record {} {} true
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.required
                          [ "password", "username" ],
                        _js2n__-prdslib.records.record
                          {
                            password = _js2n__-prdslib.isType '"String",
                            username = _js2n__-prdslib.isType '"String",
                          } {} true _js2n__-prdslib.always
                      ])
                ])
            | doc "An object of domain name => {\"username\": \"...\", \"password\": \"...\"}."
            | optional,
          lock
            | Bool
            | doc "Defaults to true. If set to false, Composer will not create a composer.lock file."
            | optional,
          notify-on-install
            | Bool
            | doc "Composer allows repositories to define a notification URL, so that they get notified whenever a package from that repository is installed. This option allows you to disable that behaviour, defaults to true."
            | optional,
          optimize-autoloader
            | Bool
            | doc "Always optimize when dumping the autoloader."
            | optional,
          platform
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record {} {} true
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.isType '"Bool"
                      ])
                ])
            | doc "This is an object of package name (keys) and version (values) that will be used to mock the platform packages on this machine, the version can be set to false to make it appear like the package is not present."
            | optional,
          platform-check
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Bool",
                  _js2n__-prdslib.isType '"String"
                ])
            | doc "Defaults to \"php-only\" which checks only the PHP version. Setting to true will also check the presence of required PHP extensions. If set to false, Composer will not create and require a platform_check.php file as part of the autoloader bootstrap."
            | optional,
          preferred-install
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.anyOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.isType 'Record
                    ],
                  _js2n__-prdslib.records.record {} {} true
                    (_js2n__-prdslib.anyOf [ _js2n__-prdslib.isType '"String" ])
                ])
            | doc "The install method Composer will prefer to use, defaults to auto and can be any of source, dist, auto, or an object of {\"pattern\": \"preference\"}."
            | optional,
          prepend-autoloader
            | Bool
            | doc "If false, the composer autoloader will not be prepended to existing autoloaders, defaults to true."
            | optional,
          process-timeout
            | std.number.Integer
            | doc "The timeout in seconds for process executions, defaults to 300 (5mins)."
            | optional,
          secure-http
            | Bool
            | doc "Defaults to `true`. If set to true only HTTPS URLs are allowed to be downloaded via Composer. If you really absolutely need HTTP access to something then you can disable it, but using \"Let's Encrypt\" to get a free SSL certificate is generally a better alternative."
            | optional,
          secure-svn-domains
            | Array (String)
            | doc "A list of domains which should be trusted/marked as using a secure Subversion/SVN transport. By default svn:// protocol is seen as insecure and will throw. This is a better/safer alternative to disabling `secure-http` altogether."
            | optional,
          sort-packages
            | Bool
            | doc "Defaults to false. If set to true, Composer will sort packages when adding/updating a new dependency."
            | optional,
          store-auths
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.isType '"Bool"
                ])
            | doc "What to do after prompting for authentication, one of: true (store), false (do not store) or \"prompt\" (ask every time), defaults to prompt."
            | optional,
          use-github-api
            | Bool
            | doc "Defaults to true.  If set to false, globally disables the use of the GitHub API for all GitHub repositories and clones the repository as it would for any other repository."
            | optional,
          use-include-path
            | Bool
            | doc "If true, the Composer autoloader will also look for classes in the PHP include path."
            | optional,
          use-parent-dir
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.isType '"Bool"
                ])
            | doc "When running Composer in a directory where there is no composer.json, if there is one present in a directory above Composer will by default ask you whether you want to use that directory's composer.json instead. One of: true (always use parent if needed), false (never ask or use it) or \"prompt\" (ask every time), defaults to prompt."
            | optional,
          vendor-dir
            | String
            | doc "The location where all packages are installed, defaults to \"vendor\"."
            | optional,
          ..
        }
        | doc "Composer options."
        | optional,
      conflict
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                (_js2n__-prdslib.isType '"String")
            ])
        | doc "This is an object of package name (keys) and version constraints (values) that conflict with this package."
        | optional,
      default-branch
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf [ _js2n__-prdslib.isType '"Bool" ])
        | doc "Internal use only, do not specify this in composer.json. Indicates whether this version is the default branch of the linked VCS repository. Defaults to false."
        | optional,
      description | String | doc "Short package description." | optional,
      dist | _js2n__-refsenv."_js2n__-:definitions/dist!contract" | optional,
      extra
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.isType '"Array"
                ],
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ])
        | doc "Arbitrary extra data that can be used by plugins, for example, package of type composer-plugin may have a 'class' key defining an installer class name."
        | optional,
      funding
        | Array
          {
            type
              | String
              | doc "Type of funding or platform through which funding is possible."
              | optional,
            url
              | String
              | doc "URL to a website with details on funding and a way to fund the package."
              | optional,
            ..
          }
        | doc "A list of options to fund the development and maintenance of the package."
        | optional,
      homepage | String | doc "Homepage URL for the project." | optional,
      include-path
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf [ _js2n__-prdslib.isType '"Array" ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "DEPRECATED: A list of directories which should get added to PHP's include path. This is only present to support legacy projects, and all new code should preferably use autoloading."
        | optional,
      keywords | Array (String) | optional,
      license
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.isType '"Array"
            ])
        | doc "License name. Or an array of license names."
        | optional,
      minimum-stability
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf [ _js2n__-prdslib.isType '"String" ],
              _js2n__-prdslib.enum
                [ "dev", "alpha", "beta", "rc", "RC", "stable" ]
            ])
        | doc "The minimum stability the packages must have to be install-able. Possible values are: dev, alpha, beta, RC, stable."
        | optional,
      name
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^[a-z0-9]([_.-]?[a-z0-9]+)*/[a-z0-9](([_.]|-{1,2})?[a-z0-9]+)*$"
            ])
        | doc "Package name, including 'vendor-name/' prefix."
        | optional,
      non-feature-branches
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf [ _js2n__-prdslib.isType '"Array" ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "A set of string or regex patterns for non-numeric branch names that will not be handled as feature branches."
        | optional,
      php-ext
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.not
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.records.required
                      [ "os-families", "os-families-exclude" ],
                    _js2n__-prdslib.records.record {} {} true
                      _js2n__-prdslib.always
                  ]),
              _js2n__-prdslib.records.record
                {
                  build-path =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  configure-options =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.required [ "name" ],
                                _js2n__-prdslib.records.record
                                  {
                                    description =
                                      _js2n__-prdslib.isType '"String",
                                    name =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.strings.pattern
                                              "^[a-zA-Z0-9][a-zA-Z0-9-_]*$"
                                          ],
                                    needs-value =
                                      _js2n__-prdslib.isType '"Bool",
                                  } {} true _js2n__-prdslib.always
                              ])
                        ],
                  download-url-method =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "composer-default", "pre-packaged-source" ]
                        ],
                  extension-name = _js2n__-prdslib.isType '"String",
                  os-families =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.enum
                                  [
                                    "windows",
                                    "bsd",
                                    "darwin",
                                    "solaris",
                                    "linux",
                                    "unknown"
                                  ]
                              ]),
                          _js2n__-prdslib.arrays.minItems 1
                        ],
                  os-families-exclude =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.enum
                                  [
                                    "windows",
                                    "bsd",
                                    "darwin",
                                    "solaris",
                                    "linux",
                                    "unknown"
                                  ]
                              ]),
                          _js2n__-prdslib.arrays.minItems 1
                        ],
                  "priority" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.maximum 99,
                          _js2n__-prdslib.numbers.minimum 10
                        ],
                  support-nts = _js2n__-prdslib.isType '"Bool",
                  support-zts = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ])
        | doc "Settings for PHP extension packages."
        | optional,
      prefer-stable
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf [ _js2n__-prdslib.isType '"Bool" ])
        | doc "If set to true, stable packages will be preferred to dev packages when possible, even if the minimum-stability allows unstable packages."
        | optional,
      provide
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                (_js2n__-prdslib.isType '"String")
            ])
        | doc "This is an object of package name (keys) and version constraints (values) that this package provides in addition to this package's name."
        | optional,
      readme | String | doc "Relative path to the readme document." | optional,
      replace
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                (_js2n__-prdslib.isType '"String")
            ])
        | doc "This is an object of package name (keys) and version constraints (values) that can be replaced by this package."
        | optional,
      repositories
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.isType '"Array"
                ],
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/repository!predicate",
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.maxProperties 1,
                        _js2n__-prdslib.records.minProperties 1,
                        _js2n__-prdslib.records.record {} {} true
                          (_js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.enum [ false ]
                            ])
                      ]
                  ]),
              _js2n__-prdslib.records.record {} {} true
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/repository!predicate",
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"Bool",
                        _js2n__-prdslib.enum [ false ]
                      ]
                  ])
            ])
        | doc "A set of additional repositories where packages can be found."
        | optional,
      require
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                (_js2n__-prdslib.isType '"String")
            ])
        | doc "This is an object of package name (keys) and version constraints (values) that are required to run this package."
        | optional,
      require-dev
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                (_js2n__-prdslib.isType '"String")
            ])
        | doc "This is an object of package name (keys) and version constraints (values) that this package requires for developing it (testing tools and such)."
        | optional,
      scripts
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf [ _js2n__-prdslib.isType 'Record ],
              _js2n__-prdslib.records.record
                {
                  post-autoload-dump =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.isType '"String"
                        ],
                  post-create-project-cmd =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.isType '"String"
                        ],
                  post-install-cmd =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.isType '"String"
                        ],
                  post-package-install =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.isType '"String"
                        ],
                  post-package-uninstall =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.isType '"String"
                        ],
                  post-package-update =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.isType '"String"
                        ],
                  post-root-package-install =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.isType '"String"
                        ],
                  post-status-cmd =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.isType '"String"
                        ],
                  post-update-cmd =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.isType '"String"
                        ],
                  pre-autoload-dump =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.isType '"String"
                        ],
                  pre-install-cmd =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.isType '"String"
                        ],
                  pre-package-install =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.isType '"String"
                        ],
                  pre-package-uninstall =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.isType '"String"
                        ],
                  pre-package-update =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.isType '"String"
                        ],
                  pre-status-cmd =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.isType '"String"
                        ],
                  pre-update-cmd =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.isType '"String"
                        ],
                } {} true _js2n__-prdslib.always
            ])
        | doc "Script listeners that will be executed before/after some events."
        | optional,
      scripts-aliases
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf [ _js2n__-prdslib.isType 'Record ],
              _js2n__-prdslib.records.record {} {} true
                (_js2n__-prdslib.isType '"Array")
            ])
        | doc "Aliases for custom commands."
        | optional,
      scripts-descriptions
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf [ _js2n__-prdslib.isType 'Record ],
              _js2n__-prdslib.records.record {} {} true
                (_js2n__-prdslib.isType '"String")
            ])
        | doc "Descriptions for custom commands, shown in console help."
        | optional,
      source
        | _js2n__-refsenv."_js2n__-:definitions/source!contract"
        | optional,
      suggest
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                (_js2n__-prdslib.isType '"String")
            ])
        | doc "This is an object of package name (keys) and descriptions (values) that this package suggests work well with it (this will be suggested to the user during installation)."
        | optional,
      support
        | {
          chat | String | doc "URL to the support chat." | optional,
          docs | String | doc "URL to the documentation." | optional,
          email | String | doc "Email address for support." | optional,
          forum | String | doc "URL to the forum." | optional,
          irc
            | String
            | doc "IRC channel for support, as irc://server/channel."
            | optional,
          issues | String | doc "URL to the issue tracker." | optional,
          rss | String | doc "URL to the RSS feed." | optional,
          security
            | String
            | doc "URL to the vulnerability disclosure policy (VDP)."
            | optional,
          source
            | String
            | doc "URL to browse or download the sources."
            | optional,
          wiki | String | doc "URL to the wiki." | optional,
          ..
        }
        | optional,
      target-dir
        | String
        | doc "DEPRECATED: Forces the package to be installed into the given subdirectory path. This is used for autoloading PSR-0 packages that do not contain their full path. Use forward slashes for cross-platform compatibility."
        | optional,
      time
        | String
        | doc "Package release date, in 'YYYY-MM-DD', 'YYYY-MM-DD HH:MM:SS' or 'YYYY-MM-DDTHH:MM:SSZ' format."
        | optional,
      type
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern "^[a-z0-9-]+$"
            ])
        | doc "Package type, either 'library' for common packages, 'composer-plugin' for plugins, 'metapackage' for empty packages, or a custom type ([a-z0-9-]+) defined by whatever project this package applies to."
        | optional,
      version
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern "^v?\\d+(\\.\\d+){0,3}|^dev-"
            ])
        | doc "Package version, see https://getcomposer.org/doc/04-schema.md#version for more info on valid schemes."
        | optional,
      ..
    }