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
      "_js2n__-:definitions/AmdConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  allowTopLevelThis = _js2n__-prdslib.isType '"Bool",
                  exportInteropAnnotation = _js2n__-prdslib.isType '"Bool",
                  ignoreDynamic = _js2n__-prdslib.isType '"Bool",
                  importInterop =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "babel", "node", "none", "swc" ]
                        ],
                  lazy =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                          _js2n__-prdslib.isType '"Bool"
                        ],
                  moduleId = _js2n__-prdslib.isType '"String",
                  noInterop = _js2n__-prdslib.isType '"Bool",
                  preserveImportMeta = _js2n__-prdslib.isType '"Bool",
                  strict = _js2n__-prdslib.isType '"Bool",
                  strictMode = _js2n__-prdslib.isType '"Bool",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "amd"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/Assumptions!contract" =
        {
            arrayLikeIsIterable
              | Bool
              | doc "https://babeljs.io/docs/en/assumptions#arraylikeisiterable"
              | optional,
            constantReexports
              | Bool
              | doc "https://babeljs.io/docs/en/assumptions#constantreexports"
              | optional,
            constantSuper
              | Bool
              | doc "https://babeljs.io/docs/en/assumptions#constantsuper"
              | optional,
            enumerableModuleMeta
              | Bool
              | doc "https://babeljs.io/docs/en/assumptions#enumerablemodulemeta"
              | optional,
            ignoreFunctionLength
              | Bool
              | doc "https://babeljs.io/docs/en/assumptions#ignorefunctionlength"
              | optional,
            ignoreFunctionName | Bool | optional,
            ignoreToPrimitiveHint
              | Bool
              | doc "https://babeljs.io/docs/en/assumptions#ignoretoprimitivehint"
              | optional,
            iterableIsArray
              | Bool
              | doc "https://babeljs.io/docs/en/assumptions#iterableisarray"
              | optional,
            mutableTemplateObject
              | Bool
              | doc "https://babeljs.io/docs/en/assumptions#mutabletemplateobject"
              | optional,
            noClassCalls
              | Bool
              | doc "https://babeljs.io/docs/en/assumptions#noclasscalls"
              | optional,
            noDocumentAll
              | Bool
              | doc "https://babeljs.io/docs/en/assumptions#nodocumentall"
              | optional,
            noIncompleteNsImportDetection
              | Bool
              | doc "https://babeljs.io/docs/en/assumptions#noincompletensimportdetection"
              | optional,
            noNewArrows
              | Bool
              | doc "https://babeljs.io/docs/en/assumptions#nonewarrows"
              | optional,
            objectRestNoSymbols
              | Bool
              | doc "https://babeljs.io/docs/en/assumptions#objectrestnosymbols"
              | optional,
            privateFieldsAsProperties
              | Bool
              | doc "https://babeljs.io/docs/en/assumptions#privatefieldsasproperties"
              | optional,
            pureGetters
              | Bool
              | doc "https://babeljs.io/docs/en/assumptions#puregetters"
              | optional,
            setClassMethods
              | Bool
              | doc "https://babeljs.io/docs/en/assumptions#setclassmethods"
              | optional,
            setComputedProperties
              | Bool
              | doc "https://babeljs.io/docs/en/assumptions#setcomputedproperties"
              | optional,
            setPublicClassFields
              | Bool
              | doc "https://babeljs.io/docs/en/assumptions#setpublicclassfields"
              | optional,
            setSpreadProperties
              | Bool
              | doc "https://babeljs.io/docs/en/assumptions#setspreadproperties"
              | optional,
            skipForOfIteratorClosing
              | Bool
              | doc "https://babeljs.io/docs/en/assumptions#skipforofiteratorclosing"
              | optional,
            superIsCallableConstructor
              | Bool
              | doc "https://babeljs.io/docs/en/assumptions#superiscallableconstructor"
              | optional,
            tsEnumIsReadonly | Bool | optional,
            ..
          },
      "_js2n__-:definitions/CallerOptions!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType 'Record,
                _js2n__-prdslib.records.record
                  { name = _js2n__-prdslib.isType '"String", } {} true
                  _js2n__-prdslib.always
              ]),
      "_js2n__-:definitions/CommonJsConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  allowTopLevelThis = _js2n__-prdslib.isType '"Bool",
                  exportInteropAnnotation = _js2n__-prdslib.isType '"Bool",
                  ignoreDynamic = _js2n__-prdslib.isType '"Bool",
                  importInterop =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "babel", "node", "none", "swc" ]
                        ],
                  lazy =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                          _js2n__-prdslib.isType '"Bool"
                        ],
                  noInterop = _js2n__-prdslib.isType '"Bool",
                  preserveImportMeta = _js2n__-prdslib.isType '"Bool",
                  strict = _js2n__-prdslib.isType '"Bool",
                  strictMode = _js2n__-prdslib.isType '"Bool",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "commonjs"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/ConstModulesConfig!contract"
        | doc m%"
          - `import { DEBUG } from '@ember/env-flags';`
          - `import { FEATURE_A, FEATURE_B } from '@ember/features';`
          
          See: https://github.com/swc-project/swc/issues/18#issuecomment-466272558
        "%
        = {
            globals
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record {} {} true
                      (_js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ])
                  ])
              | optional,
            ..
          },
      "_js2n__-:definitions/EnvConfig!contract"
        | doc "Configuration ported from babel-preset-env"
        = {
            bugfixes
              | Bool
              | doc m%"
                Transpiles the broken syntax to the closest non-broken modern syntax
                
                Defaults to false.
              "%
              | optional,
            coreJs | String | doc "The version of the used core js." | optional,
            debug | Bool | optional,
            dynamicImport | Bool | optional,
            exclude | Array (String) | optional,
            forceAllTransforms | Bool | doc "Enable all transforms" | optional,
            include | Array (String) | optional,
            loose | Bool | optional,
            mode | std.enum.TagOrString | [| 'usage, 'entry |] | optional,
            path | String | optional,
            shippedProposals | Bool | optional,
            skip | Array (String) | optional,
            targets
              | _js2n__-prdslib.contract_from_predicate _js2n__-prdslib.always
              | optional,
            ..
          },
      "_js2n__-:definitions/Es6Config!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  allowTopLevelThis = _js2n__-prdslib.isType '"Bool",
                  exportInteropAnnotation = _js2n__-prdslib.isType '"Bool",
                  ignoreDynamic = _js2n__-prdslib.isType '"Bool",
                  importInterop =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "babel", "node", "none", "swc" ]
                        ],
                  lazy =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                          _js2n__-prdslib.isType '"Bool"
                        ],
                  noInterop = _js2n__-prdslib.isType '"Bool",
                  preserveImportMeta = _js2n__-prdslib.isType '"Bool",
                  strict = _js2n__-prdslib.isType '"Bool",
                  strictMode = _js2n__-prdslib.isType '"Bool",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "es6"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/EsParserConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  allowReturnOutsideFunction = _js2n__-prdslib.isType '"Bool",
                  allowSuperOutsideMethod = _js2n__-prdslib.isType '"Bool",
                  autoAccessors = _js2n__-prdslib.isType '"Bool",
                  classPrivateProperty = _js2n__-prdslib.isType '"Bool",
                  classProperty = _js2n__-prdslib.isType '"Bool",
                  decorators = _js2n__-prdslib.isType '"Bool",
                  decoratorsBeforeExport = _js2n__-prdslib.isType '"Bool",
                  dynamicImport = _js2n__-prdslib.isType '"Bool",
                  explicitResourceManagement = _js2n__-prdslib.isType '"Bool",
                  exportDefaultFrom = _js2n__-prdslib.isType '"Bool",
                  exportNamespaceFrom = _js2n__-prdslib.isType '"Bool",
                  functionBind = _js2n__-prdslib.isType '"Bool",
                  importAssertions = _js2n__-prdslib.isType '"Bool",
                  importAttributes = _js2n__-prdslib.isType '"Bool",
                  importMeta = _js2n__-prdslib.isType '"Bool",
                  jsx = _js2n__-prdslib.isType '"Bool",
                  nullishCoalescing = _js2n__-prdslib.isType '"Bool",
                  numericSeparator = _js2n__-prdslib.isType '"Bool",
                  optionalChaining = _js2n__-prdslib.isType '"Bool",
                  privateMethod = _js2n__-prdslib.isType '"Bool",
                  syntax =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "ecmascript"
                        ],
                  topLevelAwait = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/GlobalPassOption!contract"
        | doc "Options for inline-global pass."
        = {
            envs
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"Array",
                        _js2n__-prdslib.arrays.arrayOf
                          (_js2n__-prdslib.isType '"String")
                      ],
                    _js2n__-prdslib.always
                  ])
              | doc m%"
                Names of environment variables that should be inlined with the value of corresponding env during build.
                
                Defaults to `["NODE_ENV", "SWC_ENV"]`
              "%
              | optional,
            typeofs
              | Dyn
              | doc m%"
                Replaces typeof calls for passed variables with corresponding value
                
                e.g. `{ window: 'object' }`
              "%
              | optional,
            vars
              | Dyn
              | doc m%"
                Global variables that should be inlined with passed value.
                
                e.g. `{ __DEBUG__: true }`
              "%
              | optional,
            ..
          },
      "_js2n__-:definitions/JsFormatOptions!predicate"
        | doc m%"
          These properties are mostly not implemented yet,
          but it exists to support passing terser config to swc minify
          without modification.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  asciiOnly = _js2n__-prdslib.isType '"Bool",
                  beautify = _js2n__-prdslib.isType '"Bool",
                  braces = _js2n__-prdslib.isType '"Bool",
                  comments = _js2n__-prdslib.enum [ "all", false, "some" ],
                  ecma =
                    _js2n__-refsenv."_js2n__-:definitions/TerserEcmaVersion!predicate",
                  indentLevel = _js2n__-prdslib.isType '"Number",
                  indentStart = _js2n__-prdslib.isType '"Number",
                  inlineScript = _js2n__-prdslib.isType '"Bool",
                  keepNumbers = _js2n__-prdslib.isType '"Number",
                  keepQuotedProps = _js2n__-prdslib.isType '"Bool",
                  maxLineLen =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.const false
                            ],
                          _js2n__-prdslib.isType '"Number"
                        ],
                  preamble = _js2n__-prdslib.isType '"String",
                  preserveAnnotations = _js2n__-prdslib.isType '"Bool",
                  quoteKeys = _js2n__-prdslib.isType '"Bool",
                  quoteStyle = _js2n__-prdslib.isType '"Bool",
                  safari10 = _js2n__-prdslib.isType '"Bool",
                  semicolons = _js2n__-prdslib.isType '"Bool",
                  shebang = _js2n__-prdslib.isType '"Bool",
                  webkit = _js2n__-prdslib.isType '"Bool",
                  wrapFuncArgs = _js2n__-prdslib.isType '"Bool",
                  wrapIife = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/JsMinifyOptions!contract" =
        {
            compress
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/TerserCompressOptions!predicate",
                    _js2n__-prdslib.isType '"Bool"
                  ])
              | optional,
            ecma
              | _js2n__-refsenv."_js2n__-:definitions/TerserEcmaVersion!contract"
              | optional,
            format
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/JsFormatOptions!predicate",
                    _js2n__-prdslib.always
                  ])
              | optional,
            inlineSourcesContent | Bool | optional,
            keep_classnames | Bool | optional,
            keep_fnames | Bool | optional,
            mangle
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/TerserMangleOptions!predicate",
                    _js2n__-prdslib.isType '"Bool"
                  ])
              | optional,
            module
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.enum [ false, true, "unknown" ])
              | optional,
            outputPath | String | optional,
            safari10 | Bool | optional,
            sourceMap | Bool | optional,
            toplevel | Bool | optional,
            ..
          },
      "_js2n__-:definitions/JscConfig!contract" =
        {
            assumptions
              | _js2n__-refsenv."_js2n__-:definitions/Assumptions!contract"
              | optional,
            baseUrl | String | optional,
            experimental
              | {
                cacheRoot
                  | String
                  | doc m%"
                    Specify the location where SWC stores its intermediate cache files.
                    Currently only transform plugin uses this. If not specified, SWC will
                    create `.swc` directories.
                  "%
                  | optional,
                disableAllLints
                  | Bool
                  | doc "Disable all lint rules."
                  | optional,
                disableBuiltinTransformsForInternalTesting
                  | Bool
                  | doc "Disable builtin transforms. If enabled, only Wasm plugins are used."
                  | optional,
                emitAssertForImportAttributes
                  | Bool
                  | doc m%"
                    Use `assert` instead of `with` for imports and exports.
                    This option only works when `keepImportAttributes` is `true`.
                  "%
                  | optional,
                emitIsolatedDts
                  | Bool
                  | doc "Emit isolated dts files for each module."
                  | optional,
                keepImportAssertions
                  | Bool
                  | doc "Keep import assertions."
                  | optional,
                keepImportAttributes
                  | Bool
                  | doc "Preserve `with` in imports and exports."
                  | optional,
                optimizeHygiene | Bool | optional,
                plugins
                  | Array (
                    _js2n__-prdslib.contract_from_predicate
                      (_js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.items
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.always
                            ],
                          _js2n__-prdslib.arrays.maxItems 2,
                          _js2n__-prdslib.arrays.minItems 2
                        ])
                  )
                  | doc m%"
                    List of custom transform plugins written in WebAssembly.
                    First parameter of tuple indicates the name of the plugin - it can be either
                    a name of the npm package can be resolved, or absolute path to .wasm binary.
                    
                    Second parameter of tuple is JSON based configuration for the plugin.
                  "%
                  | optional,
                runPluginFirst
                  | Bool
                  | doc m%"
                    Run Wasm plugins before stripping TypeScript or decorators.
                    
                    See https://github.com/swc-project/swc/issues/9132 for more details.
                  "%
                  | optional,
                ..
              }
              | doc "This is experimental, and can be removed without a major version bump."
              | optional,
            externalHelpers
              | Bool
              | doc "Use `@swc/helpers` instead of inline helpers."
              | optional,
            keepClassNames | Bool | doc "Keep class names." | optional,
            loose | Bool | optional,
            minify
              | _js2n__-refsenv."_js2n__-:definitions/JsMinifyOptions!contract"
              | optional,
            parser
              | _js2n__-refsenv."_js2n__-:definitions/ParserConfig!contract"
              | doc "Defaults to EsParserConfig"
              | optional,
            paths
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record {} {} true
                      (_js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ])
                  ])
              | optional,
            preserveAllComments | Bool | optional,
            target
              | _js2n__-refsenv."_js2n__-:definitions/JscTarget!contract"
              | doc "Defaults to `es3` (which enabled **all** pass)."
              | optional,
            transform
              | _js2n__-refsenv."_js2n__-:definitions/TransformConfig!contract"
              | optional,
            ..
          },
      "_js2n__-:definitions/JscTarget!contract" =
        std.contract.Sequence
            [
              std.enum.TagOrString,
              [|
                'esnext,
                'es5,
                'es3,
                'es2024,
                'es2023,
                'es2022,
                'es2021,
                'es2020,
                'es2019,
                'es2018,
                'es2017,
                'es2016,
                'es2015
              |]
            ],
      "_js2n__-:definitions/MatchPattern!predicate" =
        _js2n__-prdslib.isType 'Record,
      "_js2n__-:definitions/ModuleConfig!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.anyOf
              [
                _js2n__-refsenv."_js2n__-:definitions/Es6Config!predicate",
                _js2n__-refsenv."_js2n__-:definitions/CommonJsConfig!predicate",
                _js2n__-refsenv."_js2n__-:definitions/UmdConfig!predicate",
                _js2n__-refsenv."_js2n__-:definitions/AmdConfig!predicate",
                _js2n__-refsenv."_js2n__-:definitions/NodeNextConfig!predicate",
                _js2n__-refsenv."_js2n__-:definitions/SystemjsConfig!predicate"
              ]),
      "_js2n__-:definitions/NodeNextConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  allowTopLevelThis = _js2n__-prdslib.isType '"Bool",
                  exportInteropAnnotation = _js2n__-prdslib.isType '"Bool",
                  ignoreDynamic = _js2n__-prdslib.isType '"Bool",
                  importInterop =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "babel", "node", "none", "swc" ]
                        ],
                  lazy =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                          _js2n__-prdslib.isType '"Bool"
                        ],
                  noInterop = _js2n__-prdslib.isType '"Bool",
                  preserveImportMeta = _js2n__-prdslib.isType '"Bool",
                  strict = _js2n__-prdslib.isType '"Bool",
                  strictMode = _js2n__-prdslib.isType '"Bool",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "nodenext"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/OptimizerConfig!contract" =
        {
            globals
              | _js2n__-refsenv."_js2n__-:definitions/GlobalPassOption!contract"
              | optional,
            jsonify | { minCost | Number | optional, .. } | optional,
            simplify | Bool | optional,
            ..
          },
      "_js2n__-:definitions/ParserConfig!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.anyOf
              [
                _js2n__-refsenv."_js2n__-:definitions/TsParserConfig!predicate",
                _js2n__-refsenv."_js2n__-:definitions/EsParserConfig!predicate"
              ]),
      "_js2n__-:definitions/Plugin!contract" = {  .. },
      "_js2n__-:definitions/ReactConfig!contract" =
        {
            development
              | Bool
              | doc "Toggles plugins that aid in development, such as"
              | optional,
            importSource
              | String
              | doc "Declares the module specifier to be used for importing the `jsx` and `jsxs` factory functions when using `runtime` 'automatic'"
              | optional,
            pragma
              | String
              | doc m%"
                Replace the function used when compiling JSX expressions.
                
                Defaults to `React.createElement`.
              "%
              | optional,
            pragmaFrag
              | String
              | doc m%"
                Replace the component used when compiling JSX fragments.
                
                Defaults to `React.Fragment`
              "%
              | optional,
            refresh
              | Bool
              | doc "Enable fast refresh feature for React app"
              | optional,
            runtime
              | std.enum.TagOrString
              | [| 'classic, 'automatic |]
              | doc "jsx runtime"
              | optional,
            throwIfNamespace
              | Bool
              | doc m%"
                Toggles whether or not to throw an error if a XML namespaced tag name is used. For example:
                `<f:image />`
                
                Though the JSX spec allows this, it is disabled by default since React's
                JSX does not currently have support for it.
              "%
              | optional,
            useBuiltins
              | Bool
              | doc "Use `Object.assign()` instead of `_extends`. Defaults to false."
              | optional,
            ..
          },
      "_js2n__-:definitions/SystemjsConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  allowTopLevelThis = _js2n__-prdslib.isType '"Bool",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "systemjs"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/TerserCompressOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  arguments = _js2n__-prdslib.isType '"Bool",
                  arrows = _js2n__-prdslib.isType '"Bool",
                  booleans = _js2n__-prdslib.isType '"Bool",
                  booleans_as_integers = _js2n__-prdslib.isType '"Bool",
                  collapse_vars = _js2n__-prdslib.isType '"Bool",
                  comparisons = _js2n__-prdslib.isType '"Bool",
                  computed_props = _js2n__-prdslib.isType '"Bool",
                  conditionals = _js2n__-prdslib.isType '"Bool",
                  const_to_let = _js2n__-prdslib.isType '"Bool",
                  dead_code = _js2n__-prdslib.isType '"Bool",
                  defaults = _js2n__-prdslib.isType '"Bool",
                  directives = _js2n__-prdslib.isType '"Bool",
                  drop_console = _js2n__-prdslib.isType '"Bool",
                  drop_debugger = _js2n__-prdslib.isType '"Bool",
                  ecma =
                    _js2n__-refsenv."_js2n__-:definitions/TerserEcmaVersion!predicate",
                  evaluate = _js2n__-prdslib.isType '"Bool",
                  expression = _js2n__-prdslib.isType '"Bool",
                  global_defs = _js2n__-prdslib.always,
                  hoist_funs = _js2n__-prdslib.isType '"Bool",
                  hoist_props = _js2n__-prdslib.isType '"Bool",
                  hoist_vars = _js2n__-prdslib.isType '"Bool",
                  ie8 = _js2n__-prdslib.isType '"Bool",
                  if_return = _js2n__-prdslib.isType '"Bool",
                  inline =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.enum [ 0, 1, 2, 3 ]
                        ],
                  join_vars = _js2n__-prdslib.isType '"Bool",
                  keep_classnames = _js2n__-prdslib.isType '"Bool",
                  keep_fargs = _js2n__-prdslib.isType '"Bool",
                  keep_fnames = _js2n__-prdslib.isType '"Bool",
                  keep_infinity = _js2n__-prdslib.isType '"Bool",
                  loops = _js2n__-prdslib.isType '"Bool",
                  module = _js2n__-prdslib.isType '"Bool",
                  negate_iife = _js2n__-prdslib.isType '"Bool",
                  passes = _js2n__-prdslib.isType '"Number",
                  properties = _js2n__-prdslib.isType '"Bool",
                  pure_funcs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  pure_getters = _js2n__-prdslib.always,
                  reduce_funcs = _js2n__-prdslib.isType '"Bool",
                  reduce_vars = _js2n__-prdslib.isType '"Bool",
                  sequences = _js2n__-prdslib.always,
                  side_effects = _js2n__-prdslib.isType '"Bool",
                  switches = _js2n__-prdslib.isType '"Bool",
                  top_retain = _js2n__-prdslib.always,
                  toplevel = _js2n__-prdslib.always,
                  typeofs = _js2n__-prdslib.isType '"Bool",
                  unsafe = _js2n__-prdslib.isType '"Bool",
                  unsafe_arrows = _js2n__-prdslib.isType '"Bool",
                  unsafe_comps = _js2n__-prdslib.isType '"Bool",
                  unsafe_function = _js2n__-prdslib.isType '"Bool",
                  unsafe_math = _js2n__-prdslib.isType '"Bool",
                  unsafe_methods = _js2n__-prdslib.isType '"Bool",
                  unsafe_passes = _js2n__-prdslib.isType '"Bool",
                  unsafe_proto = _js2n__-prdslib.isType '"Bool",
                  unsafe_regexp = _js2n__-prdslib.isType '"Bool",
                  unsafe_symbols = _js2n__-prdslib.isType '"Bool",
                  unsafe_undefined = _js2n__-prdslib.isType '"Bool",
                  unused = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/TerserEcmaVersion!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.anyOf
              [
                _js2n__-prdslib.isType '"String",
                _js2n__-prdslib.isType '"Number"
              ]),
      "_js2n__-:definitions/TerserEcmaVersion!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.isType '"Number"
            ],
      "_js2n__-:definitions/TerserMangleOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  ie8 = _js2n__-prdslib.isType '"Bool",
                  keepClassNames = _js2n__-prdslib.isType '"Bool",
                  keepFnNames = _js2n__-prdslib.isType '"Bool",
                  keepPrivateProps = _js2n__-prdslib.isType '"Bool",
                  keep_classnames = _js2n__-prdslib.isType '"Bool",
                  keep_fnames = _js2n__-prdslib.isType '"Bool",
                  keep_private_props = _js2n__-prdslib.isType '"Bool",
                  props =
                    _js2n__-refsenv."_js2n__-:definitions/TerserManglePropertiesOptions!predicate",
                  reserved =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  safari10 = _js2n__-prdslib.isType '"Bool",
                  topLevel = _js2n__-prdslib.isType '"Bool",
                  toplevel = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/TerserManglePropertiesOptions!predicate" =
        _js2n__-prdslib.isType 'Record,
      "_js2n__-:definitions/TransformConfig!contract"
        | doc "Options for transform."
        = {
            constModules
              | _js2n__-refsenv."_js2n__-:definitions/ConstModulesConfig!contract"
              | optional,
            decoratorMetadata
              | Bool
              | doc "https://swc.rs/docs/configuring-swc.html#jsctransformdecoratormetadata"
              | optional,
            decoratorVersion
              | std.enum.TagOrString
              | [| '"2022-03", '"2021-12" |]
              | doc "https://swc.rs/docs/configuration/compilation#jsctransformdecoratorversion"
              | optional,
            legacyDecorator
              | Bool
              | doc "https://swc.rs/docs/configuring-swc.html#jsctransformlegacydecorator"
              | optional,
            optimizer
              | _js2n__-refsenv."_js2n__-:definitions/OptimizerConfig!contract"
              | doc "Defaults to null, which skips optimizer pass."
              | optional,
            react
              | _js2n__-refsenv."_js2n__-:definitions/ReactConfig!contract"
              | doc "Effective only if `syntax` supports ƒ."
              | optional,
            treatConstEnumAsEnum | Bool | optional,
            useDefineForClassFields | Bool | optional,
            ..
          },
      "_js2n__-:definitions/TsParserConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  decorators = _js2n__-prdslib.isType '"Bool",
                  dynamicImport = _js2n__-prdslib.isType '"Bool",
                  syntax =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "typescript"
                        ],
                  tsx = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/UmdConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  allowTopLevelThis = _js2n__-prdslib.isType '"Bool",
                  exportInteropAnnotation = _js2n__-prdslib.isType '"Bool",
                  globals =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  ignoreDynamic = _js2n__-prdslib.isType '"Bool",
                  importInterop =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "babel", "node", "none", "swc" ]
                        ],
                  lazy =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                          _js2n__-prdslib.isType '"Bool"
                        ],
                  noInterop = _js2n__-prdslib.isType '"Bool",
                  preserveImportMeta = _js2n__-prdslib.isType '"Bool",
                  strict = _js2n__-prdslib.isType '"Bool",
                  strictMode = _js2n__-prdslib.isType '"Bool",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "umd"
                        ],
                } {} true _js2n__-prdslib.always
            ],
    }
    in
  {
      caller
        | _js2n__-refsenv."_js2n__-:definitions/CallerOptions!contract"
        | optional,
      configFile
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.isType '"Bool"
            ])
        | doc m%"
          Defaults to searching for a default `.swcrc` file, but can
          be passed the path of any JS or JSON5 config file.
          
          
          NOTE: This option does not affect loading of .swcrc files,
          so while it may be tempting to do configFile: "./foo/.swcrc",
          it is not recommended. If the given .swcrc is loaded via the
          standard file-relative logic, you'll end up loading the same
          config file twice, merging it with itself. If you are linking
          a specific config file, it is recommended to stick with a
          naming scheme that is independent of the "swcrc" name.
          
          Defaults to `path.resolve(opts.root, ".swcrc")`
        "%
        | optional,
      cwd
        | String
        | doc m%"
          The working directory that all paths in the programmatic
          options will be resolved relative to.
          
          Defaults to `process.cwd()`.
        "%
        | optional,
      env
        | _js2n__-refsenv."_js2n__-:definitions/EnvConfig!contract"
        | optional,
      envName
        | String
        | doc m%"
          The current active environment used during configuration loading.
          This value is used as the key when resolving "env" configs,
          and is also available inside configuration functions, plugins,
          and presets, via the api.env() function.
          
          Defaults to `process.env.SWC_ENV || process.env.NODE_ENV || "development"`
        "%
        | optional,
      exclude
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.isType '"String")
                ],
              _js2n__-prdslib.isType '"String"
            ])
        | doc "Note: The type is string because it follows rust's regex syntax."
        | optional,
      filename
        | String
        | doc m%"
          The filename associated with the code currently being compiled,
          if there is one. The filename is optional, but not all of Swc's
          functionality is available when the filename is unknown, because a
          subset of options rely on the filename for their functionality.
          
          The three primary cases users could run into are:
          
          - The filename is exposed to plugins. Some plugins may require the
          presence of the filename.
          - Options like "test", "exclude", and "ignore" require the filename
          for string/RegExp matching.
          - .swcrc files are loaded relative to the file being compiled.
          If this option is omitted, Swc will behave as if swcrc: false has been set.
        "%
        | optional,
      inlineSourcesContent | Bool | optional,
      inputSourceMap
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.isType '"Bool"
            ])
        | doc m%"
          `true` will attempt to load an input sourcemap from the file itself, if it
          contains a //# sourceMappingURL=... comment. If no map is found, or the
          map fails to load and parse, it will be silently discarded.
          
           If an object is provided, it will be treated as the source map object itself.
          
          Defaults to `true`.
        "%
        | optional,
      isModule
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.enum [ false, true, "unknown" ])
        | optional,
      jsc
        | _js2n__-refsenv."_js2n__-:definitions/JscConfig!contract"
        | optional,
      minify | Bool | optional,
      module
        | _js2n__-refsenv."_js2n__-:definitions/ModuleConfig!contract"
        | optional,
      outputPath
        | String
        | doc m%"
          Destination path. Note that this value is used only to fix source path
          of source map files and swc does not write output to this path.
        "%
        | optional,
      plugin
        | _js2n__-refsenv."_js2n__-:definitions/Plugin!contract"
        | optional,
      root
        | String
        | doc m%"
          The initial path that will be processed based on the "rootMode" to
          determine the conceptual root folder for the current Swc project.
          This is used in two primary cases:
          
          - The base directory when checking for the default "configFile" value
          - The default value for "swcrcRoots".
          
          Defaults to `opts.cwd`
        "%
        | optional,
      rootMode
        | std.enum.TagOrString
        | [| 'upward-optional, 'upward, 'root |]
        | doc m%"
          This option, combined with the "root" value, defines how Swc chooses
          its project root. The different modes define different ways that Swc
          can process the "root" value to get the final project root.
          
          "root" - Passes the "root" value through as unchanged.
          "upward" - Walks upward from the "root" directory, looking for a directory
          containing a swc.config.js file, and throws an error if a swc.config.js
          is not found.
          "upward-optional" - Walk upward from the "root" directory, looking for
          a directory containing a swc.config.js file, and falls back to "root"
           if a swc.config.js is not found.
          
          
          "root" is the default mode because it avoids the risk that Swc
          will accidentally load a swc.config.js that is entirely outside
          of the current project folder. If you use "upward-optional",
          be aware that it will walk up the directory structure all the
          way to the filesystem root, and it is always possible that someone
          will have a forgotten swc.config.js in their home directory,
          which could cause unexpected errors in your builds.
          
          
          Users with monorepo project structures that run builds/tests on a
          per-package basis may well want to use "upward" since monorepos
          often have a swc.config.js in the project root. Running Swc
          in a monorepo subdirectory without "upward", will cause Swc
          to skip loading any swc.config.js files in the project root,
          which can lead to unexpected errors and compilation failure.
        "%
        | optional,
      script
        | Bool
        | doc "If true, a file is parsed as a script instead of module."
        | optional,
      sourceFileName
        | String
        | doc m%"
          The name to use for the file inside the source map object.
          
          Defaults to `path.basename(opts.filenameRelative)` when available, or `"unknown"`.
        "%
        | optional,
      sourceMaps
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.enum [ false, "inline", true ])
        | doc m%"
          - true to generate a sourcemap for the code and include it in the result object.
          - "inline" to generate a sourcemap and append it as a data URL to the end of the code, but not include it in the result object.
          
          `swc-cli` overloads some of these to also affect how maps are written to disk:
          
          - true will write the map to a .map file on disk
          - "inline" will write the file directly, so it will have a data: containing the map
          - Note: These options are bit weird, so it may make the most sense to just use true
           and handle the rest in your own code, depending on your use case.
        "%
        | optional,
      sourceRoot
        | String
        | doc "The sourceRoot fields to set in the generated source map, if one is desired."
        | optional,
      swcrc
        | Bool
        | doc m%"
          true will enable searching for configuration files relative to the "filename" provided to Swc.
          
          A swcrc value passed in the programmatic options will override one set within a configuration file.
          
          Note: .swcrc files are only loaded if the current "filename" is inside of
           a package that matches one of the "swcrcRoots" packages.
          
          
          Defaults to true as long as the filename option has been specified
        "%
        | optional,
      swcrcRoots
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/MatchPattern!predicate",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    _js2n__-refsenv."_js2n__-:definitions/MatchPattern!predicate"
                ],
              _js2n__-prdslib.isType '"Bool"
            ])
        | doc m%"
          By default, Babel will only search for .babelrc files within the "root" package
           because otherwise Babel cannot know if a given .babelrc is meant to be loaded,
           or if it's "plugins" and "presets" have even been installed, since the file
           being compiled could be inside node_modules, or have been symlinked into the project.
          
          
          This option allows users to provide a list of other packages that should be
          considered "root" packages when considering whether to load .babelrc files.
          
          
          For example, a monorepo setup that wishes to allow individual packages
          to have their own configs might want to do
          
          
          
          Defaults to `opts.root`
        "%
        | optional,
      test
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.isType '"String")
                ],
              _js2n__-prdslib.isType '"String"
            ])
        | doc "Note: The type is string because it follows rust's regex syntax."
        | optional,
      ..
    }