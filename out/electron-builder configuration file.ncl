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
      "_js2n__-:definitions/AppImageOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  artifactName =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  category =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  description =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  desktop = _js2n__-prdslib.always,
                  license =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  mimeTypes =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                          _js2n__-prdslib.isType 'Null
                        ],
                  publish =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/GithubOptions!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/S3Options!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/SpacesOptions!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/GenericServerOptions!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/BintrayOptions!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/CustomPublishOptions!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/GithubOptions!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/S3Options!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/SpacesOptions!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/GenericServerOptions!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/BintrayOptions!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/CustomPublishOptions!predicate",
                                    _js2n__-prdslib.isType '"String"
                                  ])
                            ],
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Null,
                              _js2n__-prdslib.isType '"String"
                            ]
                        ],
                  synopsis =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  systemIntegration =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "ask", "doNotAsk" ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/AppXOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  addAutoLaunchExtension = _js2n__-prdslib.isType '"Bool",
                  applicationId = _js2n__-prdslib.isType '"String",
                  artifactName =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  backgroundColor =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  displayName =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  electronUpdaterAware = _js2n__-prdslib.isType '"Bool",
                  identityName =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  languages =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Null,
                              _js2n__-prdslib.isType '"String"
                            ]
                        ],
                  makeappxArgs =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                          _js2n__-prdslib.isType 'Null
                        ],
                  publish =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/GithubOptions!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/S3Options!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/SpacesOptions!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/GenericServerOptions!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/BintrayOptions!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/CustomPublishOptions!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/GithubOptions!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/S3Options!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/SpacesOptions!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/GenericServerOptions!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/BintrayOptions!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/CustomPublishOptions!predicate",
                                    _js2n__-prdslib.isType '"String"
                                  ])
                            ],
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Null,
                              _js2n__-prdslib.isType '"String"
                            ]
                        ],
                  publisher =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  publisherDisplayName =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  setBuildNumber = _js2n__-prdslib.isType '"Bool",
                  showNameOnTiles = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/AsarOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  externalAllowed = _js2n__-prdslib.isType '"Bool",
                  ordering =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  smartUnpack = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/BintrayOptions!predicate"
        | doc m%"
          [Bintray](https://bintray.com/) options. Requires an API key. An API key can be obtained from the user [profile](https://bintray.com/profile/edit) page ("Edit Your Profile" -> API Key).
          Define `BT_TOKEN` environment variable.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "provider" ],
              _js2n__-prdslib.records.record
                {
                  component =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  distribution =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  owner =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  package =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  provider =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "bintray" ]
                        ],
                  publishAutoUpdate = _js2n__-prdslib.isType '"Bool",
                  publisherName =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                          _js2n__-prdslib.isType 'Null
                        ],
                  repo =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  token =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  updaterCacheDirName =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  user =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/CustomPublishOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "provider" ],
              _js2n__-prdslib.records.record
                {
                  provider =
                    _js2n__-refsenv."_js2n__-:definitions/PublishProvider!predicate",
                  publishAutoUpdate = _js2n__-prdslib.isType '"Bool",
                  publisherName =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                          _js2n__-prdslib.isType 'Null
                        ],
                  updaterCacheDirName =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/DebOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  afterInstall =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  afterRemove =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  artifactName =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  category =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  compression =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum [ "bzip2", "gz", "xz" ]
                            ],
                          _js2n__-prdslib.isType 'Null
                        ],
                  depends =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                          _js2n__-prdslib.isType 'Null
                        ],
                  description =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  desktop = _js2n__-prdslib.always,
                  fpm =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                          _js2n__-prdslib.isType 'Null
                        ],
                  icon = _js2n__-prdslib.isType '"String",
                  maintainer =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  mimeTypes =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                          _js2n__-prdslib.isType 'Null
                        ],
                  packageCategory =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  "priority" =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  publish =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/GithubOptions!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/S3Options!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/SpacesOptions!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/GenericServerOptions!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/BintrayOptions!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/CustomPublishOptions!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/GithubOptions!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/S3Options!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/SpacesOptions!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/GenericServerOptions!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/BintrayOptions!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/CustomPublishOptions!predicate",
                                    _js2n__-prdslib.isType '"String"
                                  ])
                            ],
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Null,
                              _js2n__-prdslib.isType '"String"
                            ]
                        ],
                  synopsis =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  vendor =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/DmgContent!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "x", "y" ],
              _js2n__-prdslib.records.record
                {
                  name = _js2n__-prdslib.isType '"String",
                  path = _js2n__-prdslib.isType '"String",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "dir", "file", "link" ]
                        ],
                  x = _js2n__-prdslib.isType '"Number",
                  y = _js2n__-prdslib.isType '"Number",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/DmgOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  artifactName =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  background =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  backgroundColor =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  contents =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/DmgContent!predicate"
                        ],
                  format =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "UDBZ", "UDCO", "UDRO", "UDRW", "UDZO", "ULFO" ]
                        ],
                  icon =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  iconSize =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"Number"
                        ],
                  iconTextSize =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"Number"
                        ],
                  internetEnabled = _js2n__-prdslib.isType '"Bool",
                  publish =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/GithubOptions!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/S3Options!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/SpacesOptions!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/GenericServerOptions!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/BintrayOptions!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/CustomPublishOptions!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/GithubOptions!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/S3Options!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/SpacesOptions!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/GenericServerOptions!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/BintrayOptions!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/CustomPublishOptions!predicate",
                                    _js2n__-prdslib.isType '"String"
                                  ])
                            ],
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Null,
                              _js2n__-prdslib.isType '"String"
                            ]
                        ],
                  title =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  window =
                    _js2n__-refsenv."_js2n__-:definitions/DmgWindow!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/DmgWindow!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  height = _js2n__-prdslib.isType '"Number",
                  width = _js2n__-prdslib.isType '"Number",
                  x = _js2n__-prdslib.isType '"Number",
                  y = _js2n__-prdslib.isType '"Number",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ElectronDownloadOptions!contract" =
        {
            arch | String | optional,
            cache
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.isType 'Null,
                    _js2n__-prdslib.isType '"String"
                  ])
              | doc "The [cache location](https://github.com/electron-userland/electron-download#cache-location)."
              | optional,
            customDir
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.isType 'Null,
                    _js2n__-prdslib.isType '"String"
                  ])
              | optional,
            customFilename
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.isType 'Null,
                    _js2n__-prdslib.isType '"String"
                  ])
              | optional,
            isVerifyChecksum | Bool | optional,
            mirror
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.isType 'Null,
                    _js2n__-prdslib.isType '"String"
                  ])
              | doc "The mirror."
              | optional,
            platform
              | std.enum.TagOrString
              | [| 'win32, 'mas, 'linux, 'darwin |]
              | optional,
            strictSSL | Bool | optional,
            version | String | optional,
          },
      "_js2n__-:definitions/FileAssociation!predicate"
        | doc m%"
          File associations.
          
          macOS (corresponds to [CFBundleDocumentTypes](https://developer.apple.com/library/content/documentation/General/Reference/InfoPlistKeyReference/Articles/CoreFoundationKeys.html#//apple_ref/doc/uid/20001431-101685)) and NSIS only.
          
          On Windows works only if [nsis.perMachine](https://electron.build/configuration/configuration#NsisOptions-perMachine) is set to `true`.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "ext" ],
              _js2n__-prdslib.records.record
                {
                  description =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  ext =
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
                  icon =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  isPackage = _js2n__-prdslib.isType '"Bool",
                  mimeType =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  name =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  role = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/FileSet!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  filter =
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
                  from = _js2n__-prdslib.isType '"String",
                  to = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/GenericServerOptions!predicate"
        | doc m%"
          Generic (any HTTP(S) server) options.
          In all publish options [File Macros](/file-patterns#file-macros) are supported.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "provider", "url" ],
              _js2n__-prdslib.records.record
                {
                  channel =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  provider =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "generic" ]
                        ],
                  publishAutoUpdate = _js2n__-prdslib.isType '"Bool",
                  publisherName =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                          _js2n__-prdslib.isType 'Null
                        ],
                  updaterCacheDirName =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  url = _js2n__-prdslib.isType '"String",
                  useMultipleRangeRequest = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/GithubOptions!predicate"
        | doc m%"
          [GitHub](https://help.github.com/articles/about-releases/) options.
          
          GitHub [personal access token](https://help.github.com/articles/creating-an-access-token-for-command-line-use/) is required. You can generate by going to [https://github.com/settings/tokens/new](https://github.com/settings/tokens/new). The access token should have the repo scope/permission.
          Define `GH_TOKEN` environment variable.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "provider" ],
              _js2n__-prdslib.records.record
                {
                  host =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  owner =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  private =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"Bool"
                        ],
                  protocol =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum [ "http", "https" ]
                            ],
                          _js2n__-prdslib.isType 'Null
                        ],
                  provider =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "github" ]
                        ],
                  publishAutoUpdate = _js2n__-prdslib.isType '"Bool",
                  publisherName =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                          _js2n__-prdslib.isType 'Null
                        ],
                  releaseType =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [ "draft", "prerelease", "release" ]
                            ],
                          _js2n__-prdslib.isType 'Null
                        ],
                  repo =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  token =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  updaterCacheDirName =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  vPrefixedTagName = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/LinuxConfiguration!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  appId =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  artifactName =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  asar =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/AsarOptions!predicate",
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Null,
                              _js2n__-prdslib.isType '"Bool"
                            ]
                        ],
                  asarUnpack =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Null,
                              _js2n__-prdslib.isType '"String"
                            ]
                        ],
                  category =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  compression =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [ "maximum", "normal", "store" ]
                            ],
                          _js2n__-prdslib.isType 'Null
                        ],
                  cscKeyPassword =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  cscLink =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  depends =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                          _js2n__-prdslib.isType 'Null
                        ],
                  description =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  desktop = _js2n__-prdslib.always,
                  detectUpdateChannel = _js2n__-prdslib.isType '"Bool",
                  electronUpdaterCompatibility =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  executableName =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  extraFiles =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/FileSet!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/FileSet!predicate",
                                    _js2n__-prdslib.isType '"String"
                                  ])
                            ],
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Null,
                              _js2n__-prdslib.isType '"String"
                            ]
                        ],
                  extraResources =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/FileSet!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/FileSet!predicate",
                                    _js2n__-prdslib.isType '"String"
                                  ])
                            ],
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Null,
                              _js2n__-prdslib.isType '"String"
                            ]
                        ],
                  fileAssociations =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/FileAssociation!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/FileAssociation!predicate"
                            ]
                        ],
                  files =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/FileSet!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/FileSet!predicate",
                                    _js2n__-prdslib.isType '"String"
                                  ])
                            ],
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Null,
                              _js2n__-prdslib.isType '"String"
                            ]
                        ],
                  forceCodeSigning = _js2n__-prdslib.isType '"Bool",
                  generateUpdatesFilesForAllChannels =
                    _js2n__-prdslib.isType '"Bool",
                  icon = _js2n__-prdslib.isType '"String",
                  maintainer =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  mimeTypes =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                          _js2n__-prdslib.isType 'Null
                        ],
                  packageCategory =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  protocols =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Protocol!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/Protocol!predicate"
                            ]
                        ],
                  publish =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/GithubOptions!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/S3Options!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/SpacesOptions!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/GenericServerOptions!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/BintrayOptions!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/CustomPublishOptions!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/GithubOptions!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/S3Options!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/SpacesOptions!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/GenericServerOptions!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/BintrayOptions!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/CustomPublishOptions!predicate",
                                    _js2n__-prdslib.isType '"String"
                                  ])
                            ],
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Null,
                              _js2n__-prdslib.isType '"String"
                            ]
                        ],
                  releaseInfo =
                    _js2n__-refsenv."_js2n__-:definitions/ReleaseInfo!predicate",
                  synopsis =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  target =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/TargetConfiguration!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/TargetConfiguration!predicate",
                                    _js2n__-prdslib.isType '"String"
                                  ])
                            ],
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Null,
                              _js2n__-prdslib.isType '"String"
                            ]
                        ],
                  vendor =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/LinuxTargetSpecificOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  afterInstall =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  afterRemove =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  artifactName =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  category =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  compression =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum [ "bzip2", "gz", "xz" ]
                            ],
                          _js2n__-prdslib.isType 'Null
                        ],
                  depends =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                          _js2n__-prdslib.isType 'Null
                        ],
                  description =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  desktop = _js2n__-prdslib.always,
                  fpm =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                          _js2n__-prdslib.isType 'Null
                        ],
                  icon = _js2n__-prdslib.isType '"String",
                  maintainer =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  mimeTypes =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                          _js2n__-prdslib.isType 'Null
                        ],
                  packageCategory =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  publish =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/GithubOptions!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/S3Options!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/SpacesOptions!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/GenericServerOptions!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/BintrayOptions!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/CustomPublishOptions!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/GithubOptions!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/S3Options!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/SpacesOptions!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/GenericServerOptions!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/BintrayOptions!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/CustomPublishOptions!predicate",
                                    _js2n__-prdslib.isType '"String"
                                  ])
                            ],
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Null,
                              _js2n__-prdslib.isType '"String"
                            ]
                        ],
                  synopsis =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  vendor =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/MacConfiguration!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  appId =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  artifactName =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  asar =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/AsarOptions!predicate",
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Null,
                              _js2n__-prdslib.isType '"Bool"
                            ]
                        ],
                  asarUnpack =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Null,
                              _js2n__-prdslib.isType '"String"
                            ]
                        ],
                  binaries =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                          _js2n__-prdslib.isType 'Null
                        ],
                  bundleShortVersion =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  bundleVersion =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  category =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  compression =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [ "maximum", "normal", "store" ]
                            ],
                          _js2n__-prdslib.isType 'Null
                        ],
                  cscInstallerKeyPassword =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  cscInstallerLink =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  cscKeyPassword =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  cscLink =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  darkModeSupport = _js2n__-prdslib.isType '"Bool",
                  detectUpdateChannel = _js2n__-prdslib.isType '"Bool",
                  electronLanguages =
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
                  electronUpdaterCompatibility =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  entitlements =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  entitlementsInherit =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  extendInfo = _js2n__-prdslib.always,
                  extraDistFiles =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Null,
                              _js2n__-prdslib.isType '"String"
                            ]
                        ],
                  extraFiles =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/FileSet!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/FileSet!predicate",
                                    _js2n__-prdslib.isType '"String"
                                  ])
                            ],
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Null,
                              _js2n__-prdslib.isType '"String"
                            ]
                        ],
                  extraResources =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/FileSet!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/FileSet!predicate",
                                    _js2n__-prdslib.isType '"String"
                                  ])
                            ],
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Null,
                              _js2n__-prdslib.isType '"String"
                            ]
                        ],
                  fileAssociations =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/FileAssociation!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/FileAssociation!predicate"
                            ]
                        ],
                  files =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/FileSet!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/FileSet!predicate",
                                    _js2n__-prdslib.isType '"String"
                                  ])
                            ],
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Null,
                              _js2n__-prdslib.isType '"String"
                            ]
                        ],
                  forceCodeSigning = _js2n__-prdslib.isType '"Bool",
                  gatekeeperAssess = _js2n__-prdslib.isType '"Bool",
                  generateUpdatesFilesForAllChannels =
                    _js2n__-prdslib.isType '"Bool",
                  hardenedRuntime = _js2n__-prdslib.isType '"Bool",
                  helperBundleId =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  icon =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  identity =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  minimumSystemVersion =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  protocols =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Protocol!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/Protocol!predicate"
                            ]
                        ],
                  provisioningProfile =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  publish =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/GithubOptions!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/S3Options!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/SpacesOptions!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/GenericServerOptions!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/BintrayOptions!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/CustomPublishOptions!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/GithubOptions!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/S3Options!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/SpacesOptions!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/GenericServerOptions!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/BintrayOptions!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/CustomPublishOptions!predicate",
                                    _js2n__-prdslib.isType '"String"
                                  ])
                            ],
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Null,
                              _js2n__-prdslib.isType '"String"
                            ]
                        ],
                  releaseInfo =
                    _js2n__-refsenv."_js2n__-:definitions/ReleaseInfo!predicate",
                  requirements =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  target =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/TargetConfiguration!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/TargetConfiguration!predicate",
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType '"String",
                                        _js2n__-prdslib.enum
                                          [
                                            "7z",
                                            "default",
                                            "dir",
                                            "dmg",
                                            "mas",
                                            "mas-dev",
                                            "pkg",
                                            "tar.bz2",
                                            "tar.gz",
                                            "tar.lz",
                                            "tar.xz",
                                            "zip"
                                          ]
                                      ]
                                  ])
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [
                                  "7z",
                                  "default",
                                  "dir",
                                  "dmg",
                                  "mas",
                                  "mas-dev",
                                  "pkg",
                                  "tar.bz2",
                                  "tar.gz",
                                  "tar.lz",
                                  "tar.xz",
                                  "zip"
                                ]
                            ],
                          _js2n__-prdslib.isType 'Null
                        ],
                  type =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [ "development", "distribution" ]
                            ],
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/MasConfiguration!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  appId =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  artifactName =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  asar =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/AsarOptions!predicate",
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Null,
                              _js2n__-prdslib.isType '"Bool"
                            ]
                        ],
                  asarUnpack =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Null,
                              _js2n__-prdslib.isType '"String"
                            ]
                        ],
                  binaries =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                          _js2n__-prdslib.isType 'Null
                        ],
                  bundleShortVersion =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  bundleVersion =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  category =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  compression =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [ "maximum", "normal", "store" ]
                            ],
                          _js2n__-prdslib.isType 'Null
                        ],
                  cscInstallerKeyPassword =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  cscInstallerLink =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  cscKeyPassword =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  cscLink =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  darkModeSupport = _js2n__-prdslib.isType '"Bool",
                  detectUpdateChannel = _js2n__-prdslib.isType '"Bool",
                  electronLanguages =
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
                  electronUpdaterCompatibility =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  entitlements =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  entitlementsInherit =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  extendInfo = _js2n__-prdslib.always,
                  extraDistFiles =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Null,
                              _js2n__-prdslib.isType '"String"
                            ]
                        ],
                  extraFiles =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/FileSet!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/FileSet!predicate",
                                    _js2n__-prdslib.isType '"String"
                                  ])
                            ],
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Null,
                              _js2n__-prdslib.isType '"String"
                            ]
                        ],
                  extraResources =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/FileSet!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/FileSet!predicate",
                                    _js2n__-prdslib.isType '"String"
                                  ])
                            ],
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Null,
                              _js2n__-prdslib.isType '"String"
                            ]
                        ],
                  fileAssociations =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/FileAssociation!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/FileAssociation!predicate"
                            ]
                        ],
                  files =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/FileSet!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/FileSet!predicate",
                                    _js2n__-prdslib.isType '"String"
                                  ])
                            ],
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Null,
                              _js2n__-prdslib.isType '"String"
                            ]
                        ],
                  forceCodeSigning = _js2n__-prdslib.isType '"Bool",
                  generateUpdatesFilesForAllChannels =
                    _js2n__-prdslib.isType '"Bool",
                  hardenedRuntime = _js2n__-prdslib.isType '"Bool",
                  helperBundleId =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  icon =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  identity =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  minimumSystemVersion =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  protocols =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Protocol!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/Protocol!predicate"
                            ]
                        ],
                  provisioningProfile =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  publish =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/GithubOptions!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/S3Options!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/SpacesOptions!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/GenericServerOptions!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/BintrayOptions!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/CustomPublishOptions!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/GithubOptions!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/S3Options!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/SpacesOptions!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/GenericServerOptions!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/BintrayOptions!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/CustomPublishOptions!predicate",
                                    _js2n__-prdslib.isType '"String"
                                  ])
                            ],
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Null,
                              _js2n__-prdslib.isType '"String"
                            ]
                        ],
                  releaseInfo =
                    _js2n__-refsenv."_js2n__-:definitions/ReleaseInfo!predicate",
                  requirements =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  target =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/TargetConfiguration!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/TargetConfiguration!predicate",
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType '"String",
                                        _js2n__-prdslib.enum
                                          [
                                            "7z",
                                            "default",
                                            "dir",
                                            "dmg",
                                            "mas",
                                            "mas-dev",
                                            "pkg",
                                            "tar.bz2",
                                            "tar.gz",
                                            "tar.lz",
                                            "tar.xz",
                                            "zip"
                                          ]
                                      ]
                                  ])
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [
                                  "7z",
                                  "default",
                                  "dir",
                                  "dmg",
                                  "mas",
                                  "mas-dev",
                                  "pkg",
                                  "tar.bz2",
                                  "tar.gz",
                                  "tar.lz",
                                  "tar.xz",
                                  "zip"
                                ]
                            ],
                          _js2n__-prdslib.isType 'Null
                        ],
                  type =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [ "development", "distribution" ]
                            ],
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/MetadataDirectories!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  app =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  buildResources =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  output =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/MsiOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  artifactName =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  createDesktopShortcut =
                    _js2n__-prdslib.enum [ "always", false, true ],
                  createStartMenuShortcut = _js2n__-prdslib.isType '"Bool",
                  menuCategory =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Bool"
                        ],
                  oneClick = _js2n__-prdslib.isType '"Bool",
                  perMachine = _js2n__-prdslib.isType '"Bool",
                  publish =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/GithubOptions!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/S3Options!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/SpacesOptions!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/GenericServerOptions!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/BintrayOptions!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/CustomPublishOptions!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/GithubOptions!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/S3Options!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/SpacesOptions!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/GenericServerOptions!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/BintrayOptions!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/CustomPublishOptions!predicate",
                                    _js2n__-prdslib.isType '"String"
                                  ])
                            ],
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Null,
                              _js2n__-prdslib.isType '"String"
                            ]
                        ],
                  runAfterFinish = _js2n__-prdslib.isType '"Bool",
                  shortcutName =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  upgradeCode =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  warningsAsErrors = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/NsisOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  allowElevation = _js2n__-prdslib.isType '"Bool",
                  allowToChangeInstallationDirectory =
                    _js2n__-prdslib.isType '"Bool",
                  artifactName =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  createDesktopShortcut =
                    _js2n__-prdslib.enum [ "always", false, true ],
                  createStartMenuShortcut = _js2n__-prdslib.isType '"Bool",
                  deleteAppDataOnUninstall = _js2n__-prdslib.isType '"Bool",
                  differentialPackage = _js2n__-prdslib.isType '"Bool",
                  displayLanguageSelector = _js2n__-prdslib.isType '"Bool",
                  guid =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  include =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  installerHeader =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  installerHeaderIcon =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  installerIcon =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  installerLanguages =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Null,
                              _js2n__-prdslib.isType '"String"
                            ]
                        ],
                  installerSidebar =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  language =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  license =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  menuCategory =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Bool"
                        ],
                  multiLanguageInstaller = _js2n__-prdslib.isType '"Bool",
                  oneClick = _js2n__-prdslib.isType '"Bool",
                  packElevateHelper = _js2n__-prdslib.isType '"Bool",
                  perMachine = _js2n__-prdslib.isType '"Bool",
                  preCompressedFileExtensions =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Null,
                              _js2n__-prdslib.isType '"String"
                            ]
                        ],
                  publish =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/GithubOptions!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/S3Options!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/SpacesOptions!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/GenericServerOptions!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/BintrayOptions!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/CustomPublishOptions!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/GithubOptions!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/S3Options!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/SpacesOptions!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/GenericServerOptions!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/BintrayOptions!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/CustomPublishOptions!predicate",
                                    _js2n__-prdslib.isType '"String"
                                  ])
                            ],
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Null,
                              _js2n__-prdslib.isType '"String"
                            ]
                        ],
                  runAfterFinish = _js2n__-prdslib.isType '"Bool",
                  script =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  shortcutName =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  unicode = _js2n__-prdslib.isType '"Bool",
                  uninstallDisplayName = _js2n__-prdslib.isType '"String",
                  uninstallerIcon =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  uninstallerSidebar =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  useZip = _js2n__-prdslib.isType '"Bool",
                  warningsAsErrors = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/NsisWebOptions!predicate"
        | doc "Web Installer options."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  allowElevation = _js2n__-prdslib.isType '"Bool",
                  allowToChangeInstallationDirectory =
                    _js2n__-prdslib.isType '"Bool",
                  appPackageUrl =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  artifactName =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  createDesktopShortcut =
                    _js2n__-prdslib.enum [ "always", false, true ],
                  createStartMenuShortcut = _js2n__-prdslib.isType '"Bool",
                  deleteAppDataOnUninstall = _js2n__-prdslib.isType '"Bool",
                  differentialPackage = _js2n__-prdslib.isType '"Bool",
                  displayLanguageSelector = _js2n__-prdslib.isType '"Bool",
                  guid =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  include =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  installerHeader =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  installerHeaderIcon =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  installerIcon =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  installerLanguages =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Null,
                              _js2n__-prdslib.isType '"String"
                            ]
                        ],
                  installerSidebar =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  language =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  license =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  menuCategory =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Bool"
                        ],
                  multiLanguageInstaller = _js2n__-prdslib.isType '"Bool",
                  oneClick = _js2n__-prdslib.isType '"Bool",
                  packElevateHelper = _js2n__-prdslib.isType '"Bool",
                  perMachine = _js2n__-prdslib.isType '"Bool",
                  preCompressedFileExtensions =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Null,
                              _js2n__-prdslib.isType '"String"
                            ]
                        ],
                  publish =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/GithubOptions!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/S3Options!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/SpacesOptions!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/GenericServerOptions!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/BintrayOptions!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/CustomPublishOptions!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/GithubOptions!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/S3Options!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/SpacesOptions!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/GenericServerOptions!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/BintrayOptions!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/CustomPublishOptions!predicate",
                                    _js2n__-prdslib.isType '"String"
                                  ])
                            ],
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Null,
                              _js2n__-prdslib.isType '"String"
                            ]
                        ],
                  runAfterFinish = _js2n__-prdslib.isType '"Bool",
                  script =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  shortcutName =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  unicode = _js2n__-prdslib.isType '"Bool",
                  uninstallDisplayName = _js2n__-prdslib.isType '"String",
                  uninstallerIcon =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  uninstallerSidebar =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  useZip = _js2n__-prdslib.isType '"Bool",
                  warningsAsErrors = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/PkgBackgroundOptions!predicate"
        | doc "Options for the background image in a PKG installer"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  alignment =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [
                                  "bottom",
                                  "bottomleft",
                                  "bottomright",
                                  "center",
                                  "left",
                                  "right",
                                  "top",
                                  "topleft",
                                  "topright"
                                ]
                            ],
                          _js2n__-prdslib.isType 'Null
                        ],
                  file = _js2n__-prdslib.isType '"String",
                  scaling =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [ "none", "proportional", "tofit" ]
                            ],
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/PkgOptions!predicate"
        | doc "macOS product archive options."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  allowAnywhere =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"Bool"
                        ],
                  allowCurrentUserHome =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"Bool"
                        ],
                  allowRootDirectory =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"Bool"
                        ],
                  artifactName =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  background =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/PkgBackgroundOptions!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  conclusion =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  hasStrictIdentifier =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"Bool"
                        ],
                  identity =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  installLocation =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  isRelocatable =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"Bool"
                        ],
                  isVersionChecked =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"Bool"
                        ],
                  license =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  overwriteAction =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum [ "update", "upgrade" ]
                            ],
                          _js2n__-prdslib.isType 'Null
                        ],
                  productbuild =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                          _js2n__-prdslib.isType 'Null
                        ],
                  publish =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/GithubOptions!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/S3Options!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/SpacesOptions!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/GenericServerOptions!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/BintrayOptions!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/CustomPublishOptions!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/GithubOptions!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/S3Options!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/SpacesOptions!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/GenericServerOptions!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/BintrayOptions!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/CustomPublishOptions!predicate",
                                    _js2n__-prdslib.isType '"String"
                                  ])
                            ],
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Null,
                              _js2n__-prdslib.isType '"String"
                            ]
                        ],
                  scripts =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  welcome =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/PlugDescriptor!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.record {} {} true
                          _js2n__-prdslib.always
                      ],
                    _js2n__-prdslib.isType 'Null
                  ])
            ],
      "_js2n__-:definitions/PortableOptions!predicate"
        | doc "Portable options."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  artifactName =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  guid =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  publish =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/GithubOptions!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/S3Options!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/SpacesOptions!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/GenericServerOptions!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/BintrayOptions!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/CustomPublishOptions!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/GithubOptions!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/S3Options!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/SpacesOptions!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/GenericServerOptions!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/BintrayOptions!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/CustomPublishOptions!predicate",
                                    _js2n__-prdslib.isType '"String"
                                  ])
                            ],
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Null,
                              _js2n__-prdslib.isType '"String"
                            ]
                        ],
                  requestExecutionLevel =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "admin", "highest", "user" ]
                        ],
                  unicode = _js2n__-prdslib.isType '"Bool",
                  unpackDirName = _js2n__-prdslib.isType '"String",
                  useZip = _js2n__-prdslib.isType '"Bool",
                  warningsAsErrors = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Protocol!predicate"
        | doc m%"
          URL Protocol Schemes. Protocols to associate the app with. macOS only.
          
          Please note — on macOS [you need to register an `open-url` event handler](http://electron.atom.io/docs/api/app/#event-open-url-macos).
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name", "schemes" ],
              _js2n__-prdslib.records.record
                {
                  name = _js2n__-prdslib.isType '"String",
                  role =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "Editor", "None", "Shell", "Viewer" ]
                        ],
                  schemes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/PublishProvider!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [ "bintray", "custom", "generic", "github", "s3", "spaces" ]
            ],
      "_js2n__-:definitions/ReleaseInfo!contract" =
        {
            releaseDate | String | doc "The release date." | optional,
            releaseName
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.isType 'Null,
                    _js2n__-prdslib.isType '"String"
                  ])
              | doc "The release name."
              | optional,
            releaseNotes
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.isType 'Null,
                    _js2n__-prdslib.isType '"String"
                  ])
              | doc "The release notes."
              | optional,
            releaseNotesFile
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.isType 'Null,
                    _js2n__-prdslib.isType '"String"
                  ])
              | doc "The path to release notes file. Defaults to `release-notes-${platform}.md` (where `platform` it is current platform — `mac`, `linux` or `windows`) or `release-notes.md` in the [build resources](#MetadataDirectories-buildResources)."
              | optional,
          },
      "_js2n__-:definitions/ReleaseInfo!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  releaseDate = _js2n__-prdslib.isType '"String",
                  releaseName =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  releaseNotes =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  releaseNotesFile =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/S3Options!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "bucket", "provider" ],
              _js2n__-prdslib.records.record
                {
                  acl =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum [ "private", "public-read" ]
                            ],
                          _js2n__-prdslib.isType 'Null
                        ],
                  bucket = _js2n__-prdslib.isType '"String",
                  channel =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  encryption =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum [ "AES256", "aws:kms" ]
                            ],
                          _js2n__-prdslib.isType 'Null
                        ],
                  endpoint =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  path =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  provider =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "s3" ]
                        ],
                  publishAutoUpdate = _js2n__-prdslib.isType '"Bool",
                  publisherName =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                          _js2n__-prdslib.isType 'Null
                        ],
                  region =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  storageClass =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [
                                  "REDUCED_REDUNDANCY",
                                  "STANDARD",
                                  "STANDARD_IA"
                                ]
                            ],
                          _js2n__-prdslib.isType 'Null
                        ],
                  updaterCacheDirName =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/SnapOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  after =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                          _js2n__-prdslib.isType 'Null
                        ],
                  artifactName =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  assumes =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Null,
                              _js2n__-prdslib.isType '"String"
                            ]
                        ],
                  buildPackages =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                          _js2n__-prdslib.isType 'Null
                        ],
                  category =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  confinement =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [ "classic", "devmode", "strict" ]
                            ],
                          _js2n__-prdslib.isType 'Null
                        ],
                  description =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  desktop = _js2n__-prdslib.always,
                  environment =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.always,
                          _js2n__-prdslib.isType 'Null
                        ],
                  grade =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum [ "devel", "stable" ]
                            ],
                          _js2n__-prdslib.isType 'Null
                        ],
                  hooks =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  mimeTypes =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                          _js2n__-prdslib.isType 'Null
                        ],
                  plugs =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/PlugDescriptor!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/PlugDescriptor!predicate",
                                    _js2n__-prdslib.isType '"String"
                                  ])
                            ],
                          _js2n__-prdslib.isType 'Null
                        ],
                  publish =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/GithubOptions!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/S3Options!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/SpacesOptions!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/GenericServerOptions!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/BintrayOptions!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/CustomPublishOptions!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/GithubOptions!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/S3Options!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/SpacesOptions!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/GenericServerOptions!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/BintrayOptions!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/CustomPublishOptions!predicate",
                                    _js2n__-prdslib.isType '"String"
                                  ])
                            ],
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Null,
                              _js2n__-prdslib.isType '"String"
                            ]
                        ],
                  stagePackages =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                          _js2n__-prdslib.isType 'Null
                        ],
                  summary =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  synopsis =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  useTemplateApp = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/SpacesOptions!predicate"
        | doc m%"
          [DigitalOcean Spaces](https://www.digitalocean.com/community/tutorials/an-introduction-to-digitalocean-spaces) options.
          Access key is required, define `DO_KEY_ID` and `DO_SECRET_KEY` environment variables.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name", "provider", "region" ],
              _js2n__-prdslib.records.record
                {
                  acl =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum [ "private", "public-read" ]
                            ],
                          _js2n__-prdslib.isType 'Null
                        ],
                  channel =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  name = _js2n__-prdslib.isType '"String",
                  path =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  provider =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "spaces" ]
                        ],
                  publishAutoUpdate = _js2n__-prdslib.isType '"Bool",
                  publisherName =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                          _js2n__-prdslib.isType 'Null
                        ],
                  region = _js2n__-prdslib.isType '"String",
                  updaterCacheDirName =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/SquirrelWindowsOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  artifactName =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  iconUrl =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  loadingGif =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  msi = _js2n__-prdslib.isType '"Bool",
                  name = _js2n__-prdslib.isType '"String",
                  publish =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/GithubOptions!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/S3Options!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/SpacesOptions!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/GenericServerOptions!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/BintrayOptions!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/CustomPublishOptions!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/GithubOptions!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/S3Options!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/SpacesOptions!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/GenericServerOptions!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/BintrayOptions!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/CustomPublishOptions!predicate",
                                    _js2n__-prdslib.isType '"String"
                                  ])
                            ],
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Null,
                              _js2n__-prdslib.isType '"String"
                            ]
                        ],
                  remoteReleases =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Bool"
                        ],
                  remoteToken =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  useAppIdAsId = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/TargetConfiguration!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "target" ],
              _js2n__-prdslib.records.record
                {
                  arch =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.enum
                                      [ "arm64", "armv7l", "ia32", "x64" ]
                                  ])
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [ "arm64", "armv7l", "ia32", "x64" ]
                            ]
                        ],
                  target = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/WindowsConfiguration!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  additionalCertificateFile =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  appId =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  artifactName =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  asar =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/AsarOptions!predicate",
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Null,
                              _js2n__-prdslib.isType '"Bool"
                            ]
                        ],
                  asarUnpack =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Null,
                              _js2n__-prdslib.isType '"String"
                            ]
                        ],
                  certificateFile =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  certificatePassword =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  certificateSha1 =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  certificateSubjectName =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  compression =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [ "maximum", "normal", "store" ]
                            ],
                          _js2n__-prdslib.isType 'Null
                        ],
                  cscKeyPassword =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  cscLink =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  detectUpdateChannel = _js2n__-prdslib.isType '"Bool",
                  electronUpdaterCompatibility =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  extraFiles =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/FileSet!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/FileSet!predicate",
                                    _js2n__-prdslib.isType '"String"
                                  ])
                            ],
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Null,
                              _js2n__-prdslib.isType '"String"
                            ]
                        ],
                  extraResources =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/FileSet!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/FileSet!predicate",
                                    _js2n__-prdslib.isType '"String"
                                  ])
                            ],
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Null,
                              _js2n__-prdslib.isType '"String"
                            ]
                        ],
                  fileAssociations =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/FileAssociation!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/FileAssociation!predicate"
                            ]
                        ],
                  files =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/FileSet!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/FileSet!predicate",
                                    _js2n__-prdslib.isType '"String"
                                  ])
                            ],
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Null,
                              _js2n__-prdslib.isType '"String"
                            ]
                        ],
                  forceCodeSigning = _js2n__-prdslib.isType '"Bool",
                  generateUpdatesFilesForAllChannels =
                    _js2n__-prdslib.isType '"Bool",
                  icon =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  legalTrademarks =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  protocols =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Protocol!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/Protocol!predicate"
                            ]
                        ],
                  publish =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/GithubOptions!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/S3Options!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/SpacesOptions!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/GenericServerOptions!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/BintrayOptions!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/CustomPublishOptions!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/GithubOptions!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/S3Options!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/SpacesOptions!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/GenericServerOptions!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/BintrayOptions!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/CustomPublishOptions!predicate",
                                    _js2n__-prdslib.isType '"String"
                                  ])
                            ],
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Null,
                              _js2n__-prdslib.isType '"String"
                            ]
                        ],
                  publisherName =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Null,
                              _js2n__-prdslib.isType '"String"
                            ]
                        ],
                  releaseInfo =
                    _js2n__-refsenv."_js2n__-:definitions/ReleaseInfo!predicate",
                  requestedExecutionLevel =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [
                                  "asInvoker",
                                  "highestAvailable",
                                  "requireAdministrator"
                                ]
                            ],
                          _js2n__-prdslib.isType 'Null
                        ],
                  rfc3161TimeStampServer =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  sign =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.always,
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Null,
                              _js2n__-prdslib.isType '"String"
                            ]
                        ],
                  signAndEditExecutable = _js2n__-prdslib.isType '"Bool",
                  signDlls = _js2n__-prdslib.isType '"Bool",
                  signingHashAlgorithms =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.enum [ "sha1", "sha256" ]
                                  ])
                            ],
                          _js2n__-prdslib.isType 'Null
                        ],
                  target =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/TargetConfiguration!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/TargetConfiguration!predicate",
                                    _js2n__-prdslib.isType '"String"
                                  ])
                            ],
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Null,
                              _js2n__-prdslib.isType '"String"
                            ]
                        ],
                  timeStampServer =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  verifyUpdateCodeSignature = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
    }
    in
  {
      "$schema"
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [ _js2n__-prdslib.isType 'Null, _js2n__-prdslib.isType '"String" ])
        | doc "JSON Schema for this document."
        | optional,
      afterAllArtifactBuild
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.always,
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType 'Null,
                  _js2n__-prdslib.isType '"String"
                ]
            ])
        | doc "The function (or path to file or module id) to be [run after all artifacts are build](#afterAllArtifactBuild)."
        | optional,
      afterPack
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.always,
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType 'Null,
                  _js2n__-prdslib.isType '"String"
                ]
            ])
        | doc "The function (or path to file or module id) to be [run after pack](#afterpack) (but before pack into distributable format and sign)."
        | optional,
      afterSign
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.always,
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType 'Null,
                  _js2n__-prdslib.isType '"String"
                ]
            ])
        | doc "The function (or path to file or module id) to be [run after pack and sign](#aftersign) (but before pack into distributable format)."
        | optional,
      apk
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/LinuxTargetSpecificOptions!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | optional,
      appId
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [ _js2n__-prdslib.isType 'Null, _js2n__-prdslib.isType '"String" ])
        | doc m%"
          The application id. Used as [CFBundleIdentifier](https://developer.apple.com/library/ios/documentation/General/Reference/InfoPlistKeyReference/Articles/CoreFoundationKeys.html#//apple_ref/doc/uid/20001431-102070) for MacOS and as
          [Application User Model ID](https://msdn.microsoft.com/en-us/library/windows/desktop/dd378459(v=vs.85).aspx) for Windows (NSIS target only, Squirrel.Windows not supported). It is strongly recommended that an explicit ID is set.
        "%
        | optional,
      appImage
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/AppImageOptions!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | doc "AppImage options."
        | optional,
      appx
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/AppXOptions!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | optional,
      artifactBuildCompleted
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.always,
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType 'Null,
                  _js2n__-prdslib.isType '"String"
                ]
            ])
        | doc "The function (or path to file or module id) to be run on artifact build completed."
        | optional,
      artifactBuildStarted
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.always,
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType 'Null,
                  _js2n__-prdslib.isType '"String"
                ]
            ])
        | doc "The function (or path to file or module id) to be run on artifact build start."
        | optional,
      artifactName
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [ _js2n__-prdslib.isType 'Null, _js2n__-prdslib.isType '"String" ])
        | doc "The [artifact file name template](/configuration/configuration#artifact-file-name-template). Defaults to `${productName}-${version}.${ext}` (some target can have other defaults, see corresponding options)."
        | optional,
      asar
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/AsarOptions!predicate",
              _js2n__-prdslib.anyOf
                [ _js2n__-prdslib.isType 'Null, _js2n__-prdslib.isType '"Bool" ]
            ])
        | doc m%"
          Whether to package the application's source code into an archive, using [Electron's archive format](http://electron.atom.io/docs/tutorial/application-packaging/).
          
          Node modules, that must be unpacked, will be detected automatically, you don't need to explicitly set [asarUnpack](#configuration-asarUnpack) - please file an issue if this doesn't work.
        "%
        | optional,
      asarUnpack
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.isType '"String")
                ],
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType 'Null,
                  _js2n__-prdslib.isType '"String"
                ]
            ])
        | doc "A [glob patterns](/file-patterns) relative to the [app directory](#MetadataDirectories-app), which specifies which files to unpack when creating the [asar](http://electron.atom.io/docs/tutorial/application-packaging/) archive."
        | optional,
      beforeBuild
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.always,
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType 'Null,
                  _js2n__-prdslib.isType '"String"
                ]
            ])
        | doc m%"
          The function (or path to file or module id) to be run before dependencies are installed or rebuilt. Works when `npmRebuild` is set to `true`. Resolving to `false` will skip dependencies install or rebuild.
          
          If provided and `node_modules` are missing, it will not invoke production dependencies check.
        "%
        | optional,
      buildDependenciesFromSource
        | Bool
        | doc "Whether to build the application native dependencies from source."
        | optional,
      buildVersion
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [ _js2n__-prdslib.isType 'Null, _js2n__-prdslib.isType '"String" ])
        | doc m%"
          The build version. Maps to the `CFBundleVersion` on macOS, and `FileVersion` metadata property on Windows. Defaults to the `version`.
          If `TRAVIS_BUILD_NUMBER` or `APPVEYOR_BUILD_NUMBER` or `CIRCLE_BUILD_NUM` or `BUILD_NUMBER` or `bamboo.buildNumber` env defined, it will be used as a build version (`version.build_number`).
        "%
        | optional,
      compression
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "maximum", "normal", "store" ]
                ],
              _js2n__-prdslib.isType 'Null
            ])
        | doc "The compression level. If you want to rapidly test build, `store` can reduce build time significantly. `maximum` doesn't lead to noticeable size difference, but increase build time."
        | optional,
      copyright
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [ _js2n__-prdslib.isType 'Null, _js2n__-prdslib.isType '"String" ])
        | doc "The human-readable copyright line for the app."
        | optional,
      cscKeyPassword
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [ _js2n__-prdslib.isType 'Null, _js2n__-prdslib.isType '"String" ])
        | optional,
      cscLink
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [ _js2n__-prdslib.isType 'Null, _js2n__-prdslib.isType '"String" ])
        | optional,
      deb
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/DebOptions!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | doc "Debian package options."
        | optional,
      detectUpdateChannel
        | Bool
        | doc "Whether to infer update channel from application version pre-release components. e.g. if version `0.12.1-alpha.1`, channel will be set to `alpha`. Otherwise to `latest`."
        | optional,
      directories
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/MetadataDirectories!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | optional,
      dmg
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/DmgOptions!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | doc "macOS DMG options."
        | optional,
      electronCompile
        | Bool
        | doc "Whether to use [electron-compile](http://github.com/electron/electron-compile) to compile app. Defaults to `true` if `electron-compile` in the dependencies. And `false` if in the `devDependencies` or doesn't specified."
        | optional,
      electronDist
        | String
        | doc "The path to custom Electron build (e.g. `~/electron/out/R`)."
        | optional,
      electronDownload
        | _js2n__-refsenv."_js2n__-:definitions/ElectronDownloadOptions!contract"
        | doc "The [electron-download](https://github.com/electron-userland/electron-download#usage) options."
        | optional,
      electronUpdaterCompatibility
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [ _js2n__-prdslib.isType 'Null, _js2n__-prdslib.isType '"String" ])
        | doc "The [electron-updater compatibility](/auto-update#compatibility) semver range."
        | optional,
      electronVersion
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [ _js2n__-prdslib.isType 'Null, _js2n__-prdslib.isType '"String" ])
        | doc "The version of electron you are packaging for. Defaults to version of `electron`, `electron-prebuilt` or `electron-prebuilt-compile` dependency."
        | optional,
      extends
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [ _js2n__-prdslib.isType 'Null, _js2n__-prdslib.isType '"String" ])
        | doc m%"
          The name of a built-in configuration preset or path to config file (relative to project dir). Currently, only `react-cra` is supported.
          
          If `react-scripts` in the app dependencies, `react-cra` will be set automatically. Set to `null` to disable automatic detection.
        "%
        | optional,
      extraFiles
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/FileSet!predicate",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/FileSet!predicate",
                        _js2n__-prdslib.isType '"String"
                      ])
                ],
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType 'Null,
                  _js2n__-prdslib.isType '"String"
                ]
            ])
        | optional,
      extraMetadata
        | _js2n__-prdslib.contract_from_predicate _js2n__-prdslib.always
        | doc "Inject properties to `package.json`."
        | optional,
      extraResources
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/FileSet!predicate",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/FileSet!predicate",
                        _js2n__-prdslib.isType '"String"
                      ])
                ],
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType 'Null,
                  _js2n__-prdslib.isType '"String"
                ]
            ])
        | optional,
      fileAssociations
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/FileAssociation!predicate",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    _js2n__-refsenv."_js2n__-:definitions/FileAssociation!predicate"
                ]
            ])
        | doc "The file associations."
        | optional,
      files
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/FileSet!predicate",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/FileSet!predicate",
                        _js2n__-prdslib.isType '"String"
                      ])
                ],
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType 'Null,
                  _js2n__-prdslib.isType '"String"
                ]
            ])
        | optional,
      forceCodeSigning
        | Bool
        | doc "Whether to fail if app will be not code signed."
        | optional,
      framework
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [ _js2n__-prdslib.isType 'Null, _js2n__-prdslib.isType '"String" ])
        | doc "The framework name. One of `electron`, `proton-native`, `libui`. Defaults to `electron`."
        | optional,
      freebsd
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/LinuxTargetSpecificOptions!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | optional,
      generateUpdatesFilesForAllChannels
        | Bool
        | doc "Please see [Building and Releasing using Channels](https://github.com/electron-userland/electron-builder/issues/1182#issuecomment-324947139)."
        | optional,
      icon
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [ _js2n__-prdslib.isType 'Null, _js2n__-prdslib.isType '"String" ])
        | optional,
      includePdb | Bool | doc "Whether to include PDB files." | optional,
      launchUiVersion
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType 'Null,
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.isType '"Bool"
            ])
        | doc "*libui-based frameworks only* The version of LaunchUI you are packaging for. Applicable for Windows only. Defaults to version suitable for used framework version."
        | optional,
      linux
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/LinuxConfiguration!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | doc "Options related to how build Linux targets."
        | optional,
      mac
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/MacConfiguration!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | doc "Options related to how build macOS targets."
        | optional,
      mas
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/MasConfiguration!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | doc "MAS (Mac Application Store) options."
        | optional,
      msi
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/MsiOptions!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | optional,
      muonVersion
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [ _js2n__-prdslib.isType 'Null, _js2n__-prdslib.isType '"String" ])
        | doc "The version of muon you are packaging for."
        | optional,
      nodeGypRebuild
        | Bool
        | doc m%"
          Whether to execute `node-gyp rebuild` before starting to package the app.
          
          Don't [use](https://github.com/electron-userland/electron-builder/issues/683#issuecomment-241214075) [npm](http://electron.atom.io/docs/tutorial/using-native-node-modules/#using-npm) (neither `.npmrc`) for configuring electron headers. Use `electron-builder node-gyp-rebuild` instead.
        "%
        | optional,
      nodeVersion
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [ _js2n__-prdslib.isType 'Null, _js2n__-prdslib.isType '"String" ])
        | doc m%"
          *libui-based frameworks only* The version of NodeJS you are packaging for.
          You can set it to `current` to set the Node.js version that you use to run.
        "%
        | optional,
      npmArgs
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.isType '"String")
                ],
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType 'Null,
                  _js2n__-prdslib.isType '"String"
                ]
            ])
        | doc "Additional command line arguments to use when installing app native deps."
        | optional,
      npmRebuild
        | Bool
        | doc "Whether to [rebuild](https://docs.npmjs.com/cli/rebuild) native dependencies before starting to package the app."
        | optional,
      npmSkipBuildFromSource | Bool | optional,
      nsis
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/NsisOptions!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | optional,
      nsisWeb
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/NsisWebOptions!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | optional,
      onNodeModuleFile
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.always,
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType 'Null,
                  _js2n__-prdslib.isType '"String"
                ]
            ])
        | doc "The function (or path to file or module id) to be [run on each node module](#onnodemodulefile) file."
        | optional,
      p5p
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/LinuxTargetSpecificOptions!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | optional,
      pacman
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/LinuxTargetSpecificOptions!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | optional,
      pkg
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/PkgOptions!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | doc "macOS PKG options."
        | optional,
      portable
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/PortableOptions!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | optional,
      productName
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [ _js2n__-prdslib.isType 'Null, _js2n__-prdslib.isType '"String" ])
        | doc "As [name](#Metadata-name), but allows you to specify a product name for your executable which contains spaces and other special characters not allowed in the [name property](https://docs.npmjs.com/files/package.json#name)."
        | optional,
      protocols
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/Protocol!predicate",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    _js2n__-refsenv."_js2n__-:definitions/Protocol!predicate"
                ]
            ])
        | doc "The URL protocol schemes."
        | optional,
      protonNodeVersion
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [ _js2n__-prdslib.isType 'Null, _js2n__-prdslib.isType '"String" ])
        | optional,
      publish
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/GithubOptions!predicate",
              _js2n__-refsenv."_js2n__-:definitions/S3Options!predicate",
              _js2n__-refsenv."_js2n__-:definitions/SpacesOptions!predicate",
              _js2n__-refsenv."_js2n__-:definitions/GenericServerOptions!predicate",
              _js2n__-refsenv."_js2n__-:definitions/BintrayOptions!predicate",
              _js2n__-refsenv."_js2n__-:definitions/CustomPublishOptions!predicate",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/GithubOptions!predicate",
                        _js2n__-refsenv."_js2n__-:definitions/S3Options!predicate",
                        _js2n__-refsenv."_js2n__-:definitions/SpacesOptions!predicate",
                        _js2n__-refsenv."_js2n__-:definitions/GenericServerOptions!predicate",
                        _js2n__-refsenv."_js2n__-:definitions/BintrayOptions!predicate",
                        _js2n__-refsenv."_js2n__-:definitions/CustomPublishOptions!predicate",
                        _js2n__-prdslib.isType '"String"
                      ])
                ],
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType 'Null,
                  _js2n__-prdslib.isType '"String"
                ]
            ])
        | optional,
      readonly
        | Bool
        | doc "Whether to fail if the application is not signed (to prevent unsigned app if code signing configuration is not correct)."
        | optional,
      releaseInfo
        | _js2n__-refsenv."_js2n__-:definitions/ReleaseInfo!contract"
        | doc m%"
          The release info. Intended for command line usage:
          
          ```
          -c.releaseInfo.releaseNotes="new features"
          ```
        "%
        | optional,
      remoteBuild
        | Bool
        | doc "Whether to build using Electron Build Service if target not supported on current OS."
        | optional,
      removePackageScripts
        | Bool
        | doc "Whether to remove `scripts` field from `package.json` files."
        | optional,
      rpm
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/LinuxTargetSpecificOptions!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | optional,
      snap
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/SnapOptions!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | doc "Snap options."
        | optional,
      squirrelWindows
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/SquirrelWindowsOptions!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | optional,
      target
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/TargetConfiguration!predicate",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/TargetConfiguration!predicate",
                        _js2n__-prdslib.isType '"String"
                      ])
                ],
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType 'Null,
                  _js2n__-prdslib.isType '"String"
                ]
            ])
        | optional,
      win
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/WindowsConfiguration!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | doc "Options related to how build Windows targets."
        | optional,
    }