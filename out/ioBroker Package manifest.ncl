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
      "_js2n__-:definitions/disallowNodeProcessParams!predicate" =
        _js2n__-prdslib.not
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.records.required [ "nodeProcessParams" ],
                _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
              ]),
      "_js2n__-:definitions/iobrokerObject!contract" =
        { _id | String, common | {  .. } | optional, type | String, .. },
      "_js2n__-:definitions/isCompactTrue!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.records.required [ "compact" ],
              _js2n__-prdslib.records.record
                { compact = _js2n__-prdslib.const true, } {} true
                _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/license!predicate"
        | doc "The license this software is published under."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "DSDP",
                  "NIST-PD",
                  "CC-BY-NC-SA-2.0",
                  "NLOD-1.0",
                  "RHeCos-1.1",
                  "GFDL-1.3-no-invariants-only",
                  "RSCPL",
                  "ASWF-Digital-Assets-1.1",
                  "GLWTPL",
                  "Info-ZIP",
                  "LPPL-1.3c",
                  "zlib-acknowledgement",
                  "checkmk",
                  "OLDAP-2.8",
                  "cve-tou",
                  "MirOS",
                  "Parity-6.0.0",
                  "CC-BY-SA-2.1-JP",
                  "InnoSetup",
                  "IPL-1.0",
                  "Spencer-86",
                  "JPNIC",
                  "OpenVision",
                  "SGP4",
                  "MPL-1.1",
                  "BSD-3-Clause-Clear",
                  "AML-glslang",
                  "Vim",
                  "Community-Spec-1.0",
                  "OSL-3.0",
                  "CrystalStacker",
                  "MPL-1.0",
                  "OLDAP-1.2",
                  "Sendmail-8.23",
                  "CMU-Mach",
                  "xpp",
                  "ECL-1.0",
                  "Plexus",
                  "Elastic-2.0",
                  "CPL-1.0",
                  "GFDL-1.2-no-invariants-only",
                  "OPL-1.0",
                  "CC-BY-SA-4.0",
                  "ADSL",
                  "SGI-B-1.1",
                  "XFree86-1.1",
                  "Latex2e-translated-notice",
                  "IPA",
                  "psutils",
                  "CC-BY-NC-ND-3.0",
                  "FSFULLR",
                  "SSLeay-standalone",
                  "MMIXware",
                  "Graphics-Gems",
                  "HPND-export-US-acknowledgement",
                  "CC-BY-NC-2.0",
                  "OLDAP-1.3",
                  "LGPL-2.1-only",
                  "NLOD-2.0",
                  "BSD-2-Clause",
                  "mailprio",
                  "CC-BY-SA-3.0",
                  "Noweb",
                  "Soundex",
                  "CECILL-1.0",
                  "Aladdin",
                  "SSH-OpenSSH",
                  "BSD-Attribution-HPND-disclaimer",
                  "CC-BY-NC-SA-2.0-UK",
                  "Kazlib",
                  "Ubuntu-font-1.0",
                  "SGI-OpenGL",
                  "Rdisc",
                  "HPND-sell-variant-MIT-disclaimer",
                  "LGPLLR",
                  "OAR",
                  "HTMLTIDY",
                  "AMPAS",
                  "NOSL",
                  "fwlw",
                  "w3m",
                  "Latex2e",
                  "O-UDA-1.0",
                  "mplus",
                  "HPND-Intel",
                  "PPL",
                  "OFL-1.1-RFN",
                  "EPL-1.0",
                  "HPND-UC-export-US",
                  "CC-BY-3.0-DE",
                  "SNIA",
                  "Barr",
                  "OLDAP-2.1",
                  "CC-BY-ND-4.0",
                  "softSurfer",
                  "LGPL-2.1-or-later",
                  "OFL-1.0",
                  "BSD-3-Clause-flex",
                  "psfrag",
                  "BSD-1-Clause",
                  "BSD-3-Clause-No-Military-License",
                  "Cube",
                  "LPPL-1.2",
                  "OLDAP-2.2.2",
                  "TTWL",
                  "CC-BY-3.0",
                  "BSD-3-Clause-Open-MPI",
                  "CC-BY-NC-ND-3.0-IGO",
                  "ZPL-2.1",
                  "CC0-1.0",
                  "NPL-1.0",
                  "CECILL-2.0",
                  "wwl",
                  "NGPL",
                  "FSFAP",
                  "any-OSI",
                  "mpich2",
                  "EUDatagrid",
                  "Sleepycat",
                  "AFL-3.0",
                  "Arphic-1999",
                  "BSD-4-Clause-UC",
                  "dtoa",
                  "Unicode-DFS-2015",
                  "TCP-wrappers",
                  "MIT-0",
                  "SugarCRM-1.1.3",
                  "iMatix",
                  "CC-BY-3.0-AT",
                  "Adobe-2006",
                  "LOOP",
                  "MIT-testregex",
                  "eGenix",
                  "GCR-docs",
                  "AAL",
                  "CAL-1.0",
                  "PHP-3.0",
                  "hdparm",
                  "OpenPBS-2.3",
                  "DL-DE-BY-2.0",
                  "GFDL-1.3-or-later",
                  "CERN-OHL-1.2",
                  "MIT",
                  "XSkat",
                  "Gutmann",
                  "CC-BY-NC-SA-2.5",
                  "PDDL-1.0",
                  "Unlicense",
                  "CUA-OPL-1.0",
                  "NCL",
                  "GFDL-1.1-invariants-or-later",
                  "CECILL-2.1",
                  "PolyForm-Small-Business-1.0.0",
                  "HP-1986",
                  "HPND-export-US",
                  "X11-swapped",
                  "SHL-0.5",
                  "BSD-Systemics",
                  "CDLA-Sharing-1.0",
                  "GFDL-1.1-or-later",
                  "Newsletr",
                  "TMate",
                  "EPICS",
                  "SAX-PD",
                  "MIT-Festival",
                  "LGPL-2.0-or-later",
                  "QPL-1.0",
                  "SSH-short",
                  "OGL-UK-1.0",
                  "GPL-2.0-only",
                  "ECL-2.0",
                  "CATOSL-1.1",
                  "Cornell-Lossless-JPEG",
                  "DOC",
                  "RSA-MD",
                  "OCLC-2.0",
                  "AGPL-3.0-only",
                  "OLDAP-2.5",
                  "CC-BY-SA-3.0-DE",
                  "Artistic-1.0-Perl",
                  "CC-BY-NC-ND-4.0",
                  "BSD-3-Clause-No-Nuclear-License-2014",
                  "Martin-Birgmeier",
                  "EUPL-1.0",
                  "McPhee-slideshow",
                  "CC-BY-NC-ND-1.0",
                  "BlueOak-1.0.0",
                  "ODC-By-1.0",
                  "COIL-1.0",
                  "Bitstream-Vera",
                  "JPL-image",
                  "MIT-enna",
                  "BSD-Inferno-Nettverk",
                  "CDDL-1.1",
                  "FSFULLRWD",
                  "GFDL-1.2-invariants-only",
                  "EFL-1.0",
                  "Entessa",
                  "Glide",
                  "CC-BY-NC-3.0-DE",
                  "Artistic-1.0-cl8",
                  "W3C-19980720",
                  "HPND-merchantability-variant",
                  "Motosoto",
                  "OLDAP-1.1",
                  "HP-1989",
                  "IEC-Code-Components-EULA",
                  "NCGL-UK-2.0",
                  "CC-BY-3.0-IGO",
                  "BSD-Source-Code",
                  "GFDL-1.1-no-invariants-only",
                  "W3C",
                  "magaz",
                  "libutil-David-Nugent",
                  "AFL-2.1",
                  "NAIST-2003",
                  "DocBook-XML",
                  "LiLiQ-Rplus-1.1",
                  "MIT-feh",
                  "UMich-Merit",
                  "CC-BY-NC-3.0",
                  "NTP",
                  "Frameworx-1.0",
                  "HPND-sell-variant",
                  "CC-BY-1.0",
                  "APL-1.0",
                  "WTFPL",
                  "FBM",
                  "ClArtistic",
                  "SunPro",
                  "VSL-1.0",
                  "CC-BY-NC-SA-3.0-IGO",
                  "NBPL-1.0",
                  "OPUBL-1.0",
                  "CC-BY-NC-ND-2.0",
                  "BSD-3-Clause-LBNL",
                  "Ruby",
                  "Fair",
                  "MIT-advertising",
                  "OGDL-Taiwan-1.0",
                  "OPL-UK-3.0",
                  "MPL-2.0",
                  "DocBook-Stylesheet",
                  "TPL-1.0",
                  "TAPR-OHL-1.0",
                  "UnixCrypt",
                  "FreeBSD-DOC",
                  "CMU-Mach-nodoc",
                  "CC-BY-3.0-AU",
                  "Zimbra-1.4",
                  "BSD-3-Clause",
                  "lsof",
                  "FreeImage",
                  "OLDAP-2.0",
                  "APSL-1.2",
                  "APSL-1.0",
                  "CC-BY-NC-SA-2.0-FR",
                  "D-FSL-1.0",
                  "pnmstitch",
                  "CC-BY-SA-2.0-UK",
                  "CERN-OHL-W-2.0",
                  "LPL-1.02",
                  "CNRI-Jython",
                  "BSD-2-Clause-first-lines",
                  "BSL-1.0",
                  "LZMA-SDK-9.11-to-9.20",
                  "Condor-1.1",
                  "CC-BY-3.0-US",
                  "CECILL-C",
                  "diffmark",
                  "HPND-Kevlin-Henney",
                  "RPL-1.1",
                  "Hippocratic-2.1",
                  "swrule",
                  "CDDL-1.0",
                  "MS-RL",
                  "any-OSI-perl-modules",
                  "CNRI-Python",
                  "OLDAP-2.3",
                  "LiLiQ-P-1.1",
                  "Python-2.0.1",
                  "MakeIndex",
                  "AFL-1.2",
                  "CC-BY-ND-2.0",
                  "FDK-AAC",
                  "SL",
                  "TU-Berlin-1.0",
                  "Saxpath",
                  "dvipdfm",
                  "BSD-2-Clause-Darwin",
                  "CPAL-1.0",
                  "copyleft-next-0.3.1",
                  "NetCDF",
                  "FTL",
                  "DocBook-Schema",
                  "CERN-OHL-S-2.0",
                  "X11-distribute-modifications-variant",
                  "copyleft-next-0.3.0",
                  "X11",
                  "CC-BY-NC-SA-2.0-DE",
                  "GFDL-1.3-only",
                  "Bahyph",
                  "LGPL-3.0-or-later",
                  "ZPL-1.1",
                  "gSOAP-1.3b",
                  "JasPer-2.0",
                  "Sendmail-Open-Source-1.1",
                  "BUSL-1.1",
                  "Eurosym",
                  "ThirdEye",
                  "CC-SA-1.0",
                  "Watcom-1.0",
                  "Caldera",
                  "Parity-7.0.0",
                  "SMPPL",
                  "MulanPSL-2.0",
                  "Afmparse",
                  "GFDL-1.2-no-invariants-or-later",
                  "Lucida-Bitmap-Fonts",
                  "DRL-1.0",
                  "CC-BY-NC-2.5",
                  "GD",
                  "Zend-2.0",
                  "Cronyx",
                  "TTYP0",
                  "CC-BY-ND-1.0",
                  "Ferguson-Twofish",
                  "SchemeReport",
                  "MIT-Khronos-old",
                  "LPD-document",
                  "UPL-1.0",
                  "CECILL-1.1",
                  "Crossword",
                  "C-UDA-1.0",
                  "BSD-3-Clause-HP",
                  "Apache-1.0",
                  "CERN-OHL-1.1",
                  "SISSL",
                  "MPL-2.0-no-copyleft-exception",
                  "OLFL-1.3",
                  "Inner-Net-2.0",
                  "GPL-1.0-only",
                  "LiLiQ-R-1.1",
                  "BSD-4.3TAHOE",
                  "AFL-2.0",
                  "GFDL-1.2-invariants-or-later",
                  "CC-BY-NC-ND-2.5",
                  "OLDAP-2.4",
                  "Brian-Gladman-3-Clause",
                  "gtkbook",
                  "OFL-1.0-no-RFN",
                  "LAL-1.3",
                  "threeparttable",
                  "Imlib2",
                  "Adobe-Display-PostScript",
                  "Xnet",
                  "OSL-2.1",
                  "OLDAP-2.2",
                  "MS-LPL",
                  "Mup",
                  "BSD-4.3RENO",
                  "MIT-Click",
                  "W3C-20150513",
                  "GPL-1.0-or-later",
                  "OSL-2.0",
                  "EPL-2.0",
                  "ASWF-Digital-Assets-1.0",
                  "APSL-1.1",
                  "HPND",
                  "Linux-OpenIB",
                  "Zeeff",
                  "OGL-UK-3.0",
                  "CC-BY-ND-3.0-DE",
                  "BSD-4-Clause-Shortened",
                  "gnuplot",
                  "libpng-2.0",
                  "Leptonica",
                  "Clips",
                  "OpenSSL",
                  "Sendmail",
                  "NCBI-PD",
                  "TrustedQSL",
                  "Catharon",
                  "EUPL-1.2",
                  "Wsuipa",
                  "OGL-UK-2.0",
                  "ISC-Veillard",
                  "CC-BY-3.0-NL",
                  "AdaCore-doc",
                  "AGPL-1.0-only",
                  "libselinux-1.0",
                  "HPND-Fenneberg-Livingston",
                  "Xdebug-1.03",
                  "Jam",
                  "check-cvs",
                  "AMD-newlib",
                  "CC-BY-NC-1.0",
                  "xinetd",
                  "BSD-4-Clause",
                  "IBM-pibs",
                  "Apache-2.0",
                  "Linux-man-pages-1-para",
                  "CPOL-1.02",
                  "BSD-Source-beginning-file",
                  "CERN-OHL-P-2.0",
                  "OFFIS",
                  "GPL-2.0-or-later",
                  "radvd",
                  "Xfig",
                  "Multics",
                  "AFL-1.1",
                  "Beerware",
                  "MS-PL",
                  "ssh-keyscan",
                  "Spencer-99",
                  "OFL-1.1",
                  "Baekmuk",
                  "Qhull",
                  "GFDL-1.2-or-later",
                  "CC-BY-NC-SA-4.0",
                  "APSL-2.0",
                  "VOSTROM",
                  "HPND-doc",
                  "NRL",
                  "TPDL",
                  "AGPL-1.0-or-later",
                  "HPND-Markus-Kuhn",
                  "LZMA-SDK-9.22",
                  "Unicode-3.0",
                  "GPL-3.0-or-later",
                  "OpenSSL-standalone",
                  "Zimbra-1.3",
                  "xkeyboard-config-Zinoviev",
                  "GFDL-1.1-invariants-only",
                  "OML",
                  "ANTLR-PD",
                  "HPND-MIT-disclaimer",
                  "Dotseqn",
                  "HPND-DEC",
                  "LGPL-2.0-only",
                  "CC-BY-2.5-AU",
                  "DEC-3-Clause",
                  "QPL-1.0-INRIA-2004",
                  "Intel",
                  "NIST-PD-fallback",
                  "CC-BY-NC-4.0",
                  "BSD-3-Clause-No-Nuclear-Warranty",
                  "HPND-UC",
                  "MIT-Wu",
                  "Kastrup",
                  "MIT-CMU",
                  "DL-DE-ZERO-2.0",
                  "NIST-Software",
                  "Spencer-94",
                  "CC-BY-2.0",
                  "EUPL-1.1",
                  "HPND-export-US-modify",
                  "generic-xts",
                  "NLPL",
                  "NCSA",
                  "PSF-2.0",
                  "Linux-man-pages-copyleft-var",
                  "OSL-1.1",
                  "mpi-permissive",
                  "Glulxe",
                  "LAL-1.2",
                  "SMAIL-GPL",
                  "NASA-1.3",
                  "SPL-1.0",
                  "BSD-Advertising-Acknowledgement",
                  "BSD-3-Clause-Modification",
                  "3D-Slicer-1.0",
                  "NPL-1.1",
                  "IJG-short",
                  "CC-BY-4.0",
                  "ulem",
                  "BSD-3-Clause-Sun",
                  "SAX-PD-2.0",
                  "TORQUE-1.1",
                  "TU-Berlin-2.0",
                  "Borceux",
                  "0BSD",
                  "Mackerras-3-Clause",
                  "GFDL-1.3-invariants-or-later",
                  "Knuth-CTAN",
                  "SMLNJ",
                  "NPOSL-3.0",
                  "OLDAP-1.4",
                  "Intel-ACPI",
                  "Adobe-Glyph",
                  "BSD-3-Clause-Attribution",
                  "metamail",
                  "Zed",
                  "Sun-PPP-2000",
                  "SGI-B-1.0",
                  "xlock",
                  "SCEA",
                  "Artistic-2.0",
                  "ICU",
                  "CC-BY-2.5",
                  "SHL-0.51",
                  "LPPL-1.3a",
                  "CDLA-Permissive-1.0",
                  "EFL-2.0",
                  "URT-RLE",
                  "HPND-sell-regexpr",
                  "GFDL-1.3-no-invariants-or-later",
                  "AMDPLPA",
                  "Bitstream-Charter",
                  "python-ldap",
                  "CC-BY-SA-3.0-AT",
                  "OGC-1.0",
                  "CC-BY-SA-2.0",
                  "PADL",
                  "NICTA-1.0",
                  "LPL-1.0",
                  "LPPL-1.1",
                  "CDL-1.0",
                  "Boehm-GC",
                  "Sun-PPP",
                  "OLDAP-2.2.1",
                  "AGPL-3.0-or-later",
                  "OLDAP-2.6",
                  "BSD-3-Clause-No-Nuclear-License",
                  "BSD-Protection",
                  "OCCT-PL",
                  "YPL-1.0",
                  "MIPS",
                  "SGI-B-2.0",
                  "MIT-open-group",
                  "AML",
                  "OSL-1.0",
                  "GFDL-1.3-invariants-only",
                  "Symlinks",
                  "Ruby-pty",
                  "UCAR",
                  "SimPL-2.0",
                  "PolyForm-Noncommercial-1.0.0",
                  "OFL-1.1-no-RFN",
                  "Furuseth",
                  "Mackerras-3-Clause-acknowledgment",
                  "CC-PDM-1.0",
                  "Zlib",
                  "BSD-2-Clause-Views",
                  "Interbase-1.0",
                  "LGPL-3.0-only",
                  "CC-BY-NC-SA-3.0",
                  "MIT-Modern-Variant",
                  "Unicode-TOU",
                  "APAFML",
                  "TCL",
                  "Xerox",
                  "FSFUL",
                  "FSFAP-no-warranty-disclaimer",
                  "Artistic-1.0",
                  "ImageMagick",
                  "Brian-Gladman-2-Clause",
                  "BitTorrent-1.1",
                  "GPL-3.0-only",
                  "Linux-man-pages-copyleft",
                  "NTP-0",
                  "curl",
                  "MITNFA",
                  "libtiff",
                  "ErlPL-1.1",
                  "Adobe-Utopia",
                  "HaskellReport",
                  "ISC",
                  "Naumen",
                  "CC-BY-SA-1.0",
                  "etalab-2.0",
                  "MPEG-SSG",
                  "CFITSIO",
                  "MulanPSL-1.0",
                  "BSD-2-Clause-Patent",
                  "CC-PDDC",
                  "TGPPL-1.0",
                  "snprintf",
                  "Boehm-GC-without-fee",
                  "Pixar",
                  "HPND-Netrek",
                  "Minpack",
                  "GFDL-1.1-only",
                  "HPND-INRIA-IMAG",
                  "App-s2p",
                  "BSD-3-Clause-acpica",
                  "OGTSL",
                  "ODbL-1.0",
                  "CC-BY-ND-3.0",
                  "CC-BY-SA-2.5",
                  "OLDAP-2.7",
                  "UCL-1.0",
                  "MTLL",
                  "HPND-export2-US",
                  "OFL-1.0-RFN",
                  "ZPL-2.0",
                  "bcrypt-Solar-Designer",
                  "CC-BY-NC-SA-3.0-DE",
                  "GFDL-1.1-no-invariants-or-later",
                  "CC-BY-SA-3.0-IGO",
                  "Apache-1.1",
                  "Caldera-no-preamble",
                  "SSPL-1.0",
                  "DRL-1.1",
                  "Linux-man-pages-copyleft-2-para",
                  "OLDAP-2.0.1",
                  "ANTLR-PD-fallback",
                  "CDLA-Permissive-2.0",
                  "HIDAPI",
                  "bzip2-1.0.6",
                  "GL2PS",
                  "TOSL",
                  "Abstyles",
                  "TermReadKey",
                  "xzoom",
                  "PostgreSQL",
                  "CNRI-Python-GPL-Compatible",
                  "Widget-Workshop",
                  "Libpng",
                  "HPND-sell-MIT-disclaimer-xserver",
                  "CC-BY-NC-SA-1.0",
                  "Python-2.0",
                  "BSD-Systemics-W3Works",
                  "LPPL-1.0",
                  "YPL-1.1",
                  "SWL",
                  "Giftware",
                  "CECILL-B",
                  "OSET-PL-2.1",
                  "CAL-1.0-Combined-Work-Exception",
                  "HPND-sell-variant-MIT-disclaimer-rev",
                  "JSON",
                  "GFDL-1.2-only",
                  "pkgconf",
                  "Unicode-DFS-2016",
                  "PHP-3.01",
                  "blessing",
                  "RPSL-1.0",
                  "BitTorrent-1.0",
                  "SISSL-1.2",
                  "IJG",
                  "OGL-Canada-2.0",
                  "CC-BY-ND-2.5",
                  "HPND-Pbmplus",
                  "CC-BY-NC-ND-3.0-DE",
                  "RPL-1.5",
                  "Nokia",
                  "HPND-doc-sell"
                ]
            ],
      "_js2n__-:definitions/multilingual!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType 'Record,
                _js2n__-prdslib.records.required [ "en" ],
                _js2n__-prdslib.records.record {}
                  {
                    "en|de|ru|pt|nl|fr|it|es|pl|uk|zh-cn" =
                      _js2n__-prdslib.isType '"String",
                  } false _js2n__-prdslib.never
              ]),
      "_js2n__-:definitions/multilingual!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "en" ],
              _js2n__-prdslib.records.record {}
                {
                  "en|de|ru|pt|nl|fr|it|es|pl|uk|zh-cn" =
                    _js2n__-prdslib.isType '"String",
                } false _js2n__-prdslib.never
            ],
    }
    in
  {
      "$schema" | String | doc "JSON schema for validation" | optional,
      common
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.ifThenElse
                _js2n__-refsenv."_js2n__-:definitions/isCompactTrue!predicate"
                _js2n__-refsenv."_js2n__-:definitions/disallowNodeProcessParams!predicate"
                _js2n__-prdslib.always,
              _js2n__-prdslib.records.required
                [
                  "desc",
                  "licenseInformation",
                  "mode",
                  "name",
                  "news",
                  "platform",
                  "tier",
                  "titleLang",
                  "version"
                ],
              _js2n__-prdslib.records.record
                {
                  adminColumns =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.required
                                  [ "align", "name", "path", "width" ],
                                _js2n__-prdslib.records.record
                                  {
                                    align =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.enum
                                              [
                                                "left",
                                                "right",
                                                "center",
                                                "justify"
                                              ]
                                          ],
                                    edit = _js2n__-prdslib.isType '"Bool",
                                    name =
                                      _js2n__-prdslib.anyOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-refsenv."_js2n__-:definitions/multilingual!predicate"
                                          ],
                                    objTypes =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"Array",
                                            _js2n__-prdslib.arrays.arrayOf
                                              (_js2n__-prdslib.isType '"String")
                                          ],
                                    path = _js2n__-prdslib.isType '"String",
                                    type = _js2n__-prdslib.isType '"String",
                                    width =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"Number",
                                            _js2n__-prdslib.numbers.minimum 0
                                          ],
                                  } {} true _js2n__-prdslib.always
                              ]),
                          _js2n__-prdslib.arrays.minItems 1
                        ],
                  adminTab =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.required
                            [ "fa-icon", "link", "name" ],
                          _js2n__-prdslib.records.record
                            {
                              fa-icon = _js2n__-prdslib.isType '"String",
                              ignoreConfigUpdate =
                                _js2n__-prdslib.isType '"Bool",
                              link = _js2n__-prdslib.isType '"String",
                              name =
                                _js2n__-refsenv."_js2n__-:definitions/multilingual!predicate",
                              singleton = _js2n__-prdslib.isType '"Bool",
                            } {} false _js2n__-prdslib.never
                        ],
                  adminUI =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.required [ "config" ],
                          _js2n__-prdslib.records.record
                            {
                              config =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [
                                          "html",
                                          "json",
                                          "materialize",
                                          "none"
                                        ]
                                    ],
                              custom =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.const "json"
                                    ],
                              tab =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [ "html", "materialize" ]
                                    ],
                            } {} false _js2n__-prdslib.never
                        ],
                  allowInit = _js2n__-prdslib.isType '"Bool",
                  authors =
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
                                    _js2n__-prdslib.records.required [ "name" ],
                                    _js2n__-prdslib.records.record
                                      {
                                        email =
                                          _js2n__-prdslib.isType '"String",
                                        name = _js2n__-prdslib.isType '"String",
                                      } {} false _js2n__-prdslib.never
                                  ]
                              ]),
                          _js2n__-prdslib.arrays.minItems 1
                        ],
                  automaticUpgrade =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "none", "patch", "minor", "major" ]
                        ],
                  availableModes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.enum
                                  [
                                    "none",
                                    "daemon",
                                    "schedule",
                                    "once",
                                    "extension"
                                  ]
                              ]),
                          _js2n__-prdslib.arrays.minItems 1
                        ],
                  blockedVersions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  blockly = _js2n__-prdslib.isType '"Bool",
                  compact = _js2n__-prdslib.isType '"Bool",
                  connectionType =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "none", "local", "cloud" ]
                        ],
                  controller = _js2n__-prdslib.isType '"Bool",
                  dataFolder = _js2n__-prdslib.isType '"String",
                  dataSource =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "none", "poll", "push", "assumption" ]
                        ],
                  dependencies =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.isType '"String"
                              ])
                        ],
                  desc =
                    _js2n__-refsenv."_js2n__-:definitions/multilingual!predicate",
                  docs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.required [ "en" ],
                          _js2n__-prdslib.records.record {}
                            {
                              "en|de|ru|pt|nl|fr|it|es|pl|uk|zh-cn" =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.isType '"Array"
                                        ],
                                      _js2n__-prdslib.arrays.arrayOf
                                        (_js2n__-prdslib.isType '"String"),
                                      _js2n__-prdslib.arrays.minItems 1
                                    ],
                            } false _js2n__-prdslib.never
                        ],
                  enabled = _js2n__-prdslib.isType '"Bool",
                  eraseOnUpload = _js2n__-prdslib.isType '"Bool",
                  extIcon = _js2n__-prdslib.isType '"String",
                  getHistory = _js2n__-prdslib.isType '"Bool",
                  globalDependencies =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.isType '"String"
                              ])
                        ],
                  icon = _js2n__-prdslib.isType '"String",
                  ifInstalledDependencies =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {}
                            { ".+" = _js2n__-prdslib.isType '"String", } true
                            _js2n__-prdslib.always
                        ],
                  install = _js2n__-prdslib.isType '"Bool",
                  keywords =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  license =
                    _js2n__-refsenv."_js2n__-:definitions/license!predicate",
                  licenseInformation =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.ifThenElse
                            (_js2n__-prdslib.records.record
                              {
                                type =
                                  _js2n__-prdslib.enum
                                      [ "paid", "commercial", "limited" ],
                              } {} true _js2n__-prdslib.always)
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required [ "link" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ]) _js2n__-prdslib.always,
                          _js2n__-prdslib.records.required [ "type" ],
                          _js2n__-prdslib.records.record
                            {
                              license =
                                _js2n__-refsenv."_js2n__-:definitions/license!predicate",
                              link =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.strings.pattern
                                        "^https://.+$"
                                    ],
                              type =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [
                                          "free",
                                          "paid",
                                          "commercial",
                                          "limited"
                                        ]
                                    ],
                            } {} false _js2n__-prdslib.never
                        ],
                  localLinks =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {}
                            {
                              ".+" =
                                _js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.records.required
                                            [ "link" ],
                                          _js2n__-prdslib.records.record
                                            {
                                              cloud =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              color =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              description =
                                                _js2n__-prdslib.anyOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"String",
                                                      _js2n__-refsenv."_js2n__-:definitions/multilingual!predicate"
                                                    ],
                                              icon =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              intro =
                                                _js2n__-prdslib.isType '"Bool",
                                              link =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              name =
                                                _js2n__-prdslib.anyOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"String",
                                                      _js2n__-refsenv."_js2n__-:definitions/multilingual!predicate"
                                                    ],
                                              order =
                                                _js2n__-prdslib.isType
                                                    '"Number",
                                              pro =
                                                _js2n__-prdslib.anyOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"Bool",
                                                      _js2n__-prdslib.isType
                                                        '"String"
                                                    ],
                                            } {} false _js2n__-prdslib.never
                                        ]
                                    ],
                            } true _js2n__-prdslib.always
                        ],
                  logTransporter = _js2n__-prdslib.isType '"Bool",
                  loglevel =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "silly", "debug", "info", "warn", "error" ]
                        ],
                  main = _js2n__-prdslib.isType '"String",
                  materialize = _js2n__-prdslib.isType '"Bool",
                  materializeTab = _js2n__-prdslib.isType '"Bool",
                  messagebox = _js2n__-prdslib.isType '"Bool",
                  messages =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.required
                                  [ "buttons", "text", "title" ],
                                _js2n__-prdslib.records.record
                                  {
                                    buttons =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"Array",
                                            _js2n__-prdslib.arrays.arrayOf
                                              (_js2n__-prdslib.enum
                                                [ "ok", "agree", "cancel" ])
                                          ],
                                    condition =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-prdslib.records.record
                                              {
                                                operand =
                                                  _js2n__-prdslib.enum
                                                      [ "or", "and" ],
                                                rules =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"Array",
                                                        _js2n__-prdslib.arrays.arrayOf
                                                          (_js2n__-prdslib.isType
                                                            '"String")
                                                      ],
                                              } {} false _js2n__-prdslib.never
                                          ],
                                    level =
                                      _js2n__-prdslib.enum
                                          [ "info", "warn", "error" ],
                                    link = _js2n__-prdslib.isType '"String",
                                    linkText =
                                      _js2n__-refsenv."_js2n__-:definitions/multilingual!predicate",
                                    text =
                                      _js2n__-refsenv."_js2n__-:definitions/multilingual!predicate",
                                    title =
                                      _js2n__-refsenv."_js2n__-:definitions/multilingual!predicate",
                                  } {} false _js2n__-prdslib.never
                              ])
                        ],
                  mode =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "none",
                              "daemon",
                              "schedule",
                              "once",
                              "extension"
                            ]
                        ],
                  name =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^(?![i|I][o|O][b|B][r|R][o|O][k|K][e|E][r|R])"
                        ],
                  news =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.maxProperties 20,
                          _js2n__-prdslib.records.minProperties 1,
                          _js2n__-prdslib.records.record {}
                            {
                              "^(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)(?:-((?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\\.(?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\\+([0-9a-zA-Z-]+(?:\\.[0-9a-zA-Z-]+)*))?$" =
                                _js2n__-refsenv."_js2n__-:definitions/multilingual!predicate",
                            } false _js2n__-prdslib.never
                        ],
                  noConfig = _js2n__-prdslib.isType '"Bool",
                  noIntro = _js2n__-prdslib.isType '"Bool",
                  noRepository = _js2n__-prdslib.isType '"Bool",
                  nodeProcessParams =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  nogit = _js2n__-prdslib.isType '"Bool",
                  nondeletable = _js2n__-prdslib.isType '"Bool",
                  onlyWWW = _js2n__-prdslib.isType '"Bool",
                  os =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [ "linux", "darwin", "win32" ]
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.enum
                                      [ "linux", "darwin", "win32" ]
                                  ]),
                              _js2n__-prdslib.arrays.minItems 1
                            ]
                        ],
                  osDependencies =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {}
                            {
                              "linux|darwin|win32" =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        (_js2n__-prdslib.isType '"String")
                                    ],
                            } false _js2n__-prdslib.never
                        ],
                  platform =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "Javascript/Node.js" ]
                        ],
                  plugins = _js2n__-prdslib.isType 'Record,
                  preserveSettings =
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
                  readme = _js2n__-prdslib.isType '"String",
                  restartAdapters =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  restartSchedule = _js2n__-prdslib.isType '"String",
                  schedule = _js2n__-prdslib.isType '"String",
                  serviceStates =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"String"
                        ],
                  singleton = _js2n__-prdslib.isType '"Bool",
                  singletonHost = _js2n__-prdslib.isType '"Bool",
                  stopBeforeUpdate = _js2n__-prdslib.isType '"Bool",
                  stopTimeout =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.numbers.multipleOf 1,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  subscribable = _js2n__-prdslib.isType '"Bool",
                  supportCustoms = _js2n__-prdslib.isType '"Bool",
                  supportStopInstance =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Number",
                              _js2n__-prdslib.numbers.multipleOf 1,
                              _js2n__-prdslib.numbers.minimum 1000
                            ]
                        ],
                  supportedMessages =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              custom = _js2n__-prdslib.isType '"Bool",
                              deviceManager = _js2n__-prdslib.isType '"Bool",
                              getHistory = _js2n__-prdslib.isType '"Bool",
                              notifications = _js2n__-prdslib.isType '"Bool",
                              stopInstance =
                                _js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.isType '"Bool",
                                      _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Number",
                                          _js2n__-prdslib.numbers.multipleOf 1,
                                          _js2n__-prdslib.numbers.minimum 1000
                                        ]
                                    ],
                            } {} false _js2n__-prdslib.never
                        ],
                  tier =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.numbers.maximum 3,
                          _js2n__-prdslib.numbers.minimum 1
                        ],
                  title = _js2n__-prdslib.isType '"String",
                  titleLang =
                    _js2n__-refsenv."_js2n__-:definitions/multilingual!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "alarm",
                              "climate-control",
                              "communication",
                              "date-and-time",
                              "energy",
                              "garden",
                              "general",
                              "geoposition",
                              "hardware",
                              "health",
                              "household",
                              "infrastructure",
                              "iot-systems",
                              "lighting",
                              "logic",
                              "messaging",
                              "metering",
                              "misc-data",
                              "multimedia",
                              "network",
                              "protocols",
                              "storage",
                              "utility",
                              "vehicle",
                              "visualization",
                              "visualization-icons",
                              "visualization-widgets",
                              "weather"
                            ]
                        ],
                  unsafePerm = _js2n__-prdslib.isType '"Bool",
                  version =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)(?:-((?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\\.(?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\\+([0-9a-zA-Z-]+(?:\\.[0-9a-zA-Z-]+)*))?$"
                        ],
                  visWidgets =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.minProperties 1,
                          _js2n__-prdslib.records.record {}
                            {
                              ".+" =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.required
                                        [ "components", "i18n", "url" ],
                                      _js2n__-prdslib.records.record
                                        {
                                          components =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"Array",
                                                  _js2n__-prdslib.arrays.arrayOf
                                                    (_js2n__-prdslib.isType
                                                      '"String"),
                                                  _js2n__-prdslib.arrays.minItems
                                                    1
                                                ],
                                          i18n =
                                            _js2n__-prdslib.anyOf
                                                [
                                                  _js2n__-prdslib.const true,
                                                  _js2n__-prdslib.const
                                                    "component",
                                                  _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        'Record,
                                                      _js2n__-prdslib.records.record
                                                        {}
                                                        {
                                                          ".+" =
                                                            _js2n__-refsenv."_js2n__-:definitions/multilingual!predicate",
                                                        } true
                                                        _js2n__-prdslib.always
                                                    ]
                                                ],
                                          ignoreInVersions =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"Array",
                                                  _js2n__-prdslib.arrays.arrayOf
                                                    (_js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"Number",
                                                        _js2n__-prdslib.numbers.multipleOf
                                                          1
                                                      ])
                                                ],
                                          url =
                                            _js2n__-prdslib.isType '"String",
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } true _js2n__-prdslib.always
                        ],
                  webByVersion = _js2n__-prdslib.isType '"Bool",
                  webExtendable = _js2n__-prdslib.isType '"Bool",
                  webExtension = _js2n__-prdslib.isType '"String",
                  webPreSettings = _js2n__-prdslib.isType 'Record,
                  webservers =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  welcomeScreen =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType 'Record
                              ])
                        ],
                  welcomeScreenPro =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType 'Record
                              ])
                        ],
                  wwwDontUpload = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ])
        | doc "Contains all common instance attributes",
      encryptedNative
        | Array (String)
        | doc "Array of config attributes which will be automatically encrypted when stored via Admin configuration page and automatically decrypted at adapter runtime, e.g. [\"password\", \"token\"]"
        | optional,
      instanceObjects
        | Array _js2n__-refsenv."_js2n__-:definitions/iobrokerObject!contract"
        | doc "Objects which will be created for each instance"
        | optional,
      native
        | {  .. }
        | doc "Predefined attributes which are accessible in index_m.html and at runtime via adapter.config.<attribute>, e.g. {\"port\": 1234, \"password\": \"secret\"}"
        | optional,
      notifications
        | Array
          {
            categories
              | Array
                {
                  category | String,
                  description
                    | _js2n__-refsenv."_js2n__-:definitions/multilingual!contract",
                  limit
                    | Number
                    | doc "Maximum amount of notifications to collect of this type",
                  name
                    | _js2n__-refsenv."_js2n__-:definitions/multilingual!contract",
                  regex | Array (String),
                  severity
                    | std.enum.TagOrString
                    | [| 'alert, 'notify, 'info |]
                    | doc "`info` will only be shown by admin, while `notify` might also be used by messaging adapters, `alert` ensures both",
                },
            description
              | _js2n__-refsenv."_js2n__-:definitions/multilingual!contract"
              | doc "Description which will be shown to the user",
            name
              | _js2n__-refsenv."_js2n__-:definitions/multilingual!contract"
              | doc "Name which will be shown to the user",
            scope | String,
          }
        | doc "Register notifications for the built-in notification system"
        | optional,
      objects
        | Array _js2n__-refsenv."_js2n__-:definitions/iobrokerObject!contract"
        | doc "Objects which will be created for the adapter"
        | optional,
      protectedNative
        | Array (String)
        | doc "Array of config attributes which will only be accessible by the own adapter, e.g. [\"password\"]"
        | optional,
    }