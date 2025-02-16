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
      "_js2n__-:definitions/dependency!predicate"
        | doc "Dependencies are specified with a simple hash of package name to version range. The version range is a string which has one or more space-separated descriptors. Dependencies can also be identified with a tarball or git URL."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                (_js2n__-prdslib.isType '"String")
            ],
      "_js2n__-:definitions/fundingUrl!predicate"
        | doc "URL to a website with details about how to fund the package."
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/fundingWay!predicate"
        | doc "Used to inform about ways to help fund development of the package."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "url" ],
              _js2n__-prdslib.records.record
                {
                  type = _js2n__-prdslib.isType '"String",
                  url =
                    _js2n__-refsenv."_js2n__-:definitions/fundingUrl!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/license!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "AGPL-3.0-only",
                  "Apache-2.0",
                  "BSD-2-Clause",
                  "BSD-3-Clause",
                  "BSL-1.0",
                  "CC0-1.0",
                  "CDDL-1.0",
                  "CDDL-1.1",
                  "EPL-1.0",
                  "EPL-2.0",
                  "GPL-2.0-only",
                  "GPL-3.0-only",
                  "ISC",
                  "LGPL-2.0-only",
                  "LGPL-2.1-only",
                  "LGPL-2.1-or-later",
                  "LGPL-3.0-only",
                  "LGPL-3.0-or-later",
                  "MIT",
                  "MPL-2.0",
                  "MS-PL",
                  "UNLICENSED"
                ]
            ],
      "_js2n__-:definitions/packageExportsEntry!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-refsenv."_js2n__-:definitions/packageExportsEntryPath!predicate",
              _js2n__-refsenv."_js2n__-:definitions/packageExportsEntryObject!predicate"
            ],
      "_js2n__-:definitions/packageExportsEntryObject!predicate"
        | doc "Used to specify conditional exports, note that Conditional exports are unsupported in older environments, so it's recommended to use the fallback array option if support for those environments is a concern."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "default" =
                    _js2n__-refsenv."_js2n__-:definitions/packageExportsEntryOrFallback!predicate",
                  "import" =
                    _js2n__-refsenv."_js2n__-:definitions/packageExportsEntryOrFallback!predicate",
                  node =
                    _js2n__-refsenv."_js2n__-:definitions/packageExportsEntryOrFallback!predicate",
                  require =
                    _js2n__-refsenv."_js2n__-:definitions/packageExportsEntryOrFallback!predicate",
                  types =
                    _js2n__-refsenv."_js2n__-:definitions/packageExportsEntryOrFallback!predicate",
                }
                {
                  "^[^.0-9]+$" =
                    _js2n__-refsenv."_js2n__-:definitions/packageExportsEntryOrFallback!predicate",
                } false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/packageExportsEntryOrFallback!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-refsenv."_js2n__-:definitions/packageExportsEntry!predicate",
              _js2n__-refsenv."_js2n__-:definitions/packageExportsFallback!predicate"
            ],
      "_js2n__-:definitions/packageExportsEntryPath!predicate"
        | doc "The module path that is resolved when this specifier is imported. Set to `null` to disallow importing this module."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.strings.pattern "^\\./"
            ],
      "_js2n__-:definitions/packageExportsFallback!predicate"
        | doc "Used to allow fallbacks in case this environment doesn't support the preceding entries."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/packageExportsEntry!predicate"
            ],
      "_js2n__-:definitions/packageImportsEntry!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-refsenv."_js2n__-:definitions/packageImportsEntryPath!predicate",
              _js2n__-refsenv."_js2n__-:definitions/packageImportsEntryObject!predicate"
            ],
      "_js2n__-:definitions/packageImportsEntryObject!predicate"
        | doc "Used to specify conditional exports, note that Conditional exports are unsupported in older environments, so it's recommended to use the fallback array option if support for those environments is a concern."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "default" =
                    _js2n__-refsenv."_js2n__-:definitions/packageImportsEntryOrFallback!predicate",
                  "import" =
                    _js2n__-refsenv."_js2n__-:definitions/packageImportsEntryOrFallback!predicate",
                  node =
                    _js2n__-refsenv."_js2n__-:definitions/packageImportsEntryOrFallback!predicate",
                  require =
                    _js2n__-refsenv."_js2n__-:definitions/packageImportsEntryOrFallback!predicate",
                  types =
                    _js2n__-refsenv."_js2n__-:definitions/packageImportsEntryOrFallback!predicate",
                }
                {
                  "^[^.0-9]+$" =
                    _js2n__-refsenv."_js2n__-:definitions/packageImportsEntryOrFallback!predicate",
                } false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/packageImportsEntryOrFallback!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-refsenv."_js2n__-:definitions/packageImportsEntry!predicate",
              _js2n__-refsenv."_js2n__-:definitions/packageImportsFallback!predicate"
            ],
      "_js2n__-:definitions/packageImportsEntryPath!predicate"
        | doc "The module path that is resolved when this specifier is imported. Set to `null` to disallow importing this module."
        = _js2n__-prdslib.anyOf
            [ _js2n__-prdslib.isType '"String", _js2n__-prdslib.isType 'Null ],
      "_js2n__-:definitions/packageImportsFallback!predicate"
        | doc "Used to allow fallbacks in case this environment doesn't support the preceding entries."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/packageImportsEntry!predicate"
            ],
      "_js2n__-:definitions/peerDependencyMeta!predicate"
        | doc "When a user installs your package, warnings are emitted if packages specified in \"peerDependencies\" are not already installed. The \"peerDependenciesMeta\" field serves to provide more information on how your peer dependencies are utilized. Most commonly, it allows peer dependencies to be marked as optional. Metadata for this field is specified with a simple hash of the package name to a metadata object."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      { "optional" = _js2n__-prdslib.isType '"Bool", } {} true
                      _js2n__-prdslib.always
                  ])
            ],
      "_js2n__-:definitions/person!predicate"
        | doc "A person who has been involved in creating or maintaining this package."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                {
                  email = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                  url = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/scriptsInstallAfter!predicate"
        | doc "Run AFTER the package is installed."
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/scriptsPublishAfter!predicate"
        | doc "Run AFTER the package is published."
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/scriptsRestart!predicate"
        | doc "Run by the 'npm restart' command. Note: 'npm restart' will run the stop and start scripts if no restart script is provided."
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/scriptsStart!predicate"
        | doc "Run by the 'npm start' command."
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/scriptsStop!predicate"
        | doc "Run by the 'npm stop' command."
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/scriptsTest!predicate"
        | doc "Run by the 'npm test' command."
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/scriptsUninstallBefore!predicate"
        | doc "Run BEFORE the package is uninstalled."
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/scriptsVersionBefore!predicate"
        | doc "Run BEFORE bump the package version."
        = _js2n__-prdslib.isType '"String",
    }
    in
  _js2n__-prdslib.contract_from_predicate
      (_js2n__-prdslib.allOf
        [
          _js2n__-prdslib.isType 'Record,
          _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.not
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.records.required
                          [ "bundleDependencies", "bundledDependencies" ],
                        _js2n__-prdslib.records.record {} {} true
                          _js2n__-prdslib.always
                      ])
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.not
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.records.required
                          [ "bundleDependencies" ],
                        _js2n__-prdslib.records.record {} {} true
                          _js2n__-prdslib.always
                      ]),
                  _js2n__-prdslib.records.required [ "bundledDependencies" ],
                  _js2n__-prdslib.records.record {} {} true
                    _js2n__-prdslib.always
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.not
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.records.required
                          [ "bundledDependencies" ],
                        _js2n__-prdslib.records.record {} {} true
                          _js2n__-prdslib.always
                      ]),
                  _js2n__-prdslib.records.required [ "bundleDependencies" ],
                  _js2n__-prdslib.records.record {} {} true
                    _js2n__-prdslib.always
                ]
            ],
          _js2n__-prdslib.records.record
            {
              author = _js2n__-refsenv."_js2n__-:definitions/person!predicate",
              ava = _js2n__-prdslib.always,
              bin =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.records.record {} {} true
                        (_js2n__-prdslib.isType '"String")
                    ],
              bugs =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.isType '"String"
                        ],
                      _js2n__-prdslib.records.record
                        {
                          email = _js2n__-prdslib.isType '"String",
                          url = _js2n__-prdslib.isType '"String",
                        } {} true _js2n__-prdslib.always
                    ],
              bundleDependencies =
                _js2n__-prdslib.oneOf
                    [
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                      _js2n__-prdslib.isType '"Bool"
                    ],
              bundledDependencies =
                _js2n__-prdslib.oneOf
                    [
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                      _js2n__-prdslib.isType '"Bool"
                    ],
              config =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
              contributors =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        _js2n__-refsenv."_js2n__-:definitions/person!predicate"
                    ],
              cpu =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.isType '"String")
                    ],
              dependencies =
                _js2n__-refsenv."_js2n__-:definitions/dependency!predicate",
              description = _js2n__-prdslib.isType '"String",
              devDependencies =
                _js2n__-refsenv."_js2n__-:definitions/dependency!predicate",
              directories =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          bin = _js2n__-prdslib.isType '"String",
                          "doc" = _js2n__-prdslib.isType '"String",
                          example = _js2n__-prdslib.isType '"String",
                          lib = _js2n__-prdslib.isType '"String",
                          man = _js2n__-prdslib.isType '"String",
                          test = _js2n__-prdslib.isType '"String",
                        } {} true _js2n__-prdslib.always
                    ],
              dist =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          shasum = _js2n__-prdslib.isType '"String",
                          tarball = _js2n__-prdslib.isType '"String",
                        } {} true _js2n__-prdslib.always
                    ],
              engineStrict = _js2n__-prdslib.isType '"Bool",
              engines =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        { node = _js2n__-prdslib.isType '"String", } {} true
                        (_js2n__-prdslib.isType '"String")
                    ],
              eslintConfig = _js2n__-prdslib.always,
              esnext =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.records.record
                        {
                          browser = _js2n__-prdslib.isType '"String",
                          main = _js2n__-prdslib.isType '"String",
                        } {} true (_js2n__-prdslib.isType '"String")
                    ],
              exports =
                _js2n__-prdslib.oneOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/packageExportsEntryPath!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              "." =
                                _js2n__-refsenv."_js2n__-:definitions/packageExportsEntryOrFallback!predicate",
                            }
                            {
                              "^\\./.+" =
                                _js2n__-refsenv."_js2n__-:definitions/packageExportsEntryOrFallback!predicate",
                            } false _js2n__-prdslib.never
                        ],
                      _js2n__-refsenv."_js2n__-:definitions/packageExportsEntryObject!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/packageExportsFallback!predicate"
                    ],
              files =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.isType '"String")
                    ],
              funding =
                _js2n__-prdslib.oneOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/fundingUrl!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/fundingWay!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.oneOf
                              [
                                _js2n__-refsenv."_js2n__-:definitions/fundingUrl!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/fundingWay!predicate"
                              ]),
                          _js2n__-prdslib.arrays.minItems 1,
                          _js2n__-prdslib.arrays.uniqueItems
                        ]
                    ],
              homepage = _js2n__-prdslib.isType '"String",
              imports =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record {}
                        {
                          "^#.+$" =
                            _js2n__-refsenv."_js2n__-:definitions/packageImportsEntryOrFallback!predicate",
                        } false _js2n__-prdslib.never
                    ],
              jscpd = _js2n__-prdslib.always,
              jspm = _js2n__-prdslib.always,
              keywords =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.isType '"String")
                    ],
              license =
                _js2n__-refsenv."_js2n__-:definitions/license!predicate",
              licenses =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.records.record
                              {
                                type =
                                  _js2n__-refsenv."_js2n__-:definitions/license!predicate",
                                url = _js2n__-prdslib.isType '"String",
                              } {} true _js2n__-prdslib.always
                          ])
                    ],
              main = _js2n__-prdslib.isType '"String",
              maintainers =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        _js2n__-refsenv."_js2n__-:definitions/person!predicate"
                    ],
              man =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.isType '"String"
                        ],
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.isType '"String")
                    ],
              module = _js2n__-prdslib.isType '"String",
              name =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.strings.maxLength 214,
                      _js2n__-prdslib.strings.minLength 1,
                      _js2n__-prdslib.strings.pattern
                        "^(?:(?:@(?:[a-z0-9-*~][a-z0-9-*._~]*)?/[a-z0-9-._~])|[a-z0-9-~])[a-z0-9-._~]*$"
                    ],
              optionalDependencies =
                _js2n__-refsenv."_js2n__-:definitions/dependency!predicate",
              os =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.isType '"String")
                    ],
              overrides = _js2n__-prdslib.isType 'Record,
              packageManager =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.strings.pattern
                        "(npm|pnpm|yarn|bun)@\\d+\\.\\d+\\.\\d+(-.+)?"
                    ],
              peerDependencies =
                _js2n__-refsenv."_js2n__-:definitions/dependency!predicate",
              peerDependenciesMeta =
                _js2n__-refsenv."_js2n__-:definitions/peerDependencyMeta!predicate",
              pnpm =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          allowNonAppliedPatches =
                            _js2n__-prdslib.isType '"Bool",
                          allowedDeprecatedVersions =
                            _js2n__-prdslib.isType 'Record,
                          auditConfig =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      ignoreCves =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"String",
                                                    _js2n__-prdslib.strings.pattern
                                                      "^CVE-\\d{4}-\\d{4,7}$"
                                                  ])
                                            ],
                                      ignoreGhsas =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"String",
                                                    _js2n__-prdslib.strings.pattern
                                                      "^GHSA(-[23456789cfghjmpqrvwx]{4}){3}$"
                                                  ])
                                            ],
                                    } {} false _js2n__-prdslib.never
                                ],
                          executionEnv =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      nodeVersion =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          ignoredOptionalDependencies =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    (_js2n__-prdslib.isType '"String")
                                ],
                          neverBuiltDependencies =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    (_js2n__-prdslib.isType '"String")
                                ],
                          onlyBuiltDependencies =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    (_js2n__-prdslib.isType '"String")
                                ],
                          onlyBuiltDependenciesFile =
                            _js2n__-prdslib.isType '"String",
                          overrides = _js2n__-prdslib.isType 'Record,
                          packageExtensions =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record {}
                                    {
                                      "^.+$" =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record
                                                {
                                                  dependencies =
                                                    _js2n__-refsenv."_js2n__-:definitions/dependency!predicate",
                                                  optionalDependencies =
                                                    _js2n__-refsenv."_js2n__-:definitions/dependency!predicate",
                                                  peerDependencies =
                                                    _js2n__-refsenv."_js2n__-:definitions/dependency!predicate",
                                                  peerDependenciesMeta =
                                                    _js2n__-refsenv."_js2n__-:definitions/peerDependencyMeta!predicate",
                                                } {} false _js2n__-prdslib.never
                                            ],
                                    } false _js2n__-prdslib.never
                                ],
                          patchedDependencies = _js2n__-prdslib.isType 'Record,
                          peerDependencyRules =
                            _js2n__-prdslib.records.record
                                {
                                  allowAny =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.isType '"String")
                                        ],
                                  allowedVersions =
                                    _js2n__-prdslib.isType 'Record,
                                  ignoreMissing =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.isType '"String")
                                        ],
                                } {} false _js2n__-prdslib.never,
                          requiredScripts =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    (_js2n__-prdslib.isType '"String")
                                ],
                          supportedArchitectures =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      cpu =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.isType
                                                  '"String")
                                            ],
                                      libc =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.isType
                                                  '"String")
                                            ],
                                      os =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.isType
                                                  '"String")
                                            ],
                                    } {} false _js2n__-prdslib.never
                                ],
                          updateConfig =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      ignoreDependencies =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.isType
                                                  '"String")
                                            ],
                                    } {} false _js2n__-prdslib.never
                                ],
                        } {} false _js2n__-prdslib.never
                    ],
              preferGlobal = _js2n__-prdslib.isType '"Bool",
              prettier = _js2n__-prdslib.always,
              private =
                _js2n__-prdslib.oneOf
                    [
                      _js2n__-prdslib.isType '"Bool",
                      _js2n__-prdslib.enum [ "false", "true" ]
                    ],
              publishConfig =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          access =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.enum
                                    [ "public", "restricted" ]
                                ],
                          provenance = _js2n__-prdslib.isType '"Bool",
                          registry = _js2n__-prdslib.isType '"String",
                          tag = _js2n__-prdslib.isType '"String",
                        } {} true _js2n__-prdslib.always
                    ],
              readme = _js2n__-prdslib.isType '"String",
              release = _js2n__-prdslib.always,
              repository =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.isType '"String"
                        ],
                      _js2n__-prdslib.records.record
                        {
                          directory = _js2n__-prdslib.isType '"String",
                          type = _js2n__-prdslib.isType '"String",
                          url = _js2n__-prdslib.isType '"String",
                        } {} true _js2n__-prdslib.always
                    ],
              resolutions = _js2n__-prdslib.isType 'Record,
              scripts =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          install =
                            _js2n__-refsenv."_js2n__-:definitions/scriptsInstallAfter!predicate",
                          lint = _js2n__-prdslib.isType '"String",
                          postinstall =
                            _js2n__-refsenv."_js2n__-:definitions/scriptsInstallAfter!predicate",
                          postpack = _js2n__-prdslib.isType '"String",
                          postpublish =
                            _js2n__-refsenv."_js2n__-:definitions/scriptsPublishAfter!predicate",
                          postrestart =
                            _js2n__-refsenv."_js2n__-:definitions/scriptsRestart!predicate",
                          poststart =
                            _js2n__-refsenv."_js2n__-:definitions/scriptsStart!predicate",
                          poststop =
                            _js2n__-refsenv."_js2n__-:definitions/scriptsStop!predicate",
                          posttest =
                            _js2n__-refsenv."_js2n__-:definitions/scriptsTest!predicate",
                          postuninstall = _js2n__-prdslib.isType '"String",
                          postversion = _js2n__-prdslib.isType '"String",
                          preinstall = _js2n__-prdslib.isType '"String",
                          prepack = _js2n__-prdslib.isType '"String",
                          prepare = _js2n__-prdslib.isType '"String",
                          prepublish = _js2n__-prdslib.isType '"String",
                          prepublishOnly = _js2n__-prdslib.isType '"String",
                          prerestart =
                            _js2n__-refsenv."_js2n__-:definitions/scriptsRestart!predicate",
                          prestart =
                            _js2n__-refsenv."_js2n__-:definitions/scriptsStart!predicate",
                          prestop =
                            _js2n__-refsenv."_js2n__-:definitions/scriptsStop!predicate",
                          pretest =
                            _js2n__-refsenv."_js2n__-:definitions/scriptsTest!predicate",
                          preuninstall =
                            _js2n__-refsenv."_js2n__-:definitions/scriptsUninstallBefore!predicate",
                          preversion =
                            _js2n__-refsenv."_js2n__-:definitions/scriptsVersionBefore!predicate",
                          publish = _js2n__-prdslib.isType '"String",
                          restart =
                            _js2n__-refsenv."_js2n__-:definitions/scriptsRestart!predicate",
                          serve = _js2n__-prdslib.isType '"String",
                          start =
                            _js2n__-refsenv."_js2n__-:definitions/scriptsStart!predicate",
                          stop =
                            _js2n__-refsenv."_js2n__-:definitions/scriptsStop!predicate",
                          test =
                            _js2n__-refsenv."_js2n__-:definitions/scriptsTest!predicate",
                          uninstall =
                            _js2n__-refsenv."_js2n__-:definitions/scriptsUninstallBefore!predicate",
                          version =
                            _js2n__-refsenv."_js2n__-:definitions/scriptsVersionBefore!predicate",
                        } {} true (_js2n__-prdslib.isType '"String")
                    ],
              stylelint = _js2n__-prdslib.always,
              type =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum [ "commonjs", "module" ]
                    ],
              types = _js2n__-prdslib.isType '"String",
              typesVersions =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record {} {} true
                        (_js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.records.record
                              {
                                "*" =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType '"Array",
                                        _js2n__-prdslib.arrays.arrayOf
                                          (_js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-prdslib.strings.pattern
                                                "^[^*]*(?:\\*[^*]*)?$"
                                            ])
                                      ],
                              }
                              {
                                "^[^*]*\\*[^*]*$" =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType '"Array",
                                        _js2n__-prdslib.arrays.arrayOf
                                          (_js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-prdslib.strings.pattern
                                                "^[^*]*(?:\\*[^*]*)?$"
                                            ])
                                      ],
                                "^[^*]+$" =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType '"Array",
                                        _js2n__-prdslib.arrays.arrayOf
                                          (_js2n__-prdslib.isType '"String")
                                      ],
                              } false _js2n__-prdslib.never
                          ])
                    ],
              typings = _js2n__-prdslib.isType '"String",
              version = _js2n__-prdslib.isType '"String",
              volta =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        { extends = _js2n__-prdslib.isType '"String", }
                        {
                          "(node|npm|pnpm|yarn)" =
                            _js2n__-prdslib.isType '"String",
                        } true _js2n__-prdslib.always
                    ],
              workspaces =
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
                          _js2n__-prdslib.records.record
                            {
                              nohoist =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        (_js2n__-prdslib.isType '"String")
                                    ],
                              packages =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        (_js2n__-prdslib.isType '"String")
                                    ],
                            } {} true _js2n__-prdslib.always
                        ]
                    ],
            } { "^_" = _js2n__-prdslib.always, } true _js2n__-prdslib.always
        ])