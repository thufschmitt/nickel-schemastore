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
      "_js2n__-:definitions/address!predicate"
        | doc "A physical or virtual address, or a range of addresses, in an 'addressable region' (memory or a binary file)."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  absoluteAddress =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum (-1)
                        ],
                  fullyQualifiedName = _js2n__-prdslib.isType '"String",
                  index =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum (-1)
                        ],
                  kind = _js2n__-prdslib.isType '"String",
                  length = _js2n__-prdslib.isType 'Integer,
                  name = _js2n__-prdslib.isType '"String",
                  offsetFromParent = _js2n__-prdslib.isType 'Integer,
                  parentIndex =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum (-1)
                        ],
                  properties =
                    _js2n__-refsenv."_js2n__-:definitions/propertyBag!predicate",
                  relativeAddress = _js2n__-prdslib.isType 'Integer,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/artifact!predicate"
        | doc "A single artifact. In some cases, this artifact might be nested within another artifact."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  contents =
                    _js2n__-refsenv."_js2n__-:definitions/artifactContent!predicate",
                  description =
                    _js2n__-refsenv."_js2n__-:definitions/message!predicate",
                  encoding = _js2n__-prdslib.isType '"String",
                  hashes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  lastModifiedTimeUtc = _js2n__-prdslib.isType '"String",
                  length =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum (-1)
                        ],
                  location =
                    _js2n__-refsenv."_js2n__-:definitions/artifactLocation!predicate",
                  mimeType =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern "[^/]+/.+"
                        ],
                  offset =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  parentIndex =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum (-1)
                        ],
                  properties =
                    _js2n__-refsenv."_js2n__-:definitions/propertyBag!predicate",
                  roles =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.enum
                              [
                                "analysisTarget",
                                "attachment",
                                "responseFile",
                                "resultFile",
                                "standardStream",
                                "tracedFile",
                                "unmodified",
                                "modified",
                                "added",
                                "deleted",
                                "renamed",
                                "uncontrolled",
                                "driver",
                                "extension",
                                "translation",
                                "taxonomy",
                                "policy",
                                "referencedOnCommandLine",
                                "memoryContents",
                                "directory",
                                "userSpecifiedConfiguration",
                                "toolSpecifiedConfiguration",
                                "debugOutputFile"
                              ]),
                          _js2n__-prdslib.arrays.minItems 0,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  sourceLanguage = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/artifactChange!predicate"
        | doc "A change to a single artifact."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "artifactLocation", "replacements" ],
              _js2n__-prdslib.records.record
                {
                  artifactLocation =
                    _js2n__-refsenv."_js2n__-:definitions/artifactLocation!predicate",
                  properties =
                    _js2n__-refsenv."_js2n__-:definitions/propertyBag!predicate",
                  replacements =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/replacement!predicate",
                          _js2n__-prdslib.arrays.minItems 1
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/artifactContent!predicate"
        | doc "Represents the contents of an artifact."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  binary = _js2n__-prdslib.isType '"String",
                  properties =
                    _js2n__-refsenv."_js2n__-:definitions/propertyBag!predicate",
                  rendered =
                    _js2n__-refsenv."_js2n__-:definitions/multiformatMessageString!predicate",
                  text = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/artifactLocation!predicate"
        | doc "Specifies the location of an artifact."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  description =
                    _js2n__-refsenv."_js2n__-:definitions/message!predicate",
                  index =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum (-1)
                        ],
                  properties =
                    _js2n__-refsenv."_js2n__-:definitions/propertyBag!predicate",
                  uri = _js2n__-prdslib.isType '"String",
                  uriBaseId = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/attachment!predicate"
        | doc "An artifact relevant to a result."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "artifactLocation" ],
              _js2n__-prdslib.records.record
                {
                  artifactLocation =
                    _js2n__-refsenv."_js2n__-:definitions/artifactLocation!predicate",
                  description =
                    _js2n__-refsenv."_js2n__-:definitions/message!predicate",
                  properties =
                    _js2n__-refsenv."_js2n__-:definitions/propertyBag!predicate",
                  rectangles =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/rectangle!predicate",
                          _js2n__-prdslib.arrays.minItems 0,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  regions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/region!predicate",
                          _js2n__-prdslib.arrays.minItems 0,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/codeFlow!predicate"
        | doc "A set of threadFlows which together describe a pattern of code execution relevant to detecting a result."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "threadFlows" ],
              _js2n__-prdslib.records.record
                {
                  message =
                    _js2n__-refsenv."_js2n__-:definitions/message!predicate",
                  properties =
                    _js2n__-refsenv."_js2n__-:definitions/propertyBag!predicate",
                  threadFlows =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/threadFlow!predicate",
                          _js2n__-prdslib.arrays.minItems 1
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/configurationOverride!predicate"
        | doc "Information about how a specific rule or notification was reconfigured at runtime."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "configuration", "descriptor" ],
              _js2n__-prdslib.records.record
                {
                  configuration =
                    _js2n__-refsenv."_js2n__-:definitions/reportingConfiguration!predicate",
                  descriptor =
                    _js2n__-refsenv."_js2n__-:definitions/reportingDescriptorReference!predicate",
                  properties =
                    _js2n__-refsenv."_js2n__-:definitions/propertyBag!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/conversion!predicate"
        | doc "Describes how a converter transformed the output of a static analysis tool from the analysis tool's native output format into the SARIF format."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "tool" ],
              _js2n__-prdslib.records.record
                {
                  analysisToolLogFiles =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/artifactLocation!predicate",
                          _js2n__-prdslib.arrays.minItems 0,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  invocation =
                    _js2n__-refsenv."_js2n__-:definitions/invocation!predicate",
                  properties =
                    _js2n__-refsenv."_js2n__-:definitions/propertyBag!predicate",
                  tool = _js2n__-refsenv."_js2n__-:definitions/tool!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/edge!predicate"
        | doc "Represents a directed edge in a graph."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "id", "sourceNodeId", "targetNodeId" ],
              _js2n__-prdslib.records.record
                {
                  id = _js2n__-prdslib.isType '"String",
                  label =
                    _js2n__-refsenv."_js2n__-:definitions/message!predicate",
                  properties =
                    _js2n__-refsenv."_js2n__-:definitions/propertyBag!predicate",
                  sourceNodeId = _js2n__-prdslib.isType '"String",
                  targetNodeId = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/edgeTraversal!predicate"
        | doc "Represents the traversal of a single edge during a graph traversal."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "edgeId" ],
              _js2n__-prdslib.records.record
                {
                  edgeId = _js2n__-prdslib.isType '"String",
                  finalState =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/multiformatMessageString!predicate"
                        ],
                  message =
                    _js2n__-refsenv."_js2n__-:definitions/message!predicate",
                  properties =
                    _js2n__-refsenv."_js2n__-:definitions/propertyBag!predicate",
                  stepOverEdgeCount =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/exception!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  innerExceptions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/exception!predicate",
                          _js2n__-prdslib.arrays.minItems 0
                        ],
                  kind = _js2n__-prdslib.isType '"String",
                  message = _js2n__-prdslib.isType '"String",
                  properties =
                    _js2n__-refsenv."_js2n__-:definitions/propertyBag!predicate",
                  stack =
                    _js2n__-refsenv."_js2n__-:definitions/stack!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/externalProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  addresses =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/address!predicate",
                          _js2n__-prdslib.arrays.minItems 0
                        ],
                  artifacts =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/artifact!predicate",
                          _js2n__-prdslib.arrays.minItems 0,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  conversion =
                    _js2n__-refsenv."_js2n__-:definitions/conversion!predicate",
                  driver =
                    _js2n__-refsenv."_js2n__-:definitions/toolComponent!predicate",
                  extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/toolComponent!predicate",
                          _js2n__-prdslib.arrays.minItems 0,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  externalizedProperties =
                    _js2n__-refsenv."_js2n__-:definitions/propertyBag!predicate",
                  graphs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/graph!predicate",
                          _js2n__-prdslib.arrays.minItems 0,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  guid =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$"
                        ],
                  invocations =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/invocation!predicate",
                          _js2n__-prdslib.arrays.minItems 0
                        ],
                  logicalLocations =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/logicalLocation!predicate",
                          _js2n__-prdslib.arrays.minItems 0,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  policies =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/toolComponent!predicate",
                          _js2n__-prdslib.arrays.minItems 0,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  properties =
                    _js2n__-refsenv."_js2n__-:definitions/propertyBag!predicate",
                  results =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/result!predicate",
                          _js2n__-prdslib.arrays.minItems 0
                        ],
                  runGuid =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$"
                        ],
                  schema = _js2n__-prdslib.isType '"String",
                  taxonomies =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/toolComponent!predicate",
                          _js2n__-prdslib.arrays.minItems 0,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  threadFlowLocations =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/threadFlowLocation!predicate",
                          _js2n__-prdslib.arrays.minItems 0,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  translations =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/toolComponent!predicate",
                          _js2n__-prdslib.arrays.minItems 0,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  version = _js2n__-prdslib.enum [ "2.1.0" ],
                  webRequests =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/webRequest!predicate",
                          _js2n__-prdslib.arrays.minItems 0,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  webResponses =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/webResponse!predicate",
                          _js2n__-prdslib.arrays.minItems 0,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/externalPropertyFileReference!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "location" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "guid" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.record
                {
                  guid =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$"
                        ],
                  itemCount =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum (-1)
                        ],
                  location =
                    _js2n__-refsenv."_js2n__-:definitions/artifactLocation!predicate",
                  properties =
                    _js2n__-refsenv."_js2n__-:definitions/propertyBag!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/externalPropertyFileReferences!predicate"
        | doc "References to external property files that should be inlined with the content of a root log file."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  addresses =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/externalPropertyFileReference!predicate",
                          _js2n__-prdslib.arrays.minItems 0,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  artifacts =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/externalPropertyFileReference!predicate",
                          _js2n__-prdslib.arrays.minItems 0,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  conversion =
                    _js2n__-refsenv."_js2n__-:definitions/externalPropertyFileReference!predicate",
                  driver =
                    _js2n__-refsenv."_js2n__-:definitions/externalPropertyFileReference!predicate",
                  extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/externalPropertyFileReference!predicate",
                          _js2n__-prdslib.arrays.minItems 0,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  externalizedProperties =
                    _js2n__-refsenv."_js2n__-:definitions/externalPropertyFileReference!predicate",
                  graphs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/externalPropertyFileReference!predicate",
                          _js2n__-prdslib.arrays.minItems 0,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  invocations =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/externalPropertyFileReference!predicate",
                          _js2n__-prdslib.arrays.minItems 0,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  logicalLocations =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/externalPropertyFileReference!predicate",
                          _js2n__-prdslib.arrays.minItems 0,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  policies =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/externalPropertyFileReference!predicate",
                          _js2n__-prdslib.arrays.minItems 0,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  properties =
                    _js2n__-refsenv."_js2n__-:definitions/propertyBag!predicate",
                  results =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/externalPropertyFileReference!predicate",
                          _js2n__-prdslib.arrays.minItems 0,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  taxonomies =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/externalPropertyFileReference!predicate",
                          _js2n__-prdslib.arrays.minItems 0,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  threadFlowLocations =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/externalPropertyFileReference!predicate",
                          _js2n__-prdslib.arrays.minItems 0,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  translations =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/externalPropertyFileReference!predicate",
                          _js2n__-prdslib.arrays.minItems 0,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  webRequests =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/externalPropertyFileReference!predicate",
                          _js2n__-prdslib.arrays.minItems 0,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  webResponses =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/externalPropertyFileReference!predicate",
                          _js2n__-prdslib.arrays.minItems 0,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/fix!predicate"
        | doc "A proposed fix for the problem represented by a result object. A fix specifies a set of artifacts to modify. For each artifact, it specifies a set of bytes to remove, and provides a set of new bytes to replace them."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "artifactChanges" ],
              _js2n__-prdslib.records.record
                {
                  artifactChanges =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/artifactChange!predicate",
                          _js2n__-prdslib.arrays.minItems 1,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  description =
                    _js2n__-refsenv."_js2n__-:definitions/message!predicate",
                  properties =
                    _js2n__-refsenv."_js2n__-:definitions/propertyBag!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/graph!predicate"
        | doc "A network of nodes and directed edges that describes some aspect of the structure of the code (for example, a call graph)."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  description =
                    _js2n__-refsenv."_js2n__-:definitions/message!predicate",
                  edges =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/edge!predicate",
                          _js2n__-prdslib.arrays.minItems 0,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  nodes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/node!predicate",
                          _js2n__-prdslib.arrays.minItems 0,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  properties =
                    _js2n__-refsenv."_js2n__-:definitions/propertyBag!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/graphTraversal!predicate"
        | doc "Represents a path through a graph."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "runGraphIndex" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "resultGraphIndex" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.record
                {
                  description =
                    _js2n__-refsenv."_js2n__-:definitions/message!predicate",
                  edgeTraversals =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/edgeTraversal!predicate",
                          _js2n__-prdslib.arrays.minItems 0
                        ],
                  immutableState =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/multiformatMessageString!predicate"
                        ],
                  initialState =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/multiformatMessageString!predicate"
                        ],
                  properties =
                    _js2n__-refsenv."_js2n__-:definitions/propertyBag!predicate",
                  resultGraphIndex =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum (-1)
                        ],
                  runGraphIndex =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum (-1)
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/invocation!predicate"
        | doc "The runtime environment of the analysis tool run."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "executionSuccessful" ],
              _js2n__-prdslib.records.record
                {
                  account = _js2n__-prdslib.isType '"String",
                  arguments =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String"),
                          _js2n__-prdslib.arrays.minItems 0
                        ],
                  commandLine = _js2n__-prdslib.isType '"String",
                  endTimeUtc = _js2n__-prdslib.isType '"String",
                  environmentVariables =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  executableLocation =
                    _js2n__-refsenv."_js2n__-:definitions/artifactLocation!predicate",
                  executionSuccessful = _js2n__-prdslib.isType '"Bool",
                  exitCode = _js2n__-prdslib.isType 'Integer,
                  exitCodeDescription = _js2n__-prdslib.isType '"String",
                  exitSignalName = _js2n__-prdslib.isType '"String",
                  exitSignalNumber = _js2n__-prdslib.isType 'Integer,
                  machine = _js2n__-prdslib.isType '"String",
                  notificationConfigurationOverrides =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/configurationOverride!predicate",
                          _js2n__-prdslib.arrays.minItems 0,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  processId = _js2n__-prdslib.isType 'Integer,
                  processStartFailureMessage = _js2n__-prdslib.isType '"String",
                  properties =
                    _js2n__-refsenv."_js2n__-:definitions/propertyBag!predicate",
                  responseFiles =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/artifactLocation!predicate",
                          _js2n__-prdslib.arrays.minItems 0,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  ruleConfigurationOverrides =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/configurationOverride!predicate",
                          _js2n__-prdslib.arrays.minItems 0,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  startTimeUtc = _js2n__-prdslib.isType '"String",
                  stderr =
                    _js2n__-refsenv."_js2n__-:definitions/artifactLocation!predicate",
                  stdin =
                    _js2n__-refsenv."_js2n__-:definitions/artifactLocation!predicate",
                  stdout =
                    _js2n__-refsenv."_js2n__-:definitions/artifactLocation!predicate",
                  stdoutStderr =
                    _js2n__-refsenv."_js2n__-:definitions/artifactLocation!predicate",
                  toolConfigurationNotifications =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/notification!predicate",
                          _js2n__-prdslib.arrays.minItems 0
                        ],
                  toolExecutionNotifications =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/notification!predicate",
                          _js2n__-prdslib.arrays.minItems 0
                        ],
                  workingDirectory =
                    _js2n__-refsenv."_js2n__-:definitions/artifactLocation!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/location!predicate"
        | doc "A location within a programming artifact."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  annotations =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/region!predicate",
                          _js2n__-prdslib.arrays.minItems 0,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  id =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum (-1)
                        ],
                  logicalLocations =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/logicalLocation!predicate",
                          _js2n__-prdslib.arrays.minItems 0,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  message =
                    _js2n__-refsenv."_js2n__-:definitions/message!predicate",
                  physicalLocation =
                    _js2n__-refsenv."_js2n__-:definitions/physicalLocation!predicate",
                  properties =
                    _js2n__-refsenv."_js2n__-:definitions/propertyBag!predicate",
                  relationships =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/locationRelationship!predicate",
                          _js2n__-prdslib.arrays.minItems 0,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/locationRelationship!predicate"
        | doc "Information about the relation of one location to another."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "target" ],
              _js2n__-prdslib.records.record
                {
                  description =
                    _js2n__-refsenv."_js2n__-:definitions/message!predicate",
                  kinds =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String"),
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  properties =
                    _js2n__-refsenv."_js2n__-:definitions/propertyBag!predicate",
                  target =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/logicalLocation!predicate"
        | doc "A logical location of a construct that produced a result."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  decoratedName = _js2n__-prdslib.isType '"String",
                  fullyQualifiedName = _js2n__-prdslib.isType '"String",
                  index =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum (-1)
                        ],
                  kind = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                  parentIndex =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum (-1)
                        ],
                  properties =
                    _js2n__-refsenv."_js2n__-:definitions/propertyBag!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/message!predicate"
        | doc "Encapsulates a message intended to be read by the end user."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "text" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "id" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.record
                {
                  arguments =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String"),
                          _js2n__-prdslib.arrays.minItems 0
                        ],
                  id = _js2n__-prdslib.isType '"String",
                  markdown = _js2n__-prdslib.isType '"String",
                  properties =
                    _js2n__-refsenv."_js2n__-:definitions/propertyBag!predicate",
                  text = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/multiformatMessageString!predicate"
        | doc "A message string or message format string rendered in multiple formats."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "text" ],
              _js2n__-prdslib.records.record
                {
                  markdown = _js2n__-prdslib.isType '"String",
                  properties =
                    _js2n__-refsenv."_js2n__-:definitions/propertyBag!predicate",
                  text = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/node!predicate"
        | doc "Represents a node in a graph."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "id" ],
              _js2n__-prdslib.records.record
                {
                  children =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/node!predicate",
                          _js2n__-prdslib.arrays.minItems 0,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  id = _js2n__-prdslib.isType '"String",
                  label =
                    _js2n__-refsenv."_js2n__-:definitions/message!predicate",
                  location =
                    _js2n__-refsenv."_js2n__-:definitions/location!predicate",
                  properties =
                    _js2n__-refsenv."_js2n__-:definitions/propertyBag!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/notification!predicate"
        | doc "Describes a condition relevant to the tool itself, as opposed to being relevant to a target being analyzed by the tool."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "message" ],
              _js2n__-prdslib.records.record
                {
                  associatedRule =
                    _js2n__-refsenv."_js2n__-:definitions/reportingDescriptorReference!predicate",
                  descriptor =
                    _js2n__-refsenv."_js2n__-:definitions/reportingDescriptorReference!predicate",
                  exception =
                    _js2n__-refsenv."_js2n__-:definitions/exception!predicate",
                  level =
                    _js2n__-prdslib.enum [ "none", "note", "warning", "error" ],
                  locations =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/location!predicate",
                          _js2n__-prdslib.arrays.minItems 0,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  message =
                    _js2n__-refsenv."_js2n__-:definitions/message!predicate",
                  properties =
                    _js2n__-refsenv."_js2n__-:definitions/propertyBag!predicate",
                  threadId = _js2n__-prdslib.isType 'Integer,
                  timeUtc = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/physicalLocation!predicate"
        | doc "A physical location relevant to a result. Specifies a reference to a programming artifact together with a range of bytes or characters within that artifact."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "address" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "artifactLocation" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.record
                {
                  address =
                    _js2n__-refsenv."_js2n__-:definitions/address!predicate",
                  artifactLocation =
                    _js2n__-refsenv."_js2n__-:definitions/artifactLocation!predicate",
                  contextRegion =
                    _js2n__-refsenv."_js2n__-:definitions/region!predicate",
                  properties =
                    _js2n__-refsenv."_js2n__-:definitions/propertyBag!predicate",
                  region =
                    _js2n__-refsenv."_js2n__-:definitions/region!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/propertyBag!contract"
        | doc "Key/value pairs that provide additional information about the object."
        = {
            tags
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"Array",
                    _js2n__-prdslib.arrays.arrayOf
                      (_js2n__-prdslib.isType '"String"),
                    _js2n__-prdslib.arrays.minItems 0,
                    _js2n__-prdslib.arrays.uniqueItems
                  ])
              | doc "A set of distinct strings that provide additional information."
              | optional,
            ..
          },
      "_js2n__-:definitions/propertyBag!predicate"
        | doc "Key/value pairs that provide additional information about the object."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  tags =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String"),
                          _js2n__-prdslib.arrays.minItems 0,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/rectangle!predicate"
        | doc "An area within an image."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  bottom = _js2n__-prdslib.isType '"Number",
                  left = _js2n__-prdslib.isType '"Number",
                  message =
                    _js2n__-refsenv."_js2n__-:definitions/message!predicate",
                  properties =
                    _js2n__-refsenv."_js2n__-:definitions/propertyBag!predicate",
                  right = _js2n__-prdslib.isType '"Number",
                  top = _js2n__-prdslib.isType '"Number",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/region!predicate"
        | doc "A region within an artifact where a result was detected."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  byteLength =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  byteOffset =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum (-1)
                        ],
                  charLength =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  charOffset =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum (-1)
                        ],
                  endColumn =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 1
                        ],
                  endLine =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 1
                        ],
                  message =
                    _js2n__-refsenv."_js2n__-:definitions/message!predicate",
                  properties =
                    _js2n__-refsenv."_js2n__-:definitions/propertyBag!predicate",
                  snippet =
                    _js2n__-refsenv."_js2n__-:definitions/artifactContent!predicate",
                  sourceLanguage = _js2n__-prdslib.isType '"String",
                  startColumn =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 1
                        ],
                  startLine =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 1
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/replacement!predicate"
        | doc "The replacement of a single region of an artifact."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "deletedRegion" ],
              _js2n__-prdslib.records.record
                {
                  deletedRegion =
                    _js2n__-refsenv."_js2n__-:definitions/region!predicate",
                  insertedContent =
                    _js2n__-refsenv."_js2n__-:definitions/artifactContent!predicate",
                  properties =
                    _js2n__-refsenv."_js2n__-:definitions/propertyBag!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/reportingConfiguration!predicate"
        | doc "Information about a rule or notification that can be configured at runtime."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  enabled = _js2n__-prdslib.isType '"Bool",
                  level =
                    _js2n__-prdslib.enum [ "none", "note", "warning", "error" ],
                  parameters =
                    _js2n__-refsenv."_js2n__-:definitions/propertyBag!predicate",
                  properties =
                    _js2n__-refsenv."_js2n__-:definitions/propertyBag!predicate",
                  rank =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.numbers.maximum 100,
                          _js2n__-prdslib.numbers.minimum (-1)
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/reportingDescriptor!predicate"
        | doc "Metadata that describes a specific report produced by the tool, as part of the analysis it provides or its runtime reporting."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "id" ],
              _js2n__-prdslib.records.record
                {
                  defaultConfiguration =
                    _js2n__-refsenv."_js2n__-:definitions/reportingConfiguration!predicate",
                  deprecatedGuids =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.strings.pattern
                                  "^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$"
                              ]),
                          _js2n__-prdslib.arrays.minItems 0,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  deprecatedIds =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String"),
                          _js2n__-prdslib.arrays.minItems 0,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  deprecatedNames =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String"),
                          _js2n__-prdslib.arrays.minItems 0,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  fullDescription =
                    _js2n__-refsenv."_js2n__-:definitions/multiformatMessageString!predicate",
                  guid =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$"
                        ],
                  help =
                    _js2n__-refsenv."_js2n__-:definitions/multiformatMessageString!predicate",
                  helpUri = _js2n__-prdslib.isType '"String",
                  id = _js2n__-prdslib.isType '"String",
                  messageStrings =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/multiformatMessageString!predicate"
                        ],
                  name = _js2n__-prdslib.isType '"String",
                  properties =
                    _js2n__-refsenv."_js2n__-:definitions/propertyBag!predicate",
                  relationships =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/reportingDescriptorRelationship!predicate",
                          _js2n__-prdslib.arrays.minItems 0,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  shortDescription =
                    _js2n__-refsenv."_js2n__-:definitions/multiformatMessageString!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/reportingDescriptorReference!predicate"
        | doc "Information about how to locate a relevant reporting descriptor."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "index" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "guid" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "id" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.record
                {
                  guid =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$"
                        ],
                  id = _js2n__-prdslib.isType '"String",
                  index =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum (-1)
                        ],
                  properties =
                    _js2n__-refsenv."_js2n__-:definitions/propertyBag!predicate",
                  toolComponent =
                    _js2n__-refsenv."_js2n__-:definitions/toolComponentReference!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/reportingDescriptorRelationship!predicate"
        | doc "Information about the relation of one reporting descriptor to another."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "target" ],
              _js2n__-prdslib.records.record
                {
                  description =
                    _js2n__-refsenv."_js2n__-:definitions/message!predicate",
                  kinds =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String"),
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  properties =
                    _js2n__-refsenv."_js2n__-:definitions/propertyBag!predicate",
                  target =
                    _js2n__-refsenv."_js2n__-:definitions/reportingDescriptorReference!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/result!predicate"
        | doc "A result produced by an analysis tool."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "message" ],
              _js2n__-prdslib.records.record
                {
                  analysisTarget =
                    _js2n__-refsenv."_js2n__-:definitions/artifactLocation!predicate",
                  attachments =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/attachment!predicate",
                          _js2n__-prdslib.arrays.minItems 0,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  baselineState =
                    _js2n__-prdslib.enum
                        [ "new", "unchanged", "updated", "absent" ],
                  codeFlows =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/codeFlow!predicate",
                          _js2n__-prdslib.arrays.minItems 0
                        ],
                  correlationGuid =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$"
                        ],
                  fingerprints =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  fixes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/fix!predicate",
                          _js2n__-prdslib.arrays.minItems 0,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  graphTraversals =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/graphTraversal!predicate",
                          _js2n__-prdslib.arrays.minItems 0,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  graphs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/graph!predicate",
                          _js2n__-prdslib.arrays.minItems 0,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  guid =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$"
                        ],
                  hostedViewerUri = _js2n__-prdslib.isType '"String",
                  kind =
                    _js2n__-prdslib.enum
                        [
                          "notApplicable",
                          "pass",
                          "fail",
                          "review",
                          "open",
                          "informational"
                        ],
                  level =
                    _js2n__-prdslib.enum [ "none", "note", "warning", "error" ],
                  locations =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/location!predicate",
                          _js2n__-prdslib.arrays.minItems 0
                        ],
                  message =
                    _js2n__-refsenv."_js2n__-:definitions/message!predicate",
                  occurrenceCount =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 1
                        ],
                  partialFingerprints =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  properties =
                    _js2n__-refsenv."_js2n__-:definitions/propertyBag!predicate",
                  provenance =
                    _js2n__-refsenv."_js2n__-:definitions/resultProvenance!predicate",
                  rank =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.numbers.maximum 100,
                          _js2n__-prdslib.numbers.minimum (-1)
                        ],
                  relatedLocations =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/location!predicate",
                          _js2n__-prdslib.arrays.minItems 0,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  rule =
                    _js2n__-refsenv."_js2n__-:definitions/reportingDescriptorReference!predicate",
                  ruleId = _js2n__-prdslib.isType '"String",
                  ruleIndex =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum (-1)
                        ],
                  stacks =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/stack!predicate",
                          _js2n__-prdslib.arrays.minItems 0,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  suppressions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/suppression!predicate",
                          _js2n__-prdslib.arrays.minItems 0,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  taxa =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/reportingDescriptorReference!predicate",
                          _js2n__-prdslib.arrays.minItems 0,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  webRequest =
                    _js2n__-refsenv."_js2n__-:definitions/webRequest!predicate",
                  webResponse =
                    _js2n__-refsenv."_js2n__-:definitions/webResponse!predicate",
                  workItemUris =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String"),
                          _js2n__-prdslib.arrays.minItems 0,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/resultProvenance!predicate"
        | doc "Contains information about how and when a result was detected."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  conversionSources =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/physicalLocation!predicate",
                          _js2n__-prdslib.arrays.minItems 0,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  firstDetectionRunGuid =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$"
                        ],
                  firstDetectionTimeUtc = _js2n__-prdslib.isType '"String",
                  invocationIndex =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum (-1)
                        ],
                  lastDetectionRunGuid =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$"
                        ],
                  lastDetectionTimeUtc = _js2n__-prdslib.isType '"String",
                  properties =
                    _js2n__-refsenv."_js2n__-:definitions/propertyBag!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/run!predicate"
        | doc "Describes a single run of an analysis tool, and contains the reported output of that run."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "tool" ],
              _js2n__-prdslib.records.record
                {
                  addresses =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/address!predicate",
                          _js2n__-prdslib.arrays.minItems 0
                        ],
                  artifacts =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/artifact!predicate",
                          _js2n__-prdslib.arrays.minItems 0,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  automationDetails =
                    _js2n__-refsenv."_js2n__-:definitions/runAutomationDetails!predicate",
                  baselineGuid =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$"
                        ],
                  columnKind =
                    _js2n__-prdslib.enum
                        [ "utf16CodeUnits", "unicodeCodePoints" ],
                  conversion =
                    _js2n__-refsenv."_js2n__-:definitions/conversion!predicate",
                  defaultEncoding = _js2n__-prdslib.isType '"String",
                  defaultSourceLanguage = _js2n__-prdslib.isType '"String",
                  externalPropertyFileReferences =
                    _js2n__-refsenv."_js2n__-:definitions/externalPropertyFileReferences!predicate",
                  graphs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/graph!predicate",
                          _js2n__-prdslib.arrays.minItems 0,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  invocations =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/invocation!predicate",
                          _js2n__-prdslib.arrays.minItems 0
                        ],
                  language =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^[a-zA-Z]{2}|^[a-zA-Z]{2}-[a-zA-Z]{2}?$"
                        ],
                  logicalLocations =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/logicalLocation!predicate",
                          _js2n__-prdslib.arrays.minItems 0,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  newlineSequences =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String"),
                          _js2n__-prdslib.arrays.minItems 1,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  originalUriBaseIds =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/artifactLocation!predicate"
                        ],
                  policies =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/toolComponent!predicate",
                          _js2n__-prdslib.arrays.minItems 0,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  properties =
                    _js2n__-refsenv."_js2n__-:definitions/propertyBag!predicate",
                  redactionTokens =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String"),
                          _js2n__-prdslib.arrays.minItems 0,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  results =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/result!predicate",
                          _js2n__-prdslib.arrays.minItems 0
                        ],
                  runAggregates =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/runAutomationDetails!predicate",
                          _js2n__-prdslib.arrays.minItems 0,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  specialLocations =
                    _js2n__-refsenv."_js2n__-:definitions/specialLocations!predicate",
                  taxonomies =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/toolComponent!predicate",
                          _js2n__-prdslib.arrays.minItems 0,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  threadFlowLocations =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/threadFlowLocation!predicate",
                          _js2n__-prdslib.arrays.minItems 0,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  tool = _js2n__-refsenv."_js2n__-:definitions/tool!predicate",
                  translations =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/toolComponent!predicate",
                          _js2n__-prdslib.arrays.minItems 0,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  versionControlProvenance =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/versionControlDetails!predicate",
                          _js2n__-prdslib.arrays.minItems 0,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  webRequests =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/webRequest!predicate",
                          _js2n__-prdslib.arrays.minItems 0,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  webResponses =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/webResponse!predicate",
                          _js2n__-prdslib.arrays.minItems 0,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/runAutomationDetails!predicate"
        | doc "Information that describes a run's identity and role within an engineering system process."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  correlationGuid =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$"
                        ],
                  description =
                    _js2n__-refsenv."_js2n__-:definitions/message!predicate",
                  guid =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$"
                        ],
                  id = _js2n__-prdslib.isType '"String",
                  properties =
                    _js2n__-refsenv."_js2n__-:definitions/propertyBag!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/specialLocations!predicate"
        | doc "Defines locations of special significance to SARIF consumers."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  displayBase =
                    _js2n__-refsenv."_js2n__-:definitions/artifactLocation!predicate",
                  properties =
                    _js2n__-refsenv."_js2n__-:definitions/propertyBag!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/stack!predicate"
        | doc "A call stack that is relevant to a result."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "frames" ],
              _js2n__-prdslib.records.record
                {
                  frames =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/stackFrame!predicate",
                          _js2n__-prdslib.arrays.minItems 0
                        ],
                  message =
                    _js2n__-refsenv."_js2n__-:definitions/message!predicate",
                  properties =
                    _js2n__-refsenv."_js2n__-:definitions/propertyBag!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/stackFrame!predicate"
        | doc "A function call within a stack trace."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  location =
                    _js2n__-refsenv."_js2n__-:definitions/location!predicate",
                  module = _js2n__-prdslib.isType '"String",
                  parameters =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String"),
                          _js2n__-prdslib.arrays.minItems 0
                        ],
                  properties =
                    _js2n__-refsenv."_js2n__-:definitions/propertyBag!predicate",
                  threadId = _js2n__-prdslib.isType 'Integer,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/suppression!predicate"
        | doc "A suppression that is relevant to a result."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "kind" ],
              _js2n__-prdslib.records.record
                {
                  guid =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$"
                        ],
                  justification = _js2n__-prdslib.isType '"String",
                  kind = _js2n__-prdslib.enum [ "inSource", "external" ],
                  location =
                    _js2n__-refsenv."_js2n__-:definitions/location!predicate",
                  properties =
                    _js2n__-refsenv."_js2n__-:definitions/propertyBag!predicate",
                  state =
                    _js2n__-prdslib.enum
                        [ "accepted", "underReview", "rejected" ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/threadFlow!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "locations" ],
              _js2n__-prdslib.records.record
                {
                  id = _js2n__-prdslib.isType '"String",
                  immutableState =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/multiformatMessageString!predicate"
                        ],
                  initialState =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/multiformatMessageString!predicate"
                        ],
                  locations =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/threadFlowLocation!predicate",
                          _js2n__-prdslib.arrays.minItems 1
                        ],
                  message =
                    _js2n__-refsenv."_js2n__-:definitions/message!predicate",
                  properties =
                    _js2n__-refsenv."_js2n__-:definitions/propertyBag!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/threadFlowLocation!predicate"
        | doc "A location visited by an analysis tool while simulating or monitoring the execution of a program."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  executionOrder =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum (-1)
                        ],
                  executionTimeUtc = _js2n__-prdslib.isType '"String",
                  importance =
                    _js2n__-prdslib.enum
                        [ "important", "essential", "unimportant" ],
                  index =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum (-1)
                        ],
                  kinds =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String"),
                          _js2n__-prdslib.arrays.minItems 0,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  location =
                    _js2n__-refsenv."_js2n__-:definitions/location!predicate",
                  module = _js2n__-prdslib.isType '"String",
                  nestingLevel =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  properties =
                    _js2n__-refsenv."_js2n__-:definitions/propertyBag!predicate",
                  stack =
                    _js2n__-refsenv."_js2n__-:definitions/stack!predicate",
                  state =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/multiformatMessageString!predicate"
                        ],
                  taxa =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/reportingDescriptorReference!predicate",
                          _js2n__-prdslib.arrays.minItems 0,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  webRequest =
                    _js2n__-refsenv."_js2n__-:definitions/webRequest!predicate",
                  webResponse =
                    _js2n__-refsenv."_js2n__-:definitions/webResponse!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/tool!predicate"
        | doc "The analysis tool that was run."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "driver" ],
              _js2n__-prdslib.records.record
                {
                  driver =
                    _js2n__-refsenv."_js2n__-:definitions/toolComponent!predicate",
                  extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/toolComponent!predicate",
                          _js2n__-prdslib.arrays.minItems 0,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  properties =
                    _js2n__-refsenv."_js2n__-:definitions/propertyBag!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/toolComponent!predicate"
        | doc "A component, such as a plug-in or the driver, of the analysis tool that was run."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                {
                  associatedComponent =
                    _js2n__-refsenv."_js2n__-:definitions/toolComponentReference!predicate",
                  contents =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.enum
                              [ "localizedData", "nonLocalizedData" ]),
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  dottedQuadFileVersion =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern "[0-9]+(\\.[0-9]+){3}"
                        ],
                  downloadUri = _js2n__-prdslib.isType '"String",
                  fullDescription =
                    _js2n__-refsenv."_js2n__-:definitions/multiformatMessageString!predicate",
                  fullName = _js2n__-prdslib.isType '"String",
                  globalMessageStrings =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/multiformatMessageString!predicate"
                        ],
                  guid =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$"
                        ],
                  informationUri = _js2n__-prdslib.isType '"String",
                  isComprehensive = _js2n__-prdslib.isType '"Bool",
                  language =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^[a-zA-Z]{2}|^[a-zA-Z]{2}-[a-zA-Z]{2}?$"
                        ],
                  localizedDataSemanticVersion =
                    _js2n__-prdslib.isType '"String",
                  locations =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/artifactLocation!predicate",
                          _js2n__-prdslib.arrays.minItems 0
                        ],
                  minimumRequiredLocalizedDataSemanticVersion =
                    _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                  notifications =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/reportingDescriptor!predicate",
                          _js2n__-prdslib.arrays.minItems 0,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  organization = _js2n__-prdslib.isType '"String",
                  product = _js2n__-prdslib.isType '"String",
                  productSuite = _js2n__-prdslib.isType '"String",
                  properties =
                    _js2n__-refsenv."_js2n__-:definitions/propertyBag!predicate",
                  releaseDateUtc = _js2n__-prdslib.isType '"String",
                  rules =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/reportingDescriptor!predicate",
                          _js2n__-prdslib.arrays.minItems 0,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  semanticVersion = _js2n__-prdslib.isType '"String",
                  shortDescription =
                    _js2n__-refsenv."_js2n__-:definitions/multiformatMessageString!predicate",
                  supportedTaxonomies =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/toolComponentReference!predicate",
                          _js2n__-prdslib.arrays.minItems 0,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  taxa =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/reportingDescriptor!predicate",
                          _js2n__-prdslib.arrays.minItems 0,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  translationMetadata =
                    _js2n__-refsenv."_js2n__-:definitions/translationMetadata!predicate",
                  version = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/toolComponentReference!predicate"
        | doc ""
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  guid =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$"
                        ],
                  index =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum (-1)
                        ],
                  name = _js2n__-prdslib.isType '"String",
                  properties =
                    _js2n__-refsenv."_js2n__-:definitions/propertyBag!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/translationMetadata!predicate"
        | doc "Provides additional metadata related to translation."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                {
                  downloadUri = _js2n__-prdslib.isType '"String",
                  fullDescription =
                    _js2n__-refsenv."_js2n__-:definitions/multiformatMessageString!predicate",
                  fullName = _js2n__-prdslib.isType '"String",
                  informationUri = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                  properties =
                    _js2n__-refsenv."_js2n__-:definitions/propertyBag!predicate",
                  shortDescription =
                    _js2n__-refsenv."_js2n__-:definitions/multiformatMessageString!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/versionControlDetails!predicate"
        | doc "Specifies the information necessary to retrieve a desired revision from a version control system."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "repositoryUri" ],
              _js2n__-prdslib.records.record
                {
                  asOfTimeUtc = _js2n__-prdslib.isType '"String",
                  branch = _js2n__-prdslib.isType '"String",
                  mappedTo =
                    _js2n__-refsenv."_js2n__-:definitions/artifactLocation!predicate",
                  properties =
                    _js2n__-refsenv."_js2n__-:definitions/propertyBag!predicate",
                  repositoryUri = _js2n__-prdslib.isType '"String",
                  revisionId = _js2n__-prdslib.isType '"String",
                  revisionTag = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/webRequest!predicate"
        | doc "A web request object."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  body =
                    _js2n__-refsenv."_js2n__-:definitions/artifactContent!predicate",
                  headers =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  index =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum (-1)
                        ],
                  method = _js2n__-prdslib.isType '"String",
                  parameters =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  properties =
                    _js2n__-refsenv."_js2n__-:definitions/propertyBag!predicate",
                  protocol = _js2n__-prdslib.isType '"String",
                  target = _js2n__-prdslib.isType '"String",
                  version = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/webResponse!predicate"
        | doc "A web response object."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  body =
                    _js2n__-refsenv."_js2n__-:definitions/artifactContent!predicate",
                  headers =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  index =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum (-1)
                        ],
                  noResponseReceived = _js2n__-prdslib.isType '"Bool",
                  properties =
                    _js2n__-refsenv."_js2n__-:definitions/propertyBag!predicate",
                  protocol = _js2n__-prdslib.isType '"String",
                  reasonPhrase = _js2n__-prdslib.isType '"String",
                  statusCode = _js2n__-prdslib.isType 'Integer,
                  version = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
    }
    in
  {
      "$schema"
        | String
        | doc "The URI of the JSON schema corresponding to the version."
        | optional,
      inlineExternalProperties
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/externalProperties!predicate",
              _js2n__-prdslib.arrays.minItems 0,
              _js2n__-prdslib.arrays.uniqueItems
            ])
        | doc "References to external property files that share data between runs."
        | optional,
      properties
        | _js2n__-refsenv."_js2n__-:definitions/propertyBag!contract"
        | doc "Key/value pairs that provide additional information about the log file."
        | optional,
      runs
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/run!predicate",
              _js2n__-prdslib.arrays.minItems 0
            ])
        | doc "The set of runs contained in this log file.",
      version
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.enum [ "2.1.0" ])
        | doc "The SARIF format version of this log file.",
    }