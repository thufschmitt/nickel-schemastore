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
      appveyor
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.isType 'Null ])
        | doc m%"
          AppVeyor CI settings. This is usually read-only and should not normally be
          manually modified. Tools like conda-smithy may modify this, as needed.
        "%
        | optional,
      azure
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [ _js2n__-prdslib.always, _js2n__-prdslib.isType 'Null ])
        | doc m%"
          Azure Pipelines CI settings. This is usually read-only and should not
          normally be manually modified. Tools like conda-smithy may modify this, as needed.
          For example:
          
          ```yaml
          azure:
              # flag for forcing the building all supported providers
              force: False
              # toggle for storing the conda build_artifacts directory (including the
              # built packages) as an Azure pipeline artifact that can be downloaded
              store_build_artifacts: False
              # toggle for freeing up some extra space on the default Azure Pipelines
              # linux image before running the Docker container for building
              free_disk_space: False
              # limit the amount of CI jobs running concurrently at a given time
              # each OS will get its proportional share of the configured value
              max_parallel: 25
          ```
          
          Below is an example configuration for setting up a self-hosted Azure agent for Linux:
          
          ```yaml
          azure:
              settings_linux:
                  pool:
                      name: your_local_pool_name
                      demands:
                          - some_key -equals some_value
                  workspace:
                      clean: all
                  strategy:
                      maxParallel: 1
          ```
          
          Below is an example configuration for adding a swapfile on an Azure agent for Linux:
          
          ```yaml
          azure:
              settings_linux:
                  swapfile_size: 10GiB
          ```
          
          If you need more space on Windows, you can use `C:` at the cost of IO performance:
          
          ```yaml
          azure:
              settings_win:
                  variables:
                      CONDA_BLD_PATH: "C:\bld"
                      MINIFORGE_HOME: "C:\Miniforge"
          ```
        "%
        | optional,
      bot
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [ _js2n__-prdslib.always, _js2n__-prdslib.isType 'Null ])
        | doc m%"
          This dictates the behavior of the conda-forge auto-tick bot which issues
          automatic version updates/migrations for feedstocks.
          A valid example is:
          
          ```yaml
          bot:
              # can the bot automerge PRs it makes on this feedstock
              automerge: true
              # only automerge on successful version PRs, migrations are not automerged
              automerge: 'version'
              # only automerge on successful migration PRs, versions are not automerged
              automerge: 'migration'
          
              # only open PRs if resulting environment is solvable, useful for tightly coupled packages
              check_solvable: true
          
              # The bot.inspection key in the conda-forge.yml can have one of seven possible values and controls
              # the bots behaviour for automatic dependency updates:
              inspection: hint  # generate hints using source code (backwards compatible)
              inspection: hint-all  # generate hints using all methods
              inspection: hint-source  # generate hints using only source code
              inspection: hint-grayskull  # generate hints using only grayskull
              inspection: update-all  # update recipe using all methods
              inspection: update-source  # update recipe using only source code
              inspection: update-grayskull  # update recipe using only grayskull
              inspection: disabled # don't update recipe, don't generate hints
          
              # any branches listed in this section will get bot migration PRs in addition
              # to the default branch
              abi_migration_branches:
                  - 'v1.10.x'
          
              version_updates:
                  # use this for packages that are updated too frequently
                  random_fraction_to_keep: 0.1  # keeps 10% of versions at random
                  exclude:
                      - '08.14'
          ```
          
          The `abi_migration_branches` feature is useful to, for example, add a
          long-term support (LTS) branch for a package.
        "%
        | optional,
      build_platform
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [ _js2n__-prdslib.always, _js2n__-prdslib.isType 'Null ])
        | doc m%"
          This is a mapping from the target platform to the build platform for the
          package to be built. For example, the following builds a `osx-64` package
          on the `linux-64` build platform using cross-compiling.
          
          ```yaml
          build_platform:
              osx_64: linux_64
          ```
          
          Leaving this field empty implicitly requests to build a package natively. i.e.
          
          ```yaml
          build_platform:
              linux_64: linux_64
              linux_ppc64le: linux_ppc64le
              linux_aarch64: linux_aarch64
              osx_64: osx_64
              osx_arm64: osx_arm64
              win_64: win_64
          ```
        "%
        | optional,
      build_with_mambabuild
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [ _js2n__-prdslib.isType '"Bool", _js2n__-prdslib.isType 'Null ])
        | doc "build_with_mambabuild is deprecated, use `conda_build_tool` instead."
        | optional,
      channel_priority
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [ _js2n__-prdslib.always, _js2n__-prdslib.isType 'Null ])
        | doc m%"
          The channel priority level for the conda solver during feedstock builds.
          For extra information, see the
          [Strict channel priority](https://conda.io/projects/conda/en/latest/user-guide/tasks/manage-channels.html#strict-channel-priority)
          section on conda documentation.
        "%
        | optional,
      choco
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.isType '"String")
                ],
              _js2n__-prdslib.isType 'Null
            ])
        | doc m%"
          This parameter allows for conda-smithy to run chocoloatey installs on Windows
          when additional system packages are needed. This is a list of strings that
          represent package names and any additional parameters. For example,
          
          ```yaml
          choco:
              # install a package
              - nvidia-display-driver
          
              # install a package with a specific version
              - cuda --version=11.0.3
          ```
          
          This is currently only implemented for Azure Pipelines. The command that is run is
          `choco install {entry} -fdv -y --debug`.  That is, `choco install` is executed
          with a standard set of additional flags that are useful on CI.
        "%
        | optional,
      circle
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.isType 'Null ])
        | doc m%"
          Circle CI settings. This is usually read-only and should not normally be
          manually modified. Tools like conda-smithy may modify this, as needed.
        "%
        | optional,
      clone_depth
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType 'Integer,
              _js2n__-prdslib.always,
              _js2n__-prdslib.isType 'Null
            ])
        | doc "The depth of the git clone."
        | optional,
      compiler_stack
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [ _js2n__-prdslib.isType '"String", _js2n__-prdslib.isType 'Null ])
        | doc m%"
          Compiler stack environment variable. This is used to specify the compiler
          stack to use for builds. Deprecated.
          
          ```yaml
          compiler_stack: comp7
          ```
        "%
        | optional,
      conda_build
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [ _js2n__-prdslib.always, _js2n__-prdslib.isType 'Null ])
        | doc m%"
          Settings in this block are used to control how `conda build`
          runs and produces artifacts. An example of the such configuration is:
          
          ```yaml
          conda_build:
              pkg_format: 2
              zstd_compression_level: 16
              error_overlinking: False
          ```
        "%
        | optional,
      conda_build_tool
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum
                    [
                      "conda-build",
                      "conda-build+classic",
                      "conda-build+conda-libmamba-solver",
                      "mambabuild",
                      "rattler-build"
                    ]
                ],
              _js2n__-prdslib.isType 'Null
            ])
        | doc "Use this option to choose which tool is used to build your recipe."
        | optional,
      conda_forge_output_validation
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [ _js2n__-prdslib.isType '"Bool", _js2n__-prdslib.isType 'Null ])
        | doc m%"
          This field must be set to `True` for feedstocks in the `conda-forge` GitHub
          organization. It enables the required feedstock artifact validation as described
          in [Output Validation and Feedstock Tokens](/docs/maintainer/infrastructure#output-validation).
        "%
        | optional,
      conda_install_tool
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "conda", "mamba", "micromamba" ]
                ],
              _js2n__-prdslib.isType 'Null
            ])
        | doc m%"
          Use this option to choose which tool is used to provision the tooling in your
          feedstock. Defaults to micromamba.
          
          If conda or mamba are chosen, the latest Miniforge will be used to
          provision the base environment. If micromamba is chosen, Miniforge
          is not involved; the environment is created directly by micromamba.
        "%
        | optional,
      conda_solver
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "libmamba", "classic" ]
                ],
              _js2n__-prdslib.always,
              _js2n__-prdslib.isType 'Null
            ])
        | doc "Choose which `conda` solver plugin to use for feedstock builds."
        | optional,
      config_version
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [ _js2n__-prdslib.isType '"String", _js2n__-prdslib.isType 'Null ])
        | doc m%"
          The conda-smithy config version to be used for conda_build_config.yaml
          files in recipe and conda-forge-pinning. This should not be manually modified.
        "%
        | optional,
      docker
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [ _js2n__-prdslib.always, _js2n__-prdslib.isType 'Null ])
        | doc m%"
          This is a mapping for Docker-specific configuration options.
          Some options are
          
          ```yaml
          docker:
              executable: docker
              command: "bash"
          ```
        "%
        | optional,
      drone
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record {} {} true
                    (_js2n__-prdslib.isType '"String")
                ],
              _js2n__-prdslib.isType 'Null
            ])
        | doc m%"
          Drone CI settings. This is usually read-only and should not normally be
          manually modified. Tools like conda-smithy may modify this, as needed.
        "%
        | optional,
      exclusive_config_file
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.always,
              _js2n__-prdslib.isType 'Null
            ])
        | doc m%"
          Exclusive conda-build config file to replace `conda-forge-pinning`.
          For advanced usage only.
        "%
        | optional,
      github
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [ _js2n__-prdslib.always, _js2n__-prdslib.isType 'Null ])
        | doc m%"
          Mapping for GitHub-specific configuration options. The defaults are as follows:
          
          ```yaml
          github:
              user_or_org: conda-forge
              repo_name: "my_repo"
              branch_name: main
              tooling_branch_name: main
          ```
        "%
        | optional,
      github_actions
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [ _js2n__-prdslib.always, _js2n__-prdslib.isType 'Null ])
        | doc m%"
          GitHub Actions CI settings. This is usually read-only and should not normally be
          manually modified. Tools like conda-smithy may modify this, as needed.
        "%
        | optional,
      idle_timeout_minutes
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType 'Integer,
              _js2n__-prdslib.always,
              _js2n__-prdslib.isType 'Null
            ])
        | doc m%"
          Configurable idle timeout. Used for packages that don't have chatty enough
          builds. Applicable only to circleci and travis.
          
          ```yaml
          idle_timeout_minutes: 60
          ```
        "%
        | optional,
      linter
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [ _js2n__-prdslib.always, _js2n__-prdslib.isType 'Null ])
        | doc m%"
          Settings in this block are used to control how `conda smithy` lints
          An example of the such configuration is:
          
          ```yaml
          linter:
              skip:
                  - lint_noarch_selectors
          ```
        "%
        | optional,
      matrix
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.isType 'Null ])
        | doc m%"
          Build matrices were used to specify a set of build configurations to run for each
          package pinned dependency. This has been deprecated in favor of the `provider` field.
          More information can be found in the
          [Build Matrices](/docs/maintainer/knowledge_base/#build-matrices) section of the
          conda-forge docs.
        "%
        | optional,
      max_py_ver
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [ _js2n__-prdslib.isType '"String", _js2n__-prdslib.isType 'Null ])
        | doc m%"
          Maximum Python version. This is used to specify the maximum Python version
          to use for builds. Deprecated.
          
          ```yaml
          max_py_ver: 37
          ```
        "%
        | optional,
      max_r_ver
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [ _js2n__-prdslib.isType '"String", _js2n__-prdslib.isType 'Null ])
        | doc m%"
          Maximum R version. This is used to specify the maximum R version to use
          for builds. Deprecated.
          
          ```yaml
          max_r_ver: 34
          ```
        "%
        | optional,
      min_py_ver
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [ _js2n__-prdslib.isType '"String", _js2n__-prdslib.isType 'Null ])
        | doc m%"
          Minimum Python version. This is used to specify the minimum Python version
          to use for builds. Deprecated.
          
          ```yaml
          min_py_ver: 27
          ```
        "%
        | optional,
      min_r_ver
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [ _js2n__-prdslib.isType '"String", _js2n__-prdslib.isType 'Null ])
        | doc m%"
          Minimum R version. This is used to specify the minimum R version to
          use for builds. Deprecated.
          
          ```yaml
          min_r_ver: 34
          ```
        "%
        | optional,
      noarch_platforms
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.always,
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf _js2n__-prdslib.always
                ],
              _js2n__-prdslib.isType 'Null
            ])
        | doc m%"
          Platforms on which to build noarch packages. The preferred default is a
          single build on `linux_64`.
          
          ```yaml
          noarch_platforms: linux_64
          ```
          
          To build on multiple platforms, e.g. for simple packages with platform-specific
          dependencies, provide a list.
          
          ```yaml
          noarch_platforms:
            - linux_64
            - win_64
          ```
        "%
        | optional,
      os_version
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [ _js2n__-prdslib.always, _js2n__-prdslib.isType 'Null ])
        | doc m%"
          This key is used to set the OS versions for `linux_*` platforms. Valid entries
          map a linux platform and arch to either `cos6` or `cos7`.
          Currently `cos6` is the default for `linux-64`.
          All other linux architectures use CentOS 7.
          Here is an example that enables CentOS 7 on `linux-64` builds
          
          ```yaml
          os_version:
              linux_64: cos7
          ```
        "%
        | optional,
      package
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.always,
              _js2n__-prdslib.isType 'Null
            ])
        | doc "Default location for a package feedstock directory basename."
        | optional,
      private_upload
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [ _js2n__-prdslib.isType '"Bool", _js2n__-prdslib.isType 'Null ])
        | doc m%"
          Whether to upload to a private channel.
          
          ```yaml
          private_upload: False
          ```
        "%
        | optional,
      provider
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [ _js2n__-prdslib.always, _js2n__-prdslib.isType 'Null ])
        | doc m%"
          The `provider` field is a mapping from build platform (not target platform)
          to CI service. It determines which service handles each build platform.
          If a desired build platform is not available with a selected provider
          (either natively or with emulation), the build will be disabled.
          Use the `build_platform` field to manually specify cross-compilation when
          no providers offer a desired build platform.
          
          The following are available as supported build platforms:
          
          * `linux_64`
          * `osx_64`
          * `win_64`
          * `linux_aarch64`
          * `linux_ppc64le`
          * `linux_s390x`
          * `linux_armv7l`
          
          The following CI services are available:
          
          * `azure`
          * `circle`
          * `travis`
          * `appveyor`
          * `None` or `False` to disable a build platform.
          * `default` to choose an appropriate CI (only if available)
          * `native` to choose an appropriate CI for native compiling (only if available)
          * `emulated` to choose an appropriate CI for compiling inside an emulation
            of the target platform (only if available)
          
          For example, switching linux_64 & osx_64 to build on Travis CI, with win_64 on
          Appveyor:
          
          ```yaml
          provider:
              linux_64: travis
              osx_64: travis
              win_64: appveyor
          ```
          
          Currently, x86_64 platforms are enabled, but other build platforms are
          disabled by default. i.e. an empty provider entry is equivalent to the
          following:
          
          ```yaml
          provider:
              linux_64: azure
              osx_64: azure
              win_64: azure
              linux_ppc64le: None
              linux_aarch64: None
          ```
          
          To enable `linux_ppc64le` and `linux_aarch64` add the following:
          
          ```yaml
          provider:
              linux_ppc64le: default
              linux_aarch64: default
          ```
        "%
        | optional,
      recipe_dir
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [ _js2n__-prdslib.isType '"String", _js2n__-prdslib.isType 'Null ])
        | doc m%"
          The relative path to the recipe directory. The default is:
          
          ```yaml
          recipe_dir: recipe
          ```
        "%
        | optional,
      remote_ci_setup
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.isType '"String")
                ],
              _js2n__-prdslib.isType 'Null
            ])
        | doc m%"
          This option can be used to override the default `conda-forge-ci-setup` package.
          Can be given with `${url or channel_alias}::package_name`,
          defaults to conda-forge channel_alias if no prefix is given.
          
          ```yaml
          remote_ci_setup: ["conda-forge-ci-setup=4", "conda-build>=24.1"]
          ```
        "%
        | optional,
      secrets
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.isType '"String")
                ],
              _js2n__-prdslib.isType 'Null
            ])
        | doc m%"
          List of secrets to be used in GitHub Actions.
          The default is an empty list and will not be used.
        "%
        | optional,
      shellcheck
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.always,
              _js2n__-prdslib.always,
              _js2n__-prdslib.isType 'Null
            ])
        | doc m%"
          Shell scripts used for builds or activation scripts can be linted with
          shellcheck. This option can be used to enable shellcheck and configure
          its behavior. This is not enabled by default, but can be enabled like so:
          
          ```yaml
          shellcheck:
              enabled: True
          ```
        "%
        | optional,
      skip_render
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.isType '"String")
                ],
              _js2n__-prdslib.isType 'Null
            ])
        | doc m%"
          This option specifies a list of files which `conda smithy` will skip rendering.
          This is useful for files that are not templates, but are still in the recipe
          directory. The default value is an empty list `[]`, which will consider that
          all files can be rendered. For example, if you want to skip rendering
          the `.gitignore` and `LICENSE.txt` files, you can add the following:
          
          ```yaml
          skip_render:
              - .gitignore
              - LICENSE.txt
          ```
        "%
        | optional,
      templates
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record {} {} true
                    (_js2n__-prdslib.isType '"String")
                ],
              _js2n__-prdslib.isType 'Null
            ])
        | doc m%"
          This is mostly an internal field for specifying where template files reside.
          You shouldn't need to modify it.
        "%
        | optional,
      test
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.always,
              _js2n__-prdslib.always,
              _js2n__-prdslib.isType 'Null
            ])
        | doc m%"
          This is used to configure on which platforms a recipe is tested.
          
          ```yaml
          test: native_and_emulated
          ```
          
          Will do testing only if the platform is native or if there is an emulator.
          
          ```yaml
          test: native
          ```
          
          Will do testing only if the platform is native.
        "%
        | optional,
      test_on_native_only
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [ _js2n__-prdslib.isType '"Bool", _js2n__-prdslib.isType 'Null ])
        | doc m%"
          This was used for disabling testing for cross-compiling.
          
          ```warning
          This has been deprecated in favor of the top-level `test` field.
          It is now mapped to `test: native_and_emulated`.
          ```
        "%
        | optional,
      travis
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.isType 'Null ])
        | doc m%"
          Travis CI settings. This is usually read-only and should not normally be
          manually modified. Tools like conda-smithy may modify this, as needed.
        "%
        | optional,
      upload_on_branch
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.always,
              _js2n__-prdslib.isType 'Null
            ])
        | doc m%"
          This parameter restricts uploading access on work from certain branches of the
          same repo. Only the branch listed in `upload_on_branch` will trigger uploading
          of packages to the target channel. The default is to skip this check if the key
          `upload_on_branch` is not in `conda-forge.yml`. To restrict uploads to the
          main branch:
          
          ```yaml
          upload_on_branch: main
          ```
        "%
        | optional,
      woodpecker
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record {} {} true
                    (_js2n__-prdslib.isType '"String")
                ],
              _js2n__-prdslib.isType 'Null
            ])
        | doc m%"
          Woodpecker CI settings. This is usually read-only and should not normally be
          manually modified. Tools like conda-smithy may modify this, as needed.
        "%
        | optional,
    }