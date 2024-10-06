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
      "_js2n__-:properties/bpf!predicate"
        | doc "load and pin eBPF programs (i.e. for XDP)"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  "" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.required
                            [ "object", "section" ],
                          _js2n__-prdslib.records.record
                            {
                              object = _js2n__-prdslib.isType '"String",
                              section = _js2n__-prdslib.isType '"String",
                            } {} false _js2n__-prdslib.never
                        ],
                } true _js2n__-prdslib.always
            ],
      "_js2n__-:properties/interfaces!predicate"
        | doc "list of interface settings (link settings and ip addresses)"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.required [ "link", "name" ],
                    _js2n__-prdslib.records.record
                      {
                        addresses =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.isType '"String")
                              ],
                        brport =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record
                                  {
                                    backup_port = _js2n__-prdslib.always,
                                    bcast_flood =
                                      _js2n__-prdslib.isType '"Bool",
                                    cost =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.numbers.maximum
                                              65535,
                                            _js2n__-prdslib.numbers.minimum 1
                                          ],
                                    fast_leave = _js2n__-prdslib.isType '"Bool",
                                    guard = _js2n__-prdslib.isType '"Bool",
                                    isolated = _js2n__-prdslib.isType '"Bool",
                                    learning = _js2n__-prdslib.isType '"Bool",
                                    mcast_flood =
                                      _js2n__-prdslib.isType '"Bool",
                                    mcast_to_ucast =
                                      _js2n__-prdslib.isType '"Bool",
                                    mode = _js2n__-prdslib.isType '"Bool",
                                    neigh_suppress =
                                      _js2n__-prdslib.isType '"Bool",
                                    "priority" =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Integer,
                                            _js2n__-prdslib.numbers.maximum 63,
                                            _js2n__-prdslib.numbers.minimum 0
                                          ],
                                    protect = _js2n__-prdslib.isType '"Bool",
                                    proxyarp = _js2n__-prdslib.isType '"Bool",
                                    proxyarp_wifi =
                                      _js2n__-prdslib.isType '"Bool",
                                    unicast_flood =
                                      _js2n__-prdslib.isType '"Bool",
                                    vlan_tunnel =
                                      _js2n__-prdslib.isType '"Bool",
                                  } {} false _js2n__-prdslib.never
                              ],
                        cshaper =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record
                                  {
                                    egress = _js2n__-prdslib.isType '"String",
                                    ingress = _js2n__-prdslib.isType '"String",
                                    profile = _js2n__-prdslib.isType '"String",
                                  } {} false _js2n__-prdslib.never
                              ],
                        ethtool = _js2n__-prdslib.always,
                        fdb =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.required
                                        [ "lladdr" ],
                                      _js2n__-prdslib.records.record
                                        {
                                          dst =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.oneOf
                                                    [
                                                      _js2n__-prdslib.always,
                                                      _js2n__-prdslib.always
                                                    ]
                                                ],
                                          flags =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"Array",
                                                  _js2n__-prdslib.arrays.items
                                                    [
                                                      _js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            '"String",
                                                          _js2n__-prdslib.enum
                                                            [
                                                              "self",
                                                              "master",
                                                              "router",
                                                              "use",
                                                              "sticky"
                                                            ]
                                                        ]
                                                    ]
                                                ],
                                          lladdr = _js2n__-prdslib.always,
                                          nhid =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Integer,
                                                  _js2n__-prdslib.numbers.minimum
                                                    1
                                                ],
                                          port =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Integer,
                                                  _js2n__-prdslib.numbers.maximum
                                                    65535,
                                                  _js2n__-prdslib.numbers.minimum
                                                    0
                                                ],
                                          state =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"Array",
                                                  _js2n__-prdslib.arrays.items
                                                    [
                                                      _js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            '"String",
                                                          _js2n__-prdslib.enum
                                                            [
                                                              "permanent",
                                                              "noarp"
                                                            ]
                                                        ]
                                                    ]
                                                ],
                                          vni =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Integer,
                                                  _js2n__-prdslib.numbers.maximum
                                                    16777215,
                                                  _js2n__-prdslib.numbers.minimum
                                                    0
                                                ],
                                        } {} false _js2n__-prdslib.never
                                    ])
                              ],
                        link =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.oneOf
                                  [
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.records.required
                                          [ "kind" ],
                                        _js2n__-prdslib.records.record
                                          {
                                            address = _js2n__-prdslib.always,
                                            group = _js2n__-prdslib.always,
                                            ifalias = _js2n__-prdslib.always,
                                            kind = _js2n__-prdslib.const "ifb",
                                            master = _js2n__-prdslib.always,
                                            mtu = _js2n__-prdslib.always,
                                            state = _js2n__-prdslib.always,
                                            txqlen = _js2n__-prdslib.always,
                                          } {} false _js2n__-prdslib.never
                                      ],
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.records.required
                                          [ "kind" ],
                                        _js2n__-prdslib.records.record
                                          {
                                            address = _js2n__-prdslib.always,
                                            bind_netns = _js2n__-prdslib.always,
                                            group = _js2n__-prdslib.always,
                                            ifalias = _js2n__-prdslib.always,
                                            kind =
                                              _js2n__-prdslib.const "ip6tnl",
                                            master = _js2n__-prdslib.always,
                                            mtu = _js2n__-prdslib.always,
                                            state = _js2n__-prdslib.always,
                                            txqlen = _js2n__-prdslib.always,
                                          } {} true _js2n__-prdslib.always
                                      ],
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.records.required
                                          [ "kind" ],
                                        _js2n__-prdslib.records.record
                                          {
                                            address = _js2n__-prdslib.always,
                                            group = _js2n__-prdslib.always,
                                            ifalias = _js2n__-prdslib.always,
                                            kind =
                                              _js2n__-prdslib.const "ipoib",
                                            master = _js2n__-prdslib.always,
                                            mtu = _js2n__-prdslib.always,
                                            state = _js2n__-prdslib.always,
                                            txqlen = _js2n__-prdslib.always,
                                          } {} true _js2n__-prdslib.always
                                      ],
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.records.required
                                          [ "kind" ],
                                        _js2n__-prdslib.records.record
                                          {
                                            address = _js2n__-prdslib.always,
                                            group = _js2n__-prdslib.always,
                                            ifalias = _js2n__-prdslib.always,
                                            kind =
                                              _js2n__-prdslib.const "ipvlan",
                                            master = _js2n__-prdslib.always,
                                            mtu = _js2n__-prdslib.always,
                                            state = _js2n__-prdslib.always,
                                            txqlen = _js2n__-prdslib.always,
                                          } {} true _js2n__-prdslib.always
                                      ],
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.records.required
                                          [ "kind" ],
                                        _js2n__-prdslib.records.record
                                          {
                                            address = _js2n__-prdslib.always,
                                            group = _js2n__-prdslib.always,
                                            ifalias = _js2n__-prdslib.always,
                                            kind =
                                              _js2n__-prdslib.const "macvlan",
                                            master = _js2n__-prdslib.always,
                                            mtu = _js2n__-prdslib.always,
                                            state = _js2n__-prdslib.always,
                                            txqlen = _js2n__-prdslib.always,
                                          } {} true _js2n__-prdslib.always
                                      ],
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.records.required
                                          [ "kind" ],
                                        _js2n__-prdslib.records.record
                                          {
                                            address = _js2n__-prdslib.always,
                                            group = _js2n__-prdslib.always,
                                            ifalias = _js2n__-prdslib.always,
                                            kind =
                                              _js2n__-prdslib.const "macvtap",
                                            master = _js2n__-prdslib.always,
                                            mtu = _js2n__-prdslib.always,
                                            state = _js2n__-prdslib.always,
                                            txqlen = _js2n__-prdslib.always,
                                          } {} true _js2n__-prdslib.always
                                      ],
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.records.required
                                          [ "kind" ],
                                        _js2n__-prdslib.records.record
                                          {
                                            address = _js2n__-prdslib.always,
                                            group = _js2n__-prdslib.always,
                                            ifalias = _js2n__-prdslib.always,
                                            kind = _js2n__-prdslib.const "team",
                                            master = _js2n__-prdslib.always,
                                            mtu = _js2n__-prdslib.always,
                                            state = _js2n__-prdslib.always,
                                            txqlen = _js2n__-prdslib.always,
                                          } {} true _js2n__-prdslib.always
                                      ],
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.records.required
                                          [ "kind", "tun_type" ],
                                        _js2n__-prdslib.records.record
                                          {
                                            address = _js2n__-prdslib.always,
                                            bind_netns = _js2n__-prdslib.always,
                                            group = _js2n__-prdslib.always,
                                            ifalias = _js2n__-prdslib.always,
                                            kind = _js2n__-prdslib.const "tun",
                                            master = _js2n__-prdslib.always,
                                            mtu = _js2n__-prdslib.always,
                                            state = _js2n__-prdslib.always,
                                            tun_group =
                                              _js2n__-prdslib.anyOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      'Integer,
                                                    _js2n__-prdslib.isType
                                                      '"String"
                                                  ],
                                            tun_multi_queue =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.anyOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"Bool",
                                                        _js2n__-prdslib.isType
                                                          'Integer
                                                      ],
                                                    _js2n__-prdslib.enum
                                                      [ 0, false, 1, true ]
                                                  ],
                                            tun_owner =
                                              _js2n__-prdslib.anyOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      'Integer,
                                                    _js2n__-prdslib.isType
                                                      '"String"
                                                  ],
                                            tun_persist =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.anyOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"Bool",
                                                        _js2n__-prdslib.isType
                                                          'Integer
                                                      ],
                                                    _js2n__-prdslib.enum
                                                      [ 0, false, 1, true ]
                                                  ],
                                            tun_pi =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.anyOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"Bool",
                                                        _js2n__-prdslib.isType
                                                          'Integer
                                                      ],
                                                    _js2n__-prdslib.enum
                                                      [ 0, false, 1, true ]
                                                  ],
                                            tun_type =
                                              _js2n__-prdslib.enum
                                                  [ 1, "tun", 2, "tap" ],
                                            tun_vnet_hdr =
                                              _js2n__-prdslib.enum
                                                  [ 0, false, 1, true ],
                                            txqlen = _js2n__-prdslib.always,
                                          } {} false _js2n__-prdslib.never
                                      ],
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.records.required
                                          [ "kind" ],
                                        _js2n__-prdslib.records.record
                                          {
                                            address = _js2n__-prdslib.always,
                                            group = _js2n__-prdslib.always,
                                            ifalias = _js2n__-prdslib.always,
                                            kind = _js2n__-prdslib.const "vrf",
                                            master = _js2n__-prdslib.always,
                                            mtu = _js2n__-prdslib.always,
                                            state = _js2n__-prdslib.always,
                                            txqlen = _js2n__-prdslib.always,
                                          } {} true _js2n__-prdslib.always
                                      ],
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.records.required
                                          [ "kind" ],
                                        _js2n__-prdslib.records.record
                                          {
                                            address = _js2n__-prdslib.always,
                                            bind_netns = _js2n__-prdslib.always,
                                            group = _js2n__-prdslib.always,
                                            ifalias = _js2n__-prdslib.always,
                                            kind = _js2n__-prdslib.const "vti",
                                            master = _js2n__-prdslib.always,
                                            mtu = _js2n__-prdslib.always,
                                            state = _js2n__-prdslib.always,
                                            txqlen = _js2n__-prdslib.always,
                                          } {} true _js2n__-prdslib.always
                                      ],
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.records.required
                                          [ "kind" ],
                                        _js2n__-prdslib.records.record
                                          {
                                            address = _js2n__-prdslib.always,
                                            bind_netns = _js2n__-prdslib.always,
                                            group = _js2n__-prdslib.always,
                                            ifalias = _js2n__-prdslib.always,
                                            kind = _js2n__-prdslib.const "vti6",
                                            master = _js2n__-prdslib.always,
                                            mtu = _js2n__-prdslib.always,
                                            state = _js2n__-prdslib.always,
                                            txqlen = _js2n__-prdslib.always,
                                          } {} true _js2n__-prdslib.always
                                      ],
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.records.required
                                          [ "kind" ],
                                        _js2n__-prdslib.records.record
                                          {
                                            address = _js2n__-prdslib.always,
                                            bond_ad_lacp_rate =
                                              _js2n__-prdslib.enum
                                                  [ 0, "slow", 1, "fast" ],
                                            bond_ad_select =
                                              _js2n__-prdslib.enum
                                                  [
                                                    0,
                                                    "stable",
                                                    1,
                                                    "bandwidth",
                                                    2,
                                                    "count"
                                                  ],
                                            bond_all_slaves_active =
                                              _js2n__-prdslib.enum [ 0, 1 ],
                                            bond_arp_all_targets =
                                              _js2n__-prdslib.enum
                                                  [ 0, "any", 1, "all" ],
                                            bond_arp_interval =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      'Integer,
                                                    _js2n__-prdslib.numbers.minimum
                                                      0
                                                  ],
                                            bond_arp_validate =
                                              _js2n__-prdslib.enum
                                                  [
                                                    0,
                                                    "none",
                                                    1,
                                                    "active",
                                                    2,
                                                    "backup",
                                                    3,
                                                    "all",
                                                    4,
                                                    "filter",
                                                    5,
                                                    "filter_active",
                                                    6,
                                                    "filter_backup"
                                                  ],
                                            bond_downdelay =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      'Integer,
                                                    _js2n__-prdslib.numbers.minimum
                                                      0
                                                  ],
                                            bond_fail_over_mac =
                                              _js2n__-prdslib.enum
                                                  [
                                                    0,
                                                    "none",
                                                    1,
                                                    "active",
                                                    2,
                                                    "follow"
                                                  ],
                                            bond_lp_interval =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      'Integer,
                                                    _js2n__-prdslib.numbers.maximum
                                                      2147483647,
                                                    _js2n__-prdslib.numbers.minimum
                                                      0
                                                  ],
                                            bond_miimon =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      'Integer,
                                                    _js2n__-prdslib.numbers.minimum
                                                      0
                                                  ],
                                            bond_min_links =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      'Integer,
                                                    _js2n__-prdslib.numbers.minimum
                                                      0
                                                  ],
                                            bond_mode =
                                              _js2n__-prdslib.enum
                                                  [
                                                    0,
                                                    "balance-rr",
                                                    1,
                                                    "active-backup",
                                                    2,
                                                    "balance-xor",
                                                    3,
                                                    "broadcast",
                                                    4,
                                                    "802.3ad",
                                                    5,
                                                    "balance-tlb",
                                                    6,
                                                    "balance-alb"
                                                  ],
                                            bond_num_peer_notif =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      'Integer,
                                                    _js2n__-prdslib.numbers.minimum
                                                      0
                                                  ],
                                            bond_packets_per_slave =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      'Integer,
                                                    _js2n__-prdslib.numbers.maximum
                                                      65535,
                                                    _js2n__-prdslib.numbers.minimum
                                                      0
                                                  ],
                                            bond_primary_reselect =
                                              _js2n__-prdslib.enum
                                                  [
                                                    0,
                                                    "always",
                                                    1,
                                                    "better",
                                                    2,
                                                    "failure"
                                                  ],
                                            bond_resend_igmp =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      'Integer,
                                                    _js2n__-prdslib.numbers.maximum
                                                      255,
                                                    _js2n__-prdslib.numbers.minimum
                                                      0
                                                  ],
                                            bond_tlb_dynamic_lb =
                                              _js2n__-prdslib.enum [ 0, 1 ],
                                            bond_updelay =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      'Integer,
                                                    _js2n__-prdslib.numbers.minimum
                                                      0
                                                  ],
                                            bond_use_carrier =
                                              _js2n__-prdslib.enum [ 0, 1 ],
                                            bond_xmit_hash_policy =
                                              _js2n__-prdslib.enum
                                                  [
                                                    0,
                                                    "layer2",
                                                    1,
                                                    "layer3+4",
                                                    2,
                                                    "layer2+3",
                                                    3,
                                                    "encap2+3",
                                                    4,
                                                    "encap3+4",
                                                    5,
                                                    "vlan+srcmac"
                                                  ],
                                            group = _js2n__-prdslib.always,
                                            ifalias = _js2n__-prdslib.always,
                                            kind = _js2n__-prdslib.const "bond",
                                            master = _js2n__-prdslib.always,
                                            mtu = _js2n__-prdslib.always,
                                            state = _js2n__-prdslib.always,
                                            txqlen = _js2n__-prdslib.always,
                                          } {} false _js2n__-prdslib.never
                                      ],
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.records.required
                                          [ "kind" ],
                                        _js2n__-prdslib.records.record
                                          {
                                            address = _js2n__-prdslib.always,
                                            br_ageing_time =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      'Integer,
                                                    _js2n__-prdslib.numbers.minimum
                                                      0
                                                  ],
                                            br_vlan_protocol =
                                              _js2n__-prdslib.enum
                                                  [
                                                    33024,
                                                    "802.1q",
                                                    34984,
                                                    "802.1ad"
                                                  ],
                                            group = _js2n__-prdslib.always,
                                            ifalias = _js2n__-prdslib.always,
                                            kind =
                                              _js2n__-prdslib.const "bridge",
                                            master = _js2n__-prdslib.always,
                                            mtu = _js2n__-prdslib.always,
                                            state = _js2n__-prdslib.always,
                                            txqlen = _js2n__-prdslib.always,
                                          } {} true _js2n__-prdslib.always
                                      ],
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.records.required
                                          [ "kind" ],
                                        _js2n__-prdslib.records.record
                                          {
                                            address = _js2n__-prdslib.always,
                                            businfo =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"String",
                                                    _js2n__-prdslib.strings.maxLength
                                                      32
                                                  ],
                                            group = _js2n__-prdslib.always,
                                            ifalias = _js2n__-prdslib.always,
                                            kind =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"String",
                                                    _js2n__-prdslib.enum
                                                      [ "physical" ]
                                                  ],
                                            master = _js2n__-prdslib.always,
                                            mtu = _js2n__-prdslib.always,
                                            permaddr = _js2n__-prdslib.always,
                                            state = _js2n__-prdslib.always,
                                            txqlen = _js2n__-prdslib.always,
                                          } {} false _js2n__-prdslib.never
                                      ],
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.records.required
                                          [ "kind", "link" ],
                                        _js2n__-prdslib.records.record
                                          {
                                            address = _js2n__-prdslib.always,
                                            group = _js2n__-prdslib.always,
                                            ifalias = _js2n__-prdslib.always,
                                            kind = _js2n__-prdslib.const "dsa",
                                            link = _js2n__-prdslib.always,
                                            link_netns = _js2n__-prdslib.always,
                                            master = _js2n__-prdslib.always,
                                            mtu = _js2n__-prdslib.always,
                                            permaddr = _js2n__-prdslib.always,
                                            state = _js2n__-prdslib.always,
                                            txqlen = _js2n__-prdslib.always,
                                          } {} false _js2n__-prdslib.never
                                      ],
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.records.required
                                          [ "kind" ],
                                        _js2n__-prdslib.records.record
                                          {
                                            address = _js2n__-prdslib.always,
                                            group = _js2n__-prdslib.always,
                                            ifalias = _js2n__-prdslib.always,
                                            kind =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"String",
                                                    _js2n__-prdslib.enum
                                                      [ "dummy" ]
                                                  ],
                                            master = _js2n__-prdslib.always,
                                            mtu = _js2n__-prdslib.always,
                                            state = _js2n__-prdslib.always,
                                            txqlen = _js2n__-prdslib.always,
                                          } {} false _js2n__-prdslib.never
                                      ],
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.records.required
                                          [ "kind", "peer" ],
                                        _js2n__-prdslib.records.record
                                          {
                                            address = _js2n__-prdslib.always,
                                            group = _js2n__-prdslib.always,
                                            ifalias = _js2n__-prdslib.always,
                                            kind =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"String",
                                                    _js2n__-prdslib.enum
                                                      [ "veth", "vxcan" ]
                                                  ],
                                            master = _js2n__-prdslib.always,
                                            mtu = _js2n__-prdslib.always,
                                            peer = _js2n__-prdslib.always,
                                            peer_netns =
                                              _js2n__-prdslib.anyOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"String",
                                                    _js2n__-prdslib.isType 'Null
                                                  ],
                                            state = _js2n__-prdslib.always,
                                            txqlen = _js2n__-prdslib.always,
                                          } {} false _js2n__-prdslib.never
                                      ],
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.records.required
                                          [ "kind", "link", "vlan_id" ],
                                        _js2n__-prdslib.records.record
                                          {
                                            address = _js2n__-prdslib.always,
                                            group = _js2n__-prdslib.always,
                                            ifalias = _js2n__-prdslib.always,
                                            kind = _js2n__-prdslib.const "vlan",
                                            link = _js2n__-prdslib.always,
                                            link_netns = _js2n__-prdslib.always,
                                            master = _js2n__-prdslib.always,
                                            mtu = _js2n__-prdslib.always,
                                            state = _js2n__-prdslib.always,
                                            txqlen = _js2n__-prdslib.always,
                                            vlan_id =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.anyOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          'Integer
                                                      ],
                                                    _js2n__-prdslib.numbers.maximum
                                                      4094,
                                                    _js2n__-prdslib.numbers.minimum
                                                      0
                                                  ],
                                            vlan_protocol =
                                              _js2n__-prdslib.enum
                                                  [
                                                    33024,
                                                    "802.1q",
                                                    34984,
                                                    "802.1ad"
                                                  ],
                                          } {} false _js2n__-prdslib.never
                                      ],
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.anyOf
                                          [
                                            _js2n__-prdslib.oneOf
                                              [
                                                _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.records.required
                                                      [ "vxlan_group" ],
                                                    _js2n__-prdslib.records.record
                                                      {} {} true
                                                      _js2n__-prdslib.always
                                                  ],
                                                _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.records.required
                                                      [ "vxlan_group6" ],
                                                    _js2n__-prdslib.records.record
                                                      {} {} true
                                                      _js2n__-prdslib.always
                                                  ]
                                              ],
                                            _js2n__-prdslib.not
                                              (_js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.records.required
                                                    [
                                                      "vxlan_group",
                                                      "vxlan_group6"
                                                    ],
                                                  _js2n__-prdslib.records.record
                                                    {} {} true
                                                    _js2n__-prdslib.always
                                                ])
                                          ],
                                        _js2n__-prdslib.records.required
                                          [ "kind", "vxlan_id" ],
                                        _js2n__-prdslib.records.record
                                          {
                                            address = _js2n__-prdslib.always,
                                            bind_netns = _js2n__-prdslib.always,
                                            group = _js2n__-prdslib.always,
                                            ifalias = _js2n__-prdslib.always,
                                            kind =
                                              _js2n__-prdslib.const "vxlan",
                                            master = _js2n__-prdslib.always,
                                            mtu = _js2n__-prdslib.always,
                                            state = _js2n__-prdslib.always,
                                            txqlen = _js2n__-prdslib.always,
                                            vxlan_ageing =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      'Integer,
                                                    _js2n__-prdslib.numbers.maximum
                                                      4294967296,
                                                    _js2n__-prdslib.numbers.minimum
                                                      0
                                                  ],
                                            vxlan_df =
                                              _js2n__-prdslib.enum
                                                  [
                                                    0,
                                                    "unset",
                                                    1,
                                                    "set",
                                                    2,
                                                    "inherit"
                                                  ],
                                            vxlan_group =
                                              _js2n__-prdslib.isType '"String",
                                            vxlan_group6 =
                                              _js2n__-prdslib.isType '"String",
                                            vxlan_id =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      'Integer,
                                                    _js2n__-prdslib.numbers.maximum
                                                      16777215,
                                                    _js2n__-prdslib.numbers.minimum
                                                      0
                                                  ],
                                            vxlan_l2miss =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      'Integer,
                                                    _js2n__-prdslib.numbers.maximum
                                                      1,
                                                    _js2n__-prdslib.numbers.minimum
                                                      0
                                                  ],
                                            vxlan_l3miss =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      'Integer,
                                                    _js2n__-prdslib.numbers.maximum
                                                      1,
                                                    _js2n__-prdslib.numbers.minimum
                                                      0
                                                  ],
                                            vxlan_label =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      'Integer,
                                                    _js2n__-prdslib.numbers.maximum
                                                      1048575,
                                                    _js2n__-prdslib.numbers.minimum
                                                      0
                                                  ],
                                            vxlan_learning =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      'Integer,
                                                    _js2n__-prdslib.numbers.maximum
                                                      1,
                                                    _js2n__-prdslib.numbers.minimum
                                                      0
                                                  ],
                                            vxlan_limit =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      'Integer,
                                                    _js2n__-prdslib.numbers.maximum
                                                      4294967296,
                                                    _js2n__-prdslib.numbers.minimum
                                                      0
                                                  ],
                                            vxlan_link = _js2n__-prdslib.always,
                                            vxlan_local =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"String",
                                                    _js2n__-prdslib.oneOf
                                                      [
                                                        _js2n__-prdslib.always,
                                                        _js2n__-prdslib.always
                                                      ]
                                                  ],
                                            vxlan_proxy =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      'Integer,
                                                    _js2n__-prdslib.numbers.maximum
                                                      1,
                                                    _js2n__-prdslib.numbers.minimum
                                                      0
                                                  ],
                                            vxlan_rsc =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      'Integer,
                                                    _js2n__-prdslib.numbers.maximum
                                                      1,
                                                    _js2n__-prdslib.numbers.minimum
                                                      0
                                                  ],
                                            vxlan_tos =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      'Integer,
                                                    _js2n__-prdslib.numbers.maximum
                                                      255,
                                                    _js2n__-prdslib.numbers.minimum
                                                      0
                                                  ],
                                            vxlan_ttl =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      'Integer,
                                                    _js2n__-prdslib.numbers.maximum
                                                      255,
                                                    _js2n__-prdslib.numbers.minimum
                                                      0
                                                  ],
                                            vxlan_ttl_inherit =
                                              _js2n__-prdslib.isType '"Bool",
                                            vxlan_udp_csum =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      'Integer,
                                                    _js2n__-prdslib.numbers.maximum
                                                      1,
                                                    _js2n__-prdslib.numbers.minimum
                                                      0
                                                  ],
                                          } {} false _js2n__-prdslib.never
                                      ],
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.records.required
                                          [
                                            "ipip_local",
                                            "ipip_remote",
                                            "kind"
                                          ],
                                        _js2n__-prdslib.records.record
                                          {
                                            address = _js2n__-prdslib.always,
                                            bind_netns = _js2n__-prdslib.always,
                                            group = _js2n__-prdslib.always,
                                            ifalias = _js2n__-prdslib.always,
                                            ipip_local = _js2n__-prdslib.always,
                                            ipip_remote =
                                              _js2n__-prdslib.always,
                                            kind = _js2n__-prdslib.const "ipip",
                                            master = _js2n__-prdslib.always,
                                            mtu = _js2n__-prdslib.always,
                                            state = _js2n__-prdslib.always,
                                            txqlen = _js2n__-prdslib.always,
                                          } {} false _js2n__-prdslib.never
                                      ],
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.records.required
                                          [ "kind", "sit_local", "sit_remote" ],
                                        _js2n__-prdslib.records.record
                                          {
                                            address = _js2n__-prdslib.always,
                                            bind_netns = _js2n__-prdslib.always,
                                            group = _js2n__-prdslib.always,
                                            ifalias = _js2n__-prdslib.always,
                                            kind = _js2n__-prdslib.const "sit",
                                            master = _js2n__-prdslib.always,
                                            mtu = _js2n__-prdslib.always,
                                            sit_local = _js2n__-prdslib.always,
                                            sit_remote = _js2n__-prdslib.always,
                                            state = _js2n__-prdslib.always,
                                            txqlen = _js2n__-prdslib.always,
                                          } {} false _js2n__-prdslib.never
                                      ],
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.records.required
                                          [ "gre_local", "gre_remote", "kind" ],
                                        _js2n__-prdslib.records.record
                                          {
                                            address = _js2n__-prdslib.always,
                                            bind_netns = _js2n__-prdslib.always,
                                            gre_link = _js2n__-prdslib.always,
                                            gre_local = _js2n__-prdslib.always,
                                            gre_remote = _js2n__-prdslib.always,
                                            group = _js2n__-prdslib.always,
                                            ifalias = _js2n__-prdslib.always,
                                            kind =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"String",
                                                    _js2n__-prdslib.enum
                                                      [ "gre", "gretap" ]
                                                  ],
                                            master = _js2n__-prdslib.always,
                                            mtu = _js2n__-prdslib.always,
                                            state = _js2n__-prdslib.always,
                                            txqlen = _js2n__-prdslib.always,
                                          } {} false _js2n__-prdslib.never
                                      ],
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.records.required
                                          [
                                            "ip6gre_local",
                                            "ip6gre_remote",
                                            "kind"
                                          ],
                                        _js2n__-prdslib.records.record
                                          {
                                            address = _js2n__-prdslib.always,
                                            bind_netns = _js2n__-prdslib.always,
                                            group = _js2n__-prdslib.always,
                                            ifalias = _js2n__-prdslib.always,
                                            ip6gre_link =
                                              _js2n__-prdslib.always,
                                            ip6gre_local =
                                              _js2n__-prdslib.always,
                                            ip6gre_remote =
                                              _js2n__-prdslib.always,
                                            kind =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"String",
                                                    _js2n__-prdslib.enum
                                                      [ "ip6gre", "ip6gretap" ]
                                                  ],
                                            master = _js2n__-prdslib.always,
                                            mtu = _js2n__-prdslib.always,
                                            state = _js2n__-prdslib.always,
                                            txqlen = _js2n__-prdslib.always,
                                          } {} false _js2n__-prdslib.never
                                      ],
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.records.required
                                          [
                                            "geneve_id",
                                            "geneve_remote",
                                            "kind"
                                          ],
                                        _js2n__-prdslib.records.record
                                          {
                                            address = _js2n__-prdslib.always,
                                            bind_netns = _js2n__-prdslib.always,
                                            geneve_id =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.anyOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          'Integer
                                                      ],
                                                    _js2n__-prdslib.numbers.maximum
                                                      16777215,
                                                    _js2n__-prdslib.numbers.minimum
                                                      0
                                                  ],
                                            geneve_remote =
                                              _js2n__-prdslib.always,
                                            group = _js2n__-prdslib.always,
                                            ifalias = _js2n__-prdslib.always,
                                            kind =
                                              _js2n__-prdslib.const "geneve",
                                            master = _js2n__-prdslib.always,
                                            mtu = _js2n__-prdslib.always,
                                            state = _js2n__-prdslib.always,
                                            txqlen = _js2n__-prdslib.always,
                                          } {} false _js2n__-prdslib.never
                                      ],
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.records.required
                                          [
                                            "geneve_id",
                                            "geneve_remote6",
                                            "kind"
                                          ],
                                        _js2n__-prdslib.records.record
                                          {
                                            address = _js2n__-prdslib.always,
                                            bind_netns = _js2n__-prdslib.always,
                                            geneve_id =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.anyOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          'Integer
                                                      ],
                                                    _js2n__-prdslib.numbers.maximum
                                                      16777215,
                                                    _js2n__-prdslib.numbers.minimum
                                                      0
                                                  ],
                                            geneve_remote6 =
                                              _js2n__-prdslib.always,
                                            group = _js2n__-prdslib.always,
                                            ifalias = _js2n__-prdslib.always,
                                            kind =
                                              _js2n__-prdslib.const "geneve",
                                            master = _js2n__-prdslib.always,
                                            mtu = _js2n__-prdslib.always,
                                            state = _js2n__-prdslib.always,
                                            txqlen = _js2n__-prdslib.always,
                                          } {} false _js2n__-prdslib.never
                                      ],
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.records.required
                                          [ "kind" ],
                                        _js2n__-prdslib.records.record
                                          {
                                            address = _js2n__-prdslib.always,
                                            bind_netns = _js2n__-prdslib.always,
                                            group = _js2n__-prdslib.always,
                                            ifalias = _js2n__-prdslib.always,
                                            kind =
                                              _js2n__-prdslib.const "wireguard",
                                            master = _js2n__-prdslib.always,
                                            mtu = _js2n__-prdslib.always,
                                            state = _js2n__-prdslib.always,
                                            txqlen = _js2n__-prdslib.always,
                                          } {} false _js2n__-prdslib.never
                                      ],
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.records.required
                                          [ "kind", "xfrm_if_id" ],
                                        _js2n__-prdslib.records.record
                                          {
                                            address = _js2n__-prdslib.always,
                                            bind_netns = _js2n__-prdslib.always,
                                            group = _js2n__-prdslib.always,
                                            ifalias = _js2n__-prdslib.always,
                                            kind = _js2n__-prdslib.const "xfrm",
                                            master = _js2n__-prdslib.always,
                                            mtu = _js2n__-prdslib.always,
                                            state = _js2n__-prdslib.always,
                                            txqlen = _js2n__-prdslib.always,
                                            xfrm_if_id =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.anyOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          'Integer
                                                      ],
                                                    _js2n__-prdslib.numbers.maximum
                                                      4294967295,
                                                    _js2n__-prdslib.numbers.minimum
                                                      0
                                                  ],
                                            xfrm_link = _js2n__-prdslib.always,
                                          } {} false _js2n__-prdslib.never
                                      ]
                                  ],
                                _js2n__-prdslib.records.required [ "kind" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ],
                        name = _js2n__-prdslib.always,
                        neighbours =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.required
                                        [ "dst" ],
                                      _js2n__-prdslib.records.record
                                        {
                                          dst =
                                            _js2n__-prdslib.isType '"String",
                                          lladdr = _js2n__-prdslib.always,
                                        } {} false _js2n__-prdslib.never
                                    ])
                              ],
                        sysctl =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record
                                  {
                                    ipv4 = _js2n__-prdslib.always,
                                    ipv6 = _js2n__-prdslib.always,
                                    mpls = _js2n__-prdslib.always,
                                  } {} false _js2n__-prdslib.never
                              ],
                        tc =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record
                                  {
                                    filter =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"Array",
                                            _js2n__-prdslib.arrays.arrayOf
                                              (_js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.oneOf
                                                    [
                                                      _js2n__-prdslib.records.record
                                                        {
                                                          action =
                                                            _js2n__-prdslib.always,
                                                          kind =
                                                            _js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    '"String",
                                                                  _js2n__-prdslib.enum
                                                                    [ "basic" ]
                                                                ],
                                                          "match" =
                                                            _js2n__-prdslib.isType
                                                                'Record,
                                                          prio =
                                                            _js2n__-prdslib.always,
                                                          protocol =
                                                            _js2n__-prdslib.always,
                                                        } {} false
                                                        _js2n__-prdslib.never,
                                                      _js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.oneOf
                                                            [
                                                              _js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.records.required
                                                                    [
                                                                      "key",
                                                                      "kind",
                                                                      "mode"
                                                                    ],
                                                                  _js2n__-prdslib.records.record
                                                                    {
                                                                      key =
                                                                        _js2n__-prdslib.allOf
                                                                            [
                                                                              _js2n__-prdslib.isType
                                                                                '"String",
                                                                              _js2n__-prdslib.enum
                                                                                [
                                                                                  "src",
                                                                                  "dst",
                                                                                  "proto",
                                                                                  "proto-src",
                                                                                  "proto-dst",
                                                                                  "iif",
                                                                                  "priority",
                                                                                  "mark",
                                                                                  "nfct",
                                                                                  "nfct-src",
                                                                                  "nfct-dst",
                                                                                  "nfct-proto-src",
                                                                                  "nfct-proto-dst",
                                                                                  "rt-classid",
                                                                                  "sk-uid",
                                                                                  "sk-gid",
                                                                                  "vlan-tag",
                                                                                  "rxhash"
                                                                                ]
                                                                            ],
                                                                      mode =
                                                                        _js2n__-prdslib.allOf
                                                                            [
                                                                              _js2n__-prdslib.isType
                                                                                '"String",
                                                                              _js2n__-prdslib.enum
                                                                                [
                                                                                  "map"
                                                                                ]
                                                                            ],
                                                                    } {} true
                                                                    _js2n__-prdslib.always
                                                                ],
                                                              _js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.records.required
                                                                    [
                                                                      "keys",
                                                                      "kind",
                                                                      "mode"
                                                                    ],
                                                                  _js2n__-prdslib.records.record
                                                                    {
                                                                      keys =
                                                                        _js2n__-prdslib.allOf
                                                                            [
                                                                              _js2n__-prdslib.isType
                                                                                '"Array",
                                                                              _js2n__-prdslib.arrays.arrayOf
                                                                                (_js2n__-prdslib.allOf
                                                                                  [
                                                                                    _js2n__-prdslib.isType
                                                                                      '"String",
                                                                                    _js2n__-prdslib.enum
                                                                                      [
                                                                                        "src",
                                                                                        "dst",
                                                                                        "proto",
                                                                                        "proto-src",
                                                                                        "proto-dst",
                                                                                        "iif",
                                                                                        "priority",
                                                                                        "mark",
                                                                                        "nfct",
                                                                                        "nfct-src",
                                                                                        "nfct-dst",
                                                                                        "nfct-proto-src",
                                                                                        "nfct-proto-dst",
                                                                                        "rt-classid",
                                                                                        "sk-uid",
                                                                                        "sk-gid",
                                                                                        "vlan-tag",
                                                                                        "rxhash"
                                                                                      ]
                                                                                  ])
                                                                            ],
                                                                      mode =
                                                                        _js2n__-prdslib.allOf
                                                                            [
                                                                              _js2n__-prdslib.isType
                                                                                '"String",
                                                                              _js2n__-prdslib.enum
                                                                                [
                                                                                  "hash"
                                                                                ]
                                                                            ],
                                                                      perturb =
                                                                        _js2n__-prdslib.allOf
                                                                            [
                                                                              _js2n__-prdslib.isType
                                                                                'Integer,
                                                                              _js2n__-prdslib.numbers.maximum
                                                                                294967295,
                                                                              _js2n__-prdslib.numbers.minimum
                                                                                0
                                                                            ],
                                                                    } {} true
                                                                    _js2n__-prdslib.always
                                                                ]
                                                            ],
                                                          _js2n__-prdslib.records.record
                                                            {
                                                              action =
                                                                _js2n__-prdslib.always,
                                                              addend =
                                                                _js2n__-prdslib.allOf
                                                                    [
                                                                      _js2n__-prdslib.isType
                                                                        'Integer,
                                                                      _js2n__-prdslib.numbers.maximum
                                                                        4294967295,
                                                                      _js2n__-prdslib.numbers.minimum
                                                                        0
                                                                    ],
                                                              and =
                                                                _js2n__-prdslib.allOf
                                                                    [
                                                                      _js2n__-prdslib.isType
                                                                        'Integer,
                                                                      _js2n__-prdslib.numbers.maximum
                                                                        4294967295,
                                                                      _js2n__-prdslib.numbers.minimum
                                                                        0
                                                                    ],
                                                              baseclass =
                                                                _js2n__-prdslib.allOf
                                                                    [
                                                                      _js2n__-prdslib.isType
                                                                        'Integer,
                                                                      _js2n__-prdslib.numbers.maximum
                                                                        65535,
                                                                      _js2n__-prdslib.numbers.minimum
                                                                        0
                                                                    ],
                                                              divisor =
                                                                _js2n__-prdslib.allOf
                                                                    [
                                                                      _js2n__-prdslib.isType
                                                                        'Integer,
                                                                      _js2n__-prdslib.numbers.maximum
                                                                        4294967295,
                                                                      _js2n__-prdslib.numbers.minimum
                                                                        0
                                                                    ],
                                                              kind =
                                                                _js2n__-prdslib.allOf
                                                                    [
                                                                      _js2n__-prdslib.isType
                                                                        '"String",
                                                                      _js2n__-prdslib.enum
                                                                        [
                                                                          "flow"
                                                                        ]
                                                                    ],
                                                              or =
                                                                _js2n__-prdslib.allOf
                                                                    [
                                                                      _js2n__-prdslib.isType
                                                                        'Integer,
                                                                      _js2n__-prdslib.numbers.maximum
                                                                        4294967295,
                                                                      _js2n__-prdslib.numbers.minimum
                                                                        0
                                                                    ],
                                                              prio =
                                                                _js2n__-prdslib.always,
                                                              protocol =
                                                                _js2n__-prdslib.always,
                                                              rshift =
                                                                _js2n__-prdslib.allOf
                                                                    [
                                                                      _js2n__-prdslib.isType
                                                                        'Integer,
                                                                      _js2n__-prdslib.numbers.maximum
                                                                        4294967295,
                                                                      _js2n__-prdslib.numbers.minimum
                                                                        0
                                                                    ],
                                                              xor =
                                                                _js2n__-prdslib.allOf
                                                                    [
                                                                      _js2n__-prdslib.isType
                                                                        'Integer,
                                                                      _js2n__-prdslib.numbers.maximum
                                                                        4294967295,
                                                                      _js2n__-prdslib.numbers.minimum
                                                                        0
                                                                    ],
                                                            } {} true
                                                            _js2n__-prdslib.always
                                                        ],
                                                      _js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.records.required
                                                            [
                                                              "handle",
                                                              "kind"
                                                            ],
                                                          _js2n__-prdslib.records.record
                                                            {
                                                              action =
                                                                _js2n__-prdslib.always,
                                                              handle =
                                                                _js2n__-prdslib.allOf
                                                                    [
                                                                      _js2n__-prdslib.isType
                                                                        'Integer,
                                                                      _js2n__-prdslib.numbers.minimum
                                                                        0
                                                                    ],
                                                              kind =
                                                                _js2n__-prdslib.allOf
                                                                    [
                                                                      _js2n__-prdslib.isType
                                                                        '"String",
                                                                      _js2n__-prdslib.enum
                                                                        [ "fw" ]
                                                                    ],
                                                              prio =
                                                                _js2n__-prdslib.always,
                                                              protocol =
                                                                _js2n__-prdslib.always,
                                                            } {} false
                                                            _js2n__-prdslib.never
                                                        ],
                                                      _js2n__-prdslib.records.record
                                                        {
                                                          action =
                                                            _js2n__-prdslib.always,
                                                          classid =
                                                            _js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    'Integer,
                                                                  _js2n__-prdslib.numbers.maximum
                                                                    4294967295,
                                                                  _js2n__-prdslib.numbers.minimum
                                                                    0
                                                                ],
                                                          flags =
                                                            _js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    'Integer,
                                                                  _js2n__-prdslib.numbers.maximum
                                                                    4294967295,
                                                                  _js2n__-prdslib.numbers.minimum
                                                                    0
                                                                ],
                                                          kind =
                                                            _js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    '"String",
                                                                  _js2n__-prdslib.enum
                                                                    [
                                                                      "matchall"
                                                                    ]
                                                                ],
                                                          parent =
                                                            _js2n__-prdslib.always,
                                                          prio =
                                                            _js2n__-prdslib.always,
                                                          protocol =
                                                            _js2n__-prdslib.always,
                                                        } {} false
                                                        _js2n__-prdslib.never
                                                    ],
                                                  _js2n__-prdslib.records.required
                                                    [ "kind" ],
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      kind =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                '"String",
                                                              _js2n__-prdslib.enum
                                                                [
                                                                  "basic",
                                                                  "flow",
                                                                  "fw",
                                                                  "matchall"
                                                                ]
                                                            ],
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ])
                                          ],
                                    ingress = _js2n__-prdslib.isType '"Bool",
                                    qdisc = _js2n__-prdslib.always,
                                  } {} false _js2n__-prdslib.never
                              ],
                        vrrp = _js2n__-prdslib.always,
                        wireguard =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.required
                                  [ "private_key" ],
                                _js2n__-prdslib.records.record
                                  {
                                    fwmark =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Integer,
                                            _js2n__-prdslib.numbers.maximum
                                              4294967295,
                                            _js2n__-prdslib.numbers.minimum 0
                                          ],
                                    listen_port =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Integer,
                                            _js2n__-prdslib.numbers.maximum
                                              65535,
                                            _js2n__-prdslib.numbers.minimum 0
                                          ],
                                    peers =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"Array",
                                            _js2n__-prdslib.arrays.arrayOf
                                              (_js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.required
                                                    [ "public_key" ],
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      allowedips =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                '"Array",
                                                              _js2n__-prdslib.arrays.arrayOf
                                                                (_js2n__-prdslib.isType
                                                                  '"String")
                                                            ],
                                                      endpoint =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      persistent_keepalive_interval =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                'Integer,
                                                              _js2n__-prdslib.numbers.maximum
                                                                65535,
                                                              _js2n__-prdslib.numbers.minimum
                                                                0
                                                            ],
                                                      preshared_key =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      public_key =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                    } {} false
                                                    _js2n__-prdslib.never
                                                ])
                                          ],
                                    private_key =
                                      _js2n__-prdslib.isType '"String",
                                  } {} false _js2n__-prdslib.never
                              ],
                        xdp =
                          _js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"Bool",
                                    _js2n__-prdslib.enum [ false ]
                                  ],
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.required
                                      [ "pinned" ],
                                    _js2n__-prdslib.records.record
                                      {
                                        mode = _js2n__-prdslib.always,
                                        pinned =
                                          _js2n__-prdslib.isType '"String",
                                      } {} false _js2n__-prdslib.never
                                  ],
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.required [ "bpf" ],
                                    _js2n__-prdslib.records.record
                                      {
                                        bpf = _js2n__-prdslib.isType '"String",
                                        mode = _js2n__-prdslib.always,
                                      } {} false _js2n__-prdslib.never
                                  ]
                              ],
                      } {} false _js2n__-prdslib.never
                  ])
            ],
      "_js2n__-:properties/options!predicate"
        | doc "global configuration settings"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  sysctl =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              all =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          ipv4 = _js2n__-prdslib.always,
                                          ipv6 = _js2n__-prdslib.always,
                                        } {} false _js2n__-prdslib.never
                                    ],
                              "default" =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          ipv4 = _js2n__-prdslib.always,
                                          ipv6 = _js2n__-prdslib.always,
                                        } {} false _js2n__-prdslib.never
                                    ],
                              mpls = _js2n__-prdslib.always,
                            } {} false _js2n__-prdslib.never
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:properties/routing!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  routes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.required [ "to" ],
                                _js2n__-prdslib.records.record
                                  {
                                    dev =
                                      _js2n__-prdslib.anyOf
                                          [
                                            _js2n__-prdslib.isType 'Integer,
                                            _js2n__-prdslib.isType '"String"
                                          ],
                                    preference =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Integer,
                                            _js2n__-prdslib.numbers.maximum
                                              4294967295,
                                            _js2n__-prdslib.numbers.minimum 0
                                          ],
                                    proto =
                                      _js2n__-prdslib.anyOf
                                          [
                                            _js2n__-prdslib.isType 'Integer,
                                            _js2n__-prdslib.isType '"String"
                                          ],
                                    realm =
                                      _js2n__-prdslib.anyOf
                                          [
                                            _js2n__-prdslib.isType 'Integer,
                                            _js2n__-prdslib.isType '"String"
                                          ],
                                    scope =
                                      _js2n__-prdslib.anyOf
                                          [
                                            _js2n__-prdslib.isType 'Integer,
                                            _js2n__-prdslib.isType '"String"
                                          ],
                                    src =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.oneOf
                                              [
                                                _js2n__-prdslib.always,
                                                _js2n__-prdslib.always
                                              ]
                                          ],
                                    table =
                                      _js2n__-prdslib.anyOf
                                          [
                                            _js2n__-prdslib.isType 'Integer,
                                            _js2n__-prdslib.isType '"String"
                                          ],
                                    to = _js2n__-prdslib.isType '"String",
                                    type =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.anyOf
                                              [
                                                _js2n__-prdslib.isType 'Integer,
                                                _js2n__-prdslib.isType '"String"
                                              ],
                                            _js2n__-prdslib.enum
                                              [
                                                "unicast",
                                                "local",
                                                "broadcast",
                                                "anycast",
                                                "multicast",
                                                "blackhole",
                                                "unreachable",
                                                "prohibit",
                                                "throw",
                                                "nat",
                                                "xresolve"
                                              ],
                                            _js2n__-prdslib.numbers.maximum 11,
                                            _js2n__-prdslib.numbers.minimum 1
                                          ],
                                    via =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.oneOf
                                              [
                                                _js2n__-prdslib.always,
                                                _js2n__-prdslib.always
                                              ]
                                          ],
                                    vrrp = _js2n__-prdslib.always,
                                  } {} false _js2n__-prdslib.never
                              ])
                        ],
                  rules =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.ifThenElse
                                  (_js2n__-prdslib.records.record
                                    { action = _js2n__-prdslib.const "to_tbl", }
                                    {} true _js2n__-prdslib.always)
                                  (_js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.records.required
                                        [ "priority", "table" ],
                                      _js2n__-prdslib.records.record {} {} true
                                        _js2n__-prdslib.always
                                    ])
                                  (_js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.records.required
                                        [ "priority" ],
                                      _js2n__-prdslib.records.record {} {} true
                                        _js2n__-prdslib.always
                                    ]),
                                _js2n__-prdslib.records.record
                                  {
                                    action =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.anyOf
                                              [
                                                _js2n__-prdslib.isType 'Integer,
                                                _js2n__-prdslib.isType '"String"
                                              ],
                                            _js2n__-prdslib.enum
                                              [
                                                "to_tbl",
                                                "blackhole",
                                                "unreachable",
                                                "prohibit"
                                              ]
                                          ],
                                    from = _js2n__-prdslib.isType '"String",
                                    fwmark = _js2n__-prdslib.isType 'Integer,
                                    iif = _js2n__-prdslib.isType '"String",
                                    ipproto =
                                      _js2n__-prdslib.anyOf
                                          [
                                            _js2n__-prdslib.isType 'Integer,
                                            _js2n__-prdslib.isType '"String"
                                          ],
                                    oif = _js2n__-prdslib.isType '"String",
                                    "priority" =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Integer,
                                            _js2n__-prdslib.numbers.maximum
                                              4294967295,
                                            _js2n__-prdslib.numbers.minimum 0
                                          ],
                                    proto =
                                      _js2n__-prdslib.anyOf
                                          [
                                            _js2n__-prdslib.isType 'Integer,
                                            _js2n__-prdslib.isType '"String"
                                          ],
                                    table =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.anyOf
                                              [
                                                _js2n__-prdslib.isType 'Integer,
                                                _js2n__-prdslib.isType '"String"
                                              ],
                                            _js2n__-prdslib.numbers.maximum 255,
                                            _js2n__-prdslib.numbers.minimum 0
                                          ],
                                    to = _js2n__-prdslib.isType '"String",
                                    vrrp = _js2n__-prdslib.always,
                                  } {} false _js2n__-prdslib.never
                              ])
                        ],
                } {} false _js2n__-prdslib.never
            ],
    }
    in
  {
      bpf
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  "" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.required
                            [ "object", "section" ],
                          _js2n__-prdslib.records.record
                            {
                              object = _js2n__-prdslib.isType '"String",
                              section = _js2n__-prdslib.isType '"String",
                            } {} false _js2n__-prdslib.never
                        ],
                } true _js2n__-prdslib.always
            ])
        | doc "load and pin eBPF programs (i.e. for XDP)"
        | optional,
      cshaper
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "default" ],
              _js2n__-prdslib.records.record {}
                {
                  "" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.required
                            [
                              "egress_qdisc",
                              "ingress_ifname",
                              "ingress_qdisc"
                            ],
                          _js2n__-prdslib.records.record
                            {
                              egress_qdisc = _js2n__-prdslib.always,
                              ingress_ifname =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.required
                                        [ "replace", "search" ],
                                      _js2n__-prdslib.records.record
                                        {
                                          replace =
                                            _js2n__-prdslib.isType '"String",
                                          search =
                                            _js2n__-prdslib.isType '"String",
                                        } {} false _js2n__-prdslib.never
                                    ],
                              ingress_qdisc = _js2n__-prdslib.always,
                            } {} false _js2n__-prdslib.never
                        ],
                } true _js2n__-prdslib.always
            ])
        | doc "cshaper templates"
        | optional,
      defaults
        | Array
          {
            clear_addresses
              | Bool
              | doc "implicit remove all ip addresses"
              | optional,
            clear_fdb
              | Bool
              | doc "implicit remove all permanent fdb entries"
              | optional,
            clear_neighbours
              | Bool
              | doc "implicit remove all permanent ip neighbours"
              | optional,
            clear_tc | Bool | doc "implicit remove all tc qdiscs" | optional,
            ethtool | Dyn | optional,
            link
              | {
                group | Dyn | optional,
                ifalias | Dyn | optional,
                link | Dyn | optional,
                link_netns | Dyn | optional,
                master | Dyn | optional,
                mtu | Dyn | optional,
                state | Dyn | optional,
                txqlen | Dyn | optional,
              }
              | doc "implicit link settings for matching interfaces"
              | optional,
            "match"
              | Array
                {
                  ifname
                    | String
                    | doc "regex to match interface name"
                    | optional,
                  kind | String | doc "regex to match link type" | optional,
                }
              | doc "apply default settings for interfaces  matching any list item (OR)",
          }
        | doc "default settings for configured interfaces"
        | optional,
      ignore
        | {
          fdb | Dyn | optional,
          fdb_builtin | Dyn | optional,
          ifname | Dyn | optional,
          ifname_builtin | Dyn | optional,
          ipaddr | Dyn | optional,
          ipaddr_builtin | Dyn | optional,
          ipaddr_dynamic
            | Bool
            | doc "ignore dynamic assigned ip addresses"
            | optional,
          netns
            | Array (String)
            | doc "netns namespaces matching this list of regex will be ignored"
            | optional,
          routes | Dyn | optional,
          routes_builtin | Dyn | optional,
          rules | Dyn | optional,
          rules_builtin | Dyn | optional,
        }
        | doc "ignore patterns to skip interface, ip address or routing objects"
        | optional,
      interfaces
        | Array
          {
            addresses
              | Array (String)
              | doc "ip addresses of the interface"
              | optional,
            brport
              | {
                backup_port
                  | Dyn
                  | doc "backup bridge port on loss carrier"
                  | optional,
                bcast_flood | Bool | doc "flood broadcasts" | optional,
                cost
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.numbers.maximum 65535,
                        _js2n__-prdslib.numbers.minimum 1
                      ])
                  | doc "set port cost"
                  | optional,
                fast_leave
                  | Bool
                  | doc "enable multicast fast leave"
                  | optional,
                guard | Bool | doc "filter BPDU packets" | optional,
                isolated
                  | Bool
                  | doc "isolated port, can communicate only with non-isolated ports"
                  | optional,
                learning | Bool | doc "allow MAC address learning" | optional,
                mcast_flood | Bool | doc "flood multicasts" | optional,
                mcast_to_ucast
                  | Bool
                  | doc "clone multicast packets into unicasts"
                  | optional,
                mode | Bool | doc "enable hairpin mode" | optional,
                neigh_suppress | Bool | doc "ARP and ND suppression" | optional,
                "priority"
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Integer,
                        _js2n__-prdslib.numbers.maximum 63,
                        _js2n__-prdslib.numbers.minimum 0
                      ])
                  | doc "set port priority"
                  | optional,
                protect | Bool | doc "prevent to become a root port" | optional,
                proxyarp | Bool | doc "enable proxy ARP" | optional,
                proxyarp_wifi
                  | Bool
                  | doc "enable proxy ARP (IEEE 802.11 and Hotspot 2.0)"
                  | optional,
                unicast_flood | Bool | doc "flood unknown unicasts" | optional,
                vlan_tunnel | Bool | doc "VLAN to tunnel mapping" | optional,
              }
              | doc "settings for bridge ports"
              | optional,
            cshaper
              | {
                egress | String | doc "target egress bandwidth" | optional,
                ingress | String | doc "target ingress bandwidth" | optional,
                profile | String | doc "cshaper profile" | optional,
              }
              | doc "simple shaper setup based on the [cake](https://man7.org/linux/man-pages/man8/tc-cake.8.html) queue discipline; replaces any tc settings"
              | optional,
            ethtool | Dyn | optional,
            fdb
              | Array
                {
                  dst
                    | _js2n__-prdslib.contract_from_predicate
                      (_js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.oneOf
                            [ _js2n__-prdslib.always, _js2n__-prdslib.always ]
                        ])
                    | doc "ip address of the destination VXLAN tunnel endpoint"
                    | optional,
                  flags
                    | _js2n__-prdslib.contract_from_predicate
                      (_js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.items
                            [
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.enum
                                    [
                                      "self",
                                      "master",
                                      "router",
                                      "use",
                                      "sticky"
                                    ]
                                ]
                            ]
                        ])
                    | optional,
                  lladdr | Dyn | doc "destination link layer address",
                  nhid
                    | _js2n__-prdslib.contract_from_predicate
                      (_js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 1
                        ])
                    | doc "ecmp nexthop group for the VXLAN device driver"
                    | optional,
                  port
                    | _js2n__-prdslib.contract_from_predicate
                      (_js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.maximum 65535,
                          _js2n__-prdslib.numbers.minimum 0
                        ])
                    | doc "destination port number to use to connect to the remote VXLAN tunnel endpoint"
                    | optional,
                  state
                    | _js2n__-prdslib.contract_from_predicate
                      (_js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.items
                            [
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.enum [ "permanent", "noarp" ]
                                ]
                            ]
                        ])
                    | optional,
                  vni
                    | _js2n__-prdslib.contract_from_predicate
                      (_js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.maximum 16777215,
                          _js2n__-prdslib.numbers.minimum 0
                        ])
                    | doc "virtual network identifier this entry belongs to"
                    | optional,
                }
              | doc "forwarding database for bridge interfaces, the entries are distinct by the `lladdr` property"
              | optional,
            link
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.oneOf
                      [
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "kind" ],
                            _js2n__-prdslib.records.record
                              {
                                address = _js2n__-prdslib.always,
                                group = _js2n__-prdslib.always,
                                ifalias = _js2n__-prdslib.always,
                                kind = _js2n__-prdslib.const "ifb",
                                master = _js2n__-prdslib.always,
                                mtu = _js2n__-prdslib.always,
                                state = _js2n__-prdslib.always,
                                txqlen = _js2n__-prdslib.always,
                              } {} false _js2n__-prdslib.never
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "kind" ],
                            _js2n__-prdslib.records.record
                              {
                                address = _js2n__-prdslib.always,
                                bind_netns = _js2n__-prdslib.always,
                                group = _js2n__-prdslib.always,
                                ifalias = _js2n__-prdslib.always,
                                kind = _js2n__-prdslib.const "ip6tnl",
                                master = _js2n__-prdslib.always,
                                mtu = _js2n__-prdslib.always,
                                state = _js2n__-prdslib.always,
                                txqlen = _js2n__-prdslib.always,
                              } {} true _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "kind" ],
                            _js2n__-prdslib.records.record
                              {
                                address = _js2n__-prdslib.always,
                                group = _js2n__-prdslib.always,
                                ifalias = _js2n__-prdslib.always,
                                kind = _js2n__-prdslib.const "ipoib",
                                master = _js2n__-prdslib.always,
                                mtu = _js2n__-prdslib.always,
                                state = _js2n__-prdslib.always,
                                txqlen = _js2n__-prdslib.always,
                              } {} true _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "kind" ],
                            _js2n__-prdslib.records.record
                              {
                                address = _js2n__-prdslib.always,
                                group = _js2n__-prdslib.always,
                                ifalias = _js2n__-prdslib.always,
                                kind = _js2n__-prdslib.const "ipvlan",
                                master = _js2n__-prdslib.always,
                                mtu = _js2n__-prdslib.always,
                                state = _js2n__-prdslib.always,
                                txqlen = _js2n__-prdslib.always,
                              } {} true _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "kind" ],
                            _js2n__-prdslib.records.record
                              {
                                address = _js2n__-prdslib.always,
                                group = _js2n__-prdslib.always,
                                ifalias = _js2n__-prdslib.always,
                                kind = _js2n__-prdslib.const "macvlan",
                                master = _js2n__-prdslib.always,
                                mtu = _js2n__-prdslib.always,
                                state = _js2n__-prdslib.always,
                                txqlen = _js2n__-prdslib.always,
                              } {} true _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "kind" ],
                            _js2n__-prdslib.records.record
                              {
                                address = _js2n__-prdslib.always,
                                group = _js2n__-prdslib.always,
                                ifalias = _js2n__-prdslib.always,
                                kind = _js2n__-prdslib.const "macvtap",
                                master = _js2n__-prdslib.always,
                                mtu = _js2n__-prdslib.always,
                                state = _js2n__-prdslib.always,
                                txqlen = _js2n__-prdslib.always,
                              } {} true _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "kind" ],
                            _js2n__-prdslib.records.record
                              {
                                address = _js2n__-prdslib.always,
                                group = _js2n__-prdslib.always,
                                ifalias = _js2n__-prdslib.always,
                                kind = _js2n__-prdslib.const "team",
                                master = _js2n__-prdslib.always,
                                mtu = _js2n__-prdslib.always,
                                state = _js2n__-prdslib.always,
                                txqlen = _js2n__-prdslib.always,
                              } {} true _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required
                              [ "kind", "tun_type" ],
                            _js2n__-prdslib.records.record
                              {
                                address = _js2n__-prdslib.always,
                                bind_netns = _js2n__-prdslib.always,
                                group = _js2n__-prdslib.always,
                                ifalias = _js2n__-prdslib.always,
                                kind = _js2n__-prdslib.const "tun",
                                master = _js2n__-prdslib.always,
                                mtu = _js2n__-prdslib.always,
                                state = _js2n__-prdslib.always,
                                tun_group =
                                  _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType 'Integer,
                                        _js2n__-prdslib.isType '"String"
                                      ],
                                tun_multi_queue =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.anyOf
                                          [
                                            _js2n__-prdslib.isType '"Bool",
                                            _js2n__-prdslib.isType 'Integer
                                          ],
                                        _js2n__-prdslib.enum
                                          [ 0, false, 1, true ]
                                      ],
                                tun_owner =
                                  _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType 'Integer,
                                        _js2n__-prdslib.isType '"String"
                                      ],
                                tun_persist =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.anyOf
                                          [
                                            _js2n__-prdslib.isType '"Bool",
                                            _js2n__-prdslib.isType 'Integer
                                          ],
                                        _js2n__-prdslib.enum
                                          [ 0, false, 1, true ]
                                      ],
                                tun_pi =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.anyOf
                                          [
                                            _js2n__-prdslib.isType '"Bool",
                                            _js2n__-prdslib.isType 'Integer
                                          ],
                                        _js2n__-prdslib.enum
                                          [ 0, false, 1, true ]
                                      ],
                                tun_type =
                                  _js2n__-prdslib.enum [ 1, "tun", 2, "tap" ],
                                tun_vnet_hdr =
                                  _js2n__-prdslib.enum [ 0, false, 1, true ],
                                txqlen = _js2n__-prdslib.always,
                              } {} false _js2n__-prdslib.never
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "kind" ],
                            _js2n__-prdslib.records.record
                              {
                                address = _js2n__-prdslib.always,
                                group = _js2n__-prdslib.always,
                                ifalias = _js2n__-prdslib.always,
                                kind = _js2n__-prdslib.const "vrf",
                                master = _js2n__-prdslib.always,
                                mtu = _js2n__-prdslib.always,
                                state = _js2n__-prdslib.always,
                                txqlen = _js2n__-prdslib.always,
                              } {} true _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "kind" ],
                            _js2n__-prdslib.records.record
                              {
                                address = _js2n__-prdslib.always,
                                bind_netns = _js2n__-prdslib.always,
                                group = _js2n__-prdslib.always,
                                ifalias = _js2n__-prdslib.always,
                                kind = _js2n__-prdslib.const "vti",
                                master = _js2n__-prdslib.always,
                                mtu = _js2n__-prdslib.always,
                                state = _js2n__-prdslib.always,
                                txqlen = _js2n__-prdslib.always,
                              } {} true _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "kind" ],
                            _js2n__-prdslib.records.record
                              {
                                address = _js2n__-prdslib.always,
                                bind_netns = _js2n__-prdslib.always,
                                group = _js2n__-prdslib.always,
                                ifalias = _js2n__-prdslib.always,
                                kind = _js2n__-prdslib.const "vti6",
                                master = _js2n__-prdslib.always,
                                mtu = _js2n__-prdslib.always,
                                state = _js2n__-prdslib.always,
                                txqlen = _js2n__-prdslib.always,
                              } {} true _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "kind" ],
                            _js2n__-prdslib.records.record
                              {
                                address = _js2n__-prdslib.always,
                                bond_ad_lacp_rate =
                                  _js2n__-prdslib.enum [ 0, "slow", 1, "fast" ],
                                bond_ad_select =
                                  _js2n__-prdslib.enum
                                      [
                                        0,
                                        "stable",
                                        1,
                                        "bandwidth",
                                        2,
                                        "count"
                                      ],
                                bond_all_slaves_active =
                                  _js2n__-prdslib.enum [ 0, 1 ],
                                bond_arp_all_targets =
                                  _js2n__-prdslib.enum [ 0, "any", 1, "all" ],
                                bond_arp_interval =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Integer,
                                        _js2n__-prdslib.numbers.minimum 0
                                      ],
                                bond_arp_validate =
                                  _js2n__-prdslib.enum
                                      [
                                        0,
                                        "none",
                                        1,
                                        "active",
                                        2,
                                        "backup",
                                        3,
                                        "all",
                                        4,
                                        "filter",
                                        5,
                                        "filter_active",
                                        6,
                                        "filter_backup"
                                      ],
                                bond_downdelay =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Integer,
                                        _js2n__-prdslib.numbers.minimum 0
                                      ],
                                bond_fail_over_mac =
                                  _js2n__-prdslib.enum
                                      [ 0, "none", 1, "active", 2, "follow" ],
                                bond_lp_interval =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Integer,
                                        _js2n__-prdslib.numbers.maximum
                                          2147483647,
                                        _js2n__-prdslib.numbers.minimum 0
                                      ],
                                bond_miimon =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Integer,
                                        _js2n__-prdslib.numbers.minimum 0
                                      ],
                                bond_min_links =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Integer,
                                        _js2n__-prdslib.numbers.minimum 0
                                      ],
                                bond_mode =
                                  _js2n__-prdslib.enum
                                      [
                                        0,
                                        "balance-rr",
                                        1,
                                        "active-backup",
                                        2,
                                        "balance-xor",
                                        3,
                                        "broadcast",
                                        4,
                                        "802.3ad",
                                        5,
                                        "balance-tlb",
                                        6,
                                        "balance-alb"
                                      ],
                                bond_num_peer_notif =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Integer,
                                        _js2n__-prdslib.numbers.minimum 0
                                      ],
                                bond_packets_per_slave =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Integer,
                                        _js2n__-prdslib.numbers.maximum 65535,
                                        _js2n__-prdslib.numbers.minimum 0
                                      ],
                                bond_primary_reselect =
                                  _js2n__-prdslib.enum
                                      [
                                        0,
                                        "always",
                                        1,
                                        "better",
                                        2,
                                        "failure"
                                      ],
                                bond_resend_igmp =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Integer,
                                        _js2n__-prdslib.numbers.maximum 255,
                                        _js2n__-prdslib.numbers.minimum 0
                                      ],
                                bond_tlb_dynamic_lb =
                                  _js2n__-prdslib.enum [ 0, 1 ],
                                bond_updelay =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Integer,
                                        _js2n__-prdslib.numbers.minimum 0
                                      ],
                                bond_use_carrier =
                                  _js2n__-prdslib.enum [ 0, 1 ],
                                bond_xmit_hash_policy =
                                  _js2n__-prdslib.enum
                                      [
                                        0,
                                        "layer2",
                                        1,
                                        "layer3+4",
                                        2,
                                        "layer2+3",
                                        3,
                                        "encap2+3",
                                        4,
                                        "encap3+4",
                                        5,
                                        "vlan+srcmac"
                                      ],
                                group = _js2n__-prdslib.always,
                                ifalias = _js2n__-prdslib.always,
                                kind = _js2n__-prdslib.const "bond",
                                master = _js2n__-prdslib.always,
                                mtu = _js2n__-prdslib.always,
                                state = _js2n__-prdslib.always,
                                txqlen = _js2n__-prdslib.always,
                              } {} false _js2n__-prdslib.never
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "kind" ],
                            _js2n__-prdslib.records.record
                              {
                                address = _js2n__-prdslib.always,
                                br_ageing_time =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Integer,
                                        _js2n__-prdslib.numbers.minimum 0
                                      ],
                                br_vlan_protocol =
                                  _js2n__-prdslib.enum
                                      [ 33024, "802.1q", 34984, "802.1ad" ],
                                group = _js2n__-prdslib.always,
                                ifalias = _js2n__-prdslib.always,
                                kind = _js2n__-prdslib.const "bridge",
                                master = _js2n__-prdslib.always,
                                mtu = _js2n__-prdslib.always,
                                state = _js2n__-prdslib.always,
                                txqlen = _js2n__-prdslib.always,
                              } {} true _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "kind" ],
                            _js2n__-prdslib.records.record
                              {
                                address = _js2n__-prdslib.always,
                                businfo =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType '"String",
                                        _js2n__-prdslib.strings.maxLength 32
                                      ],
                                group = _js2n__-prdslib.always,
                                ifalias = _js2n__-prdslib.always,
                                kind =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType '"String",
                                        _js2n__-prdslib.enum [ "physical" ]
                                      ],
                                master = _js2n__-prdslib.always,
                                mtu = _js2n__-prdslib.always,
                                permaddr = _js2n__-prdslib.always,
                                state = _js2n__-prdslib.always,
                                txqlen = _js2n__-prdslib.always,
                              } {} false _js2n__-prdslib.never
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "kind", "link" ],
                            _js2n__-prdslib.records.record
                              {
                                address = _js2n__-prdslib.always,
                                group = _js2n__-prdslib.always,
                                ifalias = _js2n__-prdslib.always,
                                kind = _js2n__-prdslib.const "dsa",
                                link = _js2n__-prdslib.always,
                                link_netns = _js2n__-prdslib.always,
                                master = _js2n__-prdslib.always,
                                mtu = _js2n__-prdslib.always,
                                permaddr = _js2n__-prdslib.always,
                                state = _js2n__-prdslib.always,
                                txqlen = _js2n__-prdslib.always,
                              } {} false _js2n__-prdslib.never
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "kind" ],
                            _js2n__-prdslib.records.record
                              {
                                address = _js2n__-prdslib.always,
                                group = _js2n__-prdslib.always,
                                ifalias = _js2n__-prdslib.always,
                                kind =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType '"String",
                                        _js2n__-prdslib.enum [ "dummy" ]
                                      ],
                                master = _js2n__-prdslib.always,
                                mtu = _js2n__-prdslib.always,
                                state = _js2n__-prdslib.always,
                                txqlen = _js2n__-prdslib.always,
                              } {} false _js2n__-prdslib.never
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "kind", "peer" ],
                            _js2n__-prdslib.records.record
                              {
                                address = _js2n__-prdslib.always,
                                group = _js2n__-prdslib.always,
                                ifalias = _js2n__-prdslib.always,
                                kind =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType '"String",
                                        _js2n__-prdslib.enum [ "veth", "vxcan" ]
                                      ],
                                master = _js2n__-prdslib.always,
                                mtu = _js2n__-prdslib.always,
                                peer = _js2n__-prdslib.always,
                                peer_netns =
                                  _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType '"String",
                                        _js2n__-prdslib.isType 'Null
                                      ],
                                state = _js2n__-prdslib.always,
                                txqlen = _js2n__-prdslib.always,
                              } {} false _js2n__-prdslib.never
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required
                              [ "kind", "link", "vlan_id" ],
                            _js2n__-prdslib.records.record
                              {
                                address = _js2n__-prdslib.always,
                                group = _js2n__-prdslib.always,
                                ifalias = _js2n__-prdslib.always,
                                kind = _js2n__-prdslib.const "vlan",
                                link = _js2n__-prdslib.always,
                                link_netns = _js2n__-prdslib.always,
                                master = _js2n__-prdslib.always,
                                mtu = _js2n__-prdslib.always,
                                state = _js2n__-prdslib.always,
                                txqlen = _js2n__-prdslib.always,
                                vlan_id =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.anyOf
                                          [ _js2n__-prdslib.isType 'Integer ],
                                        _js2n__-prdslib.numbers.maximum 4094,
                                        _js2n__-prdslib.numbers.minimum 0
                                      ],
                                vlan_protocol =
                                  _js2n__-prdslib.enum
                                      [ 33024, "802.1q", 34984, "802.1ad" ],
                              } {} false _js2n__-prdslib.never
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.oneOf
                                  [
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.records.required
                                          [ "vxlan_group" ],
                                        _js2n__-prdslib.records.record {} {}
                                          true _js2n__-prdslib.always
                                      ],
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.records.required
                                          [ "vxlan_group6" ],
                                        _js2n__-prdslib.records.record {} {}
                                          true _js2n__-prdslib.always
                                      ]
                                  ],
                                _js2n__-prdslib.not
                                  (_js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.records.required
                                        [ "vxlan_group", "vxlan_group6" ],
                                      _js2n__-prdslib.records.record {} {} true
                                        _js2n__-prdslib.always
                                    ])
                              ],
                            _js2n__-prdslib.records.required
                              [ "kind", "vxlan_id" ],
                            _js2n__-prdslib.records.record
                              {
                                address = _js2n__-prdslib.always,
                                bind_netns = _js2n__-prdslib.always,
                                group = _js2n__-prdslib.always,
                                ifalias = _js2n__-prdslib.always,
                                kind = _js2n__-prdslib.const "vxlan",
                                master = _js2n__-prdslib.always,
                                mtu = _js2n__-prdslib.always,
                                state = _js2n__-prdslib.always,
                                txqlen = _js2n__-prdslib.always,
                                vxlan_ageing =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Integer,
                                        _js2n__-prdslib.numbers.maximum
                                          4294967296,
                                        _js2n__-prdslib.numbers.minimum 0
                                      ],
                                vxlan_df =
                                  _js2n__-prdslib.enum
                                      [ 0, "unset", 1, "set", 2, "inherit" ],
                                vxlan_group = _js2n__-prdslib.isType '"String",
                                vxlan_group6 = _js2n__-prdslib.isType '"String",
                                vxlan_id =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Integer,
                                        _js2n__-prdslib.numbers.maximum
                                          16777215,
                                        _js2n__-prdslib.numbers.minimum 0
                                      ],
                                vxlan_l2miss =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Integer,
                                        _js2n__-prdslib.numbers.maximum 1,
                                        _js2n__-prdslib.numbers.minimum 0
                                      ],
                                vxlan_l3miss =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Integer,
                                        _js2n__-prdslib.numbers.maximum 1,
                                        _js2n__-prdslib.numbers.minimum 0
                                      ],
                                vxlan_label =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Integer,
                                        _js2n__-prdslib.numbers.maximum 1048575,
                                        _js2n__-prdslib.numbers.minimum 0
                                      ],
                                vxlan_learning =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Integer,
                                        _js2n__-prdslib.numbers.maximum 1,
                                        _js2n__-prdslib.numbers.minimum 0
                                      ],
                                vxlan_limit =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Integer,
                                        _js2n__-prdslib.numbers.maximum
                                          4294967296,
                                        _js2n__-prdslib.numbers.minimum 0
                                      ],
                                vxlan_link = _js2n__-prdslib.always,
                                vxlan_local =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType '"String",
                                        _js2n__-prdslib.oneOf
                                          [
                                            _js2n__-prdslib.always,
                                            _js2n__-prdslib.always
                                          ]
                                      ],
                                vxlan_proxy =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Integer,
                                        _js2n__-prdslib.numbers.maximum 1,
                                        _js2n__-prdslib.numbers.minimum 0
                                      ],
                                vxlan_rsc =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Integer,
                                        _js2n__-prdslib.numbers.maximum 1,
                                        _js2n__-prdslib.numbers.minimum 0
                                      ],
                                vxlan_tos =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Integer,
                                        _js2n__-prdslib.numbers.maximum 255,
                                        _js2n__-prdslib.numbers.minimum 0
                                      ],
                                vxlan_ttl =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Integer,
                                        _js2n__-prdslib.numbers.maximum 255,
                                        _js2n__-prdslib.numbers.minimum 0
                                      ],
                                vxlan_ttl_inherit =
                                  _js2n__-prdslib.isType '"Bool",
                                vxlan_udp_csum =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Integer,
                                        _js2n__-prdslib.numbers.maximum 1,
                                        _js2n__-prdslib.numbers.minimum 0
                                      ],
                              } {} false _js2n__-prdslib.never
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required
                              [ "ipip_local", "ipip_remote", "kind" ],
                            _js2n__-prdslib.records.record
                              {
                                address = _js2n__-prdslib.always,
                                bind_netns = _js2n__-prdslib.always,
                                group = _js2n__-prdslib.always,
                                ifalias = _js2n__-prdslib.always,
                                ipip_local = _js2n__-prdslib.always,
                                ipip_remote = _js2n__-prdslib.always,
                                kind = _js2n__-prdslib.const "ipip",
                                master = _js2n__-prdslib.always,
                                mtu = _js2n__-prdslib.always,
                                state = _js2n__-prdslib.always,
                                txqlen = _js2n__-prdslib.always,
                              } {} false _js2n__-prdslib.never
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required
                              [ "kind", "sit_local", "sit_remote" ],
                            _js2n__-prdslib.records.record
                              {
                                address = _js2n__-prdslib.always,
                                bind_netns = _js2n__-prdslib.always,
                                group = _js2n__-prdslib.always,
                                ifalias = _js2n__-prdslib.always,
                                kind = _js2n__-prdslib.const "sit",
                                master = _js2n__-prdslib.always,
                                mtu = _js2n__-prdslib.always,
                                sit_local = _js2n__-prdslib.always,
                                sit_remote = _js2n__-prdslib.always,
                                state = _js2n__-prdslib.always,
                                txqlen = _js2n__-prdslib.always,
                              } {} false _js2n__-prdslib.never
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required
                              [ "gre_local", "gre_remote", "kind" ],
                            _js2n__-prdslib.records.record
                              {
                                address = _js2n__-prdslib.always,
                                bind_netns = _js2n__-prdslib.always,
                                gre_link = _js2n__-prdslib.always,
                                gre_local = _js2n__-prdslib.always,
                                gre_remote = _js2n__-prdslib.always,
                                group = _js2n__-prdslib.always,
                                ifalias = _js2n__-prdslib.always,
                                kind =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType '"String",
                                        _js2n__-prdslib.enum [ "gre", "gretap" ]
                                      ],
                                master = _js2n__-prdslib.always,
                                mtu = _js2n__-prdslib.always,
                                state = _js2n__-prdslib.always,
                                txqlen = _js2n__-prdslib.always,
                              } {} false _js2n__-prdslib.never
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required
                              [ "ip6gre_local", "ip6gre_remote", "kind" ],
                            _js2n__-prdslib.records.record
                              {
                                address = _js2n__-prdslib.always,
                                bind_netns = _js2n__-prdslib.always,
                                group = _js2n__-prdslib.always,
                                ifalias = _js2n__-prdslib.always,
                                ip6gre_link = _js2n__-prdslib.always,
                                ip6gre_local = _js2n__-prdslib.always,
                                ip6gre_remote = _js2n__-prdslib.always,
                                kind =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType '"String",
                                        _js2n__-prdslib.enum
                                          [ "ip6gre", "ip6gretap" ]
                                      ],
                                master = _js2n__-prdslib.always,
                                mtu = _js2n__-prdslib.always,
                                state = _js2n__-prdslib.always,
                                txqlen = _js2n__-prdslib.always,
                              } {} false _js2n__-prdslib.never
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required
                              [ "geneve_id", "geneve_remote", "kind" ],
                            _js2n__-prdslib.records.record
                              {
                                address = _js2n__-prdslib.always,
                                bind_netns = _js2n__-prdslib.always,
                                geneve_id =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.anyOf
                                          [ _js2n__-prdslib.isType 'Integer ],
                                        _js2n__-prdslib.numbers.maximum
                                          16777215,
                                        _js2n__-prdslib.numbers.minimum 0
                                      ],
                                geneve_remote = _js2n__-prdslib.always,
                                group = _js2n__-prdslib.always,
                                ifalias = _js2n__-prdslib.always,
                                kind = _js2n__-prdslib.const "geneve",
                                master = _js2n__-prdslib.always,
                                mtu = _js2n__-prdslib.always,
                                state = _js2n__-prdslib.always,
                                txqlen = _js2n__-prdslib.always,
                              } {} false _js2n__-prdslib.never
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required
                              [ "geneve_id", "geneve_remote6", "kind" ],
                            _js2n__-prdslib.records.record
                              {
                                address = _js2n__-prdslib.always,
                                bind_netns = _js2n__-prdslib.always,
                                geneve_id =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.anyOf
                                          [ _js2n__-prdslib.isType 'Integer ],
                                        _js2n__-prdslib.numbers.maximum
                                          16777215,
                                        _js2n__-prdslib.numbers.minimum 0
                                      ],
                                geneve_remote6 = _js2n__-prdslib.always,
                                group = _js2n__-prdslib.always,
                                ifalias = _js2n__-prdslib.always,
                                kind = _js2n__-prdslib.const "geneve",
                                master = _js2n__-prdslib.always,
                                mtu = _js2n__-prdslib.always,
                                state = _js2n__-prdslib.always,
                                txqlen = _js2n__-prdslib.always,
                              } {} false _js2n__-prdslib.never
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "kind" ],
                            _js2n__-prdslib.records.record
                              {
                                address = _js2n__-prdslib.always,
                                bind_netns = _js2n__-prdslib.always,
                                group = _js2n__-prdslib.always,
                                ifalias = _js2n__-prdslib.always,
                                kind = _js2n__-prdslib.const "wireguard",
                                master = _js2n__-prdslib.always,
                                mtu = _js2n__-prdslib.always,
                                state = _js2n__-prdslib.always,
                                txqlen = _js2n__-prdslib.always,
                              } {} false _js2n__-prdslib.never
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required
                              [ "kind", "xfrm_if_id" ],
                            _js2n__-prdslib.records.record
                              {
                                address = _js2n__-prdslib.always,
                                bind_netns = _js2n__-prdslib.always,
                                group = _js2n__-prdslib.always,
                                ifalias = _js2n__-prdslib.always,
                                kind = _js2n__-prdslib.const "xfrm",
                                master = _js2n__-prdslib.always,
                                mtu = _js2n__-prdslib.always,
                                state = _js2n__-prdslib.always,
                                txqlen = _js2n__-prdslib.always,
                                xfrm_if_id =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.anyOf
                                          [ _js2n__-prdslib.isType 'Integer ],
                                        _js2n__-prdslib.numbers.maximum
                                          4294967295,
                                        _js2n__-prdslib.numbers.minimum 0
                                      ],
                                xfrm_link = _js2n__-prdslib.always,
                              } {} false _js2n__-prdslib.never
                          ]
                      ],
                    _js2n__-prdslib.records.required [ "kind" ],
                    _js2n__-prdslib.records.record {} {} true
                      _js2n__-prdslib.always
                  ])
              | doc "link settings of the interface",
            name | Dyn | doc "name of the interface",
            neighbours
              | Array
                {
                  dst | String | doc "protocol address of the neighbour",
                  lladdr
                    | Dyn
                    | doc "link layer address of the neighbour"
                    | optional,
                }
              | doc "static ARP or NDISC cache entries"
              | optional,
            sysctl
              | {
                ipv4 | Dyn | optional,
                ipv6 | Dyn | optional,
                mpls | Dyn | optional,
              }
              | doc "interface sysctl settings"
              | optional,
            tc
              | {
                filter
                  | Array (
                    _js2n__-prdslib.contract_from_predicate
                      (_js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.oneOf
                            [
                              _js2n__-prdslib.records.record
                                {
                                  action = _js2n__-prdslib.always,
                                  kind =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.enum [ "basic" ]
                                        ],
                                  "match" = _js2n__-prdslib.isType 'Record,
                                  prio = _js2n__-prdslib.always,
                                  protocol = _js2n__-prdslib.always,
                                } {} false _js2n__-prdslib.never,
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.records.required
                                            [ "key", "kind", "mode" ],
                                          _js2n__-prdslib.records.record
                                            {
                                              key =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"String",
                                                      _js2n__-prdslib.enum
                                                        [
                                                          "src",
                                                          "dst",
                                                          "proto",
                                                          "proto-src",
                                                          "proto-dst",
                                                          "iif",
                                                          "priority",
                                                          "mark",
                                                          "nfct",
                                                          "nfct-src",
                                                          "nfct-dst",
                                                          "nfct-proto-src",
                                                          "nfct-proto-dst",
                                                          "rt-classid",
                                                          "sk-uid",
                                                          "sk-gid",
                                                          "vlan-tag",
                                                          "rxhash"
                                                        ]
                                                    ],
                                              mode =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"String",
                                                      _js2n__-prdslib.enum
                                                        [ "map" ]
                                                    ],
                                            } {} true _js2n__-prdslib.always
                                        ],
                                      _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.records.required
                                            [ "keys", "kind", "mode" ],
                                          _js2n__-prdslib.records.record
                                            {
                                              keys =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"Array",
                                                      _js2n__-prdslib.arrays.arrayOf
                                                        (_js2n__-prdslib.allOf
                                                          [
                                                            _js2n__-prdslib.isType
                                                              '"String",
                                                            _js2n__-prdslib.enum
                                                              [
                                                                "src",
                                                                "dst",
                                                                "proto",
                                                                "proto-src",
                                                                "proto-dst",
                                                                "iif",
                                                                "priority",
                                                                "mark",
                                                                "nfct",
                                                                "nfct-src",
                                                                "nfct-dst",
                                                                "nfct-proto-src",
                                                                "nfct-proto-dst",
                                                                "rt-classid",
                                                                "sk-uid",
                                                                "sk-gid",
                                                                "vlan-tag",
                                                                "rxhash"
                                                              ]
                                                          ])
                                                    ],
                                              mode =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"String",
                                                      _js2n__-prdslib.enum
                                                        [ "hash" ]
                                                    ],
                                              perturb =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        'Integer,
                                                      _js2n__-prdslib.numbers.maximum
                                                        294967295,
                                                      _js2n__-prdslib.numbers.minimum
                                                        0
                                                    ],
                                            } {} true _js2n__-prdslib.always
                                        ]
                                    ],
                                  _js2n__-prdslib.records.record
                                    {
                                      action = _js2n__-prdslib.always,
                                      addend =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Integer,
                                              _js2n__-prdslib.numbers.maximum
                                                4294967295,
                                              _js2n__-prdslib.numbers.minimum 0
                                            ],
                                      and =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Integer,
                                              _js2n__-prdslib.numbers.maximum
                                                4294967295,
                                              _js2n__-prdslib.numbers.minimum 0
                                            ],
                                      baseclass =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Integer,
                                              _js2n__-prdslib.numbers.maximum
                                                65535,
                                              _js2n__-prdslib.numbers.minimum 0
                                            ],
                                      divisor =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Integer,
                                              _js2n__-prdslib.numbers.maximum
                                                4294967295,
                                              _js2n__-prdslib.numbers.minimum 0
                                            ],
                                      kind =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-prdslib.enum [ "flow" ]
                                            ],
                                      or =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Integer,
                                              _js2n__-prdslib.numbers.maximum
                                                4294967295,
                                              _js2n__-prdslib.numbers.minimum 0
                                            ],
                                      prio = _js2n__-prdslib.always,
                                      protocol = _js2n__-prdslib.always,
                                      rshift =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Integer,
                                              _js2n__-prdslib.numbers.maximum
                                                4294967295,
                                              _js2n__-prdslib.numbers.minimum 0
                                            ],
                                      xor =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Integer,
                                              _js2n__-prdslib.numbers.maximum
                                                4294967295,
                                              _js2n__-prdslib.numbers.minimum 0
                                            ],
                                    } {} true _js2n__-prdslib.always
                                ],
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "handle", "kind" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      action = _js2n__-prdslib.always,
                                      handle =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Integer,
                                              _js2n__-prdslib.numbers.minimum 0
                                            ],
                                      kind =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-prdslib.enum [ "fw" ]
                                            ],
                                      prio = _js2n__-prdslib.always,
                                      protocol = _js2n__-prdslib.always,
                                    } {} false _js2n__-prdslib.never
                                ],
                              _js2n__-prdslib.records.record
                                {
                                  action = _js2n__-prdslib.always,
                                  classid =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Integer,
                                          _js2n__-prdslib.numbers.maximum
                                            4294967295,
                                          _js2n__-prdslib.numbers.minimum 0
                                        ],
                                  flags =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Integer,
                                          _js2n__-prdslib.numbers.maximum
                                            4294967295,
                                          _js2n__-prdslib.numbers.minimum 0
                                        ],
                                  kind =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.enum [ "matchall" ]
                                        ],
                                  parent = _js2n__-prdslib.always,
                                  prio = _js2n__-prdslib.always,
                                  protocol = _js2n__-prdslib.always,
                                } {} false _js2n__-prdslib.never
                            ],
                          _js2n__-prdslib.records.required [ "kind" ],
                          _js2n__-prdslib.records.record
                            {
                              kind =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [ "basic", "flow", "fw", "matchall" ]
                                    ],
                            } {} true _js2n__-prdslib.always
                        ])
                  )
                  | doc "filter used by qdiscs"
                  | optional,
                ingress
                  | Bool
                  | doc "enable the ingress qdisc for policing and shaping in ingress"
                  | optional,
                qdisc | Dyn | doc "root queueing disciplines" | optional,
              }
              | doc "settings for traffic control"
              | optional,
            vrrp | Dyn | optional,
            wireguard
              | {
                fwmark
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Integer,
                        _js2n__-prdslib.numbers.maximum 4294967295,
                        _js2n__-prdslib.numbers.minimum 0
                      ])
                  | doc "fwmark for outgoing packets"
                  | optional,
                listen_port
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Integer,
                        _js2n__-prdslib.numbers.maximum 65535,
                        _js2n__-prdslib.numbers.minimum 0
                      ])
                  | doc "port for listening"
                  | optional,
                peers
                  | Array
                    {
                      allowedips
                        | Array (String)
                        | doc "list of prefixes in CIDR notation"
                        | optional,
                      endpoint
                        | String
                        | doc "initial endpoint IP or hostname"
                        | optional,
                      persistent_keepalive_interval
                        | _js2n__-prdslib.contract_from_predicate
                          (_js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.numbers.maximum 65535,
                              _js2n__-prdslib.numbers.minimum 0
                            ])
                        | doc "keepalive interval seconds"
                        | optional,
                      preshared_key
                        | String
                        | doc "preshared key for post-quantum resistance (consider to use the `!include` tag to read the key from file)"
                        | optional,
                      public_key | String | doc "the peer's public key",
                    }
                  | doc "list of peer definitions"
                  | optional,
                private_key
                  | String
                  | doc "local private key (consider to use the `!include` tag to read the key from file)",
              }
              | doc "settings for WireGuard interfaces"
              | optional,
            xdp
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.oneOf
                  [
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"Bool",
                        _js2n__-prdslib.enum [ false ]
                      ],
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.required [ "pinned" ],
                        _js2n__-prdslib.records.record
                          {
                            mode = _js2n__-prdslib.always,
                            pinned = _js2n__-prdslib.isType '"String",
                          } {} false _js2n__-prdslib.never
                      ],
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.required [ "bpf" ],
                        _js2n__-prdslib.records.record
                          {
                            bpf = _js2n__-prdslib.isType '"String",
                            mode = _js2n__-prdslib.always,
                          } {} false _js2n__-prdslib.never
                      ]
                  ])
              | doc "settings for XDP (\"eXpress Data Path\") BPF program"
              | optional,
          }
        | doc "list of interface settings (link settings and ip addresses)",
      namespaces
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  ".+" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.required [ "interfaces" ],
                          _js2n__-prdslib.records.record
                            {
                              bpf =
                                _js2n__-refsenv."_js2n__-:properties/bpf!predicate",
                              interfaces =
                                _js2n__-refsenv."_js2n__-:properties/interfaces!predicate",
                              options =
                                _js2n__-refsenv."_js2n__-:properties/options!predicate",
                              routing =
                                _js2n__-refsenv."_js2n__-:properties/routing!predicate",
                            } {} false _js2n__-prdslib.never
                        ],
                } false _js2n__-prdslib.never
            ])
        | optional,
      options
        | {
          sysctl
            | {
              all
                | { ipv4 | Dyn | optional, ipv6 | Dyn | optional, }
                | doc "overrides [per interface sysctl settings](https://www.kernel.org/doc/Documentation/networking/ip-sysctl.txt) in `/proc/sys/net/ipv*/conf/all/`"
                | optional,
              "default"
                | { ipv4 | Dyn | optional, ipv6 | Dyn | optional, }
                | doc "default [per interface sysctl settings](https://www.kernel.org/doc/Documentation/networking/ip-sysctl.txt) in `/proc/sys/net/ipv*/conf/default/`"
                | optional,
              mpls | Dyn | optional,
            }
            | doc "global sysctl settings"
            | optional,
        }
        | doc "global configuration settings"
        | optional,
      routing
        | {
          routes
            | Array
              {
                dev
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.isType 'Integer,
                        _js2n__-prdslib.isType '"String"
                      ])
                  | doc "the output device name"
                  | optional,
                preference
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Integer,
                        _js2n__-prdslib.numbers.maximum 4294967295,
                        _js2n__-prdslib.numbers.minimum 0
                      ])
                  | doc "preference of the route"
                  | optional,
                proto
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.isType 'Integer,
                        _js2n__-prdslib.isType '"String"
                      ])
                  | doc "the routing protool identifier of this route"
                  | optional,
                realm
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.isType 'Integer,
                        _js2n__-prdslib.isType '"String"
                      ])
                  | doc "the realm to which this route is assigned"
                  | optional,
                scope
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.isType 'Integer,
                        _js2n__-prdslib.isType '"String"
                      ])
                  | doc "the scope of the destinations covered by the route prefix"
                  | optional,
                src
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.oneOf
                          [ _js2n__-prdslib.always, _js2n__-prdslib.always ]
                      ])
                  | doc "the source address to prefer"
                  | optional,
                table
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.isType 'Integer,
                        _js2n__-prdslib.isType '"String"
                      ])
                  | doc "the table to add this route to"
                  | optional,
                to | String | doc "the destination prefix of the route",
                type
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.isType 'Integer,
                            _js2n__-prdslib.isType '"String"
                          ],
                        _js2n__-prdslib.enum
                          [
                            "unicast",
                            "local",
                            "broadcast",
                            "anycast",
                            "multicast",
                            "blackhole",
                            "unreachable",
                            "prohibit",
                            "throw",
                            "nat",
                            "xresolve"
                          ],
                        _js2n__-prdslib.numbers.maximum 11,
                        _js2n__-prdslib.numbers.minimum 1
                      ])
                  | doc "the type of this route"
                  | optional,
                via
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.oneOf
                          [ _js2n__-prdslib.always, _js2n__-prdslib.always ]
                      ])
                  | doc "address of the nexthop router"
                  | optional,
                vrrp | Dyn | optional,
              }
            | optional,
          rules
            | Array (
              _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.ifThenElse
                      (_js2n__-prdslib.records.record
                        { action = _js2n__-prdslib.const "to_tbl", } {} true
                        _js2n__-prdslib.always)
                      (_js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.required
                            [ "priority", "table" ],
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-prdslib.always
                        ])
                      (_js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.required [ "priority" ],
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-prdslib.always
                        ]),
                    _js2n__-prdslib.records.record
                      {
                        action =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.anyOf
                                  [
                                    _js2n__-prdslib.isType 'Integer,
                                    _js2n__-prdslib.isType '"String"
                                  ],
                                _js2n__-prdslib.enum
                                  [
                                    "to_tbl",
                                    "blackhole",
                                    "unreachable",
                                    "prohibit"
                                  ]
                              ],
                        from = _js2n__-prdslib.isType '"String",
                        fwmark = _js2n__-prdslib.isType 'Integer,
                        iif = _js2n__-prdslib.isType '"String",
                        ipproto =
                          _js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.isType 'Integer,
                                _js2n__-prdslib.isType '"String"
                              ],
                        oif = _js2n__-prdslib.isType '"String",
                        "priority" =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Integer,
                                _js2n__-prdslib.numbers.maximum 4294967295,
                                _js2n__-prdslib.numbers.minimum 0
                              ],
                        proto =
                          _js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.isType 'Integer,
                                _js2n__-prdslib.isType '"String"
                              ],
                        table =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.anyOf
                                  [
                                    _js2n__-prdslib.isType 'Integer,
                                    _js2n__-prdslib.isType '"String"
                                  ],
                                _js2n__-prdslib.numbers.maximum 255,
                                _js2n__-prdslib.numbers.minimum 0
                              ],
                        to = _js2n__-prdslib.isType '"String",
                        vrrp = _js2n__-prdslib.always,
                      } {} false _js2n__-prdslib.never
                  ])
            )
            | optional,
        }
        | optional,
    }