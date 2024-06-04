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
      "_js2n__-:definitions/datatype!predicate"
        | doc "Indicates limitations on the valid values a symbol may be assigned. When specified, the symbol value is attempted to be converted to this type. The datatype \"choice\" is supported only for parameter symbols and requires providing symbols.choices configuration for the symbol."
        = _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.enum
                [ "choice", "bool", "float", "int", "hex", "text" ],
              _js2n__-prdslib.strings.pattern "^(integer|string)$"
            ],
      "_js2n__-:definitions/generatorCasing!predicate" =
        _js2n__-prdslib.records.record
            {
              generator = _js2n__-prdslib.enum [ "casing" ],
              parameters =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "source" ],
                      _js2n__-prdslib.records.record
                        {
                          source = _js2n__-prdslib.isType '"String",
                          toLower = _js2n__-prdslib.isType '"Bool",
                        } {} true _js2n__-prdslib.always
                    ],
            } {} true _js2n__-prdslib.always,
      "_js2n__-:definitions/generatorCoalesce!predicate" =
        _js2n__-prdslib.records.record
            {
              generator = _js2n__-prdslib.enum [ "coalesce" ],
              parameters =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required
                        [ "fallbackVariableName", "sourceVariableName" ],
                      _js2n__-prdslib.records.record
                        {
                          defaultValue = _js2n__-prdslib.isType '"String",
                          fallbackVariableName =
                            _js2n__-prdslib.isType '"String",
                          sourceVariableName = _js2n__-prdslib.isType '"String",
                        } {} true _js2n__-prdslib.always
                    ],
            } {} true _js2n__-prdslib.always,
      "_js2n__-:definitions/generatorConstant!predicate" =
        _js2n__-prdslib.records.record
            {
              generator = _js2n__-prdslib.enum [ "constant" ],
              parameters =
                _js2n__-prdslib.records.record
                    { value = _js2n__-prdslib.isType '"String", } {} true
                    _js2n__-prdslib.always,
            } {} true _js2n__-prdslib.always,
      "_js2n__-:definitions/generatorGuid!predicate" =
        _js2n__-prdslib.records.record
            {
              generator = _js2n__-prdslib.enum [ "guid" ],
              parameters =
                _js2n__-prdslib.records.record
                    {
                      defaultFormat = _js2n__-prdslib.isType '"String",
                      format = _js2n__-prdslib.isType '"String",
                    } {} true _js2n__-prdslib.always,
            } {} true _js2n__-prdslib.always,
      "_js2n__-:definitions/generatorJoin!predicate" =
        _js2n__-prdslib.records.record
            {
              generator = _js2n__-prdslib.enum [ "join" ],
              parameters =
                _js2n__-prdslib.records.record
                    {
                      removeEmptyValues = _js2n__-prdslib.isType '"Bool",
                      separator = _js2n__-prdslib.isType '"String",
                      symbols =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.required
                                      [ "value" ],
                                    _js2n__-prdslib.records.record
                                      {
                                        type =
                                          _js2n__-prdslib.enum
                                              [ "ref", "const" ],
                                        value =
                                          _js2n__-prdslib.isType '"String",
                                      } {} true _js2n__-prdslib.always
                                  ])
                            ],
                    } {} true _js2n__-prdslib.always,
            } {} true _js2n__-prdslib.always,
      "_js2n__-:definitions/generatorNow!predicate" =
        _js2n__-prdslib.records.record
            {
              generator = _js2n__-prdslib.enum [ "now" ],
              parameters =
                _js2n__-prdslib.records.record
                    {
                      format = _js2n__-prdslib.isType '"String",
                      utc = _js2n__-prdslib.isType '"Bool",
                    } {} true _js2n__-prdslib.always,
            } {} true _js2n__-prdslib.always,
      "_js2n__-:definitions/generatorPort!predicate" =
        _js2n__-prdslib.records.record
            {
              generator = _js2n__-prdslib.enum [ "port" ],
              parameters =
                _js2n__-prdslib.records.record
                    {
                      fallback = _js2n__-prdslib.isType 'Integer,
                      high = _js2n__-prdslib.isType 'Integer,
                      low = _js2n__-prdslib.isType 'Integer,
                    } {} true _js2n__-prdslib.always,
            } {} true _js2n__-prdslib.always,
      "_js2n__-:definitions/generatorRandom!predicate" =
        _js2n__-prdslib.records.record
            {
              generator = _js2n__-prdslib.enum [ "random" ],
              parameters =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "low" ],
                      _js2n__-prdslib.records.record
                        {
                          high = _js2n__-prdslib.isType 'Integer,
                          low = _js2n__-prdslib.isType 'Integer,
                        } {} true _js2n__-prdslib.always
                    ],
            } {} true _js2n__-prdslib.always,
      "_js2n__-:definitions/generatorRegex!predicate" =
        _js2n__-prdslib.records.record
            {
              generator = _js2n__-prdslib.enum [ "regex" ],
              parameters =
                _js2n__-prdslib.records.record
                    {
                      source = _js2n__-prdslib.isType '"String",
                      steps =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.records.required
                                      [ "regex", "replacement" ],
                                    _js2n__-prdslib.records.record
                                      {
                                        regex =
                                          _js2n__-prdslib.isType '"String",
                                        replacement =
                                          _js2n__-prdslib.isType '"String",
                                      } {} true _js2n__-prdslib.always
                                  ])
                            ],
                    } {} true _js2n__-prdslib.always,
            } {} true _js2n__-prdslib.always,
      "_js2n__-:definitions/generatorRegexMatch!predicate" =
        _js2n__-prdslib.records.record
            {
              datatype = _js2n__-prdslib.enum [ "bool" ],
              generator = _js2n__-prdslib.enum [ "regexMatch" ],
              parameters =
                _js2n__-prdslib.records.record
                    {
                      pattern = _js2n__-prdslib.isType '"String",
                      source = _js2n__-prdslib.isType '"String",
                    } {} true _js2n__-prdslib.always,
            } {} true _js2n__-prdslib.always,
      "_js2n__-:definitions/generatorSwitch!predicate" =
        _js2n__-prdslib.records.record
            {
              generator = _js2n__-prdslib.enum [ "switch" ],
              parameters =
                _js2n__-prdslib.records.record
                    {
                      cases =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.required
                                      [ "condition", "value" ],
                                    _js2n__-prdslib.records.record
                                      {
                                        condition =
                                          _js2n__-prdslib.isType '"String",
                                        value =
                                          _js2n__-prdslib.isType '"String",
                                      } {} true _js2n__-prdslib.always
                                  ])
                            ],
                      datatype =
                        _js2n__-refsenv."_js2n__-:definitions/datatype!predicate",
                      evaluator =
                        _js2n__-prdslib.enum [ "C++", "C++2", "MSBUILD", "VB" ],
                    } {} true _js2n__-prdslib.always,
            } {} true _js2n__-prdslib.always,
      "_js2n__-:definitions/guid!predicate"
        | doc "A guid string to be replaced in source files. Format and casing is not significant in the config as format and casing is preserved based on the particular guid in processed file(s)."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^\\{?[0-9A-Fa-f]{8}[-]?([0-9A-Fa-f]{4}[-]?){3}[0-9A-Fa-f]{12}\\}?$"
            ],
      "_js2n__-:definitions/ice!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.isType '"String"),
                  _js2n__-prdslib.arrays.uniqueItems
                ],
              _js2n__-prdslib.isType '"String"
            ],
      "_js2n__-:definitions/modifier!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  condition = _js2n__-prdslib.isType '"String",
                  copyOnly =
                    _js2n__-refsenv."_js2n__-:definitions/ice!predicate",
                  exclude =
                    _js2n__-refsenv."_js2n__-:definitions/ice!predicate",
                  include =
                    _js2n__-refsenv."_js2n__-:definitions/ice!predicate",
                  rename =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/source!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType 'Record,
                _js2n__-refsenv."_js2n__-:definitions/modifier!predicate",
                _js2n__-prdslib.records.record
                  {
                    modifiers =
                      _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType '"Array",
                            _js2n__-prdslib.arrays.arrayOf
                              _js2n__-refsenv."_js2n__-:definitions/modifier!predicate"
                          ],
                    source = _js2n__-prdslib.isType '"String",
                    target = _js2n__-prdslib.isType '"String",
                  } {} true _js2n__-prdslib.always
              ]),
    }
    in
  {
      author | String | doc "The author of the template.",
      baselines
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
                        defaultOverrides =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record {} {} true
                                  (_js2n__-prdslib.isType '"String")
                              ],
                        description = _js2n__-prdslib.isType '"String",
                      } {} true _js2n__-prdslib.always
                  ])
            ])
        | doc "Alternate sets of defaults for symbols."
        | optional,
      classifications
        | Array (
          _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType '"String",
                _js2n__-prdslib.strings.minLength 1
              ])
        )
        | doc "Zero or more characteristics of the template that a user might search for it by.",
      constraints
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.oneOf
                      [
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.not
                              (_js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required [ "type" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      type =
                                        _js2n__-prdslib.enum
                                            [
                                              "os",
                                              "host",
                                              "workload",
                                              "sdk-version",
                                              "project-capability"
                                            ],
                                    } {} true _js2n__-prdslib.always
                                ]),
                            _js2n__-prdslib.records.record
                              {
                                args =
                                  _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType '"Array",
                                        _js2n__-prdslib.isType 'Record,
                                        _js2n__-prdslib.isType '"String"
                                      ],
                              } {} true _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.records.record
                          {
                            args =
                              _js2n__-prdslib.oneOf
                                  [
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType '"String",
                                        _js2n__-prdslib.enum
                                          [ "Windows", "Linux", "OSX" ]
                                      ],
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType '"Array",
                                        _js2n__-prdslib.arrays.arrayOf
                                          (_js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-prdslib.enum
                                                [ "Windows", "Linux", "OSX" ]
                                            ])
                                      ]
                                  ],
                            type = _js2n__-prdslib.enum [ "os" ],
                          } {} true _js2n__-prdslib.always,
                        _js2n__-prdslib.records.record
                          {
                            args =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"Array",
                                    _js2n__-prdslib.arrays.arrayOf
                                      (_js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.required
                                            [ "hostname" ],
                                          _js2n__-prdslib.records.record
                                            {
                                              hostname =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"String",
                                                      _js2n__-prdslib.oneOf
                                                        [
                                                          _js2n__-prdslib.not
                                                            (_js2n__-prdslib.enum
                                                              [
                                                                "dotnetcli",
                                                                "vs",
                                                                "vs-mac",
                                                                "ide"
                                                              ]),
                                                          _js2n__-prdslib.enum
                                                            [
                                                              "dotnetcli",
                                                              "vs",
                                                              "vs-mac",
                                                              "ide"
                                                            ]
                                                        ]
                                                    ],
                                              version =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                            } {} true _js2n__-prdslib.always
                                        ])
                                  ],
                            type = _js2n__-prdslib.enum [ "host" ],
                          } {} true _js2n__-prdslib.always,
                        _js2n__-prdslib.records.record
                          {
                            args =
                              _js2n__-prdslib.oneOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType '"Array",
                                        _js2n__-prdslib.arrays.arrayOf
                                          (_js2n__-prdslib.isType '"String")
                                      ]
                                  ],
                            type = _js2n__-prdslib.enum [ "workload" ],
                          } {} true _js2n__-prdslib.always,
                        _js2n__-prdslib.records.record
                          {
                            args =
                              _js2n__-prdslib.oneOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType '"Array",
                                        _js2n__-prdslib.arrays.arrayOf
                                          (_js2n__-prdslib.isType '"String")
                                      ]
                                  ],
                            type = _js2n__-prdslib.enum [ "sdk-version" ],
                          } {} true _js2n__-prdslib.always,
                        _js2n__-prdslib.records.record
                          {
                            args = _js2n__-prdslib.isType '"String",
                            type =
                              _js2n__-prdslib.enum [ "project-capability" ],
                          } {} true _js2n__-prdslib.always
                      ],
                    _js2n__-prdslib.records.required [ "type" ],
                    _js2n__-prdslib.records.record
                      {
                        args = _js2n__-prdslib.always,
                        type = _js2n__-prdslib.isType '"String",
                      } {} true _js2n__-prdslib.always
                  ])
            ])
        | doc "The constraints section defines the restrictions when the template can be run. Available since .NET SDK 7.0.100."
        | optional,
      defaultName
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.minLength 1
            ])
        | doc "The name to use during creation if no name has been specified by the user or provided from the host."
        | optional,
      description
        | String
        | doc "A description of the template's purpose or contents for use in help."
        | optional,
      forms
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.oneOf
                      [
                        _js2n__-prdslib.not
                          (_js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.records.required [ "identifier" ],
                              _js2n__-prdslib.records.record
                                {
                                  identifier =
                                    _js2n__-prdslib.enum
                                        [
                                          "lowerCaseInvariant",
                                          "xmlEncode",
                                          "safe_name",
                                          "lower_safe_name",
                                          "upperCaseInvariant",
                                          "replace",
                                          "safe_namespace",
                                          "lower_safe_namespace",
                                          "chain",
                                          "lowerCase",
                                          "identity",
                                          "upperCase",
                                          "jsonEncode",
                                          "firstLowerCase",
                                          "firstLowerCaseInvariant",
                                          "firstUpperCase",
                                          "firstUpperCaseInvariant",
                                          "titleCase",
                                          "kebabCase"
                                        ],
                                } {} true _js2n__-prdslib.always
                            ]),
                        _js2n__-prdslib.records.record
                          {
                            identifier =
                              _js2n__-prdslib.enum [ "lowerCaseInvariant" ],
                          } {} true _js2n__-prdslib.always,
                        _js2n__-prdslib.records.record
                          { identifier = _js2n__-prdslib.enum [ "xmlEncode" ], }
                          {} true _js2n__-prdslib.always,
                        _js2n__-prdslib.records.record
                          { identifier = _js2n__-prdslib.enum [ "safe_name" ], }
                          {} true _js2n__-prdslib.always,
                        _js2n__-prdslib.records.record
                          {
                            identifier =
                              _js2n__-prdslib.enum [ "lower_safe_name" ],
                          } {} true _js2n__-prdslib.always,
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required
                              [ "pattern", "replacement" ],
                            _js2n__-prdslib.records.record
                              {
                                identifier = _js2n__-prdslib.enum [ "replace" ],
                                pattern = _js2n__-prdslib.isType '"String",
                                replacement = _js2n__-prdslib.isType '"String",
                              } {} true _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.records.record
                          {
                            identifier =
                              _js2n__-prdslib.enum [ "safe_namespace" ],
                          } {} true _js2n__-prdslib.always,
                        _js2n__-prdslib.records.record
                          {
                            identifier =
                              _js2n__-prdslib.enum [ "lower_safe_namespace" ],
                          } {} true _js2n__-prdslib.always,
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "steps" ],
                            _js2n__-prdslib.records.record
                              {
                                identifier = _js2n__-prdslib.enum [ "chain" ],
                                steps =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType '"Array",
                                        _js2n__-prdslib.arrays.arrayOf
                                          (_js2n__-prdslib.isType '"String")
                                      ],
                              } {} true _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.records.record
                          { identifier = _js2n__-prdslib.enum [ "lowerCase" ], }
                          {} true _js2n__-prdslib.always,
                        _js2n__-prdslib.records.record
                          { identifier = _js2n__-prdslib.enum [ "identity" ], }
                          {} true _js2n__-prdslib.always,
                        _js2n__-prdslib.records.record
                          { identifier = _js2n__-prdslib.enum [ "upperCase" ], }
                          {} true _js2n__-prdslib.always,
                        _js2n__-prdslib.records.record
                          {
                            identifier =
                              _js2n__-prdslib.enum [ "upperCaseInvariant" ],
                          } {} true _js2n__-prdslib.always,
                        _js2n__-prdslib.records.record
                          {
                            identifier = _js2n__-prdslib.enum [ "jsonEncode" ],
                          } {} true _js2n__-prdslib.always,
                        _js2n__-prdslib.records.record
                          {
                            identifier =
                              _js2n__-prdslib.enum [ "firstLowerCase" ],
                          } {} true _js2n__-prdslib.always,
                        _js2n__-prdslib.records.record
                          {
                            identifier =
                              _js2n__-prdslib.enum
                                  [ "firstLowerCaseInvariant" ],
                          } {} true _js2n__-prdslib.always,
                        _js2n__-prdslib.records.record
                          {
                            identifier =
                              _js2n__-prdslib.enum [ "firstUpperCase" ],
                          } {} true _js2n__-prdslib.always,
                        _js2n__-prdslib.records.record
                          {
                            identifier =
                              _js2n__-prdslib.enum
                                  [ "firstUpperCaseInvariant" ],
                          } {} true _js2n__-prdslib.always,
                        _js2n__-prdslib.records.record
                          { identifier = _js2n__-prdslib.enum [ "titleCase" ], }
                          {} true _js2n__-prdslib.always,
                        _js2n__-prdslib.records.record
                          { identifier = _js2n__-prdslib.enum [ "kebabCase" ], }
                          {} true _js2n__-prdslib.always
                      ],
                    _js2n__-prdslib.records.record
                      { identifier = _js2n__-prdslib.isType '"String", } {} true
                      _js2n__-prdslib.always
                  ])
            ])
        | doc "Custom value forms used by the template."
        | optional,
      generatorVersions
        | String
        | doc "The semantic version range of the Microsoft.TemplateEngine.Orchestrator.RunnableProjects package that this template is usable with. In older versions of the engine, the four octet version string is used but is matched against a constant which was never changed from 1.0.0.0 - either syntax is now accepted, however the four octet string will not be changed from 1.0.0.0."
        | optional,
      groupIdentity
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.minLength 1
            ])
        | doc "The ID of the group this template belongs to. When combined with the \"tags\" section, this allows multiple templates to be displayed as one, with the the decision for which one to use being presented as a choice in each one of the pivot categories (keys)."
        | optional,
      guids
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/guid!predicate",
              _js2n__-prdslib.arrays.uniqueItems
            ])
        | doc "A list of guids which appear in the template source and should be replaced in the template output. For each guid listed, a replacement guid is generated, and replaces all occurrences of the source guid in the output."
        | optional,
      identity
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.minLength 1
            ])
        | doc "A unique name for this template.",
      name
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.minLength 1
            ])
        | doc "The name for the template that users should see.",
      placeholderFilename
        | String
        | doc "A filename that will be completely ignored except to indicate that its containing directory should be copied. This allows creation of an empty directory in the created template, by having a corresponding source directory containing just the placeholder file. Completely empty directories are ignored."
        | optional,
      postActions
        | Array (
          _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType 'Record,
                _js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.records.required
                          [ "actionId", "manualInstructions" ],
                        _js2n__-prdslib.records.record
                          {
                            actionId =
                              _js2n__-refsenv."_js2n__-:definitions/guid!predicate",
                            applyFileRenamesToArgs =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"Array",
                                    _js2n__-prdslib.arrays.arrayOf
                                      (_js2n__-prdslib.isType '"String")
                                  ],
                            applyFileRenamesToManualInstructions =
                              _js2n__-prdslib.isType '"Bool",
                            args = _js2n__-prdslib.isType 'Record,
                            condition = _js2n__-prdslib.isType '"String",
                            continueOnError = _js2n__-prdslib.isType '"Bool",
                            description = _js2n__-prdslib.isType '"String",
                            id = _js2n__-prdslib.isType '"String",
                            manualInstructions =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"Array",
                                    _js2n__-prdslib.arrays.arrayOf
                                      (_js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.required
                                            [ "text" ],
                                          _js2n__-prdslib.records.record
                                            {
                                              condition =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              id =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              text =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                            } {} true _js2n__-prdslib.always
                                        ])
                                  ],
                          } {} true _js2n__-prdslib.always
                      ],
                    _js2n__-prdslib.oneOf
                      [
                        _js2n__-prdslib.not
                          (_js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.records.required [ "actionId" ],
                              _js2n__-prdslib.records.record
                                {
                                  actionId =
                                    _js2n__-prdslib.enum
                                        [
                                          "AC1156F7-BB77-4DB8-B28F-24EEBCCA1E5C",
                                          "3A7C4B45-1F5D-4A30-959A-51B88E82B5D2",
                                          "B17581D1-C5C9-4489-8F0A-004BE667B814",
                                          "cb9a6cf3-4f5c-4860-b9d2-03a574959774",
                                          "210D431B-A78B-4D2F-B762-4ED3E3EA9025",
                                          "D396686C-DE0E-4DE6-906D-291CD29FC5DE",
                                          "84C0DA21-51C8-4541-9940-6CA19AF04EE6"
                                        ],
                                } {} true _js2n__-prdslib.always
                            ]),
                        _js2n__-prdslib.records.record
                          {
                            actionId =
                              _js2n__-prdslib.enum
                                  [ "AC1156F7-BB77-4DB8-B28F-24EEBCCA1E5C" ],
                            args =
                              _js2n__-prdslib.records.record
                                  {
                                    args = _js2n__-prdslib.isType '"String",
                                    executable =
                                      _js2n__-prdslib.isType '"String",
                                  } {} true _js2n__-prdslib.always,
                          } {} true _js2n__-prdslib.always,
                        _js2n__-prdslib.records.record
                          {
                            actionId =
                              _js2n__-prdslib.enum
                                  [ "3A7C4B45-1F5D-4A30-959A-51B88E82B5D2" ],
                            args =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.records.required
                                      [ "executable" ],
                                    _js2n__-prdslib.records.record
                                      {
                                        args = _js2n__-prdslib.isType '"String",
                                        executable =
                                          _js2n__-prdslib.isType '"String",
                                        redirectStandardError =
                                          _js2n__-prdslib.isType '"Bool",
                                        redirectStandardOutput =
                                          _js2n__-prdslib.isType '"Bool",
                                      } {} true _js2n__-prdslib.always
                                  ],
                          } {} true _js2n__-prdslib.always,
                        _js2n__-prdslib.records.record
                          {
                            actionId =
                              _js2n__-prdslib.enum
                                  [ "B17581D1-C5C9-4489-8F0A-004BE667B814" ],
                            args =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.records.required
                                      [ "reference", "referenceType" ],
                                    _js2n__-prdslib.records.record
                                      {
                                        projectFileExtensions =
                                          _js2n__-prdslib.isType '"String",
                                        reference =
                                          _js2n__-prdslib.isType '"String",
                                        referenceType =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [
                                                    "project",
                                                    "package",
                                                    "framework"
                                                  ]
                                              ],
                                        targetFiles =
                                          _js2n__-prdslib.oneOf
                                              [
                                                _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"Array",
                                                    _js2n__-prdslib.arrays.arrayOf
                                                      (_js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            '"String",
                                                          _js2n__-prdslib.arrays.uniqueItems
                                                        ])
                                                  ],
                                                _js2n__-prdslib.isType '"String"
                                              ],
                                        version =
                                          _js2n__-prdslib.isType '"String",
                                      } {} true _js2n__-prdslib.always
                                  ],
                          } {} true _js2n__-prdslib.always,
                        _js2n__-prdslib.records.record
                          {
                            actionId =
                              _js2n__-prdslib.enum
                                  [ "cb9a6cf3-4f5c-4860-b9d2-03a574959774" ],
                            args =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.record {} {} true
                                      (_js2n__-prdslib.oneOf
                                        [
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"String",
                                                    _js2n__-prdslib.arrays.uniqueItems
                                                  ])
                                            ],
                                          _js2n__-prdslib.isType '"String"
                                        ])
                                  ],
                          } {} true _js2n__-prdslib.always,
                        _js2n__-prdslib.records.record
                          {
                            actionId =
                              _js2n__-prdslib.enum
                                  [ "210D431B-A78B-4D2F-B762-4ED3E3EA9025" ],
                            args =
                              _js2n__-prdslib.records.record
                                  {
                                    files =
                                      _js2n__-prdslib.oneOf
                                          [
                                            _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType '"Array",
                                                _js2n__-prdslib.arrays.arrayOf
                                                  (_js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"String",
                                                      _js2n__-prdslib.arrays.uniqueItems
                                                    ])
                                              ],
                                            _js2n__-prdslib.isType '"String"
                                          ],
                                  } {} true _js2n__-prdslib.always,
                          } {} true _js2n__-prdslib.always,
                        _js2n__-prdslib.records.record
                          {
                            actionId =
                              _js2n__-prdslib.enum
                                  [ "D396686C-DE0E-4DE6-906D-291CD29FC5DE" ],
                            args =
                              _js2n__-prdslib.records.record
                                  {
                                    inRoot = _js2n__-prdslib.isType '"Bool",
                                    primaryOutputIndexes =
                                      _js2n__-prdslib.isType '"String",
                                    projectFiles =
                                      _js2n__-prdslib.oneOf
                                          [
                                            _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType '"Array",
                                                _js2n__-prdslib.arrays.arrayOf
                                                  (_js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"String",
                                                      _js2n__-prdslib.arrays.uniqueItems
                                                    ])
                                              ],
                                            _js2n__-prdslib.isType '"String"
                                          ],
                                    solutionFolder =
                                      _js2n__-prdslib.isType '"String",
                                  } {} true _js2n__-prdslib.always,
                          } {} true _js2n__-prdslib.always,
                        _js2n__-prdslib.records.record
                          {
                            actionId =
                              _js2n__-prdslib.enum
                                  [ "84C0DA21-51C8-4541-9940-6CA19AF04EE6" ],
                            args =
                              _js2n__-prdslib.records.record
                                  { files = _js2n__-prdslib.isType '"String", }
                                  {} true _js2n__-prdslib.always,
                          } {} true _js2n__-prdslib.always
                      ]
                  ]
              ])
        )
        | doc "Defines an ordered list of actions to perform after template generation. The post action information is provided to the creation broker, to act on as appropriate."
        | optional,
      precedence
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType 'Integer,
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.strings.pattern "^([0-9]+)$"
            ])
        | doc "A value used to determine how preferred this template is among the other templates with the same groupIdentity (higher values are more preferred)."
        | optional,
      preferDefaultName
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf [ _js2n__-prdslib.isType '"Bool" ])
        | doc "Indicated which behaviour to use when no `--name` is specified during template creation. If `true` it will use the template's `defaultName`. If no `defaultName` is found, or `preferDefaultName` is `false` it uses the fallback (output folder)."
        | optional,
      preferNameDirectory
        | Bool
        | doc "Indicates whether to create a directory for the template if name is specified but an output directory is not set (instead of creating the content directly in the current directory)."
        | optional,
      primaryOutputs
        | Array
          {
            condition
              | String
              | doc "The condition for including the specified path in the primary outputs set."
              | optional,
            path
              | String
              | doc "The path to the file in the template content whose corresponding output file should be included as a primary output.",
            ..
          }
        | doc "A list of important output paths created during template generation. These paths need to be added to the newly created project at the end of template creation."
        | optional,
      shortName
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.isType '"String")
                    ]
                ],
              _js2n__-prdslib.strings.minLength 1
            ]),
      sourceName
        | String
        | doc "The text in the source content to replace with the name the user specifies. The value of the 'sourceName' is available in built-in 'name' symbol that can be used as the source for creating other symbols and condition expressions. See important information about how to select correct 'sourceName' in https://github.com/dotnet/templating/wiki/Naming-and-default-value-forms."
        | optional,
      sources
        | Array _js2n__-refsenv."_js2n__-:definitions/source!contract"
        | doc "The set of mappings in the template content to user directories."
        | optional,
      symbols
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.oneOf
                      [
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "binding" ],
                            _js2n__-prdslib.records.record
                              {
                                binding = _js2n__-prdslib.isType '"String",
                                defaultValue = _js2n__-prdslib.isType '"String",
                                fileRename = _js2n__-prdslib.isType '"String",
                                onlyIf =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType '"Array",
                                        _js2n__-prdslib.arrays.arrayOf
                                          (_js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record
                                                {
                                                  after =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  before =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                } {} true _js2n__-prdslib.always
                                            ])
                                      ],
                                replaces = _js2n__-prdslib.isType '"String",
                                type = _js2n__-prdslib.enum [ "bind" ],
                              } {} true _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required
                              [ "valueSource", "valueTransform" ],
                            _js2n__-prdslib.records.record
                              {
                                defaultValue = _js2n__-prdslib.isType '"String",
                                fileRename = _js2n__-prdslib.isType '"String",
                                onlyIf =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType '"Array",
                                        _js2n__-prdslib.arrays.arrayOf
                                          (_js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record
                                                {
                                                  after =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  before =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                } {} true _js2n__-prdslib.always
                                            ])
                                      ],
                                replaces = _js2n__-prdslib.isType '"String",
                                type = _js2n__-prdslib.enum [ "derived" ],
                                valueSource = _js2n__-prdslib.isType '"String",
                                valueTransform =
                                  _js2n__-prdslib.isType '"String",
                              } {} true _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.oneOf
                              [
                                _js2n__-refsenv."_js2n__-:definitions/generatorCasing!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/generatorCoalesce!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/generatorConstant!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/generatorGuid!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/generatorNow!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/generatorPort!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/generatorRandom!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/generatorRegex!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/generatorRegexMatch!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/generatorSwitch!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/generatorJoin!predicate"
                              ],
                            _js2n__-prdslib.records.required [ "generator" ],
                            _js2n__-prdslib.records.record
                              {
                                fileRename = _js2n__-prdslib.isType '"String",
                                onlyIf =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType '"Array",
                                        _js2n__-prdslib.arrays.arrayOf
                                          (_js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record
                                                {
                                                  after =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  before =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                } {} true _js2n__-prdslib.always
                                            ])
                                      ],
                                replaces = _js2n__-prdslib.isType '"String",
                                type = _js2n__-prdslib.enum [ "generated" ],
                              } {} true _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.records.record
                          {
                            allowMultipleValues =
                              _js2n__-prdslib.isType '"Bool",
                            choices =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"Array",
                                    _js2n__-prdslib.arrays.arrayOf
                                      (_js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.records.required
                                            [ "choice" ],
                                          _js2n__-prdslib.records.record
                                            {
                                              choice =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              description =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              displayName =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                            } {} true _js2n__-prdslib.always
                                        ])
                                  ],
                            defaultValue = _js2n__-prdslib.isType '"String",
                            description = _js2n__-prdslib.isType '"String",
                            displayName = _js2n__-prdslib.isType '"String",
                            enableQuotelessLiterals =
                              _js2n__-prdslib.isType '"Bool",
                            fileRename = _js2n__-prdslib.isType '"String",
                            forms =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.record
                                      {
                                        global =
                                          _js2n__-prdslib.oneOf
                                              [
                                                _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"Array",
                                                    _js2n__-prdslib.arrays.arrayOf
                                                      (_js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            '"String",
                                                          _js2n__-prdslib.arrays.uniqueItems
                                                        ])
                                                  ],
                                                _js2n__-prdslib.isType '"String"
                                              ],
                                      } {} true _js2n__-prdslib.always
                                  ],
                            isEnabled =
                              _js2n__-prdslib.oneOf
                                  [
                                    _js2n__-prdslib.isType '"Bool",
                                    _js2n__-prdslib.isType '"String"
                                  ],
                            isRequired =
                              _js2n__-prdslib.oneOf
                                  [
                                    _js2n__-prdslib.isType '"Bool",
                                    _js2n__-prdslib.isType '"String"
                                  ],
                            onlyIf =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"Array",
                                    _js2n__-prdslib.arrays.arrayOf
                                      (_js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.record
                                            {
                                              after =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              before =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                            } {} true _js2n__-prdslib.always
                                        ])
                                  ],
                            replaces = _js2n__-prdslib.isType '"String",
                            type = _js2n__-prdslib.enum [ "parameter" ],
                          } {} true _js2n__-prdslib.always,
                        _js2n__-prdslib.records.record
                          {
                            type = _js2n__-prdslib.enum [ "computed" ],
                            value = _js2n__-prdslib.isType '"String",
                          } {} true _js2n__-prdslib.always
                      ],
                    _js2n__-prdslib.records.required [ "type" ],
                    _js2n__-prdslib.records.record
                      {
                        datatype =
                          _js2n__-refsenv."_js2n__-:definitions/datatype!predicate",
                        type =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.enum
                                  [
                                    "bind",
                                    "derived",
                                    "generated",
                                    "parameter",
                                    "computed"
                                  ]
                              ],
                      } {} true _js2n__-prdslib.always
                  ])
            ])
        | doc "The symbols section defines variables and their values, the values may be the defined in terms of other symbols. When a defined symbol name is encountered anywhere in the template definition, it is replaced by the value defined in this configuration. The symbols configuration is a collection of key-value pairs. The keys are the symbol names, and the value contains key-value-pair configuration information on how to assign the symbol a value."
        | optional,
      tags
        | {
          language
            | String
            | doc "The programming language the template primarily contains or is intended for use with."
            | optional,
          type
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.enum [ "project", "item", "solution" ])
            | doc "The type of template: project or item.",
          ..
        }
        | doc "Common information about templates, these are effectively interchangeable with choice type parameter symbols.",
      thirdPartyNotices
        | String
        | doc "An URL for a document indicating any libraries used by the template that are not owned/provided by the template author."
        | optional,
      ..
    }