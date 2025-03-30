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
      "_js2n__-:definitions/dependency-type!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [ "direct", "indirect", "all", "production", "development" ]
            ],
      "_js2n__-:definitions/insecure-external-code-execution!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "allow", "deny" ]
            ],
      "_js2n__-:definitions/package-ecosystem-values!predicate" =
        _js2n__-prdslib.enum
            [
              "bun",
              "bundler",
              "cargo",
              "composer",
              "devcontainers",
              "docker",
              "docker-compose",
              "dotnet-sdk",
              "elm",
              "gitsubmodule",
              "github-actions",
              "gomod",
              "gradle",
              "maven",
              "mix",
              "npm",
              "nuget",
              "pip",
              "pub",
              "swift",
              "terraform",
              "uv"
            ],
      "_js2n__-:definitions/registry!predicate"
        | doc "The top-level registries key is optional. It allows you to specify authentication details that Dependabot can use to access private package registries."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.minProperties 1,
              _js2n__-prdslib.records.record {}
                {
                  ".+" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.required [ "type", "url" ],
                          _js2n__-prdslib.records.record
                            {
                              auth-key = _js2n__-prdslib.isType '"String",
                              key = _js2n__-prdslib.isType '"String",
                              organization = _js2n__-prdslib.isType '"String",
                              password = _js2n__-prdslib.isType '"String",
                              public-key-fingerprint =
                                _js2n__-prdslib.isType '"String",
                              replaces-base = _js2n__-prdslib.isType '"Bool",
                              repo = _js2n__-prdslib.isType '"String",
                              token = _js2n__-prdslib.isType '"String",
                              type =
                                _js2n__-prdslib.enum
                                    [
                                      "composer-repository",
                                      "docker-registry",
                                      "git",
                                      "hex-organization",
                                      "hex-repository",
                                      "maven-repository",
                                      "npm-registry",
                                      "nuget-feed",
                                      "python-index",
                                      "rubygems-server",
                                      "terraform-registry"
                                    ],
                              url = _js2n__-prdslib.isType '"String",
                              username = _js2n__-prdslib.isType '"String",
                            } {} false _js2n__-prdslib.never
                        ],
                } false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/schedule-day!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "monday",
                  "tuesday",
                  "wednesday",
                  "thursday",
                  "friday",
                  "saturday",
                  "sunday"
                ]
            ],
      "_js2n__-:definitions/schedule-interval!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "daily", "weekly", "monthly" ]
            ],
      "_js2n__-:definitions/timezone!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "Africa/Abidjan",
                  "Africa/Accra",
                  "Africa/Addis_Ababa",
                  "Africa/Algiers",
                  "Africa/Asmara",
                  "Africa/Asmera",
                  "Africa/Bamako",
                  "Africa/Bangui",
                  "Africa/Banjul",
                  "Africa/Bissau",
                  "Africa/Blantyre",
                  "Africa/Brazzaville",
                  "Africa/Bujumbura",
                  "Africa/Cairo",
                  "Africa/Casablanca",
                  "Africa/Ceuta",
                  "Africa/Conakry",
                  "Africa/Dakar",
                  "Africa/Dar_es_Salaam",
                  "Africa/Djibouti",
                  "Africa/Douala",
                  "Africa/El_Aaiun",
                  "Africa/Freetown",
                  "Africa/Gaborone",
                  "Africa/Harare",
                  "Africa/Johannesburg",
                  "Africa/Juba",
                  "Africa/Kampala",
                  "Africa/Khartoum",
                  "Africa/Kigali",
                  "Africa/Kinshasa",
                  "Africa/Lagos",
                  "Africa/Libreville",
                  "Africa/Lome",
                  "Africa/Luanda",
                  "Africa/Lubumbashi",
                  "Africa/Lusaka",
                  "Africa/Malabo",
                  "Africa/Maputo",
                  "Africa/Maseru",
                  "Africa/Mbabane",
                  "Africa/Mogadishu",
                  "Africa/Monrovia",
                  "Africa/Nairobi",
                  "Africa/Ndjamena",
                  "Africa/Niamey",
                  "Africa/Nouakchott",
                  "Africa/Ouagadougou",
                  "Africa/Porto-Novo",
                  "Africa/Sao_Tome",
                  "Africa/Timbuktu",
                  "Africa/Tripoli",
                  "Africa/Tunis",
                  "Africa/Windhoek",
                  "America/Adak",
                  "America/Anchorage",
                  "America/Anguilla",
                  "America/Antigua",
                  "America/Araguaina",
                  "America/Argentina/Buenos_Aires",
                  "America/Argentina/Catamarca",
                  "America/Argentina/ComodRivadavia",
                  "America/Argentina/Cordoba",
                  "America/Argentina/Jujuy",
                  "America/Argentina/La_Rioja",
                  "America/Argentina/Mendoza",
                  "America/Argentina/Rio_Gallegos",
                  "America/Argentina/Salta",
                  "America/Argentina/San_Juan",
                  "America/Argentina/San_Luis",
                  "America/Argentina/Tucuman",
                  "America/Argentina/Ushuaia",
                  "America/Aruba",
                  "America/Asuncion",
                  "America/Atikokan",
                  "America/Atka",
                  "America/Bahia",
                  "America/Bahia_Banderas",
                  "America/Barbados",
                  "America/Belem",
                  "America/Belize",
                  "America/Blanc-Sablon",
                  "America/Boa_Vista",
                  "America/Bogota",
                  "America/Boise",
                  "America/Buenos_Aires",
                  "America/Cambridge_Bay",
                  "America/Campo_Grande",
                  "America/Cancun",
                  "America/Caracas",
                  "America/Catamarca",
                  "America/Cayenne",
                  "America/Cayman",
                  "America/Chicago",
                  "America/Chihuahua",
                  "America/Coral_Harbour",
                  "America/Cordoba",
                  "America/Costa_Rica",
                  "America/Creston",
                  "America/Cuiaba",
                  "America/Curacao",
                  "America/Danmarkshavn",
                  "America/Dawson",
                  "America/Dawson_Creek",
                  "America/Denver",
                  "America/Detroit",
                  "America/Dominica",
                  "America/Edmonton",
                  "America/Eirunepe",
                  "America/El_Salvador",
                  "America/Ensenada",
                  "America/Fort_Nelson",
                  "America/Fort_Wayne",
                  "America/Fortaleza",
                  "America/Glace_Bay",
                  "America/Godthab",
                  "America/Goose_Bay",
                  "America/Grand_Turk",
                  "America/Grenada",
                  "America/Guadeloupe",
                  "America/Guatemala",
                  "America/Guayaquil",
                  "America/Guyana",
                  "America/Halifax",
                  "America/Havana",
                  "America/Hermosillo",
                  "America/Indiana/Indianapolis",
                  "America/Indiana/Knox",
                  "America/Indiana/Marengo",
                  "America/Indiana/Petersburg",
                  "America/Indiana/Tell_City",
                  "America/Indiana/Vevay",
                  "America/Indiana/Vincennes",
                  "America/Indiana/Winamac",
                  "America/Indianapolis",
                  "America/Inuvik",
                  "America/Iqaluit",
                  "America/Jamaica",
                  "America/Jujuy",
                  "America/Juneau",
                  "America/Kentucky/Louisville",
                  "America/Kentucky/Monticello",
                  "America/Knox_IN",
                  "America/Kralendijk",
                  "America/La_Paz",
                  "America/Lima",
                  "America/Los_Angeles",
                  "America/Louisville",
                  "America/Lower_Princes",
                  "America/Maceio",
                  "America/Managua",
                  "America/Manaus",
                  "America/Marigot",
                  "America/Martinique",
                  "America/Matamoros",
                  "America/Mazatlan",
                  "America/Mendoza",
                  "America/Menominee",
                  "America/Merida",
                  "America/Metlakatla",
                  "America/Mexico_City",
                  "America/Miquelon",
                  "America/Moncton",
                  "America/Monterrey",
                  "America/Montevideo",
                  "America/Montreal",
                  "America/Montserrat",
                  "America/Nassau",
                  "America/New_York",
                  "America/Nipigon",
                  "America/Nome",
                  "America/Noronha",
                  "America/North_Dakota/Beulah",
                  "America/North_Dakota/Center",
                  "America/North_Dakota/New_Salem",
                  "America/Nuuk",
                  "America/Ojinaga",
                  "America/Panama",
                  "America/Pangnirtung",
                  "America/Paramaribo",
                  "America/Phoenix",
                  "America/Port-au-Prince",
                  "America/Port_of_Spain",
                  "America/Porto_Acre",
                  "America/Porto_Velho",
                  "America/Puerto_Rico",
                  "America/Punta_Arenas",
                  "America/Rainy_River",
                  "America/Rankin_Inlet",
                  "America/Recife",
                  "America/Regina",
                  "America/Resolute",
                  "America/Rio_Branco",
                  "America/Rosario",
                  "America/Santa_Isabel",
                  "America/Santarem",
                  "America/Santiago",
                  "America/Santo_Domingo",
                  "America/Sao_Paulo",
                  "America/Scoresbysund",
                  "America/Shiprock",
                  "America/Sitka",
                  "America/St_Barthelemy",
                  "America/St_Johns",
                  "America/St_Kitts",
                  "America/St_Lucia",
                  "America/St_Thomas",
                  "America/St_Vincent",
                  "America/Swift_Current",
                  "America/Tegucigalpa",
                  "America/Thule",
                  "America/Thunder_Bay",
                  "America/Tijuana",
                  "America/Toronto",
                  "America/Tortola",
                  "America/Vancouver",
                  "America/Virgin",
                  "America/Whitehorse",
                  "America/Winnipeg",
                  "America/Yakutat",
                  "America/Yellowknife",
                  "Antarctica/Casey",
                  "Antarctica/Davis",
                  "Antarctica/DumontDUrville",
                  "Antarctica/Macquarie",
                  "Antarctica/Mawson",
                  "Antarctica/McMurdo",
                  "Antarctica/Palmer",
                  "Antarctica/Rothera",
                  "Antarctica/South_Pole",
                  "Antarctica/Syowa",
                  "Antarctica/Troll",
                  "Antarctica/Vostok",
                  "Arctic/Longyearbyen",
                  "Asia/Aden",
                  "Asia/Almaty",
                  "Asia/Amman",
                  "Asia/Anadyr",
                  "Asia/Aqtau",
                  "Asia/Aqtobe",
                  "Asia/Ashgabat",
                  "Asia/Ashkhabad",
                  "Asia/Atyrau",
                  "Asia/Baghdad",
                  "Asia/Bahrain",
                  "Asia/Baku",
                  "Asia/Bangkok",
                  "Asia/Barnaul",
                  "Asia/Beirut",
                  "Asia/Bishkek",
                  "Asia/Brunei",
                  "Asia/Calcutta",
                  "Asia/Chita",
                  "Asia/Choibalsan",
                  "Asia/Chongqing",
                  "Asia/Chungking",
                  "Asia/Colombo",
                  "Asia/Dacca",
                  "Asia/Damascus",
                  "Asia/Dhaka",
                  "Asia/Dili",
                  "Asia/Dubai",
                  "Asia/Dushanbe",
                  "Asia/Famagusta",
                  "Asia/Gaza",
                  "Asia/Harbin",
                  "Asia/Hebron",
                  "Asia/Ho_Chi_Minh",
                  "Asia/Hong_Kong",
                  "Asia/Hovd",
                  "Asia/Irkutsk",
                  "Asia/Istanbul",
                  "Asia/Jakarta",
                  "Asia/Jayapura",
                  "Asia/Jerusalem",
                  "Asia/Kabul",
                  "Asia/Kamchatka",
                  "Asia/Karachi",
                  "Asia/Kashgar",
                  "Asia/Kathmandu",
                  "Asia/Katmandu",
                  "Asia/Khandyga",
                  "Asia/Kolkata",
                  "Asia/Krasnoyarsk",
                  "Asia/Kuala_Lumpur",
                  "Asia/Kuching",
                  "Asia/Kuwait",
                  "Asia/Macao",
                  "Asia/Macau",
                  "Asia/Magadan",
                  "Asia/Makassar",
                  "Asia/Manila",
                  "Asia/Muscat",
                  "Asia/Nicosia",
                  "Asia/Novokuznetsk",
                  "Asia/Novosibirsk",
                  "Asia/Omsk",
                  "Asia/Oral",
                  "Asia/Phnom_Penh",
                  "Asia/Pontianak",
                  "Asia/Pyongyang",
                  "Asia/Qatar",
                  "Asia/Qostanay",
                  "Asia/Qyzylorda",
                  "Asia/Rangoon",
                  "Asia/Riyadh",
                  "Asia/Saigon",
                  "Asia/Sakhalin",
                  "Asia/Samarkand",
                  "Asia/Seoul",
                  "Asia/Shanghai",
                  "Asia/Singapore",
                  "Asia/Srednekolymsk",
                  "Asia/Taipei",
                  "Asia/Tashkent",
                  "Asia/Tbilisi",
                  "Asia/Tehran",
                  "Asia/Tel_Aviv",
                  "Asia/Thimbu",
                  "Asia/Thimphu",
                  "Asia/Tokyo",
                  "Asia/Tomsk",
                  "Asia/Ujung_Pandang",
                  "Asia/Ulaanbaatar",
                  "Asia/Ulan_Bator",
                  "Asia/Urumqi",
                  "Asia/Ust-Nera",
                  "Asia/Vientiane",
                  "Asia/Vladivostok",
                  "Asia/Yakutsk",
                  "Asia/Yangon",
                  "Asia/Yekaterinburg",
                  "Asia/Yerevan",
                  "Atlantic/Azores",
                  "Atlantic/Bermuda",
                  "Atlantic/Canary",
                  "Atlantic/Cape_Verde",
                  "Atlantic/Faeroe",
                  "Atlantic/Faroe",
                  "Atlantic/Jan_Mayen",
                  "Atlantic/Madeira",
                  "Atlantic/Reykjavik",
                  "Atlantic/South_Georgia",
                  "Atlantic/St_Helena",
                  "Atlantic/Stanley",
                  "Australia/ACT",
                  "Australia/Adelaide",
                  "Australia/Brisbane",
                  "Australia/Broken_Hill",
                  "Australia/Canberra",
                  "Australia/Currie",
                  "Australia/Darwin",
                  "Australia/Eucla",
                  "Australia/Hobart",
                  "Australia/LHI",
                  "Australia/Lindeman",
                  "Australia/Lord_Howe",
                  "Australia/Melbourne",
                  "Australia/North",
                  "Australia/NSW",
                  "Australia/Perth",
                  "Australia/Queensland",
                  "Australia/South",
                  "Australia/Sydney",
                  "Australia/Tasmania",
                  "Australia/Victoria",
                  "Australia/West",
                  "Australia/Yancowinna",
                  "Brazil/Acre",
                  "Brazil/DeNoronha",
                  "Brazil/East",
                  "Brazil/West",
                  "Canada/Atlantic",
                  "Canada/Central",
                  "Canada/Eastern",
                  "Canada/Mountain",
                  "Canada/Newfoundland",
                  "Canada/Pacific",
                  "Canada/Saskatchewan",
                  "Canada/Yukon",
                  "Chile/Continental",
                  "Chile/EasterIsland",
                  "Cuba",
                  "Egypt",
                  "Eire",
                  "Etc/GMT",
                  "Etc/GMT+0",
                  "Etc/GMT+1",
                  "Etc/GMT+10",
                  "Etc/GMT+11",
                  "Etc/GMT+12",
                  "Etc/GMT+2",
                  "Etc/GMT+3",
                  "Etc/GMT+4",
                  "Etc/GMT+5",
                  "Etc/GMT+6",
                  "Etc/GMT+7",
                  "Etc/GMT+8",
                  "Etc/GMT+9",
                  "Etc/GMT-0",
                  "Etc/GMT-1",
                  "Etc/GMT-10",
                  "Etc/GMT-11",
                  "Etc/GMT-12",
                  "Etc/GMT-13",
                  "Etc/GMT-14",
                  "Etc/GMT-2",
                  "Etc/GMT-3",
                  "Etc/GMT-4",
                  "Etc/GMT-5",
                  "Etc/GMT-6",
                  "Etc/GMT-7",
                  "Etc/GMT-8",
                  "Etc/GMT-9",
                  "Etc/GMT0",
                  "Etc/Greenwich",
                  "Etc/UCT",
                  "Etc/Universal",
                  "Etc/UTC",
                  "Etc/Zulu",
                  "Europe/Amsterdam",
                  "Europe/Andorra",
                  "Europe/Astrakhan",
                  "Europe/Athens",
                  "Europe/Belfast",
                  "Europe/Belgrade",
                  "Europe/Berlin",
                  "Europe/Bratislava",
                  "Europe/Brussels",
                  "Europe/Bucharest",
                  "Europe/Budapest",
                  "Europe/Busingen",
                  "Europe/Chisinau",
                  "Europe/Copenhagen",
                  "Europe/Dublin",
                  "Europe/Gibraltar",
                  "Europe/Guernsey",
                  "Europe/Helsinki",
                  "Europe/Isle_of_Man",
                  "Europe/Istanbul",
                  "Europe/Jersey",
                  "Europe/Kaliningrad",
                  "Europe/Kiev",
                  "Europe/Kirov",
                  "Europe/Kyiv",
                  "Europe/Lisbon",
                  "Europe/Ljubljana",
                  "Europe/London",
                  "Europe/Luxembourg",
                  "Europe/Madrid",
                  "Europe/Malta",
                  "Europe/Mariehamn",
                  "Europe/Minsk",
                  "Europe/Monaco",
                  "Europe/Moscow",
                  "Europe/Nicosia",
                  "Europe/Oslo",
                  "Europe/Paris",
                  "Europe/Podgorica",
                  "Europe/Prague",
                  "Europe/Riga",
                  "Europe/Rome",
                  "Europe/Samara",
                  "Europe/San_Marino",
                  "Europe/Sarajevo",
                  "Europe/Saratov",
                  "Europe/Simferopol",
                  "Europe/Skopje",
                  "Europe/Sofia",
                  "Europe/Stockholm",
                  "Europe/Tallinn",
                  "Europe/Tirane",
                  "Europe/Tiraspol",
                  "Europe/Ulyanovsk",
                  "Europe/Uzhgorod",
                  "Europe/Vaduz",
                  "Europe/Vatican",
                  "Europe/Vienna",
                  "Europe/Vilnius",
                  "Europe/Volgograd",
                  "Europe/Warsaw",
                  "Europe/Zagreb",
                  "Europe/Zaporozhye",
                  "Europe/Zurich",
                  "GB",
                  "GB-Eire",
                  "Hongkong",
                  "Iceland",
                  "Indian/Antananarivo",
                  "Indian/Chagos",
                  "Indian/Christmas",
                  "Indian/Cocos",
                  "Indian/Comoro",
                  "Indian/Kerguelen",
                  "Indian/Mahe",
                  "Indian/Maldives",
                  "Indian/Mauritius",
                  "Indian/Mayotte",
                  "Indian/Reunion",
                  "Iran",
                  "Israel",
                  "Jamaica",
                  "Japan",
                  "Kwajalein",
                  "Libya",
                  "Mexico/BajaNorte",
                  "Mexico/BajaSur",
                  "Mexico/General",
                  "Navajo",
                  "NZ",
                  "NZ-CHAT",
                  "Pacific/Apia",
                  "Pacific/Auckland",
                  "Pacific/Bougainville",
                  "Pacific/Chatham",
                  "Pacific/Chuuk",
                  "Pacific/Easter",
                  "Pacific/Efate",
                  "Pacific/Enderbury",
                  "Pacific/Fakaofo",
                  "Pacific/Fiji",
                  "Pacific/Funafuti",
                  "Pacific/Galapagos",
                  "Pacific/Gambier",
                  "Pacific/Guadalcanal",
                  "Pacific/Guam",
                  "Pacific/Honolulu",
                  "Pacific/Johnston",
                  "Pacific/Kanton",
                  "Pacific/Kiritimati",
                  "Pacific/Kosrae",
                  "Pacific/Kwajalein",
                  "Pacific/Majuro",
                  "Pacific/Marquesas",
                  "Pacific/Midway",
                  "Pacific/Nauru",
                  "Pacific/Niue",
                  "Pacific/Norfolk",
                  "Pacific/Noumea",
                  "Pacific/Pago_Pago",
                  "Pacific/Palau",
                  "Pacific/Pitcairn",
                  "Pacific/Pohnpei",
                  "Pacific/Ponape",
                  "Pacific/Port_Moresby",
                  "Pacific/Rarotonga",
                  "Pacific/Saipan",
                  "Pacific/Samoa",
                  "Pacific/Tahiti",
                  "Pacific/Tarawa",
                  "Pacific/Tongatapu",
                  "Pacific/Truk",
                  "Pacific/Wake",
                  "Pacific/Wallis",
                  "Pacific/Yap",
                  "Poland",
                  "Portugal",
                  "PRC",
                  "ROC",
                  "Singapore",
                  "US/Alaska",
                  "US/Aleutian",
                  "US/Arizona",
                  "US/Central",
                  "US/East-Indiana",
                  "US/Eastern",
                  "US/Hawaii",
                  "US/Indiana-Starke",
                  "US/Michigan",
                  "US/Mountain",
                  "US/Pacific",
                  "US/Samoa"
                ]
            ],
      "_js2n__-:definitions/update!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required
                        [ "package-ecosystem", "schedule" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.oneOf
                    [
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.required [ "directories" ],
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-prdslib.always
                        ],
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.required [ "directory" ],
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-prdslib.always
                        ]
                    ]
                ],
              _js2n__-prdslib.records.record
                {
                  allow =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.anyOf
                                  [
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.records.required
                                          [ "dependency-name" ],
                                        _js2n__-prdslib.records.record {} {}
                                          true _js2n__-prdslib.always
                                      ],
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.records.required
                                          [ "dependency-type" ],
                                        _js2n__-prdslib.records.record {} {}
                                          true _js2n__-prdslib.always
                                      ]
                                  ],
                                _js2n__-prdslib.records.record
                                  {
                                    dependency-name =
                                      _js2n__-prdslib.isType '"String",
                                    dependency-type =
                                      _js2n__-refsenv."_js2n__-:definitions/dependency-type!predicate",
                                  } {} false _js2n__-prdslib.never
                              ])
                        ],
                  assignees =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.strings.minLength 1
                              ]),
                          _js2n__-prdslib.arrays.minItems 1,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  commit-message =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required [ "prefix" ],
                                  _js2n__-prdslib.records.record {} {} true
                                    _js2n__-prdslib.always
                                ],
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "prefix-development" ],
                                  _js2n__-prdslib.records.record {} {} true
                                    _js2n__-prdslib.always
                                ],
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "include" ],
                                  _js2n__-prdslib.records.record {} {} true
                                    _js2n__-prdslib.always
                                ]
                            ],
                          _js2n__-prdslib.records.record
                            {
                              include =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum [ "scope" ]
                                    ],
                              prefix =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.strings.maxLength 50
                                    ],
                              prefix-development =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.strings.maxLength 50
                                    ],
                            } {} false _js2n__-prdslib.never
                        ],
                  directories =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.strings.minLength 1
                              ]),
                          _js2n__-prdslib.arrays.minItems 1,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  directory = _js2n__-prdslib.isType '"String",
                  groups =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.minProperties 1,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.anyOf
                                  [
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.records.required
                                          [ "dependency-type" ],
                                        _js2n__-prdslib.records.record {} {}
                                          true _js2n__-prdslib.always
                                      ],
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.records.required
                                          [ "patterns" ],
                                        _js2n__-prdslib.records.record {} {}
                                          true _js2n__-prdslib.always
                                      ],
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.records.required
                                          [ "exclude-patterns" ],
                                        _js2n__-prdslib.records.record {} {}
                                          true _js2n__-prdslib.always
                                      ],
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.records.required
                                          [ "update-types" ],
                                        _js2n__-prdslib.records.record {} {}
                                          true _js2n__-prdslib.always
                                      ]
                                  ],
                                _js2n__-prdslib.records.record
                                  {
                                    applies-to =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.enum
                                              [
                                                "version-updates",
                                                "security-updates"
                                              ]
                                          ],
                                    dependency-type =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.enum
                                              [ "development", "production" ]
                                          ],
                                    exclude-patterns =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"Array",
                                            _js2n__-prdslib.arrays.arrayOf
                                              (_js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.strings.minLength
                                                    1
                                                ]),
                                            _js2n__-prdslib.arrays.minItems 1,
                                            _js2n__-prdslib.arrays.uniqueItems
                                          ],
                                    patterns =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"Array",
                                            _js2n__-prdslib.arrays.arrayOf
                                              (_js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.strings.minLength
                                                    1
                                                ]),
                                            _js2n__-prdslib.arrays.minItems 1,
                                            _js2n__-prdslib.arrays.uniqueItems
                                          ],
                                    update-types =
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
                                                      "major",
                                                      "minor",
                                                      "patch"
                                                    ]
                                                ]),
                                            _js2n__-prdslib.arrays.minItems 1,
                                            _js2n__-prdslib.arrays.uniqueItems
                                          ],
                                  } {} false _js2n__-prdslib.never
                              ])
                        ],
                  ignore =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.anyOf
                                  [
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.records.required
                                          [ "dependency-name" ],
                                        _js2n__-prdslib.records.record {} {}
                                          true _js2n__-prdslib.always
                                      ],
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.records.required
                                          [ "update-types" ],
                                        _js2n__-prdslib.records.record {} {}
                                          true _js2n__-prdslib.always
                                      ],
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.records.required
                                          [ "versions" ],
                                        _js2n__-prdslib.records.record {} {}
                                          true _js2n__-prdslib.always
                                      ]
                                  ],
                                _js2n__-prdslib.records.record
                                  {
                                    dependency-name =
                                      _js2n__-prdslib.isType '"String",
                                    update-types =
                                      _js2n__-refsenv."_js2n__-:definitions/update-types!predicate",
                                    versions =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"Array",
                                            _js2n__-prdslib.arrays.arrayOf
                                              (_js2n__-prdslib.isType
                                                '"String"),
                                            _js2n__-prdslib.arrays.minItems 1,
                                            _js2n__-prdslib.arrays.uniqueItems
                                          ],
                                  } {} false _js2n__-prdslib.never
                              ])
                        ],
                  insecure-external-code-execution =
                    _js2n__-refsenv."_js2n__-:definitions/insecure-external-code-execution!predicate",
                  labels =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.strings.minLength 1
                              ]),
                          _js2n__-prdslib.arrays.minItems 0,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  milestone =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 1
                        ],
                  open-pull-requests-limit =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  package-ecosystem =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/package-ecosystem-values!predicate",
                              _js2n__-prdslib.strings.minLength 1
                            ]
                        ],
                  pull-request-branch-name =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.required [ "separator" ],
                          _js2n__-prdslib.records.record
                            {
                              separator =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum [ "-", "_", "/" ]
                                    ],
                            } {} false _js2n__-prdslib.never
                        ],
                  rebase-strategy =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "auto", "disabled" ]
                        ],
                  registries =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.strings.minLength 1
                                  ]),
                              _js2n__-prdslib.arrays.minItems 1,
                              _js2n__-prdslib.arrays.uniqueItems
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.const "*"
                            ]
                        ],
                  reviewers =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.strings.minLength 1
                              ]),
                          _js2n__-prdslib.arrays.minItems 1,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  schedule =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.required [ "interval" ],
                          _js2n__-prdslib.records.record
                            {
                              day =
                                _js2n__-refsenv."_js2n__-:definitions/schedule-day!predicate",
                              interval =
                                _js2n__-refsenv."_js2n__-:definitions/schedule-interval!predicate",
                              time =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.strings.pattern
                                        "^([01][0-9]|2[0-3]):[0-5][0-9]$"
                                    ],
                              timezone =
                                _js2n__-refsenv."_js2n__-:definitions/timezone!predicate",
                            } {} true _js2n__-prdslib.always
                        ],
                  target-branch =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.minLength 1
                        ],
                  vendor = _js2n__-prdslib.isType '"Bool",
                  versioning-strategy =
                    _js2n__-refsenv."_js2n__-:definitions/versioning-strategy!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/update-types!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.enum
                      [
                        "version-update:semver-major",
                        "version-update:semver-minor",
                        "version-update:semver-patch"
                      ]
                  ]),
              _js2n__-prdslib.arrays.minItems 1,
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/versioning-strategy!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "auto",
                  "increase",
                  "increase-if-necessary",
                  "lockfile-only",
                  "widen"
                ]
            ],
    }
    in
  _js2n__-prdslib.contract_from_predicate
      (_js2n__-prdslib.allOf
        [
          _js2n__-prdslib.isType 'Record,
          _js2n__-prdslib.ifThenElse
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.records.required [ "enable-beta-ecosystems" ],
                _js2n__-prdslib.records.record
                  { enable-beta-ecosystems = _js2n__-prdslib.const true, } {}
                  true _js2n__-prdslib.always
              ]) _js2n__-prdslib.always
            (_js2n__-prdslib.records.record
              {
                updates =
                  _js2n__-prdslib.arrays.arrayOf
                      (_js2n__-prdslib.records.record
                        {
                          package-ecosystem =
                            _js2n__-refsenv."_js2n__-:definitions/package-ecosystem-values!predicate",
                        } {} true _js2n__-prdslib.always),
              } {} true _js2n__-prdslib.always),
          _js2n__-prdslib.records.required [ "updates", "version" ],
          _js2n__-prdslib.records.record
            {
              enable-beta-ecosystems = _js2n__-prdslib.isType '"Bool",
              registries =
                _js2n__-refsenv."_js2n__-:definitions/registry!predicate",
              updates =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        _js2n__-refsenv."_js2n__-:definitions/update!predicate"
                    ],
              version =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Integer,
                      _js2n__-prdslib.enum [ 2 ]
                    ],
            } {} false _js2n__-prdslib.never
        ])