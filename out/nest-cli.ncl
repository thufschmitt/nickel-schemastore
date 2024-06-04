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
      "_js2n__-:definitions/AssetsOptions!contract"
        | doc "For finer control, the element can be object."
        = _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.isType 'Record
                  ],
                _js2n__-prdslib.records.record
                  {
                    exclude = _js2n__-prdslib.isType '"String",
                    include = _js2n__-prdslib.isType '"String",
                    outDir = _js2n__-prdslib.isType '"String",
                    watchAssets = _js2n__-prdslib.isType '"Bool",
                  } {} false _js2n__-prdslib.never
              ]),
      "_js2n__-:definitions/AssetsOptions!predicate"
        | doc "For finer control, the element can be object."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.isType 'Record
                ],
              _js2n__-prdslib.records.record
                {
                  exclude = _js2n__-prdslib.isType '"String",
                  include = _js2n__-prdslib.isType '"String",
                  outDir = _js2n__-prdslib.isType '"String",
                  watchAssets = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/CompilerOptions!contract"
        | doc "A map with keys specifying compiler options and values specifying the option setting. See https://docs.nestjs.com/cli/monorepo#global-compiler-options for details"
        = {
            assets
              | Array
                _js2n__-refsenv."_js2n__-:definitions/AssetsOptions!contract"
              | doc "Enables automatically distributing non-TypeScript assets whenever a compilation step begins (asset distribution does not happen on incremental compiles in --watch mode). Accept glob-like string and object. See https://docs.nestjs.com/cli/monorepo#assets for details."
              | optional,
            builder
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.enum [ "tsc", "webpack", "swc" ]
                      ],
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.record
                          {
                            options =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.record
                                      {
                                        copyFiles =
                                          _js2n__-prdslib.isType '"Bool",
                                        extensions =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType '"Array",
                                                _js2n__-prdslib.arrays.arrayOf
                                                  (_js2n__-prdslib.isType
                                                    '"String")
                                              ],
                                        filenames =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType '"Array",
                                                _js2n__-prdslib.arrays.arrayOf
                                                  (_js2n__-prdslib.isType
                                                    '"String")
                                              ],
                                        includeDotfiles =
                                          _js2n__-prdslib.isType '"Bool",
                                        outDir =
                                          _js2n__-prdslib.isType '"String",
                                        quiet = _js2n__-prdslib.isType '"Bool",
                                        sync = _js2n__-prdslib.isType '"Bool",
                                        watch = _js2n__-prdslib.isType '"Bool",
                                      } {} true _js2n__-prdslib.always
                                  ],
                            type =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.enum
                                      [ "tsc", "webpack", "swc" ]
                                  ],
                          } {} true _js2n__-prdslib.always
                      ]
                  ])
              | optional,
            deleteOutDir
              | Bool
              | doc "If true, whenever the compiler is invoked, it will first remove the compilation output directory (as configured in tsconfig.json, where the default is ./dist)."
              | optional,
            manualRestart
              | Bool
              | doc "If true, enables the shortcut `rs` to manually restart the server."
              | optional,
            plugins
              | Array
                _js2n__-refsenv."_js2n__-:definitions/PluginItems!contract"
              | optional,
            tsConfigPath
              | String
              | doc "(monorepo only) Points at the file containing the tsconfig.json settings that will be used when nest build or nest start is called without a project option (e.g., when the default project is built or started). 'nest build' will not work as expected without this file."
              | optional,
            typeCheck
              | Bool
              | doc "If true, enable type checking (when SWC is used). See https://docs.nestjs.com/recipes/swc#type-checking for details."
              | optional,
            watchAssets
              | Bool
              | doc "If true, run in watch-mode, watching all non-TypeScript assets. Setting watchAssets in a top-level compilerOptions property overrides any watchAssets settings within the assets property."
              | optional,
            webpack
              | Bool
              | doc "If true, use webpack compiler (deprecated option, use `builder` instead). If false or not present, use tsc. In monorepo mode, the default is true (use webpack), in standard mode, the default is false (use tsc). See https://docs.nestjs.com/cli/monorepo#cli-properties for details."
              | optional,
            webpackConfigPath
              | String
              | doc "Points at a webpack options file. If not specified, Nest looks for the file webpack.config.js."
              | optional,
          },
      "_js2n__-:definitions/CompilerOptions!predicate"
        | doc "A map with keys specifying compiler options and values specifying the option setting. See https://docs.nestjs.com/cli/monorepo#global-compiler-options for details"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  assets =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/AssetsOptions!predicate"
                        ],
                  builder =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum [ "tsc", "webpack", "swc" ]
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  options =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.record
                                            {
                                              copyFiles =
                                                _js2n__-prdslib.isType '"Bool",
                                              extensions =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"Array",
                                                      _js2n__-prdslib.arrays.arrayOf
                                                        (_js2n__-prdslib.isType
                                                          '"String")
                                                    ],
                                              filenames =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"Array",
                                                      _js2n__-prdslib.arrays.arrayOf
                                                        (_js2n__-prdslib.isType
                                                          '"String")
                                                    ],
                                              includeDotfiles =
                                                _js2n__-prdslib.isType '"Bool",
                                              outDir =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              quiet =
                                                _js2n__-prdslib.isType '"Bool",
                                              sync =
                                                _js2n__-prdslib.isType '"Bool",
                                              watch =
                                                _js2n__-prdslib.isType '"Bool",
                                            } {} true _js2n__-prdslib.always
                                        ],
                                  type =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.enum
                                            [ "tsc", "webpack", "swc" ]
                                        ],
                                } {} true _js2n__-prdslib.always
                            ]
                        ],
                  deleteOutDir = _js2n__-prdslib.isType '"Bool",
                  manualRestart = _js2n__-prdslib.isType '"Bool",
                  plugins =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/PluginItems!predicate"
                        ],
                  tsConfigPath = _js2n__-prdslib.isType '"String",
                  typeCheck = _js2n__-prdslib.isType '"Bool",
                  watchAssets = _js2n__-prdslib.isType '"Bool",
                  webpack = _js2n__-prdslib.isType '"Bool",
                  webpackConfigPath = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/GenerateBaseDirOptions!contract"
        | doc "Base directory"
        = String,
      "_js2n__-:definitions/GenerateBaseDirOptions!predicate"
        | doc "Base directory"
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/GenerateFlatOptions!contract"
        | doc "If true, all generate commands will generate a flat structure"
        = Bool,
      "_js2n__-:definitions/GenerateFlatOptions!predicate"
        | doc "If true, all generate commands will generate a flat structure"
        = _js2n__-prdslib.isType '"Bool",
      "_js2n__-:definitions/GenerateOptions!contract"
        | doc "A map with keys specifying global generate options and values specifying the option setting. See https://docs.nestjs.com/cli/monorepo#global-generate-options for details"
        = {
            baseDir
              | _js2n__-refsenv."_js2n__-:definitions/GenerateBaseDirOptions!contract"
              | optional,
            flat
              | _js2n__-refsenv."_js2n__-:definitions/GenerateFlatOptions!contract"
              | optional,
            spec
              | _js2n__-refsenv."_js2n__-:definitions/GenerateSpecOptions!contract"
              | optional,
          },
      "_js2n__-:definitions/GenerateOptions!predicate"
        | doc "A map with keys specifying global generate options and values specifying the option setting. See https://docs.nestjs.com/cli/monorepo#global-generate-options for details"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  baseDir =
                    _js2n__-refsenv."_js2n__-:definitions/GenerateBaseDirOptions!predicate",
                  flat =
                    _js2n__-refsenv."_js2n__-:definitions/GenerateFlatOptions!predicate",
                  spec =
                    _js2n__-refsenv."_js2n__-:definitions/GenerateSpecOptions!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/GenerateSpecOptions!contract"
        | doc "If the value is boolean, a value of true enables spec generation by default and a value of false disables it. A flag passed on the CLI command line overrides this setting, as does a project-specific generateOptions setting (more below). If the value is an object, each key represents a schematic name, and the boolean value determines whether the default spec generation is enabled / disabled for that specific schematic. See https://docs.nestjs.com/cli/monorepo#global-generate-options for details."
        = _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.isType '"Bool",
                    _js2n__-prdslib.isType 'Record
                  ],
                _js2n__-prdslib.records.record
                  {
                    app = _js2n__-prdslib.isType '"Bool",
                    application = _js2n__-prdslib.isType '"Bool",
                    cl = _js2n__-prdslib.isType '"Bool",
                    class = _js2n__-prdslib.isType '"Bool",
                    co = _js2n__-prdslib.isType '"Bool",
                    config = _js2n__-prdslib.isType '"Bool",
                    configuration = _js2n__-prdslib.isType '"Bool",
                    controller = _js2n__-prdslib.isType '"Bool",
                    d = _js2n__-prdslib.isType '"Bool",
                    decorator = _js2n__-prdslib.isType '"Bool",
                    f = _js2n__-prdslib.isType '"Bool",
                    filter = _js2n__-prdslib.isType '"Bool",
                    ga = _js2n__-prdslib.isType '"Bool",
                    gateway = _js2n__-prdslib.isType '"Bool",
                    gu = _js2n__-prdslib.isType '"Bool",
                    guard = _js2n__-prdslib.isType '"Bool",
                    "in" = _js2n__-prdslib.isType '"Bool",
                    interceptor = _js2n__-prdslib.isType '"Bool",
                    interface = _js2n__-prdslib.isType '"Bool",
                    lib = _js2n__-prdslib.isType '"Bool",
                    library = _js2n__-prdslib.isType '"Bool",
                    mi = _js2n__-prdslib.isType '"Bool",
                    middleware = _js2n__-prdslib.isType '"Bool",
                    mo = _js2n__-prdslib.isType '"Bool",
                    module = _js2n__-prdslib.isType '"Bool",
                    pi = _js2n__-prdslib.isType '"Bool",
                    pipe = _js2n__-prdslib.isType '"Bool",
                    pr = _js2n__-prdslib.isType '"Bool",
                    provider = _js2n__-prdslib.isType '"Bool",
                    r = _js2n__-prdslib.isType '"Bool",
                    res = _js2n__-prdslib.isType '"Bool",
                    resolver = _js2n__-prdslib.isType '"Bool",
                    resource = _js2n__-prdslib.isType '"Bool",
                    s = _js2n__-prdslib.isType '"Bool",
                    service = _js2n__-prdslib.isType '"Bool",
                    sub-app = _js2n__-prdslib.isType '"Bool",
                  } {} false _js2n__-prdslib.never
              ]),
      "_js2n__-:definitions/GenerateSpecOptions!predicate"
        | doc "If the value is boolean, a value of true enables spec generation by default and a value of false disables it. A flag passed on the CLI command line overrides this setting, as does a project-specific generateOptions setting (more below). If the value is an object, each key represents a schematic name, and the boolean value determines whether the default spec generation is enabled / disabled for that specific schematic. See https://docs.nestjs.com/cli/monorepo#global-generate-options for details."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Bool",
                  _js2n__-prdslib.isType 'Record
                ],
              _js2n__-prdslib.records.record
                {
                  app = _js2n__-prdslib.isType '"Bool",
                  application = _js2n__-prdslib.isType '"Bool",
                  cl = _js2n__-prdslib.isType '"Bool",
                  class = _js2n__-prdslib.isType '"Bool",
                  co = _js2n__-prdslib.isType '"Bool",
                  config = _js2n__-prdslib.isType '"Bool",
                  configuration = _js2n__-prdslib.isType '"Bool",
                  controller = _js2n__-prdslib.isType '"Bool",
                  d = _js2n__-prdslib.isType '"Bool",
                  decorator = _js2n__-prdslib.isType '"Bool",
                  f = _js2n__-prdslib.isType '"Bool",
                  filter = _js2n__-prdslib.isType '"Bool",
                  ga = _js2n__-prdslib.isType '"Bool",
                  gateway = _js2n__-prdslib.isType '"Bool",
                  gu = _js2n__-prdslib.isType '"Bool",
                  guard = _js2n__-prdslib.isType '"Bool",
                  "in" = _js2n__-prdslib.isType '"Bool",
                  interceptor = _js2n__-prdslib.isType '"Bool",
                  interface = _js2n__-prdslib.isType '"Bool",
                  lib = _js2n__-prdslib.isType '"Bool",
                  library = _js2n__-prdslib.isType '"Bool",
                  mi = _js2n__-prdslib.isType '"Bool",
                  middleware = _js2n__-prdslib.isType '"Bool",
                  mo = _js2n__-prdslib.isType '"Bool",
                  module = _js2n__-prdslib.isType '"Bool",
                  pi = _js2n__-prdslib.isType '"Bool",
                  pipe = _js2n__-prdslib.isType '"Bool",
                  pr = _js2n__-prdslib.isType '"Bool",
                  provider = _js2n__-prdslib.isType '"Bool",
                  r = _js2n__-prdslib.isType '"Bool",
                  res = _js2n__-prdslib.isType '"Bool",
                  resolver = _js2n__-prdslib.isType '"Bool",
                  resource = _js2n__-prdslib.isType '"Bool",
                  s = _js2n__-prdslib.isType '"Bool",
                  service = _js2n__-prdslib.isType '"Bool",
                  sub-app = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/GraphQLPluginOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { typeFileNameSuffix = _js2n__-prdslib.isType '"Array", } {}
                true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/PluginItems!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.isType 'Record
                  ],
                _js2n__-prdslib.records.record
                  {
                    name = _js2n__-prdslib.isType '"String",
                    options =
                      _js2n__-prdslib.anyOf
                          [
                            _js2n__-refsenv."_js2n__-:definitions/PluginOptions!predicate",
                            _js2n__-refsenv."_js2n__-:definitions/GraphQLPluginOptions!predicate",
                            _js2n__-refsenv."_js2n__-:definitions/SwaggerPluginOptions!predicate"
                          ],
                  } {} true _js2n__-prdslib.always
              ]),
      "_js2n__-:definitions/PluginItems!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.isType 'Record
                ],
              _js2n__-prdslib.records.record
                {
                  name = _js2n__-prdslib.isType '"String",
                  options =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/PluginOptions!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/GraphQLPluginOptions!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/SwaggerPluginOptions!predicate"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/PluginOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { introspectComments = _js2n__-prdslib.isType '"Bool", } {} true
                _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/ProjectConfiguration!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  compilerOptions =
                    _js2n__-refsenv."_js2n__-:definitions/CompilerOptions!predicate",
                  entryFile = _js2n__-prdslib.isType '"String",
                  generateOptions =
                    _js2n__-refsenv."_js2n__-:definitions/GenerateOptions!predicate",
                  root = _js2n__-prdslib.isType '"String",
                  sourceRoot = _js2n__-prdslib.isType '"String",
                  type = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/SwaggerPluginOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  classValidatorShim = _js2n__-prdslib.isType '"Bool",
                  controllerFileNameSuffix = _js2n__-prdslib.isType '"String",
                  controllerKeyOfComment = _js2n__-prdslib.isType '"String",
                  dtoFileNameSuffix =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  dtoKeyOfComment = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
    }
    in
  {
      collection
        | String
        | doc "Points at the collection of schematics used to generate components. you generally should not change this value."
        | optional,
      compilerOptions
        | _js2n__-refsenv."_js2n__-:definitions/CompilerOptions!contract"
        | optional,
      defaultLibraryPrefix
        | String
        | doc "Default import prefix for newly generated libraries."
        | optional,
      entryFile
        | String
        | doc "The entry file where 'nest start' work with. Default to 'main'."
        | optional,
      generateOptions
        | _js2n__-refsenv."_js2n__-:definitions/GenerateOptions!contract"
        | optional,
      language | String | optional,
      monorepo
        | Bool
        | doc "(monorepo only) For a monorepo mode structure, this value is always true."
        | optional,
      projects
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                _js2n__-refsenv."_js2n__-:definitions/ProjectConfiguration!predicate"
            ])
        | optional,
      root
        | String
        | doc "(monorepo only) Points at the project root of the default project."
        | optional,
      sourceRoot
        | String
        | doc "Points at the root of the source code for the single project in standard mode structures, or the default project in monorepo mode structures."
        | optional,
      ..
    }