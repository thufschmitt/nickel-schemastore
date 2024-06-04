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
      "_js2n__-:definitions/generic-memory!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType '"String",
                _js2n__-prdslib.strings.pattern
                  "^[1-9][0-9]*(M|MB|G|GB|m|mb|g|gb)$"
              ]),
      "_js2n__-:definitions/hooks!contract" =
        Array
            {
              name
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.strings.pattern "^[A-Za-z0-9_\\-\\.]+$"
                    ])
                | doc "An internal name which can be used for documentation purposes and shown by the deployer.",
              parameters
                | _js2n__-refsenv."_js2n__-:definitions/hooks-parameters!contract"
                | doc "Configuration parameters that are used when executing the hook to the target runtime environment."
                | optional,
              parameters-metadata
                | _js2n__-refsenv."_js2n__-:definitions/properties-metadata!contract"
                | doc "Additional information about the hook's parameters."
                | optional,
              phases
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType '"String",
                            _js2n__-prdslib.enum
                              [
                                "application.before-stop.live",
                                "application.before-stop.idle",
                                "application.after-stop.live",
                                "application.after-stop.idle",
                                "application.before-unmap-routes",
                                "deploy.application.before-stop",
                                "blue-green.application.before-stop.idle",
                                "blue-green.application.before-stop.live",
                                "deploy.application.after-stop",
                                "blue-green.application.after-stop.idle",
                                "blue-green.application.after-stop.live",
                                "deploy.application.before-unmap-routes",
                                "blue-green.application.before-unmap-routes.live",
                                "blue-green.application.before-unmap-routes.idle",
                                "deploy.application.before-start",
                                "blue-green.application.before-start.idle",
                                "blue-green.application.before-start.live"
                              ]
                          ])
                    ])
                | doc "A list of strings that define the points at which the hook must be executed."
                | optional,
              requires
                | Array
                  {
                    name
                      | _js2n__-prdslib.contract_from_predicate
                        (_js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType '"String",
                            _js2n__-prdslib.strings.pattern
                              "^[A-Za-z0-9_\\-\\.]+$"
                          ])
                      | doc "An MTA internal name which must match either a provided name, or a resource name within the same MTA.",
                    parameters
                      | {  .. }
                      | doc "Parameters can be used to influence the behavior of tools which interpret this descriptor. Parameters are not made available to the hook at runtime. Provided property values can be accessed by \"~{<provided-property-name>}\". Such expressions can be part of an arbitrary string"
                      | optional,
                    parameters-metadata
                      | _js2n__-refsenv."_js2n__-:definitions/properties-metadata!contract"
                      | doc "Additional information about the hook's parameters."
                      | optional,
                    ..
                  }
                | doc "List of names either matching a resource name or a provided dependency name provided within the same MTA that are required by this hook."
                | optional,
              type
                | std.enum.TagOrString
                | [| 'task |]
                | doc "Defines the type of action that should be executed by the deployer.",
              ..
            },
      "_js2n__-:definitions/hooks-parameters!contract" =
        {
            command
              | String
              | doc "Defines the actual command that is executed as a Cloud Foundry task.",
            disk-quota
              | _js2n__-refsenv."_js2n__-:definitions/generic-memory!contract"
              | doc "Defines the disk space that is available to the Cloud Foundry task."
              | optional,
            memory
              | _js2n__-refsenv."_js2n__-:definitions/generic-memory!contract"
              | doc "Defines the memory that is available to the Cloud Foundry task."
              | optional,
            name
              | String
              | doc "Defines the name of the Cloud Foundry task that should be executed."
              | optional,
            ..
          },
      "_js2n__-:definitions/module-parameters!contract" =
        {
            app-name
              | String
              | doc "The name of the application in the Cloud Foundry environment to be deployed for this module, based on the module name."
              | optional,
            buildpack
              | String
              | doc "The name or the URL of a custom buildpack required by the application."
              | optional,
            buildpacks
              | _js2n__-refsenv."_js2n__-:definitions/module-parameters-buildpacks!contract"
              | doc "An array of buildpacks. If a buildpack parameter already exists, it will be overwritten by the buildpacks listed in the buildpacks parameter, so that you have to include it in the array."
              | optional,
            command
              | String
              | doc "A custom command required to start the application."
              | optional,
            create-service-broker
              | Bool
              | doc "Specifies whether [true|false] a service broker should be registered for the application module; default value is: false."
              | optional,
            dependency-type
              | std.enum.TagOrString
              | [| 'soft, 'hard |]
              | doc "Defines the memory allocated to the application."
              | optional,
            disk-quota
              | _js2n__-refsenv."_js2n__-:definitions/generic-memory!contract"
              | doc "The disk space that will be available to the application. This parameter requires a unit of measurement M, MB, G, or GB in upper or lower case."
              | optional,
            docker
              | _js2n__-refsenv."_js2n__-:definitions/module-parameters-docker!contract"
              | doc "Creates a module from a docker image. When using a docker image parameter, we do not need to specify the module in the MANIFEST.mf file.When uploading a docker image, the content of a module is not needed."
              | optional,
            domain
              | String
              | doc "The domain on which the application will be available later."
              | optional,
            domains
              | _js2n__-refsenv."_js2n__-:definitions/module-parameters-domains!contract"
              | doc "The domains on which the application will be available later. The resulting application routes will be the Cartesian product of the domains and hosts. That is, a separate route for each host is constructed on each domain."
              | optional,
            enable-ssh
              | Bool
              | doc "Enables use of SSH within an application. Supported for the Diego container runtime environment only."
              | optional,
            health-check-http-endpoint
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.strings.pattern "^/.+"
                  ])
              | doc "A http health check defaults to using '/' as its endpoint, but you can specify a custom endpoint."
              | optional,
            health-check-invocation-timeout
              | std.number.Integer
              | doc "The timeout in seconds for individual health check requests for http and port health checks."
              | optional,
            health-check-timeout
              | std.number.Integer
              | doc "The timeout is the amount of time (in seconds) allowed to elapse between starting up an app and the first healthy response."
              | optional,
            health-check-type
              | std.enum.TagOrString
              | [| 'http, 'process, 'port |]
              | doc "Defines how the module will be monitored for availability."
              | optional,
            host
              | String
              | doc "The hostname or subdomain where an application is available later."
              | optional,
            hosts
              | _js2n__-refsenv."_js2n__-:definitions/module-parameters-hosts!contract"
              | doc "The hostnames or subdomain where an application is available later."
              | optional,
            idle-domain
              | String
              | doc "The idle domain on which the idle application will be available during blue-green deploy."
              | optional,
            idle-domains
              | _js2n__-refsenv."_js2n__-:definitions/module-parameters-domains!contract"
              | doc "The domains on which the idle application will be available during blue-green deploy. The resulting application routes will be the Cartesian product of the domains and hosts. That is, a separate route for each host is constructed on each domain."
              | optional,
            idle-host
              | String
              | doc "The hostname or subdomain where the idle application will be available during blue-green deploy."
              | optional,
            idle-hosts
              | _js2n__-refsenv."_js2n__-:definitions/module-parameters-hosts!contract"
              | doc "The hostnames or subdomain where the idle application will be available during blue-green deploy."
              | optional,
            instances
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"Number",
                    _js2n__-prdslib.numbers.minimum 0
                  ])
              | doc "The number of application instances that will be started during the deployment."
              | optional,
            keep-existing
              | _js2n__-refsenv."_js2n__-:definitions/module-parameters-keep-existing!contract"
              | doc "Defines the application attributes which will be kept after the deployment or blue-green deployment has finished. The supported attributes which could be kept are application environment, application bindings and application routes. If not specified, the default values are false, which indicates that each application attribute will be updated with the new values presented in the deployment descriptor."
              | optional,
            keep-existing-routes
              | Bool
              | doc "When specified on module level, it indicates if the existing routes of the module's corresponding application should be kept even if they are not defined within the deployment and/or extension descriptors.When specified on global level, under the parameters section of the descriptor, it indicates if the existing routes of all applications within that MTA should be kept.The module-level variant of the parameter has priority over the global parameter.This parameter is typically used when users want to keep the routes they have mapped manually by using the cf map-route command. We discourage this approach, as manual operations could lead to inconsistent deployment results and difficult troubleshooting. We recommend you to define all routes in the deployment and/or extension descriptors, which allows for their automatic management."
              | optional,
            memory
              | _js2n__-refsenv."_js2n__-:definitions/generic-memory!contract"
              | doc "Defines the memory allocated to the application."
              | optional,
            no-route
              | Bool
              | doc "Defines if a route should be assigned to the application."
              | optional,
            no-start
              | Bool
              | doc "Start/do not start the application during deployment. This parameter setting overrides the command-line option --no-start. If you explicitly set the no-start to false for the module foo in the example provided, then the module foo is started on deployment, even if you also specify the command-line option --no-start with the cf deploy command."
              | optional,
            restart-on-env-change
              | _js2n__-refsenv."_js2n__-:definitions/module-parameters-restart-on-env-change!contract"
              | doc "Specifies whether an application should be restarted if an environment variable has been changed in one of the following categories: vcap-application, vcap-services, user-provided. If you set these parameters to false, the changes in environment are not consumable by a running instances of the application. If your application depends on the latest environment, it might become outdated."
              | optional,
            routes
              | _js2n__-refsenv."_js2n__-:definitions/module-parameters-routes!contract"
              | doc "A parameter that lists multiple HTTP routes. It is a combination of the old parameters host, domain, port and route-path, which encompasses the full addresses to which to bind a module. In case the new routes parameter and the old ones are available, the routes value is used and the values of the old parameters are ignored. Each route for the application is created if it does not already exist. A routes parameter consists of one or many HTTP routes following the pattern myhost.my.domain/path"
              | optional,
            service-broker-name
              | String
              | doc "The name of the service broker in the Cloud Foundry environment to be created and registered for the specified application module."
              | optional,
            service-broker-password
              | String
              | doc "The password used for authentication by the XS controller at the service broker when performing service-related requests. The parameter is mandatory if create-service-broker: true."
              | optional,
            service-broker-space-scoped
              | Bool
              | doc "Makes the service plans of the broker visible only within the targeted space."
              | optional,
            service-broker-url
              | String
              | doc "Specifies the value of the service broker universal resource locator (URL) to register; service requests are sent to this URL. The parameter is mandatory if create-service-broker: true."
              | optional,
            service-broker-user
              | String
              | doc "The name of the user required for authentication by the XS controller at the service broker when performing service-related requests. The parameter is mandatory if create-service-broker: true."
              | optional,
            stack
              | String
              | doc "Use this parameter to define which prebuilt root file system (rootfs) you want to use."
              | optional,
            tasks
              | _js2n__-refsenv."_js2n__-:definitions/module-parameters-tasks!contract"
              | doc "Specify tasks, which are available for execution in the current droplet of the application. Also provide use of environment variables which are specified with the env scope."
              | optional,
            upload-timeout
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"Number",
                    _js2n__-prdslib.numbers.minimum 0
                  ])
              | doc "The application upload timeout in seconds."
              | optional,
            ..
          },
      "_js2n__-:definitions/module-parameters-buildpacks!contract" =
        Array (String),
      "_js2n__-:definitions/module-parameters-docker!contract" =
        {
            image
              | String
              | doc "An image parameter is a docker image from the Docker Hub or somewhere else. eg. cloudfoundry/test-app"
              | optional,
            password
              | String
              | doc "The password is optional, but if a Docker image from a private repository is uploaded, then it is mandatory."
              | optional,
            username
              | String
              | doc "The username is optional, but if a Docker image from a private repository is uploaded, then it is mandatory."
              | optional,
            ..
          },
      "_js2n__-:definitions/module-parameters-domains!contract" =
        Array (String),
      "_js2n__-:definitions/module-parameters-hosts!contract" = Array (String),
      "_js2n__-:definitions/module-parameters-keep-existing!contract" =
        {
            env | Bool | doc "Keep the existing environment" | optional,
            routes | Bool | doc "Keep the existing routes" | optional,
            service-bindings
              | Bool
              | doc "Keep the existing Service bindings"
              | optional,
            ..
          },
      "_js2n__-:definitions/module-parameters-restart-on-env-change!contract" =
        Array (
            _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.records.record
                {
                  user-provided = _js2n__-prdslib.isType '"Bool",
                  vcap-application = _js2n__-prdslib.isType '"Bool",
                  vcap-services = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always)
          ),
      "_js2n__-:definitions/module-parameters-routes!contract" =
        Array
            {
              apply-namespace | Bool | optional,
              no-hostname | Bool | optional,
              protocol
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum [ "http1", "http2" ]
                    ])
                | optional,
              route | String,
              ..
            },
      "_js2n__-:definitions/module-parameters-tasks!contract" =
        Array
            {
              command | String | doc "The command to be executed.",
              disk-quota
                | _js2n__-refsenv."_js2n__-:definitions/generic-memory!contract"
                | doc "Defines the disk space that is available to the Cloud Foundry task."
                | optional,
              memory
                | _js2n__-refsenv."_js2n__-:definitions/generic-memory!contract"
                | doc "Defines the memory that is available to the Cloud Foundry task."
                | optional,
              name | String | doc "The task name.",
              ..
            },
      "_js2n__-:definitions/module-provides!contract" =
        Array
            {
              name
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.strings.pattern "^[A-Za-z0-9_\\-\\.]+$"
                    ])
                | doc "An MTA internal name which can used by a requiring module.",
              parameters
                | _js2n__-refsenv."_js2n__-:definitions/module-provides-parameters!contract"
                | doc "Parameters can be used to influence the behavior of tools which interpret this descriptor. Parameters are not made available to the module at runtime. Provided property values can be accessed by \"~{<provided-property-name>}\". Such expressions can be part of an arbitrary string"
                | optional,
              parameters-metadata
                | _js2n__-refsenv."_js2n__-:definitions/properties-metadata!contract"
                | doc "Additional information about the provided dependency's parameters."
                | optional,
              properties
                | {  .. }
                | doc "Property names and values make up the configuration data which is to be provided to requiring modules at runtime"
                | optional,
              properties-metadata
                | _js2n__-refsenv."_js2n__-:definitions/properties-metadata!contract"
                | doc "Additional information about the provided dependency's properties."
                | optional,
              public
                | Bool
                | doc "Indicates, that the provided properties shall be made publicly available by the deployer. Default value is false."
                | optional,
              ..
            },
      "_js2n__-:definitions/module-provides-parameters!contract" =
        {
            visibility
              | Array
                _js2n__-refsenv."_js2n__-:definitions/resource-configuration-target!contract"
              | optional,
            ..
          },
      "_js2n__-:definitions/module-requires!contract" =
        Array
            {
              list
                | String
                | doc "All required and found configuration data sets will be assembled into a JSON array and provided to the module by the lookup name as specified by the value of 'list'."
                | optional,
              name
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.strings.pattern "^[A-Za-z0-9_\\-\\.]+$"
                    ])
                | doc "An MTA internal name which must match either a provided name, a resource name, or a module name within the same MTA.",
              parameters
                | _js2n__-refsenv."_js2n__-:definitions/module-requires-parameters!contract"
                | doc "Parameters can be used to influence the behavior of tools which interpret this descriptor. Parameters are not made available to the module at runtime. Provided property values can be accessed by \"~{<provided-property-name>}\". Such expressions can be part of an arbitrary string"
                | optional,
              parameters-metadata
                | _js2n__-refsenv."_js2n__-:definitions/properties-metadata!contract"
                | doc "Additional information about the required dependency's parameters."
                | optional,
              properties
                | {  .. }
                | doc "Required properties can be mapped from provided properties. Provided property values can be accessed by \"~{<provided-property-name>}\". Such expressions can be part of an arbitrary string"
                | optional,
              properties-metadata
                | _js2n__-refsenv."_js2n__-:definitions/properties-metadata!contract"
                | doc "Additional information about the required dependency's properties."
                | optional,
              ..
            },
      "_js2n__-:definitions/module-requires-parameters!contract" =
        {
            content-target
              | Bool
              | doc "Specify that the resource would be used as a target for the module content deployment."
              | optional,
            ..
          },
      "_js2n__-:definitions/module-type!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType '"String",
                _js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.enum
                      [
                        "application",
                        "binary",
                        "business-logging",
                        "com.sap.application.content",
                        "com.sap.html5.application-content",
                        "com.sap.portal.site-content",
                        "com.sap.xs.hdi",
                        "com.sap.xs.hdi-dynamic",
                        "custom",
                        "dotnet_core",
                        "go",
                        "java",
                        "java.tomcat",
                        "java.tomee",
                        "javascript.nodejs",
                        "nodejs",
                        "php",
                        "python",
                        "ruby",
                        "staticfile"
                      ],
                    _js2n__-prdslib.isType '"String"
                  ]
              ]),
      "_js2n__-:definitions/properties-metadata!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType 'Record,
                _js2n__-prdslib.records.record {} {} true
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          "optional" = _js2n__-prdslib.isType '"Bool",
                          overwritable = _js2n__-prdslib.isType '"Bool",
                        } {} true _js2n__-prdslib.always
                    ])
              ]),
      "_js2n__-:definitions/resource-configuration-target!contract" =
        {
            org
              | String
              | doc "The org in which the configuration will be looked for"
              | optional,
            space
              | String
              | doc "The space in which the configuration will be looked for"
              | optional,
            ..
          },
      "_js2n__-:definitions/resource-parameters!contract" =
        {
            config
              | {  .. }
              | doc "Map value, containing the service creation configuration, for example, url and user credentials (user and password)."
              | optional,
            provider-id
              | String
              | doc "The resource from the provider MTA <mta-id>:<mta-provides-dependency-name>."
              | optional,
            provider-nid
              | std.enum.TagOrString
              | [| 'mta |]
              | doc "When used for cross-MTA dependency resolution the provider-nid is always 'mta'."
              | optional,
            service
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.enum
                          [
                            "application-logs",
                            "auditlog",
                            "rabbitmq",
                            "autoscaler",
                            "portal-services",
                            "fs-storage",
                            "hana",
                            "jobscheduler",
                            "xsuaa",
                            "connectivity",
                            "destination",
                            "feature-flags",
                            "redis",
                            "ml-foundation-services",
                            "mongodb",
                            "objectstore",
                            "postgresql"
                          ],
                        _js2n__-prdslib.isType '"String"
                      ]
                  ])
              | doc "Name of the service to create."
              | optional,
            service-broker
              | String
              | doc "The name of the service broker to be used."
              | optional,
            service-key-name
              | String
              | doc "Used when consuming an existing service key. Specifies the name of the service key. See Consumption of existing service keys for more information."
              | optional,
            service-name
              | String
              | doc "Service instance name. Default value is the resource name."
              | optional,
            service-plan
              | String
              | doc "Name of the service plan to be used."
              | optional,
            service-tags
              | Array (String)
              | doc "Some services employ a list of custom tags, which provide an easier way for applications to parse <VCAP_SERVICES> for credentials. You can provide custom tags when creating a service instance. For more information, see Service Tags."
              | optional,
            siteId
              | String
              | doc "A globally unique ID (GUID) for your Fiori LaunchPad site."
              | optional,
            skip-service-updates
              | _js2n__-refsenv."_js2n__-:definitions/resource-skip-service-updates!contract"
              | doc "Map value, containing the service components (parameters, plan, tags) to skip when updating a service."
              | optional,
            syslog-drain-url
              | String
              | doc "URL to which logs for bound applications are streamed."
              | optional,
            target
              | _js2n__-refsenv."_js2n__-:definitions/resource-configuration-target!contract"
              | doc "The name of the organization and space in which the provider MTA is deployed."
              | optional,
            version
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.strings.pattern
                      "^(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)(-(0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*)(\\.(0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*))*)?(\\+[0-9a-zA-Z-]+(\\.[0-9a-zA-Z-]+)*)?$"
                  ])
              | doc "The version of the provider MTA."
              | optional,
            ..
          },
      "_js2n__-:definitions/resource-requires!contract" =
        Array
            {
              name
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.strings.pattern "^[A-Za-z0-9_\\-\\.]+$"
                    ])
                | doc "An MTA internal name which must match either a provided name, or a resource name within the same MTA.",
              parameters
                | {  .. }
                | doc "Parameters can be used to influence the behavior of tools which interpret this descriptor. Parameters are not made available to the resource at runtime. Provided property values can be accessed by \"~{<provided-property-name>}\". Such expressions can be part of an arbitrary string"
                | optional,
              parameters-metadata
                | _js2n__-refsenv."_js2n__-:definitions/properties-metadata!contract"
                | doc "Additional information about the required dependency's parameters."
                | optional,
              properties
                | {  .. }
                | doc "Required properties can be mapped from provided properties. Provided property values can be accessed by \"~{<provided-property-name>}\". Such expressions can be part of an arbitrary string"
                | optional,
              properties-metadata
                | _js2n__-refsenv."_js2n__-:definitions/properties-metadata!contract"
                | doc "Additional information about the required dependency's properties."
                | optional,
              ..
            },
      "_js2n__-:definitions/resource-skip-service-updates!contract" =
        {
            parameters
              | Bool
              | doc "The configuration parameters which will be passed to the service broker."
              | optional,
            plan | Bool | doc "The service plan." | optional,
            syslog-drain-url
              | Bool
              | doc "URL to which logs for bound applications are streamed."
              | optional,
            tags
              | Bool
              | doc "The custom tags for a service instance."
              | optional,
            ..
          },
      "_js2n__-:definitions/resource-type!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType '"String",
                _js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.enum
                      [
                        "org.cloudfoundry.managed-service",
                        "org.cloudfoundry.existing-service",
                        "org.cloudfoundry.existing-service-key",
                        "org.cloudfoundry.user-provided-service",
                        "configuration"
                      ],
                    _js2n__-prdslib.isType '"String"
                  ]
              ]),
    }
    in
  {
      ID
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern "^[A-Za-z0-9_\\-\\.]+$"
            ])
        | doc "A globally unique ID of this MTA. Unlimited string of unicode characters.",
      _schema-version
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern "^(\\d+\\.)?(\\d+\\.)?(\\*|\\d+)$"
            ])
        | doc "Used to indicate to an MTA processing tool (e.g. a deployer), which schema version was taken as the base when authoring a descriptor.",
      copyright
        | String
        | doc "A copyright statement from the provider."
        | optional,
      description
        | String
        | doc "A non-translatable description of this MTA. This is not a text for application users."
        | optional,
      hooks
        | _js2n__-refsenv."_js2n__-:definitions/hooks!contract"
        | doc "A list of hooks that will be executed for the MTA."
        | optional,
      module-types
        | Array
          {
            extends
              | String
              | doc "The name of the extended type. Can be another module type defined in this descriptor or one of the default types supported by the deployer.",
            name
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.strings.pattern "^[A-Za-z0-9_\\-\\.]+$"
                  ])
              | doc " An MTA internal name of the module type that will be specified in the 'type' element of modules consuming it.",
            parameters
              | {  .. }
              | doc "Configuration parameters that will be inherited in all modules of this type."
              | optional,
            parameters-metadata
              | _js2n__-refsenv."_js2n__-:definitions/properties-metadata!contract"
              | doc "Additional information about the module's parameters."
              | optional,
            properties
              | {  .. }
              | doc "A collection of key-value pairs that will be inherited by all modules of this type."
              | optional,
            properties-metadata
              | _js2n__-refsenv."_js2n__-:definitions/properties-metadata!contract"
              | doc "Additional information about the module type's properties."
              | optional,
            ..
          }
        | doc "A list of custom module type definitions that will be used by the MTA application."
        | optional,
      modules
        | Array
          {
            deployed-after
              | Array (String)
              | doc "A list containing the names of the modules that must be deployed prior to this one."
              | optional,
            description
              | String
              | doc "A free text describing this module."
              | optional,
            hooks
              | _js2n__-refsenv."_js2n__-:definitions/hooks!contract"
              | doc "A list of hooks that will be executed for the module."
              | optional,
            name
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.strings.pattern "^[A-Za-z0-9_\\-\\.]+$"
                  ])
              | doc "The module name which must be unique and cannot be the same as any provided property set or resource name.",
            parameters
              | _js2n__-refsenv."_js2n__-:definitions/module-parameters!contract"
              | doc "Configuration parameters that are used when deploying the module to the target runtime environment."
              | optional,
            parameters-metadata
              | _js2n__-refsenv."_js2n__-:definitions/properties-metadata!contract"
              | doc "Additional information about the module's parameters."
              | optional,
            path
              | String
              | doc "The path to a folder that contains the module artifacts."
              | optional,
            properties
              | {  .. }
              | doc "A collection of key-value pairs that are available to the module at runtime."
              | optional,
            properties-metadata
              | _js2n__-refsenv."_js2n__-:definitions/properties-metadata!contract"
              | doc "Additional information about the module's properties."
              | optional,
            provides
              | _js2n__-refsenv."_js2n__-:definitions/module-provides!contract"
              | doc "List of provided names (MTA internal) to which properties can be attached"
              | optional,
            requires
              | _js2n__-refsenv."_js2n__-:definitions/module-requires!contract"
              | doc "List of names either matching a resource name or a name provided by another module within the same MTA that are required by this module."
              | optional,
            type
              | _js2n__-refsenv."_js2n__-:definitions/module-type!contract"
              | doc "The module type that defines the design-time tools for the module.",
            ..
          }
        | doc "A list of modules to be deployed by the MTA application."
        | optional,
      parameters
        | {  .. }
        | doc "Global parameters related to the MTA application."
        | optional,
      parameters-metadata
        | _js2n__-refsenv."_js2n__-:definitions/properties-metadata!contract"
        | doc "Additional information about the MTA's parameters."
        | optional,
      provider
        | String
        | doc "The provider or vendor of this software."
        | optional,
      resource-types
        | Array
          {
            extends
              | String
              | doc "The name of the extended type. Can be another resource type defined in this descriptor or one of the default types supported by the deployer.",
            name
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.strings.pattern "^[A-Za-z0-9_\\-\\.]+$"
                  ])
              | doc " An MTA internal name of the resource type that will be specified in the 'type' element of resources consuming it.",
            parameters
              | {  .. }
              | doc "Configuration parameters that will be inherited in all resources of this type."
              | optional,
            parameters-metadata
              | _js2n__-refsenv."_js2n__-:definitions/properties-metadata!contract"
              | doc "Additional information about the resource's parameters."
              | optional,
            properties
              | {  .. }
              | doc "A collection of key-value pairs that will be inherited by all resources of this type."
              | optional,
            properties-metadata
              | _js2n__-refsenv."_js2n__-:definitions/properties-metadata!contract"
              | doc "Additional information about the resource type's properties."
              | optional,
            ..
          }
        | doc "A list of custom resource type definitions that will be used by the MTA application."
        | optional,
      resources
        | Array
          {
            active
              | Bool
              | doc "If a resource is declared to be active, it is allocated and bound according to declared requirements. Default value is true."
              | optional,
            description
              | String
              | doc "A free text describing this resource."
              | optional,
            hooks
              | _js2n__-refsenv."_js2n__-:definitions/hooks!contract"
              | doc "A list of hooks that will be executed for the resource."
              | optional,
            name
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.strings.pattern "^[A-Za-z0-9_\\-\\.]+$"
                  ])
              | doc "The resource name which must be unique and cannot be the same as any provided property set or resource name.",
            "optional"
              | Bool
              | doc "A resource can be declared to be optional, if the MTA can compensate for its non-existence. Default value is false."
              | optional,
            parameters
              | _js2n__-refsenv."_js2n__-:definitions/resource-parameters!contract"
              | doc "Parameters can be used to influence the behavior of tools which interpret this descriptor. Parameters are not made available to requiring modules at runtime. Untyped resources cannot have parameters."
              | optional,
            parameters-metadata
              | _js2n__-refsenv."_js2n__-:definitions/properties-metadata!contract"
              | doc "Additional information about the resource's parameters."
              | optional,
            processed-after
              | Array (String)
              | doc "A list containing the names of the resources that must be processed prior to this one."
              | optional,
            properties
              | {  .. }
              | doc "Property names and values make up the configuration data which is to be provided to requiring modules at runtime."
              | optional,
            properties-metadata
              | _js2n__-refsenv."_js2n__-:definitions/properties-metadata!contract"
              | doc "Additional information about the resource's properties."
              | optional,
            requires
              | _js2n__-refsenv."_js2n__-:definitions/resource-requires!contract"
              | doc "List of names either matching a resource name or a name provided by another resource within the same MTA that are required by this resource."
              | optional,
            type
              | _js2n__-refsenv."_js2n__-:definitions/resource-type!contract"
              | doc "The resource type that defines the design-time tools for the resource."
              | optional,
            ..
          }
        | doc "A list of resources to be deployed by the MTA application."
        | optional,
      version
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)(-(0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*)(\\.(0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*))*)?(\\+[0-9a-zA-Z-]+(\\.[0-9a-zA-Z-]+)*)?$"
            ])
        | doc "Application version. Shall follow the semantic versioning standard.",
      ..
    }