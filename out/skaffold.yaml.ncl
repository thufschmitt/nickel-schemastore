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
      "_js2n__-:definitions/Activation!predicate"
        | doc "criteria by which a profile is auto-activated."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  command = _js2n__-prdslib.isType '"String",
                  env = _js2n__-prdslib.isType '"String",
                  kubeContext = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Artifact!predicate"
        | doc "items that need to be built, along with the context in which they should be built."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.records.record
                    {
                      context = _js2n__-prdslib.isType '"String",
                      hooks =
                        _js2n__-refsenv."_js2n__-:definitions/BuildHooks!predicate",
                      image = _js2n__-prdslib.isType '"String",
                      platforms =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                      requires =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/ArtifactDependency!predicate"
                            ],
                      sync =
                        _js2n__-refsenv."_js2n__-:definitions/Sync!predicate",
                    } {} false _js2n__-prdslib.never,
                  _js2n__-prdslib.records.record
                    {
                      context = _js2n__-prdslib.isType '"String",
                      docker =
                        _js2n__-refsenv."_js2n__-:definitions/DockerArtifact!predicate",
                      hooks =
                        _js2n__-refsenv."_js2n__-:definitions/BuildHooks!predicate",
                      image = _js2n__-prdslib.isType '"String",
                      platforms =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                      requires =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/ArtifactDependency!predicate"
                            ],
                      sync =
                        _js2n__-refsenv."_js2n__-:definitions/Sync!predicate",
                    } {} false _js2n__-prdslib.never,
                  _js2n__-prdslib.records.record
                    {
                      bazel =
                        _js2n__-refsenv."_js2n__-:definitions/BazelArtifact!predicate",
                      context = _js2n__-prdslib.isType '"String",
                      hooks =
                        _js2n__-refsenv."_js2n__-:definitions/BuildHooks!predicate",
                      image = _js2n__-prdslib.isType '"String",
                      platforms =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                      requires =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/ArtifactDependency!predicate"
                            ],
                      sync =
                        _js2n__-refsenv."_js2n__-:definitions/Sync!predicate",
                    } {} false _js2n__-prdslib.never,
                  _js2n__-prdslib.records.record
                    {
                      context = _js2n__-prdslib.isType '"String",
                      hooks =
                        _js2n__-refsenv."_js2n__-:definitions/BuildHooks!predicate",
                      image = _js2n__-prdslib.isType '"String",
                      ko =
                        _js2n__-refsenv."_js2n__-:definitions/KoArtifact!predicate",
                      platforms =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                      requires =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/ArtifactDependency!predicate"
                            ],
                      sync =
                        _js2n__-refsenv."_js2n__-:definitions/Sync!predicate",
                    } {} false _js2n__-prdslib.never,
                  _js2n__-prdslib.records.record
                    {
                      context = _js2n__-prdslib.isType '"String",
                      hooks =
                        _js2n__-refsenv."_js2n__-:definitions/BuildHooks!predicate",
                      image = _js2n__-prdslib.isType '"String",
                      jib =
                        _js2n__-refsenv."_js2n__-:definitions/JibArtifact!predicate",
                      platforms =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                      requires =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/ArtifactDependency!predicate"
                            ],
                      sync =
                        _js2n__-refsenv."_js2n__-:definitions/Sync!predicate",
                    } {} false _js2n__-prdslib.never,
                  _js2n__-prdslib.records.record
                    {
                      context = _js2n__-prdslib.isType '"String",
                      hooks =
                        _js2n__-refsenv."_js2n__-:definitions/BuildHooks!predicate",
                      image = _js2n__-prdslib.isType '"String",
                      kaniko =
                        _js2n__-refsenv."_js2n__-:definitions/KanikoArtifact!predicate",
                      platforms =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                      requires =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/ArtifactDependency!predicate"
                            ],
                      sync =
                        _js2n__-refsenv."_js2n__-:definitions/Sync!predicate",
                    } {} false _js2n__-prdslib.never,
                  _js2n__-prdslib.records.record
                    {
                      buildpacks =
                        _js2n__-refsenv."_js2n__-:definitions/BuildpackArtifact!predicate",
                      context = _js2n__-prdslib.isType '"String",
                      hooks =
                        _js2n__-refsenv."_js2n__-:definitions/BuildHooks!predicate",
                      image = _js2n__-prdslib.isType '"String",
                      platforms =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                      requires =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/ArtifactDependency!predicate"
                            ],
                      sync =
                        _js2n__-refsenv."_js2n__-:definitions/Sync!predicate",
                    } {} false _js2n__-prdslib.never,
                  _js2n__-prdslib.records.record
                    {
                      context = _js2n__-prdslib.isType '"String",
                      custom =
                        _js2n__-refsenv."_js2n__-:definitions/CustomArtifact!predicate",
                      hooks =
                        _js2n__-refsenv."_js2n__-:definitions/BuildHooks!predicate",
                      image = _js2n__-prdslib.isType '"String",
                      platforms =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                      requires =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/ArtifactDependency!predicate"
                            ],
                      sync =
                        _js2n__-refsenv."_js2n__-:definitions/Sync!predicate",
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.records.required [ "image" ],
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/ArtifactDependency!predicate"
        | doc "describes a specific build dependency for an artifact."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "image" ],
              _js2n__-prdslib.records.record
                {
                  alias = _js2n__-prdslib.isType '"String",
                  image = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/BazelArtifact!predicate"
        | doc "describes an artifact built with [Bazel](https://bazel.build/)."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "target" ],
              _js2n__-prdslib.records.record
                {
                  args =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  target = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/BuildConfig!predicate"
        | doc "contains all the configuration for the build steps."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.records.record
                    {
                      artifacts =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/Artifact!predicate"
                            ],
                      insecureRegistries =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                      platforms =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                      tagPolicy =
                        _js2n__-refsenv."_js2n__-:definitions/TagPolicy!predicate",
                    } {} false _js2n__-prdslib.never,
                  _js2n__-prdslib.records.record
                    {
                      artifacts =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/Artifact!predicate"
                            ],
                      insecureRegistries =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                      local =
                        _js2n__-refsenv."_js2n__-:definitions/LocalBuild!predicate",
                      platforms =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                      tagPolicy =
                        _js2n__-refsenv."_js2n__-:definitions/TagPolicy!predicate",
                    } {} false _js2n__-prdslib.never,
                  _js2n__-prdslib.records.record
                    {
                      artifacts =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/Artifact!predicate"
                            ],
                      googleCloudBuild =
                        _js2n__-refsenv."_js2n__-:definitions/GoogleCloudBuild!predicate",
                      insecureRegistries =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                      platforms =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                      tagPolicy =
                        _js2n__-refsenv."_js2n__-:definitions/TagPolicy!predicate",
                    } {} false _js2n__-prdslib.never,
                  _js2n__-prdslib.records.record
                    {
                      artifacts =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/Artifact!predicate"
                            ],
                      cluster =
                        _js2n__-refsenv."_js2n__-:definitions/ClusterDetails!predicate",
                      insecureRegistries =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                      platforms =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                      tagPolicy =
                        _js2n__-refsenv."_js2n__-:definitions/TagPolicy!predicate",
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:definitions/BuildHooks!predicate"
        | doc "describes the list of lifecycle hooks to execute before and after each artifact build step."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  after =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/HostHook!predicate"
                        ],
                  before =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/HostHook!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/BuildpackArtifact!predicate"
        | doc "*alpha* describes an artifact built using [Cloud Native Buildpacks](https://buildpacks.io/). It can be used to build images out of project's sources without any additional configuration."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  builder = _js2n__-prdslib.isType '"String",
                  buildpacks =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  clearCache = _js2n__-prdslib.isType '"Bool",
                  dependencies =
                    _js2n__-refsenv."_js2n__-:definitions/BuildpackDependencies!predicate",
                  env =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  projectDescriptor = _js2n__-prdslib.isType '"String",
                  runImage = _js2n__-prdslib.isType '"String",
                  trustBuilder = _js2n__-prdslib.isType '"Bool",
                  volumes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/BuildpackVolume!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/BuildpackDependencies!predicate"
        | doc "*alpha* used to specify dependencies for an artifact built by buildpacks."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  ignore =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  paths =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/BuildpackVolume!predicate"
        | doc "*alpha* used to mount host volumes or directories in the build container."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "host", "target" ],
              _js2n__-prdslib.records.record
                {
                  host = _js2n__-prdslib.isType '"String",
                  options =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "ro", "rw", "volume-opt=<key>=<value>" ]
                        ],
                  target = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/CloudRunDeploy!predicate"
        | doc "*alpha* deploys the container to Google Cloud Run."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  projectid = _js2n__-prdslib.isType '"String",
                  region = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ClusterDetails!predicate"
        | doc "*beta* describes how to do an on-cluster build."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  HTTPS_PROXY = _js2n__-prdslib.isType '"String",
                  HTTP_PROXY = _js2n__-prdslib.isType '"String",
                  annotations =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  concurrency = _js2n__-prdslib.isType 'Integer,
                  dockerConfig =
                    _js2n__-refsenv."_js2n__-:definitions/DockerConfig!predicate",
                  namespace = _js2n__-prdslib.isType '"String",
                  nodeSelector =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  pullSecretMountPath = _js2n__-prdslib.isType '"String",
                  pullSecretName = _js2n__-prdslib.isType '"String",
                  pullSecretPath = _js2n__-prdslib.isType '"String",
                  randomDockerConfigSecret = _js2n__-prdslib.isType '"Bool",
                  randomPullSecret = _js2n__-prdslib.isType '"Bool",
                  resources =
                    _js2n__-refsenv."_js2n__-:definitions/ResourceRequirements!predicate",
                  runAsUser = _js2n__-prdslib.isType 'Integer,
                  serviceAccount = _js2n__-prdslib.isType '"String",
                  timeout = _js2n__-prdslib.isType '"String",
                  tolerations =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf _js2n__-prdslib.always
                        ],
                  volumes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf _js2n__-prdslib.always
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ConfigDependency!predicate"
        | doc "describes a dependency on another skaffold configuration."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  activeProfiles =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/ProfileDependency!predicate"
                        ],
                  configs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  git =
                    _js2n__-refsenv."_js2n__-:definitions/GitInfo!predicate",
                  path = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ContainerHook!predicate"
        | doc "describes a lifecycle hook definition to execute on a container. The container name is inferred from the scope in which this hook is defined."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "command" ],
              _js2n__-prdslib.records.record
                {
                  command =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/CustomArtifact!predicate"
        | doc "*beta* describes an artifact built from a custom build script written by the user. It can be used to build images with builders that aren't directly integrated with skaffold."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  buildCommand = _js2n__-prdslib.isType '"String",
                  dependencies =
                    _js2n__-refsenv."_js2n__-:definitions/CustomDependencies!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/CustomDependencies!predicate"
        | doc "*beta* used to specify dependencies for an artifact built by a custom build script. Either `dockerfile` or `paths` should be specified for file watching to work as expected."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  command = _js2n__-prdslib.isType '"String",
                  dockerfile =
                    _js2n__-refsenv."_js2n__-:definitions/DockerfileDependency!predicate",
                  ignore =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  paths =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/CustomTemplateTagger!predicate"
        | doc "*beta* tags images with a configurable template string."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "template" ],
              _js2n__-prdslib.records.record
                {
                  components =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/TaggerComponent!predicate"
                        ],
                  template = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/CustomTest!predicate"
        | doc "describes the custom test command provided by the user. Custom tests are run after an image build whenever build or test dependencies are changed."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "command" ],
              _js2n__-prdslib.records.record
                {
                  command = _js2n__-prdslib.isType '"String",
                  dependencies =
                    _js2n__-refsenv."_js2n__-:definitions/CustomTestDependencies!predicate",
                  timeoutSeconds = _js2n__-prdslib.isType 'Integer,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/CustomTestDependencies!predicate"
        | doc "used to specify dependencies for custom test command. `paths` should be specified for file watching to work as expected."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  command = _js2n__-prdslib.isType '"String",
                  ignore =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  paths =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/DateTimeTagger!predicate"
        | doc "*beta* tags images with the build timestamp."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  format = _js2n__-prdslib.isType '"String",
                  timezone = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/DeployConfig!predicate"
        | doc "contains all the configuration needed by the deploy steps."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  cloudrun =
                    _js2n__-refsenv."_js2n__-:definitions/CloudRunDeploy!predicate",
                  docker =
                    _js2n__-refsenv."_js2n__-:definitions/DockerDeploy!predicate",
                  helm =
                    _js2n__-refsenv."_js2n__-:definitions/LegacyHelmDeploy!predicate",
                  kpt =
                    _js2n__-refsenv."_js2n__-:definitions/KptDeploy!predicate",
                  kubeContext = _js2n__-prdslib.isType '"String",
                  kubectl =
                    _js2n__-refsenv."_js2n__-:definitions/KubectlDeploy!predicate",
                  logs =
                    _js2n__-refsenv."_js2n__-:definitions/LogsConfig!predicate",
                  statusCheck = _js2n__-prdslib.isType '"Bool",
                  statusCheckDeadlineSeconds = _js2n__-prdslib.isType 'Integer,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/DeployHookItem!predicate"
        | doc "describes a single lifecycle hook to execute before or after each deployer step."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  container =
                    _js2n__-refsenv."_js2n__-:definitions/NamedContainerHook!predicate",
                  host =
                    _js2n__-refsenv."_js2n__-:definitions/HostHook!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/DeployHooks!predicate"
        | doc "describes the list of lifecycle hooks to execute before and after each deployer step."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  after =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/DeployHookItem!predicate"
                        ],
                  before =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/DeployHookItem!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/DockerArtifact!predicate"
        | doc "describes an artifact built from a Dockerfile, usually using `docker build`."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  addHost =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  buildArgs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  cacheFrom =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  cliFlags =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  dockerfile = _js2n__-prdslib.isType '"String",
                  network =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "host", "bridge", "container:<name|id>", "none" ]
                        ],
                  noCache = _js2n__-prdslib.isType '"Bool",
                  pullParent = _js2n__-prdslib.isType '"Bool",
                  secrets =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/DockerSecret!predicate"
                        ],
                  squash = _js2n__-prdslib.isType '"Bool",
                  ssh = _js2n__-prdslib.isType '"String",
                  target = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/DockerConfig!predicate"
        | doc "contains information about the docker `config.json` to mount."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  path = _js2n__-prdslib.isType '"String",
                  secretName = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/DockerDeploy!predicate"
        | doc "uses the `docker` CLI to create application containers in Docker."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "images" ],
              _js2n__-prdslib.records.record
                {
                  images =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  useCompose = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/DockerSecret!predicate"
        | doc "used to pass in --secret to docker build, `useBuildKit: true` is required."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "id" ],
              _js2n__-prdslib.records.record
                {
                  env = _js2n__-prdslib.isType '"String",
                  id = _js2n__-prdslib.isType '"String",
                  src = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/DockerfileDependency!predicate"
        | doc "*beta* used to specify a custom build artifact that is built from a Dockerfile. This allows skaffold to determine dependencies from the Dockerfile."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  buildArgs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  path = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/EnvTemplateTagger!predicate"
        | doc "*beta* tags images with a configurable template string."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "template" ],
              _js2n__-prdslib.records.record
                { template = _js2n__-prdslib.isType '"String", } {} false
                _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/GitInfo!predicate"
        | doc "contains information on the origin of skaffold configurations cloned from a git repository."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "repo" ],
              _js2n__-prdslib.records.record
                {
                  path = _js2n__-prdslib.isType '"String",
                  ref = _js2n__-prdslib.isType '"String",
                  repo = _js2n__-prdslib.isType '"String",
                  sync = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/GitTagger!predicate"
        | doc "*beta* tags images with the git tag or commit of the artifact's workspace."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  ignoreChanges = _js2n__-prdslib.isType '"Bool",
                  prefix = _js2n__-prdslib.isType '"String",
                  variant =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "Tags",
                              "CommitSha",
                              "AbbrevCommitSha",
                              "TreeSha",
                              "AbbrevTreeSha"
                            ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/GoogleCloudBuild!predicate"
        | doc "*beta* describes how to do a remote build on [Google Cloud Build](https://cloud.google.com/cloud-build/docs/). Docker and Jib artifacts can be built on Cloud Build. The `projectId` needs to be provided and the currently logged in user should be given permissions to trigger new builds."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  concurrency = _js2n__-prdslib.isType 'Integer,
                  diskSizeGb = _js2n__-prdslib.isType 'Integer,
                  dockerImage = _js2n__-prdslib.isType '"String",
                  gradleImage = _js2n__-prdslib.isType '"String",
                  kanikoImage = _js2n__-prdslib.isType '"String",
                  koImage = _js2n__-prdslib.isType '"String",
                  logStreamingOption =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "STREAM_DEFAULT", "STREAM_ON", "STREAM_OFF" ]
                        ],
                  logging =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "LOGGING_UNSPECIFIED", "LEGACY", "GCS_ONLY" ]
                        ],
                  machineType = _js2n__-prdslib.isType '"String",
                  mavenImage = _js2n__-prdslib.isType '"String",
                  packImage = _js2n__-prdslib.isType '"String",
                  platformEmulatorInstallStep =
                    _js2n__-refsenv."_js2n__-:definitions/PlatformEmulatorInstallStep!predicate",
                  projectId = _js2n__-prdslib.isType '"String",
                  region = _js2n__-prdslib.isType '"String",
                  serviceAccount = _js2n__-prdslib.isType '"String",
                  timeout = _js2n__-prdslib.isType '"String",
                  workerPool = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Helm!predicate"
        | doc "defines the manifests from helm releases."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "releases" ],
              _js2n__-prdslib.records.record
                {
                  flags =
                    _js2n__-refsenv."_js2n__-:definitions/HelmDeployFlags!predicate",
                  releases =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/HelmRelease!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/HelmDeployFlags!predicate"
        | doc "additional option flags that are passed on the command line to `helm`."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  global =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  install =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  upgrade =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/HelmPackaged!predicate"
        | doc "parameters for packaging helm chart (`helm package`)."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  appVersion = _js2n__-prdslib.isType '"String",
                  version = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/HelmRelease!predicate"
        | doc "describes a helm release to be deployed."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                {
                  chartPath = _js2n__-prdslib.isType '"String",
                  createNamespace = _js2n__-prdslib.isType '"Bool",
                  name = _js2n__-prdslib.isType '"String",
                  namespace = _js2n__-prdslib.isType '"String",
                  overrides = _js2n__-prdslib.always,
                  packaged =
                    _js2n__-refsenv."_js2n__-:definitions/HelmPackaged!predicate",
                  recreatePods = _js2n__-prdslib.isType '"Bool",
                  remoteChart = _js2n__-prdslib.isType '"String",
                  repo = _js2n__-prdslib.isType '"String",
                  setFiles =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  setValueTemplates = _js2n__-prdslib.always,
                  setValues = _js2n__-prdslib.always,
                  skipBuildDependencies = _js2n__-prdslib.isType '"Bool",
                  upgradeOnChange = _js2n__-prdslib.isType '"Bool",
                  useHelmSecrets = _js2n__-prdslib.isType '"Bool",
                  valuesFiles =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  version = _js2n__-prdslib.isType '"String",
                  wait = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/HostHook!predicate"
        | doc "describes a lifecycle hook definition to execute on the host machine."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "command" ],
              _js2n__-prdslib.records.record
                {
                  command =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  dir = _js2n__-prdslib.isType '"String",
                  os =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/InputDigest!predicate"
        | doc "*beta* tags hashes the image content."
        = _js2n__-prdslib.isType 'Record,
      "_js2n__-:definitions/JSONParseConfig!predicate"
        | doc "defines the rules for parsing/outputting json logs."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  fields =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/JSONPatch!predicate"
        | doc "patch to be applied by a profile."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "path" ],
              _js2n__-prdslib.records.record
                {
                  from = _js2n__-prdslib.isType '"String",
                  op = _js2n__-prdslib.isType '"String",
                  path = _js2n__-prdslib.isType '"String",
                  value = _js2n__-prdslib.always,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/JibArtifact!predicate"
        | doc "builds images using the [Jib plugins for Maven and Gradle](https://github.com/GoogleContainerTools/jib/)."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  args =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  fromImage = _js2n__-prdslib.isType '"String",
                  project = _js2n__-prdslib.isType '"String",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "maven", "gradle" ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/KanikoArtifact!predicate"
        | doc "describes an artifact built from a Dockerfile, with kaniko."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  buildArgs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  cache =
                    _js2n__-refsenv."_js2n__-:definitions/KanikoCache!predicate",
                  cleanup = _js2n__-prdslib.isType '"Bool",
                  contextSubPath = _js2n__-prdslib.isType '"String",
                  digestFile = _js2n__-prdslib.isType '"String",
                  dockerfile = _js2n__-prdslib.isType '"String",
                  env =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf _js2n__-prdslib.always
                        ],
                  "force" = _js2n__-prdslib.isType '"Bool",
                  image = _js2n__-prdslib.isType '"String",
                  imageFSExtractRetry = _js2n__-prdslib.isType '"String",
                  imageNameWithDigestFile = _js2n__-prdslib.isType '"String",
                  initImage = _js2n__-prdslib.isType '"String",
                  insecure = _js2n__-prdslib.isType '"Bool",
                  insecurePull = _js2n__-prdslib.isType '"Bool",
                  insecureRegistry =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  label =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  logFormat = _js2n__-prdslib.isType '"String",
                  logTimestamp = _js2n__-prdslib.isType '"Bool",
                  noPush = _js2n__-prdslib.isType '"Bool",
                  ociLayoutPath = _js2n__-prdslib.isType '"String",
                  pushRetry = _js2n__-prdslib.isType '"String",
                  registryCertificate =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  registryMirror = _js2n__-prdslib.isType '"String",
                  reproducible = _js2n__-prdslib.isType '"Bool",
                  singleSnapshot = _js2n__-prdslib.isType '"Bool",
                  skipTLS = _js2n__-prdslib.isType '"Bool",
                  skipTLSVerifyPull = _js2n__-prdslib.isType '"Bool",
                  skipTLSVerifyRegistry =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  skipUnusedStages = _js2n__-prdslib.isType '"Bool",
                  snapshotMode = _js2n__-prdslib.isType '"String",
                  tarPath = _js2n__-prdslib.isType '"String",
                  target = _js2n__-prdslib.isType '"String",
                  useNewRun = _js2n__-prdslib.isType '"Bool",
                  verbosity = _js2n__-prdslib.isType '"String",
                  volumeMounts =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf _js2n__-prdslib.always
                        ],
                  whitelistVarRun = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/KanikoCache!predicate"
        | doc "configures Kaniko caching. If a cache is specified, Kaniko will use a remote cache which will speed up builds."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  cacheCopyLayers = _js2n__-prdslib.isType '"Bool",
                  hostPath = _js2n__-prdslib.isType '"String",
                  repo = _js2n__-prdslib.isType '"String",
                  ttl = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/KoArtifact!predicate"
        | doc "builds images using [ko](https://github.com/google/ko)."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  dependencies =
                    _js2n__-refsenv."_js2n__-:definitions/KoDependencies!predicate",
                  dir = _js2n__-prdslib.isType '"String",
                  env =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  flags =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  fromImage = _js2n__-prdslib.isType '"String",
                  labels =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  ldflags =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  main = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/KoDependencies!predicate"
        | doc "used to specify dependencies for an artifact built by ko."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  ignore =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  paths =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/KptDeploy!predicate"
        | doc "contains all the configuration needed by the deploy steps."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  applyFlags =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  defaultNamespace = _js2n__-prdslib.isType '"String",
                  dir = _js2n__-prdslib.isType '"String",
                  "false" = _js2n__-prdslib.isType '"Bool",
                  flags =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  inventoryID = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                  namespace = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/KubectlDeploy!predicate"
        | doc "*beta* uses a client side `kubectl apply` to deploy manifests. You'll need a `kubectl` CLI version installed that's compatible with your cluster."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  defaultNamespace = _js2n__-prdslib.isType '"String",
                  flags =
                    _js2n__-refsenv."_js2n__-:definitions/KubectlFlags!predicate",
                  hooks =
                    _js2n__-refsenv."_js2n__-:definitions/DeployHooks!predicate",
                  remoteManifests =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/KubectlFlags!predicate"
        | doc "additional flags passed on the command line to kubectl either on every command (Global), on creations (Apply) or deletions (Delete)."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  apply =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  delete =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  disableValidation = _js2n__-prdslib.isType '"Bool",
                  global =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Kustomize!predicate"
        | doc "defines the paths to be modified with kustomize, along with extra flags to be passed to kustomize."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  buildArgs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  paths =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/LegacyHelmDeploy!predicate"
        | doc "*beta* uses the `helm` CLI to apply the charts to the cluster."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  flags =
                    _js2n__-refsenv."_js2n__-:definitions/HelmDeployFlags!predicate",
                  hooks =
                    _js2n__-refsenv."_js2n__-:definitions/DeployHooks!predicate",
                  releases =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/HelmRelease!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/LocalBuild!predicate"
        | doc "*beta* describes how to do a build on the local docker daemon and optionally push to a repository."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  concurrency = _js2n__-prdslib.isType 'Integer,
                  push = _js2n__-prdslib.isType '"Bool",
                  tryImportMissing = _js2n__-prdslib.isType '"Bool",
                  useBuildkit = _js2n__-prdslib.isType '"Bool",
                  useDockerCLI = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/LogsConfig!predicate"
        | doc "configures how container logs are printed as a result of a deployment."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  jsonParse =
                    _js2n__-refsenv."_js2n__-:definitions/JSONParseConfig!predicate",
                  prefix =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "container", "podAndContainer", "auto", "none" ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Metadata!predicate"
        | doc "holds an optional name of the project."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  annotations =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  labels =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  name = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/NamedContainerHook!predicate"
        | doc "describes a lifecycle hook definition to execute on a named container."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "command", "podName" ],
              _js2n__-prdslib.records.record
                {
                  command =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  containerName = _js2n__-prdslib.isType '"String",
                  podName = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/PlatformEmulatorInstallStep!predicate"
        | doc "specifies a pre-build step to install the required tooling for QEMU emulation on the GoogleCloudBuild containers. This enables performing cross-platform builds on GoogleCloudBuild."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "image" ],
              _js2n__-prdslib.records.record
                {
                  args =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  entrypoint = _js2n__-prdslib.isType '"String",
                  image = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/PortForwardResource!predicate"
        | doc "describes a resource to port forward."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  address = _js2n__-prdslib.isType '"String",
                  localPort = _js2n__-prdslib.isType 'Integer,
                  namespace = _js2n__-prdslib.isType '"String",
                  port =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Integer
                        ],
                  resourceName = _js2n__-prdslib.isType '"String",
                  resourceType = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Profile!predicate"
        | doc "used to override any `build`, `test` or `deploy` configuration."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                {
                  activation =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Activation!predicate"
                        ],
                  build =
                    _js2n__-refsenv."_js2n__-:definitions/BuildConfig!predicate",
                  deploy =
                    _js2n__-refsenv."_js2n__-:definitions/DeployConfig!predicate",
                  manifests =
                    _js2n__-refsenv."_js2n__-:definitions/RenderConfig!predicate",
                  name = _js2n__-prdslib.isType '"String",
                  patches =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/JSONPatch!predicate"
                        ],
                  portForward =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/PortForwardResource!predicate"
                        ],
                  requiresAllActivations = _js2n__-prdslib.isType '"Bool",
                  resourceSelector =
                    _js2n__-refsenv."_js2n__-:definitions/ResourceSelectorConfig!predicate",
                  test =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/TestCase!predicate"
                        ],
                  verify =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/VerifyTestCase!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ProfileDependency!predicate"
        | doc "describes a mapping from referenced config profiles to the current config profiles. If the current config is activated with a profile in this mapping then the dependency configs are also activated with the corresponding mapped profiles."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                {
                  activatedBy =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  name = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/RenderConfig!predicate"
        | doc "contains all the configuration needed by the render steps."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  helm = _js2n__-refsenv."_js2n__-:definitions/Helm!predicate",
                  hooks =
                    _js2n__-refsenv."_js2n__-:definitions/RenderHooks!predicate",
                  kpt =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  kustomize =
                    _js2n__-refsenv."_js2n__-:definitions/Kustomize!predicate",
                  output = _js2n__-prdslib.isType '"String",
                  rawYaml =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  transform = _js2n__-prdslib.always,
                  validate = _js2n__-prdslib.always,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/RenderHookItem!predicate"
        | doc "describes a single lifecycle hook to execute before or after each deployer step."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  host =
                    _js2n__-refsenv."_js2n__-:definitions/HostHook!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/RenderHooks!predicate"
        | doc "describes the list of lifecycle hooks to execute before and after each render step."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  after =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/RenderHookItem!predicate"
                        ],
                  before =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/RenderHookItem!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ResourceFilter!predicate"
        | doc "contains definition to filter which resource to transform."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "groupKind" ],
              _js2n__-prdslib.records.record
                {
                  groupKind = _js2n__-prdslib.isType '"String",
                  image =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  labels =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  podSpec =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ResourceRequirement!predicate"
        | doc "stores the CPU/Memory requirements for the pod."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  cpu = _js2n__-prdslib.isType '"String",
                  ephemeralStorage = _js2n__-prdslib.isType '"String",
                  memory = _js2n__-prdslib.isType '"String",
                  resourceStorage = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ResourceRequirements!predicate"
        | doc "describes the resource requirements for the kaniko pod."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  limits =
                    _js2n__-refsenv."_js2n__-:definitions/ResourceRequirement!predicate",
                  requests =
                    _js2n__-refsenv."_js2n__-:definitions/ResourceRequirement!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ResourceSelectorConfig!predicate"
        | doc "contains all the configuration needed by the deploy steps."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  allow =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/ResourceFilter!predicate"
                        ],
                  deny =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/ResourceFilter!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ShaTagger!predicate"
        | doc "*beta* tags images with their sha256 digest."
        = _js2n__-prdslib.isType 'Record,
      "_js2n__-:definitions/SkaffoldConfig!predicate"
        | doc "holds the fields parsed from the Skaffold configuration file (skaffold.yaml)."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "apiVersion", "kind" ],
              _js2n__-prdslib.records.record
                {
                  apiVersion = _js2n__-prdslib.isType '"String",
                  build =
                    _js2n__-refsenv."_js2n__-:definitions/BuildConfig!predicate",
                  deploy =
                    _js2n__-refsenv."_js2n__-:definitions/DeployConfig!predicate",
                  kind = _js2n__-prdslib.isType '"String",
                  manifests =
                    _js2n__-refsenv."_js2n__-:definitions/RenderConfig!predicate",
                  metadata =
                    _js2n__-refsenv."_js2n__-:definitions/Metadata!predicate",
                  portForward =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/PortForwardResource!predicate"
                        ],
                  profiles =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Profile!predicate"
                        ],
                  requires =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/ConfigDependency!predicate"
                        ],
                  resourceSelector =
                    _js2n__-refsenv."_js2n__-:definitions/ResourceSelectorConfig!predicate",
                  test =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/TestCase!predicate"
                        ],
                  verify =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/VerifyTestCase!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Sync!predicate"
        | doc "*beta* specifies what files to sync into the container. This is a list of sync rules indicating the intent to sync for source files. If no files are listed, sync all the files and infer the destination."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  auto = _js2n__-prdslib.isType '"Bool",
                  hooks =
                    _js2n__-refsenv."_js2n__-:definitions/SyncHooks!predicate",
                  infer =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  manual =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/SyncRule!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/SyncHookItem!predicate"
        | doc "describes a single lifecycle hook to execute before or after each artifact sync step."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  container =
                    _js2n__-refsenv."_js2n__-:definitions/ContainerHook!predicate",
                  host =
                    _js2n__-refsenv."_js2n__-:definitions/HostHook!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/SyncHooks!predicate"
        | doc "describes the list of lifecycle hooks to execute before and after each artifact sync step."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  after =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/SyncHookItem!predicate"
                        ],
                  before =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/SyncHookItem!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/SyncRule!predicate"
        | doc "specifies which local files to sync to remote folders."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "dest", "src" ],
              _js2n__-prdslib.records.record
                {
                  dest = _js2n__-prdslib.isType '"String",
                  src = _js2n__-prdslib.isType '"String",
                  strip = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/TagPolicy!predicate"
        | doc "contains all the configuration for the tagging step."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  customTemplate =
                    _js2n__-refsenv."_js2n__-:definitions/CustomTemplateTagger!predicate",
                  dateTime =
                    _js2n__-refsenv."_js2n__-:definitions/DateTimeTagger!predicate",
                  envTemplate =
                    _js2n__-refsenv."_js2n__-:definitions/EnvTemplateTagger!predicate",
                  gitCommit =
                    _js2n__-refsenv."_js2n__-:definitions/GitTagger!predicate",
                  inputDigest =
                    _js2n__-refsenv."_js2n__-:definitions/InputDigest!predicate",
                  sha256 =
                    _js2n__-refsenv."_js2n__-:definitions/ShaTagger!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/TaggerComponent!predicate"
        | doc "*beta* a component of CustomTemplateTagger."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.records.record
                    { name = _js2n__-prdslib.isType '"String", } {} false
                    _js2n__-prdslib.never,
                  _js2n__-prdslib.records.record
                    {
                      gitCommit =
                        _js2n__-refsenv."_js2n__-:definitions/GitTagger!predicate",
                      name = _js2n__-prdslib.isType '"String",
                    } {} false _js2n__-prdslib.never,
                  _js2n__-prdslib.records.record
                    {
                      name = _js2n__-prdslib.isType '"String",
                      sha256 =
                        _js2n__-refsenv."_js2n__-:definitions/ShaTagger!predicate",
                    } {} false _js2n__-prdslib.never,
                  _js2n__-prdslib.records.record
                    {
                      envTemplate =
                        _js2n__-refsenv."_js2n__-:definitions/EnvTemplateTagger!predicate",
                      name = _js2n__-prdslib.isType '"String",
                    } {} false _js2n__-prdslib.never,
                  _js2n__-prdslib.records.record
                    {
                      dateTime =
                        _js2n__-refsenv."_js2n__-:definitions/DateTimeTagger!predicate",
                      name = _js2n__-prdslib.isType '"String",
                    } {} false _js2n__-prdslib.never,
                  _js2n__-prdslib.records.record
                    {
                      customTemplate =
                        _js2n__-refsenv."_js2n__-:definitions/CustomTemplateTagger!predicate",
                      name = _js2n__-prdslib.isType '"String",
                    } {} false _js2n__-prdslib.never,
                  _js2n__-prdslib.records.record
                    {
                      inputDigest =
                        _js2n__-refsenv."_js2n__-:definitions/InputDigest!predicate",
                      name = _js2n__-prdslib.isType '"String",
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:definitions/TestCase!predicate"
        | doc "a list of tests to run on images that Skaffold builds."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "image" ],
              _js2n__-prdslib.records.record
                {
                  context = _js2n__-prdslib.isType '"String",
                  custom =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/CustomTest!predicate"
                        ],
                  image = _js2n__-prdslib.isType '"String",
                  structureTests =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  structureTestsArgs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/VerifyTestCase!predicate"
        | doc "a list of tests to run on images that Skaffold builds."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                {
                  container = _js2n__-prdslib.always,
                  name = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
    }
    in
  _js2n__-prdslib.contract_from_predicate
      (_js2n__-prdslib.allOf
        [
          _js2n__-prdslib.isType 'Record,
          _js2n__-refsenv."_js2n__-:definitions/SkaffoldConfig!predicate"
        ])