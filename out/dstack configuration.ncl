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
      "_js2n__-:definitions/ACMGatewayCertificateRequest!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "arn" ],
              _js2n__-prdslib.records.record
                {
                  arn = _js2n__-prdslib.isType '"String",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "acm" ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/BackendType!predicate"
        | doc m%"
          Attributes:
              AWS (BackendType): Amazon Web Services
              AZURE (BackendType): Microsoft Azure
              CUDO (BackendType): Cudo
              DSTACK (BackendType): dstack Sky
              GCP (BackendType): Google Cloud Platform
              DATACRUNCH (BackendType): DataCrunch
              KUBERNETES (BackendType): Kubernetes
              LAMBDA (BackendType): Lambda Cloud
              RUNPOD (BackendType): Runpod Cloud
              TENSORDOCK (BackendType): TensorDock Marketplace
              VASTAI (BackendType): Vast.ai Marketplace
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "aws",
                  "azure",
                  "cudo",
                  "datacrunch",
                  "dstack",
                  "gcp",
                  "kubernetes",
                  "lambda",
                  "local",
                  "remote",
                  "nebius",
                  "oci",
                  "runpod",
                  "tensordock",
                  "vastai"
                ]
            ],
      "_js2n__-:definitions/CreationPolicy!predicate"
        | doc "An enumeration."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "reuse", "reuse-or-create" ]
            ],
      "_js2n__-:definitions/DevEnvironmentConfigurationRequest!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "ide" ],
              _js2n__-prdslib.records.record
                {
                  backends =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/BackendType!predicate"
                        ],
                  creation_policy =
                    _js2n__-refsenv."_js2n__-:definitions/CreationPolicy!predicate",
                  entrypoint = _js2n__-prdslib.isType '"String",
                  env = _js2n__-refsenv."_js2n__-:definitions/Env!predicate",
                  home_dir = _js2n__-prdslib.isType '"String",
                  ide =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "vscode" ]
                        ],
                  idle_duration =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum [ "off" ]
                            ],
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Integer
                        ],
                  image = _js2n__-prdslib.isType '"String",
                  init =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  instance_name = _js2n__-prdslib.isType '"String",
                  instance_types =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  max_duration =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum [ "off" ]
                            ],
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Integer
                        ],
                  max_price =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.numbers.exclusiveMinimum 0
                        ],
                  name = _js2n__-prdslib.isType '"String",
                  nvcc = _js2n__-prdslib.isType '"Bool",
                  pool_name = _js2n__-prdslib.isType '"String",
                  ports =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Integer,
                                    _js2n__-prdslib.numbers.maximum 65536,
                                    _js2n__-prdslib.numbers.exclusiveMinimum 0
                                  ],
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.strings.pattern
                                      "^(?:[0-9]+|\\*):[0-9]+$"
                                  ],
                                _js2n__-refsenv."_js2n__-:definitions/PortMappingRequest!predicate"
                              ])
                        ],
                  privileged = _js2n__-prdslib.isType '"Bool",
                  python =
                    _js2n__-refsenv."_js2n__-:definitions/PythonVersion!predicate",
                  regions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  registry_auth =
                    _js2n__-refsenv."_js2n__-:definitions/RegistryAuthRequest!predicate",
                  reservation = _js2n__-prdslib.isType '"String",
                  resources =
                    _js2n__-refsenv."_js2n__-:definitions/ResourcesSpecRequest!predicate",
                  retry =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/ProfileRetryRequest!predicate",
                          _js2n__-prdslib.isType '"Bool"
                        ],
                  retry_policy =
                    _js2n__-refsenv."_js2n__-:definitions/ProfileRetryPolicyRequest!predicate",
                  setup =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  spot_policy =
                    _js2n__-refsenv."_js2n__-:definitions/SpotPolicy!predicate",
                  termination_idle_time =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.isType '"String"
                        ],
                  termination_policy =
                    _js2n__-refsenv."_js2n__-:definitions/TerminationPolicy!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "dev-environment" ]
                        ],
                  user = _js2n__-prdslib.isType '"String",
                  version = _js2n__-prdslib.isType '"String",
                  volumes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-refsenv."_js2n__-:definitions/VolumeMountPointRequest!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/InstanceMountPointRequest!predicate",
                                _js2n__-prdslib.isType '"String"
                              ])
                        ],
                  working_dir = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Env!predicate"
        | doc m%"
          Env represents a mapping of process environment variables, as in environ(7).
          Environment values may be omitted, in that case the :class:`EnvSentinel`
          object is used as a placeholder.
          
          To create an instance from a `dict[str, str]` or a `list[str]` use pydantic's
          :meth:`BaseModel.parse_obj(dict | list)` method.
          
          NB: this is *NOT* a CoreModel, pydantic-duality, which is used as a base
          for the CoreModel, doesn't play well with custom root models.
        "%
        = _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.isType '"String")
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record {} {} true
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-refsenv."_js2n__-:definitions/EnvSentinelRequest!predicate"
                      ])
                ]
            ],
      "_js2n__-:definitions/EnvSentinelRequest!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "key" ],
              _js2n__-prdslib.records.record
                { key = _js2n__-prdslib.isType '"String", } {} false
                _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/FleetConfigurationRequest!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  backends =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/BackendType!predicate"
                        ],
                  env = _js2n__-refsenv."_js2n__-:definitions/Env!predicate",
                  idle_duration =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum [ "off" ]
                            ],
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Integer
                        ],
                  instance_types =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  max_price =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.numbers.exclusiveMinimum 0
                        ],
                  name = _js2n__-prdslib.isType '"String",
                  nodes =
                    _js2n__-refsenv."_js2n__-:definitions/Range_int_!predicate",
                  placement =
                    _js2n__-refsenv."_js2n__-:definitions/InstanceGroupPlacement!predicate",
                  regions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  reservation = _js2n__-prdslib.isType '"String",
                  resources =
                    _js2n__-refsenv."_js2n__-:definitions/ResourcesSpecRequest!predicate",
                  retry =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/ProfileRetryRequest!predicate",
                          _js2n__-prdslib.isType '"Bool"
                        ],
                  spot_policy =
                    _js2n__-refsenv."_js2n__-:definitions/SpotPolicy!predicate",
                  ssh_config =
                    _js2n__-refsenv."_js2n__-:definitions/SSHParamsRequest!predicate",
                  termination_idle_time =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.isType '"String"
                        ],
                  termination_policy =
                    _js2n__-refsenv."_js2n__-:definitions/TerminationPolicy!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "fleet" ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/GatewayConfigurationRequest!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "backend", "region" ],
              _js2n__-prdslib.records.record
                {
                  backend =
                    _js2n__-refsenv."_js2n__-:definitions/BackendType!predicate",
                  certificate =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/LetsEncryptGatewayCertificateRequest!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/ACMGatewayCertificateRequest!predicate"
                        ],
                  "default" = _js2n__-prdslib.isType '"Bool",
                  domain = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                  public_ip = _js2n__-prdslib.isType '"Bool",
                  region = _js2n__-prdslib.isType '"String",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "gateway" ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/InstanceGroupPlacement!predicate"
        | doc "An enumeration."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "any", "cluster" ]
            ],
      "_js2n__-:definitions/InstanceMountPointRequest!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "instance_path", "path" ],
              _js2n__-prdslib.records.record
                {
                  instance_path = _js2n__-prdslib.isType '"String",
                  path = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/LetsEncryptGatewayCertificateRequest!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "lets-encrypt" ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/OpenAIChatModelRequest!predicate"
        | doc m%"
          Mapping of the model for the OpenAI-compatible endpoint.
          
          Attributes:
              type (str): The type of the model, e.g. "chat"
              name (str): The name of the model. This name will be used both to load model configuration from the HuggingFace Hub and in the OpenAI-compatible endpoint.
              format (str): The format of the model, i.e. "openai".
              prefix (str): The `base_url` prefix: `http://hostname/{prefix}/chat/completions`. Defaults to `/v1`.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "format", "name" ],
              _js2n__-prdslib.records.record
                {
                  format =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "openai" ]
                        ],
                  name = _js2n__-prdslib.isType '"String",
                  prefix = _js2n__-prdslib.isType '"String",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "chat" ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/PortMappingRequest!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "container_port" ],
              _js2n__-prdslib.records.record
                {
                  container_port =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.maximum 65536,
                          _js2n__-prdslib.numbers.exclusiveMinimum 0
                        ],
                  local_port =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.maximum 65536,
                          _js2n__-prdslib.numbers.exclusiveMinimum 0
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ProfileRetryPolicyRequest!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  duration =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.isType '"String"
                        ],
                  retry = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ProfileRetryRequest!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "on_events" ],
              _js2n__-prdslib.records.record
                {
                  duration =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.isType '"String"
                        ],
                  on_events =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/RetryEvent!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/PythonVersion!predicate"
        | doc "An enumeration."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [ "3.8", "3.9", "3.10", "3.11", "3.12", "3.13" ]
            ],
      "_js2n__-:definitions/Range_int_!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  max = _js2n__-prdslib.isType 'Integer,
                  min = _js2n__-prdslib.isType 'Integer,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/RegistryAuthRequest!predicate"
        | doc m%"
          Credentials for pulling a private Docker image.
          
          Attributes:
              username (str): The username
              password (str): The password or access token
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "password", "username" ],
              _js2n__-prdslib.records.record
                {
                  password = _js2n__-prdslib.isType '"String",
                  username = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ResourcesSpecRequest!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  cpu =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/ResourcesSpecRequest/definitions/Range_Union_int__str__!predicate",
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.isType '"String"
                        ],
                  disk =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/ResourcesSpecRequest/definitions/DiskSpecRequest!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/ResourcesSpecRequest/definitions/DiskSpecSchemaRequest!predicate",
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.isType '"String"
                        ],
                  gpu =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/ResourcesSpecRequest/definitions/GPUSpecRequest!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/ResourcesSpecRequest/definitions/GPUSpecSchemaRequest!predicate",
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.isType '"String"
                        ],
                  memory =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/ResourcesSpecRequest/definitions/Range_Union_Memory__float__int__str__!predicate",
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.isType '"String"
                        ],
                  shm_size =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.isType '"String"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ResourcesSpecRequest/definitions/AcceleratorVendor!predicate"
        | doc "An enumeration."
        = _js2n__-prdslib.enum [ "nvidia", "amd", "google" ],
      "_js2n__-:definitions/ResourcesSpecRequest/definitions/DiskSpecRequest!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "size" ],
              _js2n__-prdslib.records.record
                {
                  size =
                    _js2n__-refsenv."_js2n__-:definitions/ResourcesSpecRequest/definitions/Range_Memory_!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ResourcesSpecRequest/definitions/DiskSpecSchemaRequest!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "size" ],
              _js2n__-prdslib.records.record
                {
                  size =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/ResourcesSpecRequest/definitions/Range_Union_Memory__float__int__str__!predicate",
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.isType '"String"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ResourcesSpecRequest/definitions/GPUSpecRequest!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  compute_capability =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf _js2n__-prdslib.always
                        ],
                  count =
                    _js2n__-refsenv."_js2n__-:definitions/ResourcesSpecRequest/definitions/Range_int_!predicate",
                  memory =
                    _js2n__-refsenv."_js2n__-:definitions/ResourcesSpecRequest/definitions/Range_Memory_!predicate",
                  name =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  total_memory =
                    _js2n__-refsenv."_js2n__-:definitions/ResourcesSpecRequest/definitions/Range_Memory_!predicate",
                  vendor =
                    _js2n__-refsenv."_js2n__-:definitions/ResourcesSpecRequest/definitions/AcceleratorVendor!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ResourcesSpecRequest/definitions/GPUSpecSchemaRequest!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  compute_capability =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-prdslib.always
                            ],
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.isType '"String"
                        ],
                  count =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/ResourcesSpecRequest/definitions/Range_Union_int__str__!predicate",
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.isType '"String"
                        ],
                  memory =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/ResourcesSpecRequest/definitions/Range_Union_Memory__float__int__str__!predicate",
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.isType '"String"
                        ],
                  name =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                          _js2n__-prdslib.isType '"String"
                        ],
                  total_memory =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/ResourcesSpecRequest/definitions/Range_Union_Memory__float__int__str__!predicate",
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.isType '"String"
                        ],
                  vendor =
                    _js2n__-refsenv."_js2n__-:definitions/ResourcesSpecRequest/definitions/AcceleratorVendor!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ResourcesSpecRequest/definitions/Range_Memory_!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  max = _js2n__-prdslib.isType '"Number",
                  min = _js2n__-prdslib.isType '"Number",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ResourcesSpecRequest/definitions/Range_Union_Memory__float__int__str__!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  max =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.isType '"String"
                        ],
                  min =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.isType '"String"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ResourcesSpecRequest/definitions/Range_Union_int__str__!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  max =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.isType '"String"
                        ],
                  min =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.isType '"String"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ResourcesSpecRequest/definitions/Range_int_!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  max = _js2n__-prdslib.isType 'Integer,
                  min = _js2n__-prdslib.isType 'Integer,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/RetryEvent!predicate"
        | doc "An enumeration."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "no-capacity", "interruption", "error" ]
            ],
      "_js2n__-:definitions/SSHHostParamsRequest!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "hostname" ],
              _js2n__-prdslib.records.record
                {
                  hostname = _js2n__-prdslib.isType '"String",
                  identity_file = _js2n__-prdslib.isType '"String",
                  internal_ip = _js2n__-prdslib.isType '"String",
                  port = _js2n__-prdslib.isType 'Integer,
                  ssh_key =
                    _js2n__-refsenv."_js2n__-:definitions/SSHKeyRequest!predicate",
                  user = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/SSHKeyRequest!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "public" ],
              _js2n__-prdslib.records.record
                {
                  private = _js2n__-prdslib.isType '"String",
                  public = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/SSHParamsRequest!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "hosts" ],
              _js2n__-prdslib.records.record
                {
                  hosts =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-refsenv."_js2n__-:definitions/SSHHostParamsRequest!predicate",
                                _js2n__-prdslib.isType '"String"
                              ])
                        ],
                  identity_file = _js2n__-prdslib.isType '"String",
                  network = _js2n__-prdslib.isType '"String",
                  port = _js2n__-prdslib.isType 'Integer,
                  ssh_key =
                    _js2n__-refsenv."_js2n__-:definitions/SSHKeyRequest!predicate",
                  user = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ScalingSpecRequest!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "metric", "target" ],
              _js2n__-prdslib.records.record
                {
                  metric =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "rps" ]
                        ],
                  scale_down_delay = _js2n__-prdslib.isType 'Integer,
                  scale_up_delay = _js2n__-prdslib.isType 'Integer,
                  target = _js2n__-prdslib.isType '"Number",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ServiceConfigurationRequest!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "port" ],
              _js2n__-prdslib.records.record
                {
                  auth = _js2n__-prdslib.isType '"Bool",
                  backends =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/BackendType!predicate"
                        ],
                  commands =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  creation_policy =
                    _js2n__-refsenv."_js2n__-:definitions/CreationPolicy!predicate",
                  entrypoint = _js2n__-prdslib.isType '"String",
                  env = _js2n__-refsenv."_js2n__-:definitions/Env!predicate",
                  gateway =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"String"
                        ],
                  home_dir = _js2n__-prdslib.isType '"String",
                  https = _js2n__-prdslib.isType '"Bool",
                  idle_duration =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum [ "off" ]
                            ],
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Integer
                        ],
                  image = _js2n__-prdslib.isType '"String",
                  instance_name = _js2n__-prdslib.isType '"String",
                  instance_types =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  max_duration =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum [ "off" ]
                            ],
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Integer
                        ],
                  max_price =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.numbers.exclusiveMinimum 0
                        ],
                  model =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.oneOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/TGIChatModelRequest!predicate",
                              _js2n__-refsenv."_js2n__-:definitions/OpenAIChatModelRequest!predicate"
                            ],
                          _js2n__-prdslib.isType '"String"
                        ],
                  name = _js2n__-prdslib.isType '"String",
                  nvcc = _js2n__-prdslib.isType '"Bool",
                  pool_name = _js2n__-prdslib.isType '"String",
                  port =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.numbers.maximum 65536,
                              _js2n__-prdslib.numbers.exclusiveMinimum 0
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.strings.pattern "^[0-9]+:[0-9]+$"
                            ],
                          _js2n__-refsenv."_js2n__-:definitions/PortMappingRequest!predicate"
                        ],
                  privileged = _js2n__-prdslib.isType '"Bool",
                  python =
                    _js2n__-refsenv."_js2n__-:definitions/PythonVersion!predicate",
                  regions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  registry_auth =
                    _js2n__-refsenv."_js2n__-:definitions/RegistryAuthRequest!predicate",
                  replicas =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.numbers.minimum 1
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.strings.pattern
                                "^[0-9]+..[1-9][0-9]*$"
                            ],
                          _js2n__-refsenv."_js2n__-:definitions/Range_int_!predicate"
                        ],
                  reservation = _js2n__-prdslib.isType '"String",
                  resources =
                    _js2n__-refsenv."_js2n__-:definitions/ResourcesSpecRequest!predicate",
                  retry =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/ProfileRetryRequest!predicate",
                          _js2n__-prdslib.isType '"Bool"
                        ],
                  retry_policy =
                    _js2n__-refsenv."_js2n__-:definitions/ProfileRetryPolicyRequest!predicate",
                  scaling =
                    _js2n__-refsenv."_js2n__-:definitions/ScalingSpecRequest!predicate",
                  setup =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  spot_policy =
                    _js2n__-refsenv."_js2n__-:definitions/SpotPolicy!predicate",
                  termination_idle_time =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.isType '"String"
                        ],
                  termination_policy =
                    _js2n__-refsenv."_js2n__-:definitions/TerminationPolicy!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "service" ]
                        ],
                  user = _js2n__-prdslib.isType '"String",
                  volumes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-refsenv."_js2n__-:definitions/VolumeMountPointRequest!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/InstanceMountPointRequest!predicate",
                                _js2n__-prdslib.isType '"String"
                              ])
                        ],
                  working_dir = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/SpotPolicy!predicate"
        | doc "An enumeration."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "spot", "on-demand", "auto" ]
            ],
      "_js2n__-:definitions/TGIChatModelRequest!predicate"
        | doc m%"
          Mapping of the model for the OpenAI-compatible endpoint.
          
          Attributes:
              type (str): The type of the model, e.g. "chat"
              name (str): The name of the model. This name will be used both to load model configuration from the HuggingFace Hub and in the OpenAI-compatible endpoint.
              format (str): The format of the model, e.g. "tgi" if the model is served with HuggingFace's Text Generation Inference.
              chat_template (Optional[str]): The custom prompt template for the model. If not specified, the default prompt template from the HuggingFace Hub configuration will be used.
              eos_token (Optional[str]): The custom end of sentence token. If not specified, the default end of sentence token from the HuggingFace Hub configuration will be used.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "format", "name" ],
              _js2n__-prdslib.records.record
                {
                  chat_template = _js2n__-prdslib.isType '"String",
                  eos_token = _js2n__-prdslib.isType '"String",
                  format =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "tgi" ]
                        ],
                  name = _js2n__-prdslib.isType '"String",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "chat" ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/TaskConfigurationRequest!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  backends =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/BackendType!predicate"
                        ],
                  commands =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  creation_policy =
                    _js2n__-refsenv."_js2n__-:definitions/CreationPolicy!predicate",
                  entrypoint = _js2n__-prdslib.isType '"String",
                  env = _js2n__-refsenv."_js2n__-:definitions/Env!predicate",
                  home_dir = _js2n__-prdslib.isType '"String",
                  idle_duration =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum [ "off" ]
                            ],
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Integer
                        ],
                  image = _js2n__-prdslib.isType '"String",
                  instance_name = _js2n__-prdslib.isType '"String",
                  instance_types =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  max_duration =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum [ "off" ]
                            ],
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Integer
                        ],
                  max_price =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.numbers.exclusiveMinimum 0
                        ],
                  name = _js2n__-prdslib.isType '"String",
                  nodes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 1
                        ],
                  nvcc = _js2n__-prdslib.isType '"Bool",
                  pool_name = _js2n__-prdslib.isType '"String",
                  ports =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Integer,
                                    _js2n__-prdslib.numbers.maximum 65536,
                                    _js2n__-prdslib.numbers.exclusiveMinimum 0
                                  ],
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.strings.pattern
                                      "^(?:[0-9]+|\\*):[0-9]+$"
                                  ],
                                _js2n__-refsenv."_js2n__-:definitions/PortMappingRequest!predicate"
                              ])
                        ],
                  privileged = _js2n__-prdslib.isType '"Bool",
                  python =
                    _js2n__-refsenv."_js2n__-:definitions/PythonVersion!predicate",
                  regions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  registry_auth =
                    _js2n__-refsenv."_js2n__-:definitions/RegistryAuthRequest!predicate",
                  reservation = _js2n__-prdslib.isType '"String",
                  resources =
                    _js2n__-refsenv."_js2n__-:definitions/ResourcesSpecRequest!predicate",
                  retry =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/ProfileRetryRequest!predicate",
                          _js2n__-prdslib.isType '"Bool"
                        ],
                  retry_policy =
                    _js2n__-refsenv."_js2n__-:definitions/ProfileRetryPolicyRequest!predicate",
                  setup =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  spot_policy =
                    _js2n__-refsenv."_js2n__-:definitions/SpotPolicy!predicate",
                  termination_idle_time =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.isType '"String"
                        ],
                  termination_policy =
                    _js2n__-refsenv."_js2n__-:definitions/TerminationPolicy!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "task" ]
                        ],
                  user = _js2n__-prdslib.isType '"String",
                  volumes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-refsenv."_js2n__-:definitions/VolumeMountPointRequest!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/InstanceMountPointRequest!predicate",
                                _js2n__-prdslib.isType '"String"
                              ])
                        ],
                  working_dir = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/TerminationPolicy!predicate"
        | doc "An enumeration."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "dont-destroy", "destroy-after-idle" ]
            ],
      "_js2n__-:definitions/VolumeConfigurationRequest!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "backend", "region" ],
              _js2n__-prdslib.records.record
                {
                  backend =
                    _js2n__-refsenv."_js2n__-:definitions/BackendType!predicate",
                  name = _js2n__-prdslib.isType '"String",
                  region = _js2n__-prdslib.isType '"String",
                  size = _js2n__-prdslib.isType '"Number",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "volume" ]
                        ],
                  volume_id = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/VolumeMountPointRequest!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name", "path" ],
              _js2n__-prdslib.records.record
                {
                  name =
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
                  path = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
    }
    in
  _js2n__-prdslib.contract_from_predicate
      (_js2n__-prdslib.allOf
        [
          _js2n__-prdslib.oneOf
            [
              _js2n__-refsenv."_js2n__-:definitions/DevEnvironmentConfigurationRequest!predicate",
              _js2n__-refsenv."_js2n__-:definitions/TaskConfigurationRequest!predicate",
              _js2n__-refsenv."_js2n__-:definitions/ServiceConfigurationRequest!predicate",
              _js2n__-refsenv."_js2n__-:definitions/FleetConfigurationRequest!predicate",
              _js2n__-refsenv."_js2n__-:definitions/GatewayConfigurationRequest!predicate",
              _js2n__-refsenv."_js2n__-:definitions/VolumeConfigurationRequest!predicate"
            ],
          _js2n__-prdslib.records.record {} {} false _js2n__-prdslib.never
        ])