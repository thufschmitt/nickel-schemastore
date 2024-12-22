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
      confirmOnQuit
        | Bool
        | doc "If true, show a confirmation popup before quitting Lazygit"
        | optional,
      customCommands
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        after =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record
                                  {
                                    checkForConflicts =
                                      _js2n__-prdslib.isType '"Bool",
                                  } {} false _js2n__-prdslib.never
                              ],
                        command = _js2n__-prdslib.isType '"String",
                        context =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.enum
                                  [
                                    "status",
                                    "files",
                                    "worktrees",
                                    "localBranches",
                                    "remotes",
                                    "remoteBranches",
                                    "tags",
                                    "commits",
                                    "reflogCommits",
                                    "subCommits",
                                    "commitFiles",
                                    "stash",
                                    "global"
                                  ]
                              ],
                        description = _js2n__-prdslib.isType '"String",
                        key = _js2n__-prdslib.isType '"String",
                        loadingText = _js2n__-prdslib.isType '"String",
                        outputTitle = _js2n__-prdslib.isType '"String",
                        prompts =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          body =
                                            _js2n__-prdslib.isType '"String",
                                          command =
                                            _js2n__-prdslib.isType '"String",
                                          filter =
                                            _js2n__-prdslib.isType '"String",
                                          initialValue =
                                            _js2n__-prdslib.isType '"String",
                                          key =
                                            _js2n__-prdslib.isType '"String",
                                          labelFormat =
                                            _js2n__-prdslib.isType '"String",
                                          options =
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
                                                            description =
                                                              _js2n__-prdslib.isType
                                                                  '"String",
                                                            name =
                                                              _js2n__-prdslib.isType
                                                                  '"String",
                                                            value =
                                                              _js2n__-prdslib.allOf
                                                                  [
                                                                    _js2n__-prdslib.isType
                                                                      '"String",
                                                                    _js2n__-prdslib.strings.minLength
                                                                      1
                                                                  ],
                                                          } {} false
                                                          _js2n__-prdslib.never
                                                      ])
                                                ],
                                          suggestions =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      command =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      preset =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                '"String",
                                                              _js2n__-prdslib.enum
                                                                [
                                                                  "authors",
                                                                  "branches",
                                                                  "files",
                                                                  "refs",
                                                                  "remotes",
                                                                  "remoteBranches",
                                                                  "tags"
                                                                ]
                                                            ],
                                                    } {} false
                                                    _js2n__-prdslib.never
                                                ],
                                          title =
                                            _js2n__-prdslib.isType '"String",
                                          type =
                                            _js2n__-prdslib.isType '"String",
                                          valueFormat =
                                            _js2n__-prdslib.isType '"String",
                                        } {} false _js2n__-prdslib.never
                                    ])
                              ],
                        showOutput = _js2n__-prdslib.isType '"Bool",
                        stream = _js2n__-prdslib.isType '"Bool",
                        subprocess = _js2n__-prdslib.isType '"Bool",
                      } {} false _js2n__-prdslib.never
                  ]),
              _js2n__-prdslib.arrays.uniqueItems
            ])
        | doc "User-configured commands that can be invoked from within Lazygit"
        | optional,
      disableStartupPopups
        | Bool
        | doc "If true, don't display introductory popups upon opening Lazygit."
        | optional,
      git
        | {
          allBranchesLogCmd
            | String
            | doc m%"
              Command used to display git log of all branches in the main window.
              Deprecated: Use `allBranchesLogCmds` instead.
            "%
            | optional,
          allBranchesLogCmds
            | Array (String)
            | doc "Commands used to display git log of all branches in the main window, they will be cycled in order of appearance"
            | optional,
          autoFetch
            | Bool
            | doc "If true, periodically fetch from remote"
            | optional,
          autoRefresh
            | Bool
            | doc "If true, periodically refresh files and submodules"
            | optional,
          autoStageResolvedConflicts
            | Bool
            | doc m%"
              If true, lazygit will automatically stage files that used to have merge
              conflicts but no longer do; and it will also ask you if you want to
              continue a merge or rebase if you've resolved all conflicts. If false, it
              won't do either of these things.
            "%
            | optional,
          branchLogCmd
            | String
            | doc "Command used when displaying the current branch git log in the main window"
            | optional,
          branchPrefix
            | String
            | doc "See https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#predefined-branch-name-prefix"
            | optional,
          commit
            | {
              autoWrapCommitMessage
                | Bool
                | doc "Automatic WYSIWYG wrapping of the commit message as you type"
                | optional,
              autoWrapWidth
                | std.number.Integer
                | doc "If autoWrapCommitMessage is true, the width to wrap to"
                | optional,
              signOff
                | Bool
                | doc "If true, pass '--signoff' flag when committing"
                | optional,
            }
            | doc "Config relating to committing"
            | optional,
          commitPrefix
            | {
              pattern
                | String
                | doc "pattern to match on. E.g. for 'feature/AB-123' to match on the AB-123 use \"^\\\\w+\\\\/(\\\\w+-\\\\w+).*\""
                | optional,
              replace
                | String
                | doc "Replace directive. E.g. for 'feature/AB-123' to start the commit message with 'AB-123 ' use \"[$1] \""
                | optional,
            }
            | doc "See https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#predefined-commit-message-prefix"
            | optional,
          commitPrefixes
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record {} {} true
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.record
                          {
                            pattern = _js2n__-prdslib.isType '"String",
                            replace = _js2n__-prdslib.isType '"String",
                          } {} false _js2n__-prdslib.never
                      ])
                ])
            | doc "See https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#predefined-commit-message-prefix"
            | optional,
          disableForcePushing
            | Bool
            | doc "If true, do not allow force pushes"
            | optional,
          fetchAll
            | Bool
            | doc "If true, pass the --all arg to git fetch"
            | optional,
          log
            | {
              order
                | std.enum.TagOrString
                | [| '"default", 'topo-order, 'author-date-order, 'date-order |]
                | doc m%"
                  One of: 'date-order' | 'author-date-order' | 'topo-order' | 'default'
                  'topo-order' makes it easier to read the git log graph, but commits may not
                  appear chronologically. See https://git-scm.com/docs/
                  
                  Deprecated: Configure this with `Log menu -> Commit sort order` (<c-l> in the commits window by default).
                "%
                | optional,
              showGraph
                | std.enum.TagOrString
                | [| 'when-maximised, 'never, 'always |]
                | doc m%"
                  This determines whether the git graph is rendered in the commits panel
                  One of 'always' | 'never' | 'when-maximised'
                  
                  Deprecated: Configure this with `Log menu -> Show git graph` (<c-l> in the commits window by default).
                "%
                | optional,
              showWholeGraph
                | Bool
                | doc "displays the whole git graph by default in the commits view (equivalent to passing the `--all` argument to `git log`)"
                | optional,
            }
            | doc "Config for showing the log in the commits view"
            | optional,
          mainBranches
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.isType '"String"),
                  _js2n__-prdslib.arrays.uniqueItems
                ])
            | doc "list of branches that are considered 'main' branches, used when displaying commits"
            | optional,
          merging
            | {
              args
                | String
                | doc "Extra args passed to `git merge`, e.g. --no-ff"
                | optional,
              manualCommit
                | Bool
                | doc m%"
                  If true, run merges in a subprocess so that if a commit message is required, Lazygit will not hang
                  Only applicable to unix users.
                "%
                | optional,
              squashMergeMessage
                | String
                | doc "The commit message to use for a squash merge commit. Can contain \"{{selectedRef}}\" and \"{{currentBranch}}\" placeholders."
                | optional,
            }
            | doc "Config relating to merging"
            | optional,
          overrideGpg
            | Bool
            | doc "If true, do not spawn a separate process when using GPG"
            | optional,
          paging
            | {
              colorArg
                | std.enum.TagOrString
                | [| 'never, 'always |]
                | doc "Value of the --color arg in the git diff command. Some pagers want this to be set to 'always' and some want it set to 'never'"
                | optional,
              externalDiffCommand
                | String
                | doc "e.g. 'difft --color=always'"
                | optional,
              pager
                | String
                | doc m%"
                  e.g.
                  diff-so-fancy
                  delta --dark --paging=never
                  ydiff -p cat -s --wrap --width={{columnWidth}}
                "%
                | optional,
              useConfig
                | Bool
                | doc "If true, Lazygit will use whatever pager is specified in `$GIT_PAGER`, `$PAGER`, or your *git config*. If the pager ends with something like ` | less` we will strip that part out, because less doesn't play nice with our rendering approach. If the custom pager uses less under the hood, that will also break rendering (hence the `--paging=never` flag for the `delta` pager)."
                | optional,
            }
            | doc "See https://github.com/jesseduffield/lazygit/blob/master/docs/Custom_Pagers.md"
            | optional,
          parseEmoji
            | Bool
            | doc m%"
              If true, parse emoji strings in commit messages e.g. render :rocket: as 🚀
              (This should really be under 'gui', not 'git')
            "%
            | optional,
          skipHookPrefix
            | String
            | doc "Prefix to use when skipping hooks. E.g. if set to 'WIP', then pre-commit hooks will be skipped when the commit message starts with 'WIP'"
            | optional,
          truncateCopiedCommitHashesTo
            | std.number.Integer
            | doc m%"
              When copying commit hashes to the clipboard, truncate them to this
              length. Set to 40 to disable truncation.
            "%
            | optional,
        }
        | doc "Config relating to git"
        | optional,
      gui
        | {
          animateExplosion
            | Bool
            | doc "If true, show a seriously epic explosion animation when nuking the working tree."
            | optional,
          authorColors
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record {} {} true
                    (_js2n__-prdslib.isType '"String")
                ])
            | doc "See https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#custom-author-color"
            | optional,
          border
            | std.enum.TagOrString
            | [| 'hidden, 'rounded, 'double, 'single |]
            | doc m%"
              Window border style.
              One of 'rounded' (default) | 'single' | 'double' | 'hidden'
            "%
            | optional,
          branchColors
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record {} {} true
                    (_js2n__-prdslib.isType '"String")
                ])
            | doc "See https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#custom-branch-color"
            | optional,
          commandLogSize
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Integer,
                  _js2n__-prdslib.numbers.minimum 0
                ])
            | doc "Height of the command log view"
            | optional,
          commitAuthorLongLength
            | std.number.Integer
            | doc "Length of author name in expanded commits view. 2 means show initials only."
            | optional,
          commitAuthorShortLength
            | std.number.Integer
            | doc "Length of author name in (non-expanded) commits view. 2 means show initials only."
            | optional,
          commitHashLength
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Integer,
                  _js2n__-prdslib.numbers.minimum 0
                ])
            | doc "Length of commit hash in commits view. 0 shows '*' if NF icons aren't on."
            | optional,
          commitLength
            | {
              show
                | Bool
                | doc "If true, show an indicator of commit message length"
                | optional,
            }
            | doc "Config relating to the commit length indicator"
            | optional,
          enlargedSideViewLocation
            | String
            | doc m%"
              How the window is split when in half screen mode (i.e. after hitting '+' once).
              Possible values:
              - 'left': split the window horizontally (side panel on the left, main view on the right)
              - 'top': split the window vertically (side panel on top, main view below)
            "%
            | optional,
          expandFocusedSidePanel
            | Bool
            | doc "If true, increase the height of the focused side window; creating an accordion effect."
            | optional,
          expandedSidePanelWeight
            | std.number.Integer
            | doc m%"
              The weight of the expanded side panel, relative to the other panels. 2 means
              twice as tall as the other panels. Only relevant if `expandFocusedSidePanel` is true.
            "%
            | optional,
          filterMode
            | std.enum.TagOrString
            | [| 'fuzzy, 'substring |]
            | doc m%"
              How things are filtered when typing '/'.
              One of 'substring' (default) | 'fuzzy'
            "%
            | optional,
          language
            | std.enum.TagOrString
            | [| 'ru, 'ko, 'ja, 'nl, 'pl, 'zh-CN, 'zh-TW, 'en, 'auto |]
            | doc "One of 'auto' (default) | 'en' | 'zh-CN' | 'zh-TW' | 'pl' | 'nl' | 'ja' | 'ko' | 'ru'"
            | optional,
          mainPanelSplitMode
            | std.enum.TagOrString
            | [| 'vertical, 'flexible, 'horizontal |]
            | doc m%"
              Sometimes the main window is split in two (e.g. when the selected file has both staged and unstaged changes). This setting controls how the two sections are split.
              Options are:
              - 'horizontal': split the window horizontally
              - 'vertical': split the window vertically
              - 'flexible': (default) split the window horizontally if the window is wide enough, otherwise split vertically
            "%
            | optional,
          mouseEvents
            | Bool
            | doc m%"
              If true, capture mouse events.
              When mouse events are captured, it's a little harder to select text: e.g. requiring you to hold the option key when on macOS.
            "%
            | optional,
          nerdFontsVersion
            | std.enum.TagOrString
            | [| '"", '"3", '"2" |]
            | doc m%"
              Nerd fonts version to use.
              One of: '2' | '3' | empty string (default)
              If empty, do not show icons.
            "%
            | optional,
          portraitMode
            | String
            | doc m%"
              Whether to stack UI components on top of each other.
              One of 'auto' (default) | 'always' | 'never'
            "%
            | optional,
          scrollHeight
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Integer,
                  _js2n__-prdslib.numbers.minimum 1
                ])
            | doc "The number of lines you scroll by when scrolling the main window"
            | optional,
          scrollOffBehavior
            | String
            | doc "One of: 'margin' (default) | 'jump'"
            | optional,
          scrollOffMargin
            | std.number.Integer
            | doc "See https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#scroll-off-margin"
            | optional,
          scrollPastBottom
            | Bool
            | doc "If true, allow scrolling past the bottom of the content in the main window"
            | optional,
          shortTimeFormat
            | String
            | doc m%"
              Format used when displaying time if the time is less than 24 hours ago.
              Uses Go's time format syntax: https://pkg.go.dev/time#Time.Format
            "%
            | optional,
          showBottomLine
            | Bool
            | doc "If true, show the bottom line that contains keybinding info and useful buttons. If false, this line will be hidden except to display a loader for an in-progress action."
            | optional,
          showBranchCommitHash
            | Bool
            | doc "If true, show commit hashes alongside branch names in the branches view."
            | optional,
          showCommandLog
            | Bool
            | doc "If true, show the command log"
            | optional,
          showDivergenceFromBaseBranch
            | std.enum.TagOrString
            | [| 'arrowAndNumber, 'onlyArrow, 'none |]
            | doc m%"
              Whether to show the divergence from the base branch in the branches view.
              One of: 'none' | 'onlyArrow'  | 'arrowAndNumber'
            "%
            | optional,
          showFileIcons
            | Bool
            | doc "If true (default), file icons are shown in the file views. Only relevant if NerdFontsVersion is not empty."
            | optional,
          showFileTree
            | Bool
            | doc m%"
              If true, display the files in the file views as a tree. If false, display the files as a flat list.
              This can be toggled from within Lazygit with the '~' key, but that will not change the default.
            "%
            | optional,
          showIcons
            | Bool
            | doc "Deprecated: use nerdFontsVersion instead"
            | optional,
          showListFooter
            | Bool
            | doc "If true, show the '5 of 20' footer at the bottom of list views"
            | optional,
          showNumstatInFilesView
            | Bool
            | doc "If true, show the number of lines changed per file in the Files view"
            | optional,
          showPanelJumps
            | Bool
            | doc "If true, show jump-to-window keybindings in window titles."
            | optional,
          showRandomTip
            | Bool
            | doc "If true, show a random tip in the command log when Lazygit starts"
            | optional,
          sidePanelWidth
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Number",
                  _js2n__-prdslib.numbers.maximum 1,
                  _js2n__-prdslib.numbers.minimum 0
                ])
            | doc m%"
              Fraction of the total screen width to use for the left side section. You may want to pick a small number (e.g. 0.2) if you're using a narrow screen, so that you can see more of the main section.
              Number from 0 to 1.0.
            "%
            | optional,
          skipDiscardChangeWarning
            | Bool
            | doc "If true, do not show a warning when discarding changes in the staging view."
            | optional,
          skipNoStagedFilesWarning
            | Bool
            | doc "If true, do not show a warning when attempting to commit without any staged files; instead stage all unstaged files."
            | optional,
          skipRewordInEditorWarning
            | Bool
            | doc "If true, do not show a warning when rewording a commit via an external editor"
            | optional,
          skipStashWarning
            | Bool
            | doc "If true, do not show warning when applying/popping the stash"
            | optional,
          spinner
            | {
              frames
                | Array (String)
                | doc "The frames of the spinner animation."
                | optional,
              rate
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Integer,
                      _js2n__-prdslib.numbers.minimum 1
                    ])
                | doc "The \"speed\" of the spinner in milliseconds."
                | optional,
            }
            | doc "Config relating to the spinner."
            | optional,
          splitDiff
            | std.enum.TagOrString
            | [| 'always, 'auto |]
            | doc m%"
              Whether to split the main window when viewing file changes.
              One of: 'auto' | 'always'
              If 'auto', only split the main window when a file has both staged and unstaged changes
            "%
            | optional,
          statusPanelView
            | std.enum.TagOrString
            | [| 'allBranchesLog, 'dashboard |]
            | doc m%"
              Status panel view.
              One of 'dashboard' (default) | 'allBranchesLog'
            "%
            | optional,
          switchTabsWithPanelJumpKeys
            | Bool
            | doc "If true, when using the panel jump keys (default 1 through 5) and target panel is already active, go to next tab instead"
            | optional,
          switchToFilesAfterStashApply
            | Bool
            | doc "If true, jump to the Files panel after applying a stash"
            | optional,
          switchToFilesAfterStashPop
            | Bool
            | doc "If true, jump to the Files panel after popping a stash"
            | optional,
          theme
            | {
              activeBorderColor
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.isType '"String"),
                      _js2n__-prdslib.arrays.minItems 1,
                      _js2n__-prdslib.arrays.uniqueItems
                    ])
                | doc "Border color of focused window"
                | optional,
              cherryPickedCommitBgColor
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.isType '"String"),
                      _js2n__-prdslib.arrays.minItems 1,
                      _js2n__-prdslib.arrays.uniqueItems
                    ])
                | doc "Background color of copied commit"
                | optional,
              cherryPickedCommitFgColor
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.isType '"String"),
                      _js2n__-prdslib.arrays.minItems 1,
                      _js2n__-prdslib.arrays.uniqueItems
                    ])
                | doc "Foreground color of copied commit"
                | optional,
              defaultFgColor
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.isType '"String"),
                      _js2n__-prdslib.arrays.minItems 1,
                      _js2n__-prdslib.arrays.uniqueItems
                    ])
                | doc "Default text color"
                | optional,
              inactiveBorderColor
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.isType '"String"),
                      _js2n__-prdslib.arrays.minItems 1,
                      _js2n__-prdslib.arrays.uniqueItems
                    ])
                | doc "Border color of non-focused windows"
                | optional,
              inactiveViewSelectedLineBgColor
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.isType '"String"),
                      _js2n__-prdslib.arrays.minItems 1,
                      _js2n__-prdslib.arrays.uniqueItems
                    ])
                | doc "Background color of selected line when view doesn't have focus."
                | optional,
              markedBaseCommitBgColor
                | Array (String)
                | doc "Background color of marked base commit (for rebase)"
                | optional,
              markedBaseCommitFgColor
                | Array (String)
                | doc "Foreground color of marked base commit (for rebase)"
                | optional,
              optionsTextColor
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.isType '"String"),
                      _js2n__-prdslib.arrays.minItems 1,
                      _js2n__-prdslib.arrays.uniqueItems
                    ])
                | doc "Color of keybindings help text in the bottom line"
                | optional,
              searchingActiveBorderColor
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.isType '"String"),
                      _js2n__-prdslib.arrays.minItems 1,
                      _js2n__-prdslib.arrays.uniqueItems
                    ])
                | doc "Border color of focused window when searching in that window"
                | optional,
              selectedLineBgColor
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.isType '"String"),
                      _js2n__-prdslib.arrays.minItems 1,
                      _js2n__-prdslib.arrays.uniqueItems
                    ])
                | doc m%"
                  Background color of selected line.
                  See https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#highlighting-the-selected-line
                "%
                | optional,
              unstagedChangesColor
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.isType '"String"),
                      _js2n__-prdslib.arrays.minItems 1,
                      _js2n__-prdslib.arrays.uniqueItems
                    ])
                | doc "Color for file with unstaged changes"
                | optional,
            }
            | doc m%"
              Config relating to colors and styles.
              See https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#color-attributes
            "%
            | optional,
          timeFormat
            | String
            | doc m%"
              Format used when displaying time e.g. commit time.
              Uses Go's time format syntax: https://pkg.go.dev/time#Time.Format
            "%
            | optional,
          windowSize
            | std.enum.TagOrString
            | [| 'full, 'half, 'normal |]
            | doc m%"
              Default size for focused window. Window size can be changed from within Lazygit with '+' and '_' (but this won't change the default).
              One of: 'normal' (default) | 'half' | 'full'
            "%
            | optional,
        }
        | doc "Config relating to the Lazygit UI"
        | optional,
      keybinding
        | {
          amendAttribute
            | {
              addCoAuthor | String | optional,
              resetAuthor | String | optional,
              setAuthor | String | optional,
            }
            | optional,
          branches
            | {
              checkoutBranchByName | String | optional,
              copyPullRequestURL | String | optional,
              createPullRequest | String | optional,
              createTag | String | optional,
              fastForward | String | optional,
              fetchRemote | String | optional,
              forceCheckoutBranch | String | optional,
              mergeIntoCurrentBranch | String | optional,
              pushTag | String | optional,
              rebaseBranch | String | optional,
              renameBranch | String | optional,
              setUpstream | String | optional,
              sortOrder | String | optional,
              viewGitFlowOptions | String | optional,
              viewPullRequestOptions | String | optional,
            }
            | optional,
          commitFiles | { checkoutCommitFile | String | optional, } | optional,
          commitMessage | { commitMenu | String | optional, } | optional,
          commits
            | {
              amendToCommit | String | optional,
              checkoutCommit | String | optional,
              cherryPickCopy | String | optional,
              copyCommitAttributeToClipboard | String | optional,
              createFixupCommit | String | optional,
              markCommitAsBaseForRebase | String | optional,
              markCommitAsFixup | String | optional,
              moveDownCommit | String | optional,
              moveUpCommit | String | optional,
              openInBrowser | String | optional,
              openLogMenu | String | optional,
              pasteCommits | String | optional,
              pickCommit | String | optional,
              renameCommit | String | optional,
              renameCommitWithEditor | String | optional,
              resetCherryPick | String | optional,
              resetCommitAuthor | String | optional,
              revertCommit | String | optional,
              squashAboveCommits | String | optional,
              squashDown | String | optional,
              startInteractiveRebase | String | optional,
              tagCommit | String | optional,
              viewBisectOptions | String | optional,
              viewResetOptions | String | optional,
            }
            | optional,
          files
            | {
              amendLastCommit | String | optional,
              commitChanges | String | optional,
              commitChangesWithEditor | String | optional,
              commitChangesWithoutHook | String | optional,
              confirmDiscard | String | optional,
              copyFileInfoToClipboard | String | optional,
              fetch | String | optional,
              findBaseCommitForFixup | String | optional,
              ignoreFile | String | optional,
              openMergeTool | String | optional,
              openStatusFilter | String | optional,
              refreshFiles | String | optional,
              stashAllChanges | String | optional,
              toggleStagedAll | String | optional,
              toggleTreeView | String | optional,
              viewResetOptions | String | optional,
              viewStashOptions | String | optional,
            }
            | optional,
          main
            | {
              editSelectHunk | String | optional,
              pickBothHunks | String | optional,
              toggleSelectHunk | String | optional,
            }
            | optional,
          stash
            | { popStash | String | optional, renameStash | String | optional, }
            | optional,
          status
            | {
              allBranchesLogGraph | String | optional,
              checkForUpdate | String | optional,
              recentRepos | String | optional,
            }
            | optional,
          submodules
            | {
              bulkMenu | String | optional,
              init | String | optional,
              update | String | optional,
            }
            | optional,
          universal
            | {
              confirm | String | optional,
              confirmInEditor | String | optional,
              copyToClipboard | String | optional,
              createPatchOptionsMenu | String | optional,
              createRebaseOptionsMenu | String | optional,
              decreaseContextInDiffView | String | optional,
              decreaseRenameSimilarityThreshold | String | optional,
              diffingMenu | String | optional,
              diffingMenu-alt | String | optional,
              edit | String | optional,
              executeShellCommand | String | optional,
              extrasMenu | String | optional,
              filteringMenu | String | optional,
              goInto | String | optional,
              gotoBottom | String | optional,
              gotoTop | String | optional,
              increaseContextInDiffView | String | optional,
              increaseRenameSimilarityThreshold | String | optional,
              jumpToBlock | Array (String) | optional,
              new | String | optional,
              nextBlock | String | optional,
              nextBlock-alt | String | optional,
              nextBlock-alt2 | String | optional,
              nextItem | String | optional,
              nextItem-alt | String | optional,
              nextMatch | String | optional,
              nextPage | String | optional,
              nextScreenMode | String | optional,
              nextTab | String | optional,
              openDiffTool | String | optional,
              openFile | String | optional,
              openRecentRepos | String | optional,
              optionMenu | String | optional,
              optionMenu-alt1 | String | optional,
              prevBlock | String | optional,
              prevBlock-alt | String | optional,
              prevBlock-alt2 | String | optional,
              prevItem | String | optional,
              prevItem-alt | String | optional,
              prevMatch | String | optional,
              prevPage | String | optional,
              prevScreenMode | String | optional,
              prevTab | String | optional,
              pullFiles
                | String
                | doc "'Files' appended for legacy reasons"
                | optional,
              pushFiles
                | String
                | doc "'Files' appended for legacy reasons"
                | optional,
              quit | String | optional,
              quit-alt1 | String | optional,
              quitWithoutChangingDirectory | String | optional,
              rangeSelectDown | String | optional,
              rangeSelectUp | String | optional,
              redo | String | optional,
              refresh | String | optional,
              remove | String | optional,
              return | String | optional,
              scrollDownMain | String | optional,
              scrollDownMain-alt1 | String | optional,
              scrollDownMain-alt2 | String | optional,
              scrollLeft | String | optional,
              scrollRight | String | optional,
              scrollUpMain | String | optional,
              scrollUpMain-alt1 | String | optional,
              scrollUpMain-alt2 | String | optional,
              select | String | optional,
              startSearch | String | optional,
              submitEditorText | String | optional,
              togglePanel | String | optional,
              toggleRangeSelect | String | optional,
              toggleWhitespaceInDiffView | String | optional,
              undo | String | optional,
            }
            | optional,
          worktrees | { viewWorktreeOptions | String | optional, } | optional,
        }
        | doc "Keybindings"
        | optional,
      notARepository
        | std.enum.TagOrString
        | [| 'quit, 'skip, 'create, 'prompt |]
        | doc m%"
          What to do when opening Lazygit outside of a git repo.
          - 'prompt': (default) ask whether to initialize a new repo or open in the most recent repo
          - 'create': initialize a new repo
          - 'skip': open most recent repo
          - 'quit': exit Lazygit
        "%
        | optional,
      os
        | {
          copyToClipboardCmd
            | String
            | doc m%"
              CopyToClipboardCmd is the command for copying to clipboard.
              See https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#custom-command-for-copying-to-and-pasting-from-clipboard
            "%
            | optional,
          edit
            | String
            | doc "Command for editing a file. Should contain \"{{filename}}\"."
            | optional,
          editAtLine
            | String
            | doc m%"
              Command for editing a file at a given line number. Should contain
              "{{filename}}", and may optionally contain "{{line}}".
            "%
            | optional,
          editAtLineAndWait
            | String
            | doc m%"
              Same as EditAtLine, except that the command needs to wait until the
              window is closed.
            "%
            | optional,
          editCommand
            | String
            | doc m%"
              EditCommand is the command for editing a file.
              Deprecated: use Edit instead. Note that semantics are different:
              EditCommand is just the command itself, whereas Edit contains a
              "{{filename}}" variable.
            "%
            | optional,
          editCommandTemplate
            | String
            | doc m%"
              EditCommandTemplate is the command template for editing a file
              Deprecated: use EditAtLine instead.
            "%
            | optional,
          editInTerminal
            | Bool
            | doc m%"
              Whether lazygit suspends until an edit process returns
              Pointer to bool so that we can distinguish unset (nil) from false.
              We're naming this `editInTerminal` for backwards compatibility
            "%
            | optional,
          editPreset
            | String
            | doc m%"
              A built-in preset that sets all of the above settings. Supported presets
              are defined in the getPreset function in editor_presets.go.
            "%
            | optional,
          open
            | String
            | doc m%"
              Command for opening a file, as if the file is double-clicked. Should
              contain "{{filename}}", but doesn't support "{{line}}".
            "%
            | optional,
          openCommand
            | String
            | doc m%"
              OpenCommand is the command for opening a file
              Deprecated: use Open instead.
            "%
            | optional,
          openDirInEditor
            | String
            | doc "For opening a directory in an editor"
            | optional,
          openLink
            | String
            | doc "Command for opening a link. Should contain \"{{link}}\"."
            | optional,
          openLinkCommand
            | String
            | doc m%"
              OpenLinkCommand is the command for opening a link
              Deprecated: use OpenLink instead.
            "%
            | optional,
          readFromClipboardCmd
            | String
            | doc m%"
              ReadFromClipboardCmd is the command for reading the clipboard.
              See https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#custom-command-for-copying-to-and-pasting-from-clipboard
            "%
            | optional,
        }
        | doc "Config relating to things outside of Lazygit like how files are opened, copying to clipboard, etc"
        | optional,
      promptToReturnFromSubprocess
        | Bool
        | doc "If true, display a confirmation when subprocess terminates. This allows you to view the output of the subprocess before returning to Lazygit."
        | optional,
      quitOnTopLevelReturn
        | Bool
        | doc "If true, exit Lazygit when the user presses escape in a context where there is nothing to cancel/close"
        | optional,
      refresher
        | {
          fetchInterval
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Integer,
                  _js2n__-prdslib.numbers.minimum 0
                ])
            | doc m%"
              Re-fetch interval in seconds.
              Auto-fetch can be disabled via option 'git.autoFetch'.
            "%
            | optional,
          refreshInterval
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Integer,
                  _js2n__-prdslib.numbers.minimum 0
                ])
            | doc m%"
              File/submodule refresh interval in seconds.
              Auto-refresh can be disabled via option 'git.autoRefresh'.
            "%
            | optional,
        }
        | doc "Background refreshes"
        | optional,
      services
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                (_js2n__-prdslib.isType '"String")
            ])
        | doc "See https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#custom-pull-request-urls"
        | optional,
      update
        | {
          days
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Integer,
                  _js2n__-prdslib.numbers.minimum 0
                ])
            | doc "Period in days between update checks"
            | optional,
          method
            | std.enum.TagOrString
            | [| 'never, 'background, 'prompt |]
            | doc "One of: 'prompt' (default) | 'background' | 'never'"
            | optional,
        }
        | doc "Periodic update checks"
        | optional,
    }