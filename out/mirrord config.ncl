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
      "_js2n__-:definitions/AdvancedFsUserConfig!predicate"
        | doc m%"
          Allows the user to specify the default behavior for file operations:
          
          1. `"read"` - Read from the remote file system (default) 2. `"write"` - Read/Write from the remote file system. 3. `"local"` - Read from the local file system. 4. `"localwithoverrides"` - perform fs operation locally, unless the path matches a pre-defined or user-specified exception.
          
          > Note: by default, some paths are read locally or remotely, regardless of the selected FS mode. > This is described in further detail below.
          
          Besides the default behavior, the user can specify behavior for specific regex patterns. Case insensitive.
          
          1. `"read_write"` - List of patterns that should be read/write remotely. 2. `"read_only"` - List of patterns that should be read only remotely. 3. `"local"` - List of patterns that should be read locally. 4. `"not_found"` - List of patters that should never be read nor written. These files should be treated as non-existent. 4. `"mapping"` - Map of patterns and their corresponding replacers. The replacement happens before any specific behavior as defined above or mode (uses [`Regex::replace`](https://docs.rs/regex/latest/regex/struct.Regex.html#method.replace))
          
          The logic for choosing the behavior is as follows:
          
          1. Check agains "mapping" if path needs to be replaced, if matched then continue to next step with new path after replacements otherwise continue as usual. 2. Check if one of the patterns match the file path, do the corresponding action. There's no specified order if two lists match the same path, we will use the first one (and we do not guarantee what is first).
          
          **Warning**: Specifying the same path in two lists is unsupported and can lead to undefined behaviour.
          
          3. There are pre-defined exceptions to the set FS mode. 1. Paths that match [the patterns defined here](https://github.com/metalbear-co/mirrord/tree/latest/mirrord/layer/src/file/filter/read_local_by_default.rs) are read locally by default. 2. Paths that match [the patterns defined here](https://github.com/metalbear-co/mirrord/tree/latest/mirrord/layer/src/file/filter/read_remote_by_default.rs) are read remotely by default when the mode is `localwithoverrides`. 3. Paths that match [the patterns defined here](https://github.com/metalbear-co/mirrord/tree/latest/mirrord/layer/src/file/filter/not_found_by_default.rs) under the running user's home directory will not be found by the application when the mode is not `local`.
          
          In order to override that default setting for a path, or a pattern, include it the appropriate pattern set from above. E.g. in order to read files under `/etc/` remotely even though it is covered by [the set of patterns that are read locally by default](https://github.com/metalbear-co/mirrord/tree/latest/mirrord/layer/src/file/filter/read_local_by_default.rs), add `"^/etc/."` to the `read_only` set.
          
          4. If none of the above match, use the default behavior (mode).
          
          For more information, check the file operations [technical reference](https://mirrord.dev/docs/reference/fileops/).
          
          ```json { "feature": { "fs": { "mode": "write", "read_write": ".+\\.json" , "read_only": [ ".+\\.yaml", ".+important-file\\.txt" ], "local": [ ".+\\.js", ".+\\.mjs" ], "not_found": [ "\\.config/gcloud" ] } } } ```
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  local =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/VecOrSingle_for_String!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  mapping =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  mode =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/FsModeConfig!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  not_found =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/VecOrSingle_for_String!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  read_only =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/VecOrSingle_for_String!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  read_write =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/VecOrSingle_for_String!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/AgentFileConfig!predicate"
        | doc m%"
          Configuration for the mirrord-agent pod that is spawned in the Kubernetes cluster.
          
          We provide sane defaults for this option, so you don't have to set up anything here.
          
          ```json { "agent": { "log_level": "info", "json_log": false, "namespace": "default", "image": "ghcr.io/metalbear-co/mirrord:latest", "image_pull_policy": "IfNotPresent", "image_pull_secrets": [ { "secret-key": "secret" } ], "ttl": 30, "ephemeral": false, "communication_timeout": 30, "startup_timeout": 360, "network_interface": "eth0", "flush_connections": false } } ```
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  annotations =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  check_out_of_pods =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  communication_timeout =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  disabled_capabilities =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/LinuxCapability!predicate"
                        ],
                  dns =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/FileAgentDnsConfig!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  ephemeral =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  flush_connections =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  image =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/AgentImageFileConfig!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  image_pull_policy =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  image_pull_secrets =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/AgentPullSecret!predicate"
                        ],
                  json_log =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  labels =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  log_level =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  namespace =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  network_interface =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  nftables =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  node_selector =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  privileged =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  resources =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.ResourceRequirements!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  service_account =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  startup_timeout =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  tolerations =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.Toleration!predicate"
                        ],
                  ttl =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/AgentImageFileConfig!predicate"
        | doc m%"
          <!--${internal}--> Allows us to support the dual configuration for the agent image.
          
          Whatever values missing are replaced with our defaults.
        "%
        = _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      registry =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType 'Null
                            ],
                      tag =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType 'Null
                            ],
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:definitions/AgentPullSecret!predicate"
        | doc "<!--${internal}--> Specifies a secret reference for the agent pod."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                { name = _js2n__-prdslib.isType '"String", } {} true
                _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/ConcurrentSteal!predicate"
        | doc m%"
          (Operator Only): Allows overriding port locks
          
          Can be set to either `"continue"` or `"override"`.
          
          - `"continue"`: Continue with normal execution - `"override"`: If port lock detected then override it with new lock and force close the original locking connection.
        "%
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "override" ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "continue" ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "abort" ]
                ]
            ],
      "_js2n__-:definitions/ContainerFileConfig!predicate"
        | doc "Unstable: `mirrord container` command specific config."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  cli_extra_args =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  cli_image =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  cli_image_lib_path =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/CopyTargetFileConfig!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType '"Bool",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      enabled =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.isType 'Null
                            ],
                      scale_down =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.isType 'Null
                            ],
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:definitions/CronJobTarget!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "cron_job" ],
              _js2n__-prdslib.records.record
                {
                  container =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  cron_job = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/DeploymentTarget!predicate"
        | doc "<!--${internal}--> Mirror the deployment specified by [`DeploymentTarget::deployment`]."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "deployment" ],
              _js2n__-prdslib.records.record
                {
                  container =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  deployment = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/DnsFileConfig!predicate"
        | doc m%"
          Resolve DNS via the remote pod.
          
          Defaults to `true`.
          
          Mind that: - DNS resolving can be done in multiple ways. Some frameworks use `getaddrinfo`/`gethostbyname` functions, while others communicate directly with the DNS server at port `53` and perform a sort of manual resolution. Just enabling the `dns` feature in mirrord might not be enough. If you see an address resolution error, try enabling the [`fs`](#feature-fs) feature, and setting `read_only: ["/etc/resolv.conf"]`. - DNS filter currently works only with frameworks that use `getaddrinfo`/`gethostbyname` functions.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  enabled =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  filter =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/DnsFilterConfig!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/DnsFilterConfig!predicate"
        | doc m%"
          List of addresses/ports/subnets that should be resolved through either the remote pod or local app, depending how you set this up with either `remote` or `local`.
          
          You may use this option to specify when DNS resolution is done from the remote pod (which is the default behavior when you enable remote DNS), or from the local app (default when you have remote DNS disabled).
          
          Takes a list of values, such as:
          
          - Only queries for hostname `my-service-in-cluster` will go through the remote pod.
          
          ```json { "remote": ["my-service-in-cluster"] } ```
          
          - Only queries for addresses in subnet `1.1.1.0/24` with service port `1337`` will go through the remote pod.
          
          ```json { "remote": ["1.1.1.0/24:1337"] } ```
          
          - Only queries for hostname `google.com` with service port `1337` or `7331` will go through the remote pod.
          
          ```json { "remote": ["google.com:1337", "google.com:7331"] } ```
          
          - Only queries for `localhost` with service port `1337` will go through the local app.
          
          ```json { "local": ["localhost:1337"] } ```
          
          - Only queries with service port `1337` or `7331` will go through the local app.
          
          ```json { "local": [":1337", ":7331"] } ```
          
          Valid values follow this pattern: `[name|address|subnet/mask][:port]`.
        "%
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "remote" ],
                  _js2n__-prdslib.records.record
                    {
                      remote =
                        _js2n__-refsenv."_js2n__-:definitions/VecOrSingle_for_String!predicate",
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "local" ],
                  _js2n__-prdslib.records.record
                    {
                      local =
                        _js2n__-refsenv."_js2n__-:definitions/VecOrSingle_for_String!predicate",
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:definitions/EnvFileConfig!predicate"
        | doc m%"
          Allows the user to set or override the local process' environment variables with the ones from the remote pod.
          
          Which environment variables to load from the remote pod are controlled by setting either [`include`](#feature-env-include) or [`exclude`](#feature-env-exclude).
          
          See the environment variables [reference](https://mirrord.dev/docs/reference/env/) for more details.
          
          ```json { "feature": { "env": { "include": "DATABASE_USER;PUBLIC_ENV;MY_APP_*", "exclude": "DATABASE_PASSWORD;SECRET_ENV", "override": { "DATABASE_CONNECTION": "db://localhost:7777/my-db", "LOCAL_BEAR": "panda" } } } } ```
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  exclude =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/VecOrSingle_for_String!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  include =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/VecOrSingle_for_String!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  load_from_process =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  override =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  unset =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/VecOrSingle_for_String!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ExperimentalFileConfig!predicate"
        | doc "mirrord Experimental features. This shouldn't be used unless someone from MetalBear/mirrord tells you to."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  disable_reuseaddr =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  enable_exec_hooks_linux =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  hide_ipv6_interfaces =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  readlink =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  tcp_ping4_mock =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  trust_any_certificate =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ExternalProxyFileConfig!predicate"
        | doc m%"
          Configuration for the external proxy mirrord spawns when using the `mirrord container` command. This proxy is used to allow the internal proxy running in sidecar to connect to the mirrord agent.
          
          If you get `ConnectionRefused` errors, increasing the timeouts a bit might solve the issue.
          
          ```json { "external_proxy": { "start_idle_timeout": 30, "idle_timeout": 5 } } ```
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  idle_timeout =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  log_destination =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  log_level =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  start_idle_timeout =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  tls_certificate =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  tls_enable =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  tls_key =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/FeatureFileConfig!predicate"
        | doc m%"
          Controls mirrord features.
          
          See the [technical reference, Technical Reference](https://mirrord.dev/docs/reference/) to learn more about what each feature does.
          
          The [`env`](#feature-env), [`fs`](#feature-fs) and [`network`](#feature-network) options have support for a shortened version, that you can see [here](#root-shortened).
          
          ```json { "feature": { "env": { "include": "DATABASE_USER;PUBLIC_ENV", "exclude": "DATABASE_PASSWORD;SECRET_ENV", "override": { "DATABASE_CONNECTION": "db://localhost:7777/my-db", "LOCAL_BEAR": "panda" } }, "fs": { "mode": "write", "read_write": ".+\\.json" , "read_only": [ ".+\\.yaml", ".+important-file\\.txt" ], "local": [ ".+\\.js", ".+\\.mjs" ] }, "network": { "incoming": { "mode": "steal", "http_filter": { "header_filter": "host: api\\..+" }, "port_mapping": [[ 7777, 8888 ]], "ignore_localhost": false, "ignore_ports": [9999, 10000] }, "outgoing": { "tcp": true, "udp": true, "filter": { "local": ["tcp://1.1.1.0/24:1337", "1.1.5.0/24", "google.com", ":53"] }, "ignore_localhost": false, "unix_streams": "bear.+" }, "dns": false }, "copy_target": false, "hostname": true } } ```
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  copy_target =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/CopyTargetFileConfig!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  env =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/ToggleableConfig_for_EnvFileConfig!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  fs =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/ToggleableConfig_for_FsUserConfig!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  hostname =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  network =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/ToggleableConfig_for_NetworkFileConfig!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  split_queues =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/SplitQueuesConfig!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/FileAgentDnsConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  attempts =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  timeout =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/FsModeConfig!predicate"
        | doc m%"
          Configuration for enabling read-only or read-write file operations.
          
          These options are overriden by user specified overrides and mirrord default overrides.
          
          If you set [`"localwithoverrides"`](#feature-fs-mode-localwithoverrides) then some files can be read/write remotely based on our default/user specified. Default option for general file configuration.
          
          The accepted values are: `"local"`, `"localwithoverrides`, `"read"`, or `"write`.
        "%
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "local" ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "localwithoverrides" ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "read" ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "write" ]
                ]
            ],
      "_js2n__-:definitions/FsUserConfig!predicate"
        | doc m%"
          Changes file operations behavior based on user configuration.
          
          See the file operations [reference](https://mirrord.dev/docs/reference/fileops/) for more details, and [fs advanced](#fs-advanced) for more information on how to fully setup mirrord file operations.
          
          ### Minimal `fs` config {#fs-minimal}
          
          ```json { "feature": { "fs": "read" } } ```
          
          ### Advanced `fs` config {#fs-advanced}
          
          ```json { "feature": { "fs": { "mode": "write", "read_write": ".+\\.json" , "read_only": [ ".+\\.yaml", ".+important-file\\.txt" ], "local": [ ".+\\.js", ".+\\.mjs" ] } } } ```
        "%
        = _js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/FsModeConfig!predicate",
              _js2n__-refsenv."_js2n__-:definitions/AdvancedFsUserConfig!predicate"
            ],
      "_js2n__-:definitions/HttpFilterFileConfig!predicate"
        | doc m%"
          Filter configuration for the HTTP traffic stealer feature.
          
          Allows the user to set a filter (regex) for the HTTP headers, so that the stealer traffic feature only captures HTTP requests that match the specified filter, forwarding unmatched requests to their original destinations.
          
          Only does something when [`feature.network.incoming.mode`](#feature-network-incoming-mode) is set as `"steal"`, ignored otherwise.
          
          For example, to filter based on header: ```json { "header_filter": "host: api\\..+" } ``` Setting that filter will make mirrord only steal requests with the `host` header set to hosts that start with "api", followed by a dot, and then at least one more character.
          
          For example, to filter based on path: ```json { "path_filter": "^/api/" } ``` Setting this filter will make mirrord only steal requests to URIs starting with "/api/".
          
          This can be useful for filtering out Kubernetes liveness, readiness and startup probes. For example, for avoiding stealing any probe sent by kubernetes, you can set this filter: ```json { "header_filter": "^User-Agent: (?!kube-probe)" } ``` Setting this filter will make mirrord only steal requests that **do** have a user agent that **does not** begin with "kube-probe".
          
          Similarly, you can exclude certain paths using a negative look-ahead: ```json { "path_filter": "^(?!/health/)" } ``` Setting this filter will make mirrord only steal requests to URIs that do not start with "/health/".
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  all_of =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/InnerFilter!predicate"
                        ],
                  any_of =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/InnerFilter!predicate"
                        ],
                  header_filter =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  path_filter =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  ports =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/PortList!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/IncomingAdvancedFileConfig!predicate"
        | doc "Advanced user configuration for network incoming traffic."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  http_filter =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/ToggleableConfig_for_HttpFilterFileConfig!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  ignore_localhost =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  ignore_ports =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Integer,
                                _js2n__-prdslib.numbers.minimum 0
                              ])
                        ],
                  listen_ports =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.items
                                  [
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Integer,
                                        _js2n__-prdslib.numbers.minimum 0
                                      ],
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Integer,
                                        _js2n__-prdslib.numbers.minimum 0
                                      ]
                                  ],
                                _js2n__-prdslib.arrays.maxItems 2,
                                _js2n__-prdslib.arrays.minItems 2
                              ])
                        ],
                  mode =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/IncomingMode!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  on_concurrent_steal =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/ConcurrentSteal!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  port_mapping =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.items
                                  [
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Integer,
                                        _js2n__-prdslib.numbers.minimum 0
                                      ],
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Integer,
                                        _js2n__-prdslib.numbers.minimum 0
                                      ]
                                  ],
                                _js2n__-prdslib.arrays.maxItems 2,
                                _js2n__-prdslib.arrays.minItems 2
                              ])
                        ],
                  ports =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Integer,
                                _js2n__-prdslib.numbers.minimum 0
                              ])
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/IncomingFileConfig!predicate"
        | doc m%"
          Controls the incoming TCP traffic feature.
          
          See the incoming [reference](https://mirrord.dev/docs/reference/traffic/#incoming) for more details.
          
          Incoming traffic supports 2 modes of operation:
          
          1. Mirror (**default**): Sniffs the TCP data from a port, and forwards a copy to the interested listeners;
          
          2. Steal: Captures the TCP data from a port, and forwards it to the local process, see [`steal`](##steal);
          
          ### Minimal `incoming` config
          
          ```json { "feature": { "network": { "incoming": "steal" } } } ```
          
          ### Advanced `incoming` config
          
          ```json { "feature": { "network": { "incoming": { "mode": "steal", "http_filter": { "header_filter": "host: api\\..+" }, "port_mapping": [[ 7777, 8888 ]], "ignore_localhost": false, "ignore_ports": [9999, 10000] "listen_ports": [[80, 8111]] } } } } ```
        "%
        = _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/IncomingMode!predicate",
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-refsenv."_js2n__-:definitions/IncomingAdvancedFileConfig!predicate"
            ],
      "_js2n__-:definitions/IncomingMode!predicate"
        | doc m%"
          Allows selecting between mirrorring or stealing traffic.
          
          Can be set to either `"mirror"` (default), `"steal"` or `"off"`.
          
          - `"mirror"`: Sniffs on TCP port, and send a copy of the data to listeners. - `"off"`: Disables the incoming network feature. - `"steal"`: Supports 2 modes of operation:
          
          1. Port traffic stealing: Steals all TCP data from a port, which is selected whenever the user listens in a TCP socket (enabling the feature is enough to make this work, no additional configuration is needed);
          
          2. HTTP traffic stealing: Steals only HTTP traffic, mirrord tries to detect if the incoming data on a port is HTTP (in a best-effort kind of way, not guaranteed to be HTTP), and steals the traffic on the port if it is HTTP;
        "%
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "mirror" ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "steal" ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "off" ]
                ]
            ],
      "_js2n__-:definitions/InnerFilter!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "header" ],
                  _js2n__-prdslib.records.record
                    { header = _js2n__-prdslib.isType '"String", } {} true
                    _js2n__-prdslib.always
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "path" ],
                  _js2n__-prdslib.records.record
                    { path = _js2n__-prdslib.isType '"String", } {} true
                    _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/InternalProxyFileConfig!predicate"
        | doc m%"
          Configuration for the internal proxy mirrord spawns for each local mirrord session that local layers use to connect to the remote agent
          
          This is seldom used, but if you get `ConnectionRefused` errors, you might want to increase the timeouts a bit.
          
          ```json { "internal_proxy": { "start_idle_timeout": 30, "idle_timeout": 5 } } ```
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  client_tls_certificate =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  client_tls_key =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  connect_tcp =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  container_mode =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  idle_timeout =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  log_destination =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  log_level =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  socket_timeout =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  start_idle_timeout =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/JobTarget!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "job" ],
              _js2n__-prdslib.records.record
                {
                  container =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  job = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/LinuxCapability!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [ "SYS_ADMIN", "SYS_PTRACE", "NET_RAW", "NET_ADMIN" ]
            ],
      "_js2n__-:definitions/NetworkFileConfig!predicate"
        | doc m%"
          Controls mirrord network operations.
          
          See the network traffic [reference](https://mirrord.dev/docs/reference/traffic/) for more details.
          
          ```json { "feature": { "network": { "incoming": { "mode": "steal", "http_filter": { "header_filter": "host: api\\..+" }, "port_mapping": [[ 7777, 8888 ]], "ignore_localhost": false, "ignore_ports": [9999, 10000] }, "outgoing": { "tcp": true, "udp": true, "filter": { "local": ["tcp://1.1.1.0/24:1337", "1.1.5.0/24", "google.com", ":53"] }, "ignore_localhost": false, "unix_streams": "bear.+" }, "dns": { "enabled": true, "filter": { "local": ["1.1.1.0/24:1337", "1.1.5.0/24", "google.com"] } } } } } ```
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  dns =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/ToggleableConfig_for_DnsFileConfig!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  incoming =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/ToggleableConfig_for_IncomingFileConfig!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  outgoing =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/ToggleableConfig_for_OutgoingFileConfig!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/OutgoingFileConfig!predicate"
        | doc m%"
          Tunnel outgoing network operations through mirrord.
          
          See the outgoing [reference](https://mirrord.dev/docs/reference/traffic/#outgoing) for more details.
          
          The `remote` and `local` config for this feature are **mutually** exclusive.
          
          ```json { "feature": { "network": { "outgoing": { "tcp": true, "udp": true, "ignore_localhost": false, "filter": { "local": ["tcp://1.1.1.0/24:1337", "1.1.5.0/24", "google.com", ":53"] }, "unix_streams": "bear.+" } } } } ```
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  filter =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/OutgoingFilterConfig!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  ignore_localhost =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  tcp =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  udp =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  unix_streams =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/VecOrSingle_for_String!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/OutgoingFilterConfig!predicate"
        | doc m%"
          List of addresses/ports/subnets that should be sent through either the remote pod or local app, depending how you set this up with either `remote` or `local`.
          
          You may use this option to specify when outgoing traffic is sent from the remote pod (which is the default behavior when you enable outgoing traffic), or from the local app (default when you have outgoing traffic disabled).
          
          Takes a list of values, such as:
          
          - Only UDP traffic on subnet `1.1.1.0/24` on port 1337 will go through the remote pod.
          
          ```json { "remote": ["udp://1.1.1.0/24:1337"] } ```
          
          - Only UDP and TCP traffic on resolved address of `google.com` on port `1337` and `7331` will go through the remote pod. ```json { "remote": ["google.com:1337", "google.com:7331"] } ```
          
          - Only TCP traffic on `localhost` on port 1337 will go through the local app, the rest will be emmited remotely in the cluster.
          
          ```json { "local": ["tcp://localhost:1337"] } ```
          
          - Only outgoing traffic on port `1337` and `7331` will go through the local app. ```json { "local": [":1337", ":7331"] } ```
          
          Valid values follow this pattern: `[protocol]://[name|address|subnet/mask]:[port]`.
        "%
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "remote" ],
                  _js2n__-prdslib.records.record
                    {
                      remote =
                        _js2n__-refsenv."_js2n__-:definitions/VecOrSingle_for_String!predicate",
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "local" ],
                  _js2n__-prdslib.records.record
                    {
                      local =
                        _js2n__-refsenv."_js2n__-:definitions/VecOrSingle_for_String!predicate",
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:definitions/PodTarget!predicate"
        | doc "<!--${internal}--> Mirror the pod specified by [`PodTarget::pod`]."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "pod" ],
              _js2n__-prdslib.records.record
                {
                  container =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  pod = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/PortList!predicate"
        | doc m%"
          <!--${internal}--> Helper struct for setting up ports configuration (part of the HTTP traffic stealer feature).
          
          Defaults to a list of ports `[80, 8080]`.
          
          We use this to allow implementing a custom [`Default`] initialization, as the [`MirrordConfig`] macro (currently) doesn't support more intricate expressions.
        "%
        = _js2n__-refsenv."_js2n__-:definitions/VecOrSingle_for_uint16!predicate",
      "_js2n__-:definitions/QueueFilter!predicate"
        | doc "More queue types might be added in the future."
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required
                    [ "message_filter", "queue_type" ],
                  _js2n__-prdslib.records.record
                    {
                      message_filter =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {} {} true
                                (_js2n__-prdslib.isType '"String")
                            ],
                      queue_type =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum [ "SQS" ]
                            ],
                    } {} true _js2n__-prdslib.always
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required
                    [ "message_filter", "queue_type" ],
                  _js2n__-prdslib.records.record
                    {
                      message_filter =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {} {} true
                                (_js2n__-prdslib.isType '"String")
                            ],
                      queue_type =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum [ "Kafka" ]
                            ],
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/RolloutTarget!predicate"
        | doc "<!--${internal}--> Mirror the rollout specified by [`RolloutTarget::rollout`]."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "rollout" ],
              _js2n__-prdslib.records.record
                {
                  container =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  rollout = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/SplitQueuesConfig!predicate"
        | doc "```json { \"feature\": { \"split_queues\": { \"first-queue\": { \"queue_type\": \"SQS\", \"message_filter\": { \"wows\": \"so wows\", \"coolz\": \"^very\" } }, \"second-queue\": { \"queue_type\": \"SQS\", \"message_filter\": { \"who\": \"you$\" } }, \"third-queue\": { \"queue_type\": \"Kafka\", \"message_filter\": { \"who\": \"you$\" } }, \"fourth-queue\": { \"queue_type\": \"Kafka\", \"message_filter\": { \"wows\": \"so wows\", \"coolz\": \"^very\" } }, } } } ```"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                _js2n__-refsenv."_js2n__-:definitions/QueueFilter!predicate"
            ],
      "_js2n__-:definitions/StatefulSetTarget!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "stateful_set" ],
              _js2n__-prdslib.records.record
                {
                  container =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  stateful_set = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Target!predicate"
        | doc m%"
          <!--${internal}--> ## path
          
          Specifies the running pod (or deployment) to mirror.
          
          Supports: - `pod/{sample-pod}`; - `deployment/{sample-deployment}`; - `container/{sample-container}`; - `containername/{sample-container}`. - `job/{sample-job}`; - `cronjob/{sample-cronjob}`; - `statefulset/{sample-statefulset}`;
        "%
        = _js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/DeploymentTarget!predicate",
              _js2n__-refsenv."_js2n__-:definitions/PodTarget!predicate",
              _js2n__-refsenv."_js2n__-:definitions/RolloutTarget!predicate",
              _js2n__-refsenv."_js2n__-:definitions/JobTarget!predicate",
              _js2n__-refsenv."_js2n__-:definitions/CronJobTarget!predicate",
              _js2n__-refsenv."_js2n__-:definitions/StatefulSetTarget!predicate",
              _js2n__-prdslib.isType 'Null
            ],
      "_js2n__-:definitions/TargetFileConfig!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/Target!predicate",
                  _js2n__-prdslib.isType 'Null,
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      namespace =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType 'Null
                            ],
                      path =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/Target!predicate",
                              _js2n__-prdslib.isType 'Null
                            ],
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:definitions/ToggleableConfig_for_DnsFileConfig!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType '"Bool",
              _js2n__-refsenv."_js2n__-:definitions/DnsFileConfig!predicate"
            ],
      "_js2n__-:definitions/ToggleableConfig_for_EnvFileConfig!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType '"Bool",
              _js2n__-refsenv."_js2n__-:definitions/EnvFileConfig!predicate"
            ],
      "_js2n__-:definitions/ToggleableConfig_for_FsUserConfig!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType '"Bool",
              _js2n__-refsenv."_js2n__-:definitions/FsUserConfig!predicate"
            ],
      "_js2n__-:definitions/ToggleableConfig_for_HttpFilterFileConfig!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType '"Bool",
              _js2n__-refsenv."_js2n__-:definitions/HttpFilterFileConfig!predicate"
            ],
      "_js2n__-:definitions/ToggleableConfig_for_IncomingFileConfig!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType '"Bool",
              _js2n__-refsenv."_js2n__-:definitions/IncomingFileConfig!predicate"
            ],
      "_js2n__-:definitions/ToggleableConfig_for_NetworkFileConfig!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType '"Bool",
              _js2n__-refsenv."_js2n__-:definitions/NetworkFileConfig!predicate"
            ],
      "_js2n__-:definitions/ToggleableConfig_for_OutgoingFileConfig!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType '"Bool",
              _js2n__-refsenv."_js2n__-:definitions/OutgoingFileConfig!predicate"
            ],
      "_js2n__-:definitions/VecOrSingle_for_String!predicate" =
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
      "_js2n__-:definitions/VecOrSingle_for_uint16!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Integer,
                  _js2n__-prdslib.numbers.minimum 0
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Integer,
                        _js2n__-prdslib.numbers.minimum 0
                      ])
                ]
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.ResourceClaim!predicate"
        | doc "ResourceClaim references one entry in PodSpec.ResourceClaims."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                { name = _js2n__-prdslib.isType '"String", } {} true
                _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.ResourceRequirements!predicate"
        | doc "ResourceRequirements describes the compute resource requirements."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  claims =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/io.k8s.api.core.v1.ResourceClaim!predicate"
                        ],
                  limits =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/io.k8s.apimachinery.pkg.api.resource.Quantity!predicate"
                        ],
                  requests =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/io.k8s.apimachinery.pkg.api.resource.Quantity!predicate"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.api.core.v1.Toleration!predicate"
        | doc "The pod this Toleration is attached to tolerates any taint that matches the triple <key,value,effect> using the matching operator <operator>."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  effect = _js2n__-prdslib.isType '"String",
                  key = _js2n__-prdslib.isType '"String",
                  operator = _js2n__-prdslib.isType '"String",
                  tolerationSeconds = _js2n__-prdslib.isType 'Integer,
                  value = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/io.k8s.apimachinery.pkg.api.resource.Quantity!predicate"
        | doc m%"
          Quantity is a fixed-point representation of a number. It provides convenient marshaling/unmarshaling in JSON and YAML, in addition to String() and AsInt64() accessors.
          
          The serialization format is:
          
          ``` <quantity>        ::= <signedNumber><suffix>
          
          	(Note that <suffix> may be empty, from the "" case in <decimalSI>.)
          
          <digit>           ::= 0 | 1 | ... | 9 <digits>          ::= <digit> | <digit><digits> <number>          ::= <digits> | <digits>.<digits> | <digits>. | .<digits> <sign>            ::= "+" | "-" <signedNumber>    ::= <number> | <sign><number> <suffix>          ::= <binarySI> | <decimalExponent> | <decimalSI> <binarySI>        ::= Ki | Mi | Gi | Ti | Pi | Ei
          
          	(International System of units; See: http://physics.nist.gov/cuu/Units/binary.html)
          
          <decimalSI>       ::= m | "" | k | M | G | T | P | E
          
          	(Note that 1024 = 1Ki but 1000 = 1k; I didn't choose the capitalization.)
          
          <decimalExponent> ::= "e" <signedNumber> | "E" <signedNumber> ```
          
          No matter which of the three exponent forms is used, no quantity may represent a number greater than 2^63-1 in magnitude, nor may it have more than 3 decimal places. Numbers larger or more precise will be capped or rounded up. (E.g.: 0.1m will rounded up to 1m.) This may be extended in the future if we require larger or smaller quantities.
          
          When a Quantity is parsed from a string, it will remember the type of suffix it had, and will use the same type again when it is serialized.
          
          Before serializing, Quantity will be put in "canonical form". This means that Exponent/suffix will be adjusted up or down (with a corresponding increase or decrease in Mantissa) such that:
          
          - No precision is lost - No fractional digits will be emitted - The exponent (or suffix) is as large as possible.
          
          The sign will be omitted unless the number is negative.
          
          Examples:
          
          - 1.5 will be serialized as "1500m" - 1.5Gi will be serialized as "1536Mi"
          
          Note that the quantity will NEVER be internally represented by a floating point number. That is the whole point of this exercise.
          
          Non-canonical values will still parse as long as they are well formed, but will be re-emitted in their canonical form. (So always use canonical form, or don't diff.)
          
          This format is intended to make it difficult to use these numbers without writing some sort of special handling code in the hopes that that will cause implementors to also use a fixed point implementation.
        "%
        = _js2n__-prdslib.isType '"String",
    }
    in
  {
      accept_invalid_certificates
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [ _js2n__-prdslib.isType '"Bool", _js2n__-prdslib.isType 'Null ])
        | doc m%"
          Controls whether or not mirrord accepts invalid TLS certificates (e.g. self-signed certificates).
          
          If not provided, mirrord will use value from the kubeconfig.
        "%
        | optional,
      agent
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/AgentFileConfig!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | optional,
      connect_tcp
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [ _js2n__-prdslib.isType '"String", _js2n__-prdslib.isType 'Null ])
        | doc m%"
          IP:PORT to connect to instead of using k8s api, for testing purposes.
          
          ```json { "connect_tcp": "10.10.0.100:7777" } ```
        "%
        | optional,
      container
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/ContainerFileConfig!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | optional,
      experimental
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/ExperimentalFileConfig!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | optional,
      external_proxy
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/ExternalProxyFileConfig!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | optional,
      feature
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/FeatureFileConfig!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | optional,
      internal_proxy
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/InternalProxyFileConfig!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | optional,
      kube_context
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [ _js2n__-prdslib.isType '"String", _js2n__-prdslib.isType 'Null ])
        | doc m%"
          Kube context to use from the kubeconfig file. Will use current context if not specified.
          
          ```json { "kube_context": "mycluster" } ```
        "%
        | optional,
      kubeconfig
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [ _js2n__-prdslib.isType '"String", _js2n__-prdslib.isType 'Null ])
        | doc m%"
          Path to a kubeconfig file, if not specified, will use `KUBECONFIG`, or `~/.kube/config`, or the in-cluster config.
          
          ```json { "kubeconfig": "~/bear/kube-config" } ```
        "%
        | optional,
      operator
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [ _js2n__-prdslib.isType '"Bool", _js2n__-prdslib.isType 'Null ])
        | doc "Whether mirrord should use the operator. If not set, mirrord will first attempt to use the operator, but continue without it in case of failure."
        | optional,
      sip_binaries
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/VecOrSingle_for_String!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | doc m%"
          Binaries to patch (macOS SIP).
          
          Use this when mirrord isn't loaded to protected binaries that weren't automatically patched.
          
          Runs `endswith` on the binary path (so `bash` would apply to any binary ending with `bash` while `/usr/bin/bash` would apply only for that binary).
          
          ```json { "sip_binaries": "bash;python" } ```
        "%
        | optional,
      skip_build_tools
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [ _js2n__-prdslib.isType '"Bool", _js2n__-prdslib.isType 'Null ])
        | doc m%"
          Allows mirrord to skip build tools. Useful when running command lines that build and run the application in a single command.
          
          Defaults to `true`.
          
          Build-Tools: `["as", "cc", "ld", "go", "air", "asm", "cc1", "cgo", "dlv", "gcc", "git", "link", "math", "cargo", "hpack", "rustc", "compile", "collect2", "cargo-watch", "debugserver"]`
        "%
        | optional,
      skip_processes
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/VecOrSingle_for_String!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | doc m%"
          Allows mirrord to skip unwanted processes.
          
          Useful when process A spawns process B, and the user wants mirrord to operate only on process B. Accepts a single value, or multiple values separated by `;`.
          
          ```json { "skip_processes": "bash;node" } ```
        "%
        | optional,
      target
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/TargetFileConfig!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | optional,
      telemetry
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [ _js2n__-prdslib.isType '"Bool", _js2n__-prdslib.isType 'Null ])
        | doc "Controls whether or not mirrord sends telemetry data to MetalBear cloud. Telemetry sent doesn't contain personal identifiers or any data that should be considered sensitive. It is used to improve the product. [For more information](https://github.com/metalbear-co/mirrord/blob/main/TELEMETRY.md)"
        | optional,
      use_proxy
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [ _js2n__-prdslib.isType '"Bool", _js2n__-prdslib.isType 'Null ])
        | doc "When disabled, mirrord will remove `HTTP[S]_PROXY` env variables before doing any network requests. This is useful when the system sets a proxy but you don't want mirrord to use it. This also applies to the mirrord process (as it just removes the env). If the remote pod sets this env, the mirrord process will still use it."
        | optional,
    }