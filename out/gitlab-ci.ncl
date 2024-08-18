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
      "_js2n__-:definitions/!reference!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.strings.minLength 1
                  ])
            ],
      "_js2n__-:definitions/after_script!predicate" =
        _js2n__-refsenv."_js2n__-:definitions/optional_script!predicate",
      "_js2n__-:definitions/allow_failure!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.isType '"Bool",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "exit_codes" ],
                  _js2n__-prdslib.records.record
                    { exit_codes = _js2n__-prdslib.isType 'Integer, } {} false
                    _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "exit_codes" ],
                  _js2n__-prdslib.records.record
                    {
                      exit_codes =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType 'Integer),
                              _js2n__-prdslib.arrays.minItems 1,
                              _js2n__-prdslib.arrays.uniqueItems
                            ],
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:definitions/artifacts!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  access =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "none", "developer", "all" ]
                        ],
                  exclude =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String"),
                          _js2n__-prdslib.arrays.minItems 1
                        ],
                  expire_in = _js2n__-prdslib.isType '"String",
                  expose_as = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                  paths =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String"),
                          _js2n__-prdslib.arrays.minItems 1
                        ],
                  reports =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              browser_performance =
                                _js2n__-prdslib.isType '"String",
                              codequality =
                                _js2n__-refsenv."_js2n__-:definitions/string_file_list!predicate",
                              container_scanning =
                                _js2n__-refsenv."_js2n__-:definitions/string_file_list!predicate",
                              coverage_report =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.isType 'Null
                                        ],
                                      _js2n__-prdslib.records.record
                                        {
                                          coverage_format =
                                            _js2n__-prdslib.enum
                                                [ "cobertura", "jacoco" ],
                                          path =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.strings.minLength
                                                    1
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              cyclonedx =
                                _js2n__-refsenv."_js2n__-:definitions/string_file_list!predicate",
                              dast =
                                _js2n__-refsenv."_js2n__-:definitions/string_file_list!predicate",
                              dependency_scanning =
                                _js2n__-refsenv."_js2n__-:definitions/string_file_list!predicate",
                              dotenv =
                                _js2n__-refsenv."_js2n__-:definitions/string_file_list!predicate",
                              junit =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.isType '"String"),
                                          _js2n__-prdslib.arrays.minItems 1
                                        ]
                                    ],
                              license_management =
                                _js2n__-refsenv."_js2n__-:definitions/string_file_list!predicate",
                              license_scanning =
                                _js2n__-refsenv."_js2n__-:definitions/string_file_list!predicate",
                              load_performance =
                                _js2n__-refsenv."_js2n__-:definitions/string_file_list!predicate",
                              lsif =
                                _js2n__-refsenv."_js2n__-:definitions/string_file_list!predicate",
                              metrics =
                                _js2n__-refsenv."_js2n__-:definitions/string_file_list!predicate",
                              repository_xray =
                                _js2n__-refsenv."_js2n__-:definitions/string_file_list!predicate",
                              requirements =
                                _js2n__-refsenv."_js2n__-:definitions/string_file_list!predicate",
                              sast =
                                _js2n__-refsenv."_js2n__-:definitions/string_file_list!predicate",
                              secret_detection =
                                _js2n__-refsenv."_js2n__-:definitions/string_file_list!predicate",
                              terraform =
                                _js2n__-refsenv."_js2n__-:definitions/string_file_list!predicate",
                            } {} false _js2n__-prdslib.never
                        ],
                  untracked = _js2n__-prdslib.isType '"Bool",
                  when =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "on_success", "on_failure", "always" ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/before_script!predicate" =
        _js2n__-refsenv."_js2n__-:definitions/optional_script!predicate",
      "_js2n__-:definitions/cache!predicate" =
        _js2n__-prdslib.records.record
            {
              fallback_keys =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.isType '"String"),
                      _js2n__-prdslib.arrays.maxItems 5
                    ],
              key =
                _js2n__-prdslib.oneOf
                    [
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^(?!.*\\/)^(.*[^.]+.*)$"
                        ],
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              files =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        (_js2n__-prdslib.isType '"String"),
                                      _js2n__-prdslib.arrays.maxItems 2,
                                      _js2n__-prdslib.arrays.minItems 1
                                    ],
                              prefix = _js2n__-prdslib.isType '"String",
                            } {} true _js2n__-prdslib.always
                        ]
                    ],
              paths =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.isType '"String")
                    ],
              policy =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.strings.pattern
                        "pull-push|pull|push|\\$\\w{1,255}"
                    ],
              unprotect = _js2n__-prdslib.isType '"Bool",
              untracked = _js2n__-prdslib.isType '"Bool",
              when =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum
                        [ "on_success", "on_failure", "always" ]
                    ],
            } {} true _js2n__-prdslib.always,
      "_js2n__-:definitions/changes!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "paths" ],
                  _js2n__-prdslib.records.record
                    {
                      compare_to = _js2n__-prdslib.isType '"String",
                      paths =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.isType '"String")
                ]
            ],
      "_js2n__-:definitions/exists!predicate" =
        _js2n__-prdslib.anyOf
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
                  _js2n__-prdslib.records.required [ "paths" ],
                  _js2n__-prdslib.records.record
                    {
                      paths =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                      project = _js2n__-prdslib.isType '"String",
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "paths", "project" ],
                  _js2n__-prdslib.records.record
                    {
                      paths =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                      project = _js2n__-prdslib.isType '"String",
                      ref = _js2n__-prdslib.isType '"String",
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:definitions/filter!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.isType 'Null,
              _js2n__-refsenv."_js2n__-:definitions/filter_refs!predicate",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      changes =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                      kubernetes = _js2n__-prdslib.enum [ "active" ],
                      refs =
                        _js2n__-refsenv."_js2n__-:definitions/filter_refs!predicate",
                      variables =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:definitions/filter_refs!predicate"
        | doc "Filter job by different keywords that determine origin or state, or by supplying string/regex to check against branch/tag names."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.oneOf
                      [
                        _js2n__-prdslib.enum [ "branches" ],
                        _js2n__-prdslib.enum [ "tags" ],
                        _js2n__-prdslib.enum [ "api" ],
                        _js2n__-prdslib.enum [ "external" ],
                        _js2n__-prdslib.enum [ "pipelines" ],
                        _js2n__-prdslib.enum [ "pushes" ],
                        _js2n__-prdslib.enum [ "schedules" ],
                        _js2n__-prdslib.enum [ "triggers" ],
                        _js2n__-prdslib.enum [ "web" ]
                      ],
                    _js2n__-prdslib.isType '"String"
                  ])
            ],
      "_js2n__-:definitions/globalVariables!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  ".*" =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.isType '"Number",
                              _js2n__-prdslib.isType '"String"
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  description =
                                    _js2n__-prdslib.isType '"String",
                                  expand = _js2n__-prdslib.isType '"Bool",
                                  options =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.isType '"String"),
                                          _js2n__-prdslib.arrays.minItems 1,
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ],
                                  value = _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never
                            ]
                        ],
                } true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/hooks!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  pre_get_sources_script =
                    _js2n__-refsenv."_js2n__-:definitions/optional_script!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/id_tokens!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  ".*" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.required [ "aud" ],
                          _js2n__-prdslib.records.record
                            {
                              aud =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.isType '"String"),
                                          _js2n__-prdslib.arrays.minItems 1,
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ]
                                    ],
                            } {} false _js2n__-prdslib.never
                        ],
                } true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/identity!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "google_cloud" ]
            ],
      "_js2n__-:definitions/if!predicate" = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/image!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.minLength 1
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "name" ],
                  _js2n__-prdslib.records.record
                    {
                      docker =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  platform =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.strings.minLength 1
                                        ],
                                  user =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.strings.maxLength 255,
                                          _js2n__-prdslib.strings.minLength 1
                                        ],
                                } {} false _js2n__-prdslib.never
                            ],
                      entrypoint =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.minItems 1
                            ],
                      name =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.strings.minLength 1
                            ],
                      pull_policy =
                        _js2n__-prdslib.oneOf
                            [
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.enum
                                    [ "always", "never", "if-not-present" ]
                                ],
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    (_js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType '"String",
                                        _js2n__-prdslib.enum
                                          [
                                            "always",
                                            "never",
                                            "if-not-present"
                                          ]
                                      ]),
                                  _js2n__-prdslib.arrays.minItems 1,
                                  _js2n__-prdslib.arrays.uniqueItems
                                ]
                            ],
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:definitions/includeRules!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.record
                          {
                            changes =
                              _js2n__-refsenv."_js2n__-:definitions/changes!predicate",
                            exists =
                              _js2n__-refsenv."_js2n__-:definitions/exists!predicate",
                            "if" =
                              _js2n__-refsenv."_js2n__-:definitions/if!predicate",
                            when =
                              _js2n__-prdslib.oneOf
                                  [
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType '"String",
                                        _js2n__-prdslib.enum
                                          [ "never", "always" ]
                                      ],
                                    _js2n__-prdslib.isType 'Null
                                  ],
                          } {} false _js2n__-prdslib.never
                      ],
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.strings.minLength 1
                      ],
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"Array",
                        _js2n__-prdslib.arrays.arrayOf
                          (_js2n__-prdslib.isType '"String"),
                        _js2n__-prdslib.arrays.minItems 1
                      ]
                  ])
            ],
      "_js2n__-:definitions/include_item!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern
                    "^(https?://|/?.?-?(?!\\w+://)\\w).+\\.ya?ml$"
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "local" ],
                  _js2n__-prdslib.records.record
                    {
                      inputs =
                        _js2n__-refsenv."_js2n__-:definitions/inputs!predicate",
                      local =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.strings.pattern "\\.ya?ml$"
                            ],
                      rules =
                        _js2n__-refsenv."_js2n__-:definitions/includeRules!predicate",
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "file", "project" ],
                  _js2n__-prdslib.records.record
                    {
                      file =
                        _js2n__-prdslib.oneOf
                            [
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.strings.pattern "\\.ya?ml$"
                                ],
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    (_js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType '"String",
                                        _js2n__-prdslib.strings.pattern
                                          "\\.ya?ml$"
                                      ])
                                ]
                            ],
                      inputs =
                        _js2n__-refsenv."_js2n__-:definitions/inputs!predicate",
                      project =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.strings.pattern
                                "(?:\\S/\\S|\\$\\S+)"
                            ],
                      ref = _js2n__-prdslib.isType '"String",
                      rules =
                        _js2n__-refsenv."_js2n__-:definitions/includeRules!predicate",
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "template" ],
                  _js2n__-prdslib.records.record
                    {
                      inputs =
                        _js2n__-refsenv."_js2n__-:definitions/inputs!predicate",
                      rules =
                        _js2n__-refsenv."_js2n__-:definitions/includeRules!predicate",
                      template =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.strings.pattern "\\.ya?ml$"
                            ],
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "component" ],
                  _js2n__-prdslib.records.record
                    {
                      component = _js2n__-prdslib.isType '"String",
                      inputs =
                        _js2n__-refsenv."_js2n__-:definitions/inputs!predicate",
                      rules =
                        _js2n__-refsenv."_js2n__-:definitions/includeRules!predicate",
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "remote" ],
                  _js2n__-prdslib.records.record
                    {
                      inputs =
                        _js2n__-refsenv."_js2n__-:definitions/inputs!predicate",
                      remote =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.strings.pattern
                                "^https?://.+\\.ya?ml$"
                            ],
                      rules =
                        _js2n__-refsenv."_js2n__-:definitions/includeRules!predicate",
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:definitions/inputs!predicate" = _js2n__-prdslib.isType 'Record,
      "_js2n__-:definitions/interruptible!predicate" =
        _js2n__-prdslib.isType '"Bool",
      "_js2n__-:definitions/job!predicate" =
        _js2n__-refsenv."_js2n__-:definitions/job_template!predicate",
      "_js2n__-:definitions/jobVariables!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  ".*" =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.isType '"Number",
                              _js2n__-prdslib.isType '"String"
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  expand = _js2n__-prdslib.isType '"Bool",
                                  value = _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never
                            ]
                        ],
                } true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/job_template!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "start_in", "when" ],
                      _js2n__-prdslib.records.record
                        { when = _js2n__-prdslib.enum [ "delayed" ], } {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.records.record
                    {
                      when =
                        _js2n__-prdslib.not
                            (_js2n__-prdslib.enum [ "delayed" ]),
                    } {} true _js2n__-prdslib.always
                ],
              _js2n__-prdslib.records.record
                {
                  after_script =
                    _js2n__-refsenv."_js2n__-:definitions/after_script!predicate",
                  allow_failure =
                    _js2n__-refsenv."_js2n__-:definitions/allow_failure!predicate",
                  artifacts =
                    _js2n__-refsenv."_js2n__-:definitions/artifacts!predicate",
                  before_script =
                    _js2n__-refsenv."_js2n__-:definitions/before_script!predicate",
                  cache =
                    _js2n__-refsenv."_js2n__-:definitions/cache!predicate",
                  coverage =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern "^/.+/$"
                        ],
                  dependencies =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  environment =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.required [ "name" ],
                              _js2n__-prdslib.records.record
                                {
                                  action =
                                    _js2n__-prdslib.enum
                                        [
                                          "start",
                                          "prepare",
                                          "stop",
                                          "verify",
                                          "access"
                                        ],
                                  auto_stop_in =
                                    _js2n__-prdslib.isType '"String",
                                  deployment_tier =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.enum
                                            [
                                              "production",
                                              "staging",
                                              "testing",
                                              "development",
                                              "other"
                                            ]
                                        ],
                                  kubernetes =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.record
                                            {
                                              namespace =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"String",
                                                      _js2n__-prdslib.strings.minLength
                                                        1
                                                    ],
                                            } {} true _js2n__-prdslib.always
                                        ],
                                  name =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.strings.minLength 1
                                        ],
                                  on_stop = _js2n__-prdslib.isType '"String",
                                  url =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.strings.pattern
                                            "^(https?://.+|\\$[A-Za-z]+)"
                                        ],
                                } {} false _js2n__-prdslib.never
                            ]
                        ],
                  except =
                    _js2n__-refsenv."_js2n__-:definitions/filter!predicate",
                  extends =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String"),
                              _js2n__-prdslib.arrays.minItems 1
                            ]
                        ],
                  hooks =
                    _js2n__-refsenv."_js2n__-:definitions/hooks!predicate",
                  id_tokens =
                    _js2n__-refsenv."_js2n__-:definitions/id_tokens!predicate",
                  identity =
                    _js2n__-refsenv."_js2n__-:definitions/identity!predicate",
                  image =
                    _js2n__-refsenv."_js2n__-:definitions/image!predicate",
                  inherit =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              "default" =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-prdslib.isType '"Bool",
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
                                                    "after_script",
                                                    "artifacts",
                                                    "before_script",
                                                    "cache",
                                                    "image",
                                                    "interruptible",
                                                    "retry",
                                                    "services",
                                                    "tags",
                                                    "timeout"
                                                  ]
                                              ])
                                        ]
                                    ],
                              variables =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-prdslib.isType '"Bool",
                                      _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.isType '"String")
                                        ]
                                    ],
                            } {} false _js2n__-prdslib.never
                        ],
                  interruptible =
                    _js2n__-refsenv."_js2n__-:definitions/interruptible!predicate",
                  manual_confirmation = _js2n__-prdslib.isType '"String",
                  needs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.required [ "job" ],
                                    _js2n__-prdslib.records.record
                                      {
                                        artifacts =
                                          _js2n__-prdslib.isType '"Bool",
                                        job = _js2n__-prdslib.isType '"String",
                                        "optional" =
                                          _js2n__-prdslib.isType '"Bool",
                                        parallel =
                                          _js2n__-refsenv."_js2n__-:definitions/parallel_matrix!predicate",
                                      } {} false _js2n__-prdslib.never
                                  ],
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.required
                                      [ "job", "pipeline" ],
                                    _js2n__-prdslib.records.record
                                      {
                                        artifacts =
                                          _js2n__-prdslib.isType '"Bool",
                                        job = _js2n__-prdslib.isType '"String",
                                        parallel =
                                          _js2n__-refsenv."_js2n__-:definitions/parallel_matrix!predicate",
                                        pipeline =
                                          _js2n__-prdslib.isType '"String",
                                      } {} false _js2n__-prdslib.never
                                  ],
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.required
                                      [ "job", "project", "ref" ],
                                    _js2n__-prdslib.records.record
                                      {
                                        artifacts =
                                          _js2n__-prdslib.isType '"Bool",
                                        job = _js2n__-prdslib.isType '"String",
                                        parallel =
                                          _js2n__-refsenv."_js2n__-:definitions/parallel_matrix!predicate",
                                        project =
                                          _js2n__-prdslib.isType '"String",
                                        ref = _js2n__-prdslib.isType '"String",
                                      } {} false _js2n__-prdslib.never
                                  ],
                                _js2n__-refsenv."_js2n__-:definitions/!reference!predicate"
                              ])
                        ],
                  only =
                    _js2n__-refsenv."_js2n__-:definitions/filter!predicate",
                  pages =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            { path_prefix = _js2n__-prdslib.isType '"String", }
                            {} false _js2n__-prdslib.never
                        ],
                  parallel =
                    _js2n__-refsenv."_js2n__-:definitions/parallel!predicate",
                  publish = _js2n__-prdslib.isType '"String",
                  release =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.required
                            [ "description", "tag_name" ],
                          _js2n__-prdslib.records.record
                            {
                              assets =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.required
                                        [ "links" ],
                                      _js2n__-prdslib.records.record
                                        {
                                          links =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"Array",
                                                  _js2n__-prdslib.arrays.arrayOf
                                                    (_js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          'Record,
                                                        _js2n__-prdslib.records.required
                                                          [ "name", "url" ],
                                                        _js2n__-prdslib.records.record
                                                          {
                                                            filepath =
                                                              _js2n__-prdslib.isType
                                                                  '"String",
                                                            link_type =
                                                              _js2n__-prdslib.allOf
                                                                  [
                                                                    _js2n__-prdslib.isType
                                                                      '"String",
                                                                    _js2n__-prdslib.enum
                                                                      [
                                                                        "runbook",
                                                                        "package",
                                                                        "image",
                                                                        "other"
                                                                      ]
                                                                  ],
                                                            name =
                                                              _js2n__-prdslib.allOf
                                                                  [
                                                                    _js2n__-prdslib.isType
                                                                      '"String",
                                                                    _js2n__-prdslib.strings.minLength
                                                                      1
                                                                  ],
                                                            url =
                                                              _js2n__-prdslib.allOf
                                                                  [
                                                                    _js2n__-prdslib.isType
                                                                      '"String",
                                                                    _js2n__-prdslib.strings.minLength
                                                                      1
                                                                  ],
                                                          } {} false
                                                          _js2n__-prdslib.never
                                                      ]),
                                                  _js2n__-prdslib.arrays.minItems
                                                    1
                                                ],
                                        } {} false _js2n__-prdslib.never
                                    ],
                              description =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.strings.minLength 1
                                    ],
                              milestones =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        (_js2n__-prdslib.isType '"String")
                                    ],
                              name = _js2n__-prdslib.isType '"String",
                              ref = _js2n__-prdslib.isType '"String",
                              released_at =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.strings.pattern
                                        "^(?:[1-9]\\d{3}-(?:(?:0[1-9]|1[0-2])-(?:0[1-9]|1\\d|2[0-8])|(?:0[13-9]|1[0-2])-(?:29|30)|(?:0[13578]|1[02])-31)|(?:[1-9]\\d(?:0[48]|[2468][048]|[13579][26])|(?:[2468][048]|[13579][26])00)-02-29)T(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d(?:Z|[+-][01]\\d:[0-5]\\d)$"
                                    ],
                              tag_message = _js2n__-prdslib.isType '"String",
                              tag_name =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.strings.minLength 1
                                    ],
                            } {} false _js2n__-prdslib.never
                        ],
                  resource_group = _js2n__-prdslib.isType '"String",
                  retry =
                    _js2n__-refsenv."_js2n__-:definitions/retry!predicate",
                  rules =
                    _js2n__-refsenv."_js2n__-:definitions/rules!predicate",
                  run = _js2n__-refsenv."_js2n__-:definitions/steps!predicate",
                  script =
                    _js2n__-refsenv."_js2n__-:definitions/script!predicate",
                  secrets =
                    _js2n__-refsenv."_js2n__-:definitions/secrets!predicate",
                  services =
                    _js2n__-refsenv."_js2n__-:definitions/services!predicate",
                  stage =
                    _js2n__-prdslib.anyOf
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
                                (_js2n__-prdslib.isType '"String"),
                              _js2n__-prdslib.arrays.minItems 1
                            ]
                        ],
                  start_in =
                    _js2n__-refsenv."_js2n__-:definitions/start_in!predicate",
                  tags = _js2n__-refsenv."_js2n__-:definitions/tags!predicate",
                  timeout =
                    _js2n__-refsenv."_js2n__-:definitions/timeout!predicate",
                  trigger =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.required [ "project" ],
                              _js2n__-prdslib.records.record
                                {
                                  branch = _js2n__-prdslib.isType '"String",
                                  forward =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.record
                                            {
                                              pipeline_variables =
                                                _js2n__-prdslib.isType '"Bool",
                                              yaml_variables =
                                                _js2n__-prdslib.isType '"Bool",
                                            } {} false _js2n__-prdslib.never
                                        ],
                                  project =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.strings.pattern
                                            "(?:\\S/\\S|\\$\\S+)"
                                        ],
                                  strategy =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.enum [ "depend" ]
                                        ],
                                } {} false _js2n__-prdslib.never,
                              _js2n__-prdslib.records.dependencies
                                { branch = [ "project" ], }
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  forward =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.record
                                            {
                                              pipeline_variables =
                                                _js2n__-prdslib.isType '"Bool",
                                              yaml_variables =
                                                _js2n__-prdslib.isType '"Bool",
                                            } {} false _js2n__-prdslib.never
                                        ],
                                  include =
                                    _js2n__-prdslib.oneOf
                                        [
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-prdslib.strings.pattern
                                                "\\.ya?ml$"
                                            ],
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.oneOf
                                                  [
                                                    _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          'Record,
                                                        _js2n__-prdslib.records.record
                                                          {
                                                            local =
                                                              _js2n__-prdslib.allOf
                                                                  [
                                                                    _js2n__-prdslib.isType
                                                                      '"String",
                                                                    _js2n__-prdslib.strings.pattern
                                                                      "\\.ya?ml$"
                                                                  ],
                                                          } {} false
                                                          _js2n__-prdslib.never
                                                      ],
                                                    _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          'Record,
                                                        _js2n__-prdslib.records.record
                                                          {
                                                            template =
                                                              _js2n__-prdslib.allOf
                                                                  [
                                                                    _js2n__-prdslib.isType
                                                                      '"String",
                                                                    _js2n__-prdslib.strings.pattern
                                                                      "\\.ya?ml$"
                                                                  ],
                                                          } {} false
                                                          _js2n__-prdslib.never
                                                      ],
                                                    _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          'Record,
                                                        _js2n__-prdslib.records.required
                                                          [ "artifact", "job" ],
                                                        _js2n__-prdslib.records.record
                                                          {
                                                            artifact =
                                                              _js2n__-prdslib.allOf
                                                                  [
                                                                    _js2n__-prdslib.isType
                                                                      '"String",
                                                                    _js2n__-prdslib.strings.pattern
                                                                      "\\.ya?ml$"
                                                                  ],
                                                            job =
                                                              _js2n__-prdslib.isType
                                                                  '"String",
                                                          } {} false
                                                          _js2n__-prdslib.never
                                                      ],
                                                    _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          'Record,
                                                        _js2n__-prdslib.records.required
                                                          [ "file", "project" ],
                                                        _js2n__-prdslib.records.record
                                                          {
                                                            file =
                                                              _js2n__-prdslib.allOf
                                                                  [
                                                                    _js2n__-prdslib.isType
                                                                      '"String",
                                                                    _js2n__-prdslib.strings.pattern
                                                                      "\\.ya?ml$"
                                                                  ],
                                                            project =
                                                              _js2n__-prdslib.allOf
                                                                  [
                                                                    _js2n__-prdslib.isType
                                                                      '"String",
                                                                    _js2n__-prdslib.strings.pattern
                                                                      "(?:\\S/\\S|\\$\\S+)"
                                                                  ],
                                                            ref =
                                                              _js2n__-prdslib.allOf
                                                                  [
                                                                    _js2n__-prdslib.isType
                                                                      '"String",
                                                                    _js2n__-prdslib.strings.minLength
                                                                      1
                                                                  ],
                                                          } {} false
                                                          _js2n__-prdslib.never
                                                      ]
                                                  ]),
                                              _js2n__-prdslib.arrays.maxItems 3
                                            ]
                                        ],
                                  strategy =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.enum [ "depend" ]
                                        ],
                                } {} false _js2n__-prdslib.never
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.strings.pattern
                                "(?:\\S/\\S|\\$\\S+)"
                            ]
                        ],
                  variables =
                    _js2n__-refsenv."_js2n__-:definitions/jobVariables!predicate",
                  when = _js2n__-refsenv."_js2n__-:definitions/when!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/optional_script!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType '"Array",
                            _js2n__-prdslib.arrays.arrayOf
                              (_js2n__-prdslib.isType '"String")
                          ]
                      ])
                ]
            ],
      "_js2n__-:definitions/parallel!predicate"
        | doc "Splits up a single job into multiple that run in parallel. Provides `CI_NODE_INDEX` and `CI_NODE_TOTAL` environment variables to the jobs."
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Integer,
                  _js2n__-prdslib.numbers.maximum 200,
                  _js2n__-prdslib.numbers.minimum 1
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "matrix" ],
                  _js2n__-prdslib.records.record
                    {
                      matrix =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.record {} {} true
                                      (_js2n__-prdslib.anyOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.isType '"Number",
                                          _js2n__-prdslib.isType '"Array"
                                        ])
                                  ]),
                              _js2n__-prdslib.arrays.maxItems 200
                            ],
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:definitions/parallel_matrix!predicate"
        | doc "Use the `needs:parallel:matrix` keyword to specify parallelized jobs needed to be completed for the job to run. [Learn More](https://docs.gitlab.com/ee/ci/yaml/#needsparallelmatrix)"
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "matrix" ],
                  _js2n__-prdslib.records.record
                    {
                      matrix =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.record {} {} true
                                      (_js2n__-prdslib.anyOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.isType '"Number",
                                          _js2n__-prdslib.isType '"Array"
                                        ])
                                  ]),
                              _js2n__-prdslib.arrays.maxItems 200
                            ],
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:definitions/retry!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-refsenv."_js2n__-:definitions/retry_max!predicate",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      exit_codes =
                        _js2n__-prdslib.oneOf
                            [
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    (_js2n__-prdslib.isType 'Integer),
                                  _js2n__-prdslib.arrays.minItems 1,
                                  _js2n__-prdslib.arrays.uniqueItems
                                ],
                              _js2n__-prdslib.isType 'Integer
                            ],
                      max =
                        _js2n__-refsenv."_js2n__-:definitions/retry_max!predicate",
                      when =
                        _js2n__-prdslib.oneOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/retry_errors!predicate",
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    _js2n__-refsenv."_js2n__-:definitions/retry_errors!predicate"
                                ]
                            ],
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:definitions/retry_errors!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.const "always",
              _js2n__-prdslib.const "unknown_failure",
              _js2n__-prdslib.const "script_failure",
              _js2n__-prdslib.const "api_failure",
              _js2n__-prdslib.const "stuck_or_timeout_failure",
              _js2n__-prdslib.const "runner_system_failure",
              _js2n__-prdslib.const "runner_unsupported",
              _js2n__-prdslib.const "stale_schedule",
              _js2n__-prdslib.const "job_execution_timeout",
              _js2n__-prdslib.const "archived_failure",
              _js2n__-prdslib.const "unmet_prerequisites",
              _js2n__-prdslib.const "scheduler_failure",
              _js2n__-prdslib.const "data_integrity_failure"
            ],
      "_js2n__-:definitions/retry_max!predicate"
        | doc "The number of times the job will be retried if it fails. Defaults to 0 and can max be retried 2 times (3 times total)."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Integer,
              _js2n__-prdslib.numbers.maximum 2,
              _js2n__-prdslib.numbers.minimum 0
            ],
      "_js2n__-:definitions/rules!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.record
                          {
                            allow_failure =
                              _js2n__-refsenv."_js2n__-:definitions/allow_failure!predicate",
                            changes =
                              _js2n__-refsenv."_js2n__-:definitions/changes!predicate",
                            exists =
                              _js2n__-refsenv."_js2n__-:definitions/exists!predicate",
                            "if" =
                              _js2n__-refsenv."_js2n__-:definitions/if!predicate",
                            interruptible =
                              _js2n__-refsenv."_js2n__-:definitions/interruptible!predicate",
                            needs =
                              _js2n__-refsenv."_js2n__-:definitions/rulesNeeds!predicate",
                            start_in =
                              _js2n__-refsenv."_js2n__-:definitions/start_in!predicate",
                            variables =
                              _js2n__-refsenv."_js2n__-:definitions/rulesVariables!predicate",
                            when =
                              _js2n__-refsenv."_js2n__-:definitions/when!predicate",
                          } {} false _js2n__-prdslib.never
                      ],
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.strings.minLength 1
                      ],
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"Array",
                        _js2n__-prdslib.arrays.arrayOf
                          (_js2n__-prdslib.isType '"String"),
                        _js2n__-prdslib.arrays.minItems 1
                      ]
                  ])
            ],
      "_js2n__-:definitions/rulesNeeds!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.oneOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.required [ "job" ],
                        _js2n__-prdslib.records.record
                          {
                            artifacts = _js2n__-prdslib.isType '"Bool",
                            job =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.strings.minLength 1
                                  ],
                            "optional" = _js2n__-prdslib.isType '"Bool",
                          } {} false _js2n__-prdslib.never
                      ]
                  ])
            ],
      "_js2n__-:definitions/rulesVariables!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  ".*" =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.isType '"String"
                        ],
                } true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/script!predicate" =
        _js2n__-prdslib.oneOf
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
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType '"Array",
                            _js2n__-prdslib.arrays.arrayOf
                              (_js2n__-prdslib.isType '"String")
                          ]
                      ]),
                  _js2n__-prdslib.arrays.minItems 1
                ]
            ],
      "_js2n__-:definitions/secrets!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  ".*" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required [ "vault" ],
                                  _js2n__-prdslib.records.record {} {} true
                                    _js2n__-prdslib.always
                                ],
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "azure_key_vault" ],
                                  _js2n__-prdslib.records.record {} {} true
                                    _js2n__-prdslib.always
                                ],
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "gcp_secret_manager" ],
                                  _js2n__-prdslib.records.record {} {} true
                                    _js2n__-prdslib.always
                                ],
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "akeyless" ],
                                  _js2n__-prdslib.records.record {} {} true
                                    _js2n__-prdslib.always
                                ]
                            ],
                          _js2n__-prdslib.records.record
                            {
                              akeyless =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          name =
                                            _js2n__-prdslib.isType '"String",
                                        } {} false _js2n__-prdslib.never
                                    ],
                              azure_key_vault =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.required
                                        [ "name" ],
                                      _js2n__-prdslib.records.record
                                        {
                                          name =
                                            _js2n__-prdslib.isType '"String",
                                          version =
                                            _js2n__-prdslib.isType '"String",
                                        } {} false _js2n__-prdslib.never
                                    ],
                              file = _js2n__-prdslib.isType '"Bool",
                              gcp_secret_manager =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.required
                                        [ "name" ],
                                      _js2n__-prdslib.records.record
                                        {
                                          name =
                                            _js2n__-prdslib.isType '"String",
                                          version =
                                            _js2n__-prdslib.oneOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.isType
                                                    'Integer
                                                ],
                                        } {} false _js2n__-prdslib.never
                                    ],
                              token = _js2n__-prdslib.isType '"String",
                              vault =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.required
                                            [ "engine", "field", "path" ],
                                          _js2n__-prdslib.records.record
                                            {
                                              engine =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        'Record,
                                                      _js2n__-prdslib.records.required
                                                        [ "name", "path" ],
                                                      _js2n__-prdslib.records.record
                                                        {
                                                          name =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                          path =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                        } {} true
                                                        _js2n__-prdslib.always
                                                    ],
                                              field =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              path =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                            } {} false _js2n__-prdslib.never
                                        ]
                                    ],
                            } {} false _js2n__-prdslib.never,
                          _js2n__-prdslib.records.dependencies
                            { gcp_secret_manager = [ "token" ], }
                        ],
                } true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/services!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.oneOf
                  [
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.strings.minLength 1
                      ],
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.required [ "name" ],
                        _js2n__-prdslib.records.record
                          {
                            alias =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.strings.minLength 1
                                  ],
                            command =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"Array",
                                    _js2n__-prdslib.arrays.arrayOf
                                      (_js2n__-prdslib.isType '"String"),
                                    _js2n__-prdslib.arrays.minItems 1
                                  ],
                            docker =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.record
                                      {
                                        platform =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.strings.minLength
                                                  1
                                              ],
                                        user =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.strings.maxLength
                                                  255,
                                                _js2n__-prdslib.strings.minLength
                                                  1
                                              ],
                                      } {} false _js2n__-prdslib.never
                                  ],
                            entrypoint =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"Array",
                                    _js2n__-prdslib.arrays.arrayOf
                                      (_js2n__-prdslib.isType '"String"),
                                    _js2n__-prdslib.arrays.minItems 1
                                  ],
                            name =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.strings.minLength 1
                                  ],
                            pull_policy =
                              _js2n__-prdslib.oneOf
                                  [
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType '"String",
                                        _js2n__-prdslib.enum
                                          [
                                            "always",
                                            "never",
                                            "if-not-present"
                                          ]
                                      ],
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType '"Array",
                                        _js2n__-prdslib.arrays.arrayOf
                                          (_js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-prdslib.enum
                                                [
                                                  "always",
                                                  "never",
                                                  "if-not-present"
                                                ]
                                            ]),
                                        _js2n__-prdslib.arrays.minItems 1,
                                        _js2n__-prdslib.arrays.uniqueItems
                                      ]
                                  ],
                            variables =
                              _js2n__-refsenv."_js2n__-:definitions/jobVariables!predicate",
                          } {} false _js2n__-prdslib.never
                      ]
                  ])
            ],
      "_js2n__-:definitions/start_in!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.minLength 1
            ],
      "_js2n__-:definitions/steps!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.oneOf
                      [
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "step" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "script" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ]
                      ],
                    _js2n__-prdslib.records.required [ "name" ],
                    _js2n__-prdslib.records.record
                      {
                        env =
                          _js2n__-refsenv."_js2n__-:definitions/globalVariables!predicate",
                        inputs =
                          _js2n__-refsenv."_js2n__-:definitions/inputs!predicate",
                        name = _js2n__-prdslib.isType '"String",
                        script = _js2n__-prdslib.isType '"String",
                        step = _js2n__-prdslib.isType '"String",
                      } {} false _js2n__-prdslib.never
                  ])
            ],
      "_js2n__-:definitions/string_file_list!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.isType '"String")
                ]
            ],
      "_js2n__-:definitions/tags!predicate" =
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
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"Array",
                        _js2n__-prdslib.arrays.arrayOf
                          (_js2n__-prdslib.isType '"String"),
                        _js2n__-prdslib.arrays.minItems 1
                      ]
                  ]),
              _js2n__-prdslib.arrays.minItems 1
            ],
      "_js2n__-:definitions/timeout!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.minLength 1
            ],
      "_js2n__-:definitions/when!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "on_success",
                  "on_failure",
                  "always",
                  "never",
                  "manual",
                  "delayed"
                ]
            ],
      "_js2n__-:definitions/workflowAutoCancel!predicate"
        | doc "Define the rules for when pipeline should be automatically cancelled."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  on_job_failure =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "none", "all" ]
                        ],
                  on_new_commit =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "conservative", "interruptible", "none" ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/workflowName!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.maxLength 255,
              _js2n__-prdslib.strings.minLength 1
            ],
    }
    in
  _js2n__-prdslib.contract_from_predicate
      (_js2n__-prdslib.allOf
        [
          _js2n__-prdslib.isType 'Record,
          _js2n__-prdslib.records.record
            {
              "!reference" =
                _js2n__-refsenv."_js2n__-:definitions/!reference!predicate",
              "$schema" = _js2n__-prdslib.isType '"String",
              after_script =
                _js2n__-refsenv."_js2n__-:definitions/after_script!predicate",
              before_script =
                _js2n__-refsenv."_js2n__-:definitions/before_script!predicate",
              cache = _js2n__-refsenv."_js2n__-:definitions/cache!predicate",
              "default" =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          "!reference" =
                            _js2n__-refsenv."_js2n__-:definitions/!reference!predicate",
                          after_script =
                            _js2n__-refsenv."_js2n__-:definitions/after_script!predicate",
                          artifacts =
                            _js2n__-refsenv."_js2n__-:definitions/artifacts!predicate",
                          before_script =
                            _js2n__-refsenv."_js2n__-:definitions/before_script!predicate",
                          cache =
                            _js2n__-refsenv."_js2n__-:definitions/cache!predicate",
                          hooks =
                            _js2n__-refsenv."_js2n__-:definitions/hooks!predicate",
                          id_tokens =
                            _js2n__-refsenv."_js2n__-:definitions/id_tokens!predicate",
                          identity =
                            _js2n__-refsenv."_js2n__-:definitions/identity!predicate",
                          image =
                            _js2n__-refsenv."_js2n__-:definitions/image!predicate",
                          interruptible =
                            _js2n__-refsenv."_js2n__-:definitions/interruptible!predicate",
                          retry =
                            _js2n__-refsenv."_js2n__-:definitions/retry!predicate",
                          services =
                            _js2n__-refsenv."_js2n__-:definitions/services!predicate",
                          tags =
                            _js2n__-refsenv."_js2n__-:definitions/tags!predicate",
                          timeout =
                            _js2n__-refsenv."_js2n__-:definitions/timeout!predicate",
                        } {} false _js2n__-prdslib.never
                    ],
              image = _js2n__-refsenv."_js2n__-:definitions/image!predicate",
              include =
                _js2n__-prdslib.oneOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/include_item!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/include_item!predicate"
                        ]
                    ],
              pages = _js2n__-refsenv."_js2n__-:definitions/job!predicate",
              services =
                _js2n__-refsenv."_js2n__-:definitions/services!predicate",
              stages =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.isType '"String",
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.isType '"String")
                              ]
                          ]),
                      _js2n__-prdslib.arrays.minItems 1,
                      _js2n__-prdslib.arrays.uniqueItems
                    ],
              variables =
                _js2n__-refsenv."_js2n__-:definitions/globalVariables!predicate",
              workflow =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          auto_cancel =
                            _js2n__-refsenv."_js2n__-:definitions/workflowAutoCancel!predicate",
                          name =
                            _js2n__-refsenv."_js2n__-:definitions/workflowName!predicate",
                          rules =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    (_js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.anyOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType '"Array",
                                                _js2n__-prdslib.arrays.arrayOf
                                                  (_js2n__-prdslib.isType
                                                    '"String"),
                                                _js2n__-prdslib.arrays.minItems
                                                  1
                                              ]
                                          ],
                                        _js2n__-prdslib.records.record
                                          {
                                            auto_cancel =
                                              _js2n__-refsenv."_js2n__-:definitions/workflowAutoCancel!predicate",
                                            changes =
                                              _js2n__-refsenv."_js2n__-:definitions/changes!predicate",
                                            exists =
                                              _js2n__-refsenv."_js2n__-:definitions/exists!predicate",
                                            "if" =
                                              _js2n__-refsenv."_js2n__-:definitions/if!predicate",
                                            variables =
                                              _js2n__-refsenv."_js2n__-:definitions/rulesVariables!predicate",
                                            when =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"String",
                                                    _js2n__-prdslib.enum
                                                      [ "always", "never" ]
                                                  ],
                                          } {} false _js2n__-prdslib.never
                                      ])
                                ],
                        } {} true _js2n__-prdslib.always
                    ],
            }
            {
              "^[.]" =
                _js2n__-prdslib.anyOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/job_template!predicate",
                      _js2n__-prdslib.always
                    ],
            } true _js2n__-refsenv."_js2n__-:definitions/job!predicate"
        ])