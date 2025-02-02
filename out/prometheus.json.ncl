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
      "_js2n__-:definitions/auth!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.ifThenElse
                (_js2n__-prdslib.not
                  (_js2n__-prdslib.records.record
                    { basic_auth = _js2n__-prdslib.const null, } {} true
                    _js2n__-prdslib.always))
                (_js2n__-prdslib.records.record
                  {
                    authorization = _js2n__-prdslib.const null,
                    bearer_token = _js2n__-prdslib.const null,
                    bearer_token_file = _js2n__-prdslib.const null,
                    oauth2 = _js2n__-prdslib.const null,
                    sigv4 = _js2n__-prdslib.const null,
                  } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
              _js2n__-prdslib.ifThenElse
                (_js2n__-prdslib.not
                  (_js2n__-prdslib.records.record
                    { authorization = _js2n__-prdslib.const null, } {} true
                    _js2n__-prdslib.always))
                (_js2n__-prdslib.records.record
                  {
                    basic_auth = _js2n__-prdslib.const null,
                    bearer_token = _js2n__-prdslib.const null,
                    bearer_token_file = _js2n__-prdslib.const null,
                    oauth2 = _js2n__-prdslib.const null,
                    sigv4 = _js2n__-prdslib.const null,
                  } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
              _js2n__-prdslib.ifThenElse
                (_js2n__-prdslib.not
                  (_js2n__-prdslib.records.record
                    { sigv4 = _js2n__-prdslib.const null, } {} true
                    _js2n__-prdslib.always))
                (_js2n__-prdslib.records.record
                  {
                    authorization = _js2n__-prdslib.const null,
                    basic_auth = _js2n__-prdslib.const null,
                    bearer_token = _js2n__-prdslib.const null,
                    bearer_token_file = _js2n__-prdslib.const null,
                    oauth2 = _js2n__-prdslib.const null,
                  } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
              _js2n__-prdslib.ifThenElse
                (_js2n__-prdslib.not
                  (_js2n__-prdslib.records.record
                    { oauth2 = _js2n__-prdslib.const null, } {} true
                    _js2n__-prdslib.always))
                (_js2n__-prdslib.records.record
                  {
                    authorization = _js2n__-prdslib.const null,
                    basic_auth = _js2n__-prdslib.const null,
                    bearer_token = _js2n__-prdslib.const null,
                    bearer_token_file = _js2n__-prdslib.const null,
                    sigv4 = _js2n__-prdslib.const null,
                  } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
              _js2n__-prdslib.ifThenElse
                (_js2n__-prdslib.not
                  (_js2n__-prdslib.records.record
                    { bearer_token = _js2n__-prdslib.const null, } {} true
                    _js2n__-prdslib.always))
                (_js2n__-prdslib.records.record
                  {
                    authorization = _js2n__-prdslib.const null,
                    basic_auth = _js2n__-prdslib.const null,
                    bearer_token_file = _js2n__-prdslib.const null,
                    oauth2 = _js2n__-prdslib.const null,
                    sigv4 = _js2n__-prdslib.const null,
                  } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
              _js2n__-prdslib.ifThenElse
                (_js2n__-prdslib.not
                  (_js2n__-prdslib.records.record
                    { bearer_token_file = _js2n__-prdslib.const null, } {} true
                    _js2n__-prdslib.always))
                (_js2n__-prdslib.records.record
                  {
                    authorization = _js2n__-prdslib.const null,
                    basic_auth = _js2n__-prdslib.const null,
                    bearer_token = _js2n__-prdslib.const null,
                    oauth2 = _js2n__-prdslib.const null,
                    sigv4 = _js2n__-prdslib.const null,
                  } {} true _js2n__-prdslib.always) _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/authorization!predicate"
        | doc "Sets the `Authorization` header on every scrape request with the configured credentials."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "credentials" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "credentials_file" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.record
                {
                  credentials =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  credentials_file =
                    _js2n__-refsenv."_js2n__-:definitions/filepath!predicate",
                  type =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/azure_sd_configs!predicate"
        | doc "List of Azure service discovery configurations."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType 'Record)
            ],
      "_js2n__-:definitions/basic_auth!predicate"
        | doc "Sets the `Authorization` header on every remote write request with the configured username and password. password and password_file are mutually exclusive."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "password" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "password_file" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.required [ "username" ],
              _js2n__-prdslib.records.record
                {
                  password =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  password_file =
                    _js2n__-refsenv."_js2n__-:definitions/filepath!predicate",
                  username = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/bearer_token!predicate"
        | doc "Sets the `Authorization` header on every scrape request with the configured bearer token. It is mutually exclusive with `bearer_token_file`."
        = _js2n__-prdslib.anyOf
            [ _js2n__-prdslib.isType '"String", _js2n__-prdslib.isType 'Null ],
      "_js2n__-:definitions/bearer_token_file!predicate"
        | doc "Sets the `Authorization` header on every scrape request with the bearer token read from the configured file. It is mutually exclusive with `bearer_token`."
        = _js2n__-refsenv."_js2n__-:definitions/filepath!predicate",
      "_js2n__-:definitions/consul_sd_configs!predicate"
        | doc "List of Consul service discovery configurations."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType 'Record)
            ],
      "_js2n__-:definitions/digitalocean_sd_configs!predicate"
        | doc "List of DigitalOcean service discovery configurations."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType 'Record)
            ],
      "_js2n__-:definitions/dns_sd_configs!predicate"
        | doc "List of DNS service discovery configurations."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.required [ "names" ],
                    _js2n__-prdslib.records.record
                      {
                        names =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.isType '"String"),
                                _js2n__-prdslib.arrays.minItems 1
                              ],
                        port =
                          _js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.isType 'Integer,
                                _js2n__-prdslib.isType 'Null
                              ],
                        refresh_interval =
                          _js2n__-refsenv."_js2n__-:definitions/duration!predicate",
                        type =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.anyOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.isType 'Null
                                  ],
                                _js2n__-prdslib.enum [ "SRV", "A", "AAAA" ]
                              ],
                      } {} false _js2n__-prdslib.never
                  ])
            ],
      "_js2n__-:definitions/docker_sd_configs!predicate"
        | doc "List of Docker service discovery configurations."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType 'Record)
            ],
      "_js2n__-:definitions/dockerswarm_sd_configs!predicate"
        | doc "List of Docker Swarm service discovery configurations."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType 'Record)
            ],
      "_js2n__-:definitions/duration!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.strings.pattern "^[0-9]+(ms|[smhdwy])$"
            ],
      "_js2n__-:definitions/ec2_sd_configs!predicate"
        | doc "List of EC2 service discovery configurations."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType 'Record)
            ],
      "_js2n__-:definitions/eureka_sd_configs!predicate"
        | doc "List of Eureka service discovery configurations."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType 'Record)
            ],
      "_js2n__-:definitions/file_sd_configs!predicate"
        | doc "List of file service discovery configurations."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
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
                                _js2n__-prdslib.arrays.minItems 1
                              ],
                        refresh_interval =
                          _js2n__-refsenv."_js2n__-:definitions/duration!predicate",
                      } {} true _js2n__-prdslib.always
                  ])
            ],
      "_js2n__-:definitions/filepath!predicate" =
        _js2n__-prdslib.anyOf
            [ _js2n__-prdslib.isType '"String", _js2n__-prdslib.isType 'Null ],
      "_js2n__-:definitions/filepath_glob!predicate" =
        _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/gce_sd_configs!predicate"
        | doc "List of GCE service discovery configurations."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType 'Record)
            ],
      "_js2n__-:definitions/hetzner_sd_configs!predicate"
        | doc "List of Hetzner service discovery configurations."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType 'Record)
            ],
      "_js2n__-:definitions/http_sd_configs!predicate"
        | doc "List of HTTP service discovery configurations."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-refsenv."_js2n__-:definitions/auth!predicate",
                    _js2n__-prdslib.records.required [ "url" ],
                    _js2n__-prdslib.records.record
                      {
                        authorization =
                          _js2n__-refsenv."_js2n__-:definitions/authorization!predicate",
                        basic_auth =
                          _js2n__-refsenv."_js2n__-:definitions/basic_auth!predicate",
                        bearer_token =
                          _js2n__-refsenv."_js2n__-:definitions/bearer_token!predicate",
                        bearer_token_file =
                          _js2n__-refsenv."_js2n__-:definitions/bearer_token_file!predicate",
                        follow_redirects =
                          _js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.isType '"Bool",
                                _js2n__-prdslib.isType 'Null
                              ],
                        oauth2 =
                          _js2n__-refsenv."_js2n__-:definitions/oauth2!predicate",
                        proxy_url =
                          _js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType 'Null
                              ],
                        refresh_interval =
                          _js2n__-refsenv."_js2n__-:definitions/duration!predicate",
                        tls_config =
                          _js2n__-refsenv."_js2n__-:definitions/tls_config!predicate",
                        url = _js2n__-prdslib.isType '"String",
                      } {} false _js2n__-prdslib.never
                  ])
            ],
      "_js2n__-:definitions/kubernetes_sd_configs!predicate"
        | doc "List of Kubernetes service discovery configurations."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-refsenv."_js2n__-:definitions/auth!predicate",
                    _js2n__-prdslib.records.record
                      {
                        api_server =
                          _js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType 'Null
                              ],
                        authorization =
                          _js2n__-refsenv."_js2n__-:definitions/authorization!predicate",
                        basic_auth =
                          _js2n__-refsenv."_js2n__-:definitions/basic_auth!predicate",
                        bearer_token =
                          _js2n__-refsenv."_js2n__-:definitions/bearer_token!predicate",
                        bearer_token_file =
                          _js2n__-refsenv."_js2n__-:definitions/bearer_token_file!predicate",
                        follow_redirects =
                          _js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.isType '"Bool",
                                _js2n__-prdslib.isType 'Null
                              ],
                        kubeconfig_file =
                          _js2n__-refsenv."_js2n__-:definitions/filepath!predicate",
                        namespaces =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.anyOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.isType 'Null
                                  ],
                                _js2n__-prdslib.records.record
                                  {
                                    names =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"Array",
                                            _js2n__-prdslib.arrays.arrayOf
                                              (_js2n__-prdslib.isType '"String")
                                          ],
                                    own_namespace =
                                      _js2n__-prdslib.isType '"Bool",
                                  } {} false _js2n__-prdslib.never
                              ],
                        oauth2 =
                          _js2n__-refsenv."_js2n__-:definitions/oauth2!predicate",
                        proxy_url =
                          _js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType 'Null
                              ],
                        role =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.enum
                                  [
                                    "endpoints",
                                    "service",
                                    "pod",
                                    "node",
                                    "ingress"
                                  ]
                              ],
                        selectors =
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
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.required
                                        [ "role" ],
                                      _js2n__-prdslib.records.record
                                        {
                                          field =
                                            _js2n__-prdslib.anyOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.isType 'Null
                                                ],
                                          label =
                                            _js2n__-prdslib.anyOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.isType 'Null
                                                ],
                                          role =
                                            _js2n__-prdslib.isType '"String",
                                        } {} false _js2n__-prdslib.never
                                    ])
                              ],
                        tls_config =
                          _js2n__-refsenv."_js2n__-:definitions/tls_config!predicate",
                      } {} false _js2n__-prdslib.never
                  ])
            ],
      "_js2n__-:definitions/kuma_sd_configs!predicate"
        | doc "List of Kuma service discovery configurations."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType 'Record)
            ],
      "_js2n__-:definitions/label_name!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern "^[a-zA-Z_][a-zA-Z0-9_]*$"
            ],
      "_js2n__-:definitions/label_value!predicate" =
        _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/labels!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.records.record {}
                {
                  "^[a-zA-Z_][a-zA-Z0-9_]*$" =
                    _js2n__-refsenv."_js2n__-:definitions/label_value!predicate",
                } false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/lightsail_sd_configs!predicate"
        | doc "List of Lightsail service discovery configurations."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType 'Record)
            ],
      "_js2n__-:definitions/linode_sd_configs!predicate"
        | doc "List of Linode service discovery configurations."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType 'Record)
            ],
      "_js2n__-:definitions/marathon_sd_configs!predicate"
        | doc "List of Marathon service discovery configurations."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType 'Record)
            ],
      "_js2n__-:definitions/nerve_sd_configs!predicate"
        | doc "List of AirBnB's Nerve service discovery configurations."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType 'Record)
            ],
      "_js2n__-:definitions/oauth2!predicate"
        | doc "Optional OAuth 2.0 configuration. Cannot be used at the same time as basic_auth or authorization."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "client_secret" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "client_secret_file" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.required [ "client_id", "token_url" ],
              _js2n__-prdslib.records.record
                {
                  client_id =
                    _js2n__-prdslib.anyOf [ _js2n__-prdslib.isType '"String" ],
                  client_secret =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  client_secret_file =
                    _js2n__-refsenv."_js2n__-:definitions/filepath!predicate",
                  endpoint_params =
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
                  scopes =
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
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType 'Null
                              ])
                        ],
                  tls_config =
                    _js2n__-refsenv."_js2n__-:definitions/tls_config!predicate",
                  token_url =
                    _js2n__-prdslib.anyOf [ _js2n__-prdslib.isType '"String" ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/openstack_sd_configs!predicate"
        | doc "List of OpenStack service discovery configurations."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType 'Record)
            ],
      "_js2n__-:definitions/puppetdb_sd_configs!predicate"
        | doc "List of PuppetDB service discovery configurations."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType 'Record)
            ],
      "_js2n__-:definitions/relabel_configs!predicate" =
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
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.ifThenElse
                      (_js2n__-prdslib.records.record
                        { action = _js2n__-prdslib.const "replace", } {} true
                        _js2n__-prdslib.always)
                      (_js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.required [ "target_label" ],
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-prdslib.always
                        ]) _js2n__-prdslib.always,
                    _js2n__-prdslib.records.record
                      {
                        action =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.enum
                                  [
                                    "replace",
                                    "lowercase",
                                    "uppercase",
                                    "keep",
                                    "drop",
                                    "keepequal",
                                    "dropequal",
                                    "hashmod",
                                    "labelmap",
                                    "labeldrop",
                                    "labelkeep"
                                  ]
                              ],
                        modulus = _js2n__-prdslib.isType 'Integer,
                        regex = _js2n__-prdslib.always,
                        replacement = _js2n__-prdslib.isType '"String",
                        separator = _js2n__-prdslib.isType '"String",
                        source_labels =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  _js2n__-refsenv."_js2n__-:definitions/label_name!predicate"
                              ],
                        target_label = _js2n__-prdslib.isType '"String",
                      } {} true _js2n__-prdslib.always
                  ])
            ],
      "_js2n__-:definitions/scaleway_sd_configs!predicate"
        | doc "List of Scaleway service discovery configurations."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType 'Record)
            ],
      "_js2n__-:definitions/scheme!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.enum [ "http", "https", null ]
            ],
      "_js2n__-:definitions/serverset_sd_configs!predicate"
        | doc "List of Zookeeper Serverset service discovery configurations."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType 'Record)
            ],
      "_js2n__-:definitions/sigv4!predicate"
        | doc "Optionally configures AWS's Signature Verification 4 signing process to sign requests."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.records.record
                {
                  access_key =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  profile =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  region =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  role_arn =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  secret_key =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/static_configs!predicate"
        | doc "List of labeled statically configured targets for this job."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        labels =
                          _js2n__-refsenv."_js2n__-:definitions/labels!predicate",
                        targets =
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
                      } {} true _js2n__-prdslib.always
                  ])
            ],
      "_js2n__-:definitions/tls_config!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.records.record
                {
                  ca_file =
                    _js2n__-refsenv."_js2n__-:definitions/filepath!predicate",
                  cert_file =
                    _js2n__-refsenv."_js2n__-:definitions/filepath!predicate",
                  insecure_skip_verify =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  key_file =
                    _js2n__-refsenv."_js2n__-:definitions/filepath!predicate",
                  server_name =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/triton_sd_configs!predicate"
        | doc "List of Triton service discovery configurations."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType 'Record)
            ],
      "_js2n__-:definitions/uyuni_sd_configs!predicate"
        | doc "List of Uyuni service discovery configurations."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType 'Record)
            ],
    }
    in
  _js2n__-prdslib.contract_from_predicate
      (_js2n__-prdslib.allOf
        [
          _js2n__-prdslib.anyOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.isType 'Null ],
          _js2n__-prdslib.records.record
            {
              alerting =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.isType 'Null
                        ],
                      _js2n__-prdslib.records.record
                        {
                          alert_relabel_configs =
                            _js2n__-refsenv."_js2n__-:definitions/relabel_configs!predicate",
                          alertmanagers =
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
                                        _js2n__-prdslib.isType 'Record,
                                        _js2n__-refsenv."_js2n__-:definitions/auth!predicate",
                                        _js2n__-prdslib.records.record
                                          {
                                            api_version =
                                              _js2n__-prdslib.anyOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"String",
                                                    _js2n__-prdslib.isType 'Null
                                                  ],
                                            authorization =
                                              _js2n__-refsenv."_js2n__-:definitions/authorization!predicate",
                                            azure_sd_configs =
                                              _js2n__-refsenv."_js2n__-:definitions/azure_sd_configs!predicate",
                                            basic_auth =
                                              _js2n__-refsenv."_js2n__-:definitions/basic_auth!predicate",
                                            bearer_token =
                                              _js2n__-refsenv."_js2n__-:definitions/bearer_token!predicate",
                                            bearer_token_file =
                                              _js2n__-refsenv."_js2n__-:definitions/bearer_token_file!predicate",
                                            consul_sd_configs =
                                              _js2n__-refsenv."_js2n__-:definitions/consul_sd_configs!predicate",
                                            digitalocean_sd_configs =
                                              _js2n__-refsenv."_js2n__-:definitions/digitalocean_sd_configs!predicate",
                                            dns_sd_configs =
                                              _js2n__-refsenv."_js2n__-:definitions/dns_sd_configs!predicate",
                                            docker_sd_configs =
                                              _js2n__-refsenv."_js2n__-:definitions/docker_sd_configs!predicate",
                                            dockerswarm_sd_configs =
                                              _js2n__-refsenv."_js2n__-:definitions/dockerswarm_sd_configs!predicate",
                                            ec2_sd_configs =
                                              _js2n__-refsenv."_js2n__-:definitions/ec2_sd_configs!predicate",
                                            eureka_sd_configs =
                                              _js2n__-refsenv."_js2n__-:definitions/eureka_sd_configs!predicate",
                                            file_sd_configs =
                                              _js2n__-refsenv."_js2n__-:definitions/file_sd_configs!predicate",
                                            follow_redirects =
                                              _js2n__-prdslib.anyOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"Bool",
                                                    _js2n__-prdslib.isType 'Null
                                                  ],
                                            gce_sd_configs =
                                              _js2n__-refsenv."_js2n__-:definitions/gce_sd_configs!predicate",
                                            hetzner_sd_configs =
                                              _js2n__-refsenv."_js2n__-:definitions/hetzner_sd_configs!predicate",
                                            http_sd_configs =
                                              _js2n__-refsenv."_js2n__-:definitions/http_sd_configs!predicate",
                                            kubernetes_sd_configs =
                                              _js2n__-refsenv."_js2n__-:definitions/kubernetes_sd_configs!predicate",
                                            kuma_sd_configs =
                                              _js2n__-refsenv."_js2n__-:definitions/kuma_sd_configs!predicate",
                                            lightsail_sd_configs =
                                              _js2n__-refsenv."_js2n__-:definitions/lightsail_sd_configs!predicate",
                                            linode_sd_configs =
                                              _js2n__-refsenv."_js2n__-:definitions/linode_sd_configs!predicate",
                                            marathon_sd_configs =
                                              _js2n__-refsenv."_js2n__-:definitions/marathon_sd_configs!predicate",
                                            nerve_sd_configs =
                                              _js2n__-refsenv."_js2n__-:definitions/nerve_sd_configs!predicate",
                                            oauth2 =
                                              _js2n__-refsenv."_js2n__-:definitions/oauth2!predicate",
                                            openstack_sd_configs =
                                              _js2n__-refsenv."_js2n__-:definitions/openstack_sd_configs!predicate",
                                            path_prefix =
                                              _js2n__-prdslib.anyOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"String",
                                                    _js2n__-prdslib.isType 'Null
                                                  ],
                                            proxy_url =
                                              _js2n__-prdslib.anyOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"String",
                                                    _js2n__-prdslib.isType 'Null
                                                  ],
                                            puppetdb_sd_configs =
                                              _js2n__-refsenv."_js2n__-:definitions/puppetdb_sd_configs!predicate",
                                            relabel_configs =
                                              _js2n__-refsenv."_js2n__-:definitions/relabel_configs!predicate",
                                            scaleway_sd_configs =
                                              _js2n__-refsenv."_js2n__-:definitions/scaleway_sd_configs!predicate",
                                            scheme =
                                              _js2n__-refsenv."_js2n__-:definitions/scheme!predicate",
                                            serverset_sd_configs =
                                              _js2n__-refsenv."_js2n__-:definitions/serverset_sd_configs!predicate",
                                            static_configs =
                                              _js2n__-refsenv."_js2n__-:definitions/static_configs!predicate",
                                            timeout =
                                              _js2n__-refsenv."_js2n__-:definitions/duration!predicate",
                                            tls_config =
                                              _js2n__-refsenv."_js2n__-:definitions/tls_config!predicate",
                                            triton_sd_configs =
                                              _js2n__-refsenv."_js2n__-:definitions/triton_sd_configs!predicate",
                                            uyuni_sd_configs =
                                              _js2n__-refsenv."_js2n__-:definitions/uyuni_sd_configs!predicate",
                                          } {} true _js2n__-prdslib.always
                                      ])
                                ],
                        } {} true _js2n__-prdslib.always
                    ],
              global =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.isType 'Null
                        ],
                      _js2n__-prdslib.records.record
                        {
                          body_size_limit =
                            _js2n__-prdslib.anyOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.isType 'Null
                                ],
                          evaluation_interval =
                            _js2n__-refsenv."_js2n__-:definitions/duration!predicate",
                          external_labels =
                            _js2n__-refsenv."_js2n__-:definitions/labels!predicate",
                          label_limit =
                            _js2n__-prdslib.anyOf
                                [
                                  _js2n__-prdslib.isType 'Integer,
                                  _js2n__-prdslib.isType 'Null
                                ],
                          label_name_length_limit =
                            _js2n__-prdslib.anyOf
                                [
                                  _js2n__-prdslib.isType 'Integer,
                                  _js2n__-prdslib.isType 'Null
                                ],
                          label_value_length_limit =
                            _js2n__-prdslib.anyOf
                                [
                                  _js2n__-prdslib.isType 'Integer,
                                  _js2n__-prdslib.isType 'Null
                                ],
                          query_log_file =
                            _js2n__-refsenv."_js2n__-:definitions/filepath!predicate",
                          sample_limit =
                            _js2n__-prdslib.anyOf
                                [
                                  _js2n__-prdslib.isType 'Integer,
                                  _js2n__-prdslib.isType 'Null
                                ],
                          scrape_interval =
                            _js2n__-refsenv."_js2n__-:definitions/duration!predicate",
                          scrape_timeout =
                            _js2n__-refsenv."_js2n__-:definitions/duration!predicate",
                          target_limit =
                            _js2n__-prdslib.anyOf
                                [
                                  _js2n__-prdslib.isType 'Integer,
                                  _js2n__-prdslib.isType 'Null
                                ],
                        } {} false _js2n__-prdslib.never
                    ],
              remote_read =
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
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-refsenv."_js2n__-:definitions/auth!predicate",
                            _js2n__-prdslib.records.required [ "url" ],
                            _js2n__-prdslib.records.record
                              {
                                authorization =
                                  _js2n__-refsenv."_js2n__-:definitions/authorization!predicate",
                                basic_auth =
                                  _js2n__-refsenv."_js2n__-:definitions/basic_auth!predicate",
                                bearer_token =
                                  _js2n__-refsenv."_js2n__-:definitions/bearer_token!predicate",
                                bearer_token_file =
                                  _js2n__-refsenv."_js2n__-:definitions/bearer_token_file!predicate",
                                follow_redirects =
                                  _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType '"Bool",
                                        _js2n__-prdslib.isType 'Null
                                      ],
                                headers =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.anyOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-prdslib.isType 'Null
                                          ],
                                        _js2n__-prdslib.records.record {} {}
                                          true
                                          (_js2n__-prdslib.isType '"String")
                                      ],
                                name =
                                  _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType '"String",
                                        _js2n__-prdslib.isType 'Null
                                      ],
                                oauth2 =
                                  _js2n__-refsenv."_js2n__-:definitions/oauth2!predicate",
                                proxy_url =
                                  _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType '"String",
                                        _js2n__-prdslib.isType 'Null
                                      ],
                                read_recent =
                                  _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType '"Bool",
                                        _js2n__-prdslib.isType 'Null
                                      ],
                                remote_timeout =
                                  _js2n__-refsenv."_js2n__-:definitions/duration!predicate",
                                required_matchers =
                                  _js2n__-refsenv."_js2n__-:definitions/labels!predicate",
                                tls_config =
                                  _js2n__-refsenv."_js2n__-:definitions/tls_config!predicate",
                                url = _js2n__-prdslib.isType '"String",
                              } {} false _js2n__-prdslib.never
                          ])
                    ],
              remote_write =
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
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-refsenv."_js2n__-:definitions/auth!predicate",
                            _js2n__-prdslib.records.required [ "url" ],
                            _js2n__-prdslib.records.record
                              {
                                authorization =
                                  _js2n__-refsenv."_js2n__-:definitions/authorization!predicate",
                                basic_auth =
                                  _js2n__-refsenv."_js2n__-:definitions/basic_auth!predicate",
                                bearer_token =
                                  _js2n__-refsenv."_js2n__-:definitions/bearer_token!predicate",
                                bearer_token_file =
                                  _js2n__-refsenv."_js2n__-:definitions/bearer_token_file!predicate",
                                follow_redirects =
                                  _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType '"Bool",
                                        _js2n__-prdslib.isType 'Null
                                      ],
                                headers =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.anyOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-prdslib.isType 'Null
                                          ],
                                        _js2n__-prdslib.records.record {} {}
                                          true
                                          (_js2n__-prdslib.isType '"String")
                                      ],
                                metadata_config =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.anyOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-prdslib.isType 'Null
                                          ],
                                        _js2n__-prdslib.records.record
                                          {
                                            max_samples_per_send =
                                              _js2n__-prdslib.anyOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      'Integer,
                                                    _js2n__-prdslib.isType 'Null
                                                  ],
                                            send =
                                              _js2n__-prdslib.anyOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"Bool",
                                                    _js2n__-prdslib.isType 'Null
                                                  ],
                                            send_interval =
                                              _js2n__-refsenv."_js2n__-:definitions/duration!predicate",
                                          } {} false _js2n__-prdslib.never
                                      ],
                                name =
                                  _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType '"String",
                                        _js2n__-prdslib.isType 'Null
                                      ],
                                oauth2 =
                                  _js2n__-refsenv."_js2n__-:definitions/oauth2!predicate",
                                proxy_url =
                                  _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType '"String",
                                        _js2n__-prdslib.isType 'Null
                                      ],
                                queue_config =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.anyOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-prdslib.isType 'Null
                                          ],
                                        _js2n__-prdslib.records.record
                                          {
                                            batch_send_deadline =
                                              _js2n__-refsenv."_js2n__-:definitions/duration!predicate",
                                            capacity =
                                              _js2n__-prdslib.anyOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      'Integer,
                                                    _js2n__-prdslib.isType 'Null
                                                  ],
                                            max_backoff =
                                              _js2n__-refsenv."_js2n__-:definitions/duration!predicate",
                                            max_samples_per_send =
                                              _js2n__-prdslib.anyOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      'Integer,
                                                    _js2n__-prdslib.isType 'Null
                                                  ],
                                            max_shards =
                                              _js2n__-prdslib.anyOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      'Integer,
                                                    _js2n__-prdslib.isType 'Null
                                                  ],
                                            min_backoff =
                                              _js2n__-refsenv."_js2n__-:definitions/duration!predicate",
                                            min_shards =
                                              _js2n__-prdslib.anyOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      'Integer,
                                                    _js2n__-prdslib.isType 'Null
                                                  ],
                                            retry_on_http_429 =
                                              _js2n__-prdslib.anyOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"Bool",
                                                    _js2n__-prdslib.isType 'Null
                                                  ],
                                            sample_age_limit =
                                              _js2n__-refsenv."_js2n__-:definitions/duration!predicate",
                                          } {} false _js2n__-prdslib.never
                                      ],
                                remote_timeout =
                                  _js2n__-refsenv."_js2n__-:definitions/duration!predicate",
                                send_exemplars =
                                  _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType '"Bool",
                                        _js2n__-prdslib.isType 'Null
                                      ],
                                sigv4 =
                                  _js2n__-refsenv."_js2n__-:definitions/sigv4!predicate",
                                tls_config =
                                  _js2n__-refsenv."_js2n__-:definitions/tls_config!predicate",
                                url = _js2n__-prdslib.isType '"String",
                                write_relabel_configs =
                                  _js2n__-refsenv."_js2n__-:definitions/relabel_configs!predicate",
                              } {} false _js2n__-prdslib.never
                          ])
                    ],
              rule_files =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.isType 'Null
                        ],
                      _js2n__-prdslib.arrays.arrayOf
                        _js2n__-refsenv."_js2n__-:definitions/filepath_glob!predicate"
                    ],
              scrape_config_files =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.isType 'Null
                        ],
                      _js2n__-prdslib.arrays.arrayOf
                        _js2n__-refsenv."_js2n__-:definitions/filepath_glob!predicate"
                    ],
              scrape_configs =
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
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-refsenv."_js2n__-:definitions/auth!predicate",
                            _js2n__-prdslib.records.required [ "job_name" ],
                            _js2n__-prdslib.records.record
                              {
                                authorization =
                                  _js2n__-refsenv."_js2n__-:definitions/authorization!predicate",
                                azure_sd_configs =
                                  _js2n__-refsenv."_js2n__-:definitions/azure_sd_configs!predicate",
                                basic_auth =
                                  _js2n__-refsenv."_js2n__-:definitions/basic_auth!predicate",
                                bearer_token =
                                  _js2n__-refsenv."_js2n__-:definitions/bearer_token!predicate",
                                bearer_token_file =
                                  _js2n__-refsenv."_js2n__-:definitions/bearer_token_file!predicate",
                                body_size_limit =
                                  _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType '"String",
                                        _js2n__-prdslib.isType 'Null
                                      ],
                                consul_sd_configs =
                                  _js2n__-refsenv."_js2n__-:definitions/consul_sd_configs!predicate",
                                digitalocean_sd_configs =
                                  _js2n__-refsenv."_js2n__-:definitions/digitalocean_sd_configs!predicate",
                                dns_sd_configs =
                                  _js2n__-refsenv."_js2n__-:definitions/dns_sd_configs!predicate",
                                docker_sd_configs =
                                  _js2n__-refsenv."_js2n__-:definitions/docker_sd_configs!predicate",
                                dockerswarm_sd_configs =
                                  _js2n__-refsenv."_js2n__-:definitions/dockerswarm_sd_configs!predicate",
                                ec2_sd_configs =
                                  _js2n__-refsenv."_js2n__-:definitions/ec2_sd_configs!predicate",
                                eureka_sd_configs =
                                  _js2n__-refsenv."_js2n__-:definitions/eureka_sd_configs!predicate",
                                fallback_scrape_protocol =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.anyOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.isType 'Null
                                          ],
                                        _js2n__-prdslib.enum
                                          [
                                            "OpenMetricsText0.0.1",
                                            "OpenMetricsText1.0.0",
                                            "PrometheusProto",
                                            "PrometheusText0.0.4",
                                            "PrometheusText1.0.0"
                                          ]
                                      ],
                                file_sd_configs =
                                  _js2n__-refsenv."_js2n__-:definitions/file_sd_configs!predicate",
                                follow_redirects =
                                  _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType '"Bool",
                                        _js2n__-prdslib.isType 'Null
                                      ],
                                gce_sd_configs =
                                  _js2n__-refsenv."_js2n__-:definitions/gce_sd_configs!predicate",
                                hetzner_sd_configs =
                                  _js2n__-refsenv."_js2n__-:definitions/hetzner_sd_configs!predicate",
                                honor_labels =
                                  _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType '"Bool",
                                        _js2n__-prdslib.isType 'Null
                                      ],
                                honor_timestamps =
                                  _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType '"Bool",
                                        _js2n__-prdslib.isType 'Null
                                      ],
                                http_sd_configs =
                                  _js2n__-refsenv."_js2n__-:definitions/http_sd_configs!predicate",
                                job_name = _js2n__-prdslib.isType '"String",
                                kubernetes_sd_configs =
                                  _js2n__-refsenv."_js2n__-:definitions/kubernetes_sd_configs!predicate",
                                kuma_sd_configs =
                                  _js2n__-refsenv."_js2n__-:definitions/kuma_sd_configs!predicate",
                                label_limit =
                                  _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType 'Integer,
                                        _js2n__-prdslib.isType 'Null
                                      ],
                                label_name_length_limit =
                                  _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType 'Integer,
                                        _js2n__-prdslib.isType 'Null
                                      ],
                                label_value_length_limit =
                                  _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType 'Integer,
                                        _js2n__-prdslib.isType 'Null
                                      ],
                                lightsail_sd_configs =
                                  _js2n__-refsenv."_js2n__-:definitions/lightsail_sd_configs!predicate",
                                linode_sd_configs =
                                  _js2n__-refsenv."_js2n__-:definitions/linode_sd_configs!predicate",
                                marathon_sd_configs =
                                  _js2n__-refsenv."_js2n__-:definitions/marathon_sd_configs!predicate",
                                metric_relabel_configs =
                                  _js2n__-refsenv."_js2n__-:definitions/relabel_configs!predicate",
                                metrics_path =
                                  _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType '"String",
                                        _js2n__-prdslib.isType 'Null
                                      ],
                                nerve_sd_configs =
                                  _js2n__-refsenv."_js2n__-:definitions/nerve_sd_configs!predicate",
                                oauth2 =
                                  _js2n__-refsenv."_js2n__-:definitions/oauth2!predicate",
                                openstack_sd_configs =
                                  _js2n__-refsenv."_js2n__-:definitions/openstack_sd_configs!predicate",
                                params =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.anyOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-prdslib.isType 'Null
                                          ],
                                        _js2n__-prdslib.records.record {} {}
                                          true
                                          (_js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.isType
                                                  '"String")
                                            ])
                                      ],
                                proxy_url =
                                  _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType '"String",
                                        _js2n__-prdslib.isType 'Null
                                      ],
                                puppetdb_sd_configs =
                                  _js2n__-refsenv."_js2n__-:definitions/puppetdb_sd_configs!predicate",
                                relabel_configs =
                                  _js2n__-refsenv."_js2n__-:definitions/relabel_configs!predicate",
                                sample_limit =
                                  _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType 'Integer,
                                        _js2n__-prdslib.isType 'Null
                                      ],
                                scaleway_sd_configs =
                                  _js2n__-refsenv."_js2n__-:definitions/scaleway_sd_configs!predicate",
                                scheme =
                                  _js2n__-refsenv."_js2n__-:definitions/scheme!predicate",
                                scrape_interval =
                                  _js2n__-refsenv."_js2n__-:definitions/duration!predicate",
                                scrape_timeout =
                                  _js2n__-refsenv."_js2n__-:definitions/duration!predicate",
                                serverset_sd_configs =
                                  _js2n__-refsenv."_js2n__-:definitions/serverset_sd_configs!predicate",
                                static_configs =
                                  _js2n__-refsenv."_js2n__-:definitions/static_configs!predicate",
                                target_limit =
                                  _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType 'Integer,
                                        _js2n__-prdslib.isType 'Null
                                      ],
                                tls_config =
                                  _js2n__-refsenv."_js2n__-:definitions/tls_config!predicate",
                                triton_sd_configs =
                                  _js2n__-refsenv."_js2n__-:definitions/triton_sd_configs!predicate",
                                uyuni_sd_configs =
                                  _js2n__-refsenv."_js2n__-:definitions/uyuni_sd_configs!predicate",
                              } {} false _js2n__-prdslib.never
                          ])
                    ],
              storage =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.isType 'Null
                        ],
                      _js2n__-prdslib.records.record
                        {
                          exemplars =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.isType 'Null
                                    ],
                                  _js2n__-prdslib.records.record
                                    {
                                      max_exemplars =
                                        _js2n__-prdslib.anyOf
                                            [
                                              _js2n__-prdslib.isType 'Integer,
                                              _js2n__-prdslib.isType 'Null
                                            ],
                                    } {} false _js2n__-prdslib.never
                                ],
                          tsdb =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.isType 'Null
                                    ],
                                  _js2n__-prdslib.records.record
                                    {
                                      out_of_order_time_window =
                                        _js2n__-refsenv."_js2n__-:definitions/duration!predicate",
                                    } {} false _js2n__-prdslib.never
                                ],
                        } {} false _js2n__-prdslib.never
                    ],
            } {} false _js2n__-prdslib.never
        ])