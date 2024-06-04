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
      author | String | doc "作者資訊" | optional,
      config_version
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern "\\d+(\\.\\d+)*"
            ])
        | doc "config version"
        | optional,
      fallback_colors
        | {
          border_color | String | optional,
          candidate_background | String | doc "候选栏的整体背景图/色" | optional,
          candidate_separator_color | String | optional,
          candidate_text_color | String | optional,
          comment_text_color | String | optional,
          hilited_back_color | String | optional,
          hilited_candidate_back_color | String | optional,
          hilited_candidate_text_color | String | optional,
          hilited_comment_text_color | String | optional,
          hilited_key_back_color | String | optional,
          hilited_key_symbol_color | String | optional,
          hilited_key_text_color | String | optional,
          hilited_label_color | String | doc "高亮候选序号" | optional,
          hilited_off_key_back_color | String | optional,
          hilited_off_key_text_color | String | optional,
          hilited_on_key_back_color | String | optional,
          hilited_on_key_text_color | String | optional,
          hilited_text_color | String | optional,
          key_back_color | String | optional,
          key_border_color | String | optional,
          key_symbol_color | String | optional,
          key_text_color | String | optional,
          keyboard_back_color | String | doc "键盘区的背景图/色" | optional,
          label_color | String | optional,
          liquid_keyboard_background
            | String
            | doc "liquidKeyboard 的背景图/色"
            | optional,
          long_text_back_color | String | doc "长文本按键的背景(剪贴板）" | optional,
          off_key_back_color | String | optional,
          off_key_text_color | String | optional,
          on_key_back_color | String | optional,
          on_key_text_color | String | optional,
          preview_back_color | String | optional,
          preview_text_color | String | optional,
          root_background | String | doc "整个键盘区+候选栏的背景图/色" | optional,
          shadow_color | String | optional,
          text_back_color | String | doc "编码区背景，即悬浮窗背景" | optional,
          ..
        }
        | optional,
      liquid_keyboard
        | {
          author | String | optional,
          fixed_key_bar
            | {
              keys | Array Dyn | doc "固定按键条的按键（显示名称为对应的label，不能放太多）" | optional,
              position
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.enum [ "top", "bottom", "left", "right" ])
                | doc "固定按键条摆放位置（相对滚动区域的上/下/左/右方位）"
                | optional,
              ..
            }
            | optional,
          key_height | std.number.Integer | doc "按键高度" | optional,
          key_height_land | std.number.Integer | doc "横屏模式按键高度" | optional,
          keyboards | Array (String) | optional,
          margin_x | Number | doc "左右按键间隙的1/2" | optional,
          row | std.number.Integer | doc "每屏最多显示多少行按键" | optional,
          row_land | std.number.Integer | doc "横屏每屏最多显示多少行按键" | optional,
          single_width | std.number.Integer | doc "single类型的按键宽度" | optional,
          vertical_gap | std.number.Integer | doc "纵向按键间隙" | optional,
          ..
        }
        | optional,
      name | String | doc "方案名稱" | optional,
      preset_color_schemes
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                { "\\w+" = _js2n__-prdslib.always, } true _js2n__-prdslib.always
            ])
        | optional,
      preset_keyboards
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  "\\w+" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              ascii_mode = _js2n__-prdslib.isType 'Integer,
                              author = _js2n__-prdslib.isType '"String",
                              height = _js2n__-prdslib.isType '"Number",
                              keys =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        (_js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-prdslib.records.record
                                              {
                                                click =
                                                  _js2n__-prdslib.oneOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"String",
                                                        _js2n__-prdslib.isType
                                                          'Integer,
                                                        _js2n__-prdslib.isType
                                                          '"Bool"
                                                      ],
                                                composing =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                label =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                long_click =
                                                  _js2n__-prdslib.oneOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"String",
                                                        _js2n__-prdslib.isType
                                                          'Integer
                                                      ],
                                                send_bindings =
                                                  _js2n__-prdslib.isType
                                                      '"Bool",
                                                swipe_down =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                swipe_left =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                swipe_right =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                swipe_up =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                width =
                                                  _js2n__-prdslib.isType
                                                      '"Number",
                                              } {} true _js2n__-prdslib.always
                                          ])
                                    ],
                              lock = _js2n__-prdslib.isType '"Bool",
                              name = _js2n__-prdslib.isType '"String",
                              width = _js2n__-prdslib.isType '"Number",
                            } {} true _js2n__-prdslib.always
                        ],
                } true _js2n__-prdslib.always
            ])
        | optional,
      preset_keys
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  "\\w+" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              label =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.isType 'Integer
                                    ],
                              send =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.isType 'Integer
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } true _js2n__-prdslib.always
            ])
        | optional,
      style
        | {
          auto_caps
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.enum [ true, false, "ascii" ])
            | doc "自动句首大写"
            | optional,
          background_dim_amount | Number | doc "备用参数，暂无功能" | optional,
          background_folder
            | String
            | doc "背景图保存在background目录下的哪个子目录"
            | optional,
          candidate_font | String | doc "候選字型" | optional,
          candidate_padding | std.number.Integer | doc "候選項內邊距" | optional,
          candidate_spacing | Number | doc "候選間距" | optional,
          candidate_text_size | std.number.Integer | doc "候選字號" | optional,
          candidate_use_cursor | Bool | doc "高亮候選項" | optional,
          candidate_view_height | std.number.Integer | doc "候選區高度" | optional,
          color_scheme | String | doc "配色方案" | optional,
          comment_font | String | doc "編碼提示字型" | optional,
          comment_height | std.number.Integer | doc "編碼提示區高度" | optional,
          comment_on_top | Bool | doc "編碼提示在上方或右側" | optional,
          comment_text_size | std.number.Integer | doc "編碼提示字號" | optional,
          enter_label_mode
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Integer,
                  _js2n__-prdslib.numbers.maximum 3,
                  _js2n__-prdslib.numbers.minimum 0
                ])
            | doc "是否使用App提供的ActionLabel内容作为Enter键的文本（由于多数App没有适配ActionLable，实际影响不大）。0不使用，1只使用actionlabel，2优先使用，3当其他方式没有获得label时才读取actionlabel"
            | optional,
          enter_labels
            | {
              "default" | String | optional,
              done | String | optional,
              go | String | optional,
              next | String | optional,
              pre | String | optional,
              search | String | optional,
              send | String | optional,
              ..
            }
            | doc "定义Enter键的文本"
            | optional,
          hanb_font | String | doc "擴充字型" | optional,
          horizontal | Bool | doc "水平模式" | optional,
          horizontal_gap | std.number.Integer | doc "鍵水平間距" | optional,
          key_font | String | doc "鍵盤字型" | optional,
          key_height | std.number.Integer | doc "鍵高" | optional,
          key_long_text_border | String | doc "" | optional,
          key_long_text_size | std.number.Integer | doc "長標籤字號" | optional,
          key_text_size | std.number.Integer | doc "鍵字號" | optional,
          key_width | Number | doc "鍵寬，佔螢幕寬的百分比" | optional,
          keyboard_height
            | std.number.Integer
            | doc "锁定键盘高度，避免切换时键盘高度变化而造成闪烁"
            | optional,
          keyboard_height_land
            | std.number.Integer
            | doc "锁定横屏下键盘高度，避免切换时键盘高度变化而造成闪烁"
            | optional,
          keyboard_padding
            | std.number.Integer
            | doc "竖屏模式下，屏幕左右两侧与键盘的距离（曲面屏减少误触）"
            | optional,
          keyboard_padding_bottom
            | std.number.Integer
            | doc "竖屏模式下，屏幕下边缘与键盘的距离（避免误触发全面屏手势）"
            | optional,
          keyboard_padding_land
            | std.number.Integer
            | doc "横屏模式下，屏幕左右两侧与键盘的距离（避免横屏按键过度拉伸变形）"
            | optional,
          keyboard_padding_land_bottom
            | std.number.Integer
            | doc "横屏模式下，屏幕下侧与键盘的距离"
            | optional,
          keyboard_padding_left
            | std.number.Integer
            | doc "竖屏屏模式下，左手键盘布局，屏幕左侧与键盘的距离"
            | optional,
          keyboard_padding_right
            | std.number.Integer
            | doc "竖屏屏模式下，左手键盘布局，屏幕右侧与键盘的距离"
            | optional,
          keyboards | Array (String) | doc "鍵盤配置" | optional,
          label_font | String | doc "編標籤字型" | optional,
          label_text_size | std.number.Integer | doc "標籤字號" | optional,
          latin_font | String | doc "西文字型" | optional,
          latin_locale | String | doc "西文語言" | optional,
          layout
            | {
              all_phrases | Bool | doc "所有滿足條件的詞語都顯示在窗口" | optional,
              alpha
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Integer,
                      _js2n__-prdslib.numbers.maximum 255,
                      _js2n__-prdslib.numbers.minimum 0
                    ])
                | doc "透明度"
                | optional,
              border | std.number.Integer | doc "邊框寬度" | optional,
              elevation
                | std.number.Integer
                | doc "陰影(>=Android5.0)"
                | optional,
              line_spacing | std.number.Integer | doc "候选詞的行間距(px)" | optional,
              line_spacing_multiplier | Number | doc "候选詞的行間距(倍數)" | optional,
              margin_bottom
                | std.number.Integer
                | doc "底部边距 （用于适配特定背景图）"
                | optional,
              margin_x | std.number.Integer | doc "水平邊距" | optional,
              margin_y | std.number.Integer | doc "豎直邊距" | optional,
              max_entries | std.number.Integer | doc "最大詞條數" | optional,
              max_height | std.number.Integer | doc "最大高度" | optional,
              max_length | std.number.Integer | doc "超過字數則換行" | optional,
              max_width | std.number.Integer | doc "最大寬度，超過則自動換行" | optional,
              min_check
                | std.number.Integer
                | doc "只要前n个候选词有长度大于等于min_length的词，就会把长度符合以及之前的词全部加到悬浮窗内"
                | optional,
              min_height | std.number.Integer | doc "最小高度" | optional,
              min_length | std.number.Integer | doc "最小詞長" | optional,
              min_width | std.number.Integer | doc "最小寬度" | optional,
              movable
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.enum [ true, false, "once" ])
                | doc "是否可移動窗口，或僅移動一次"
                | optional,
              position
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.enum
                    [
                      "left",
                      "right",
                      "left_up",
                      "right_up",
                      "fixed",
                      "bottom_left",
                      "bottom_right",
                      "top_left",
                      "top_right"
                    ])
                | doc "位置 (left、right需要>=Android5.0)"
                | optional,
              real_margin
                | std.number.Integer
                | doc "屏幕左右边缘和悬浮窗之间的距离"
                | optional,
              round_corner | std.number.Integer | doc "窗口圓角" | optional,
              spacing
                | std.number.Integer
                | doc "屏幕上下边缘或预编辑上下边缘和悬浮窗之间的距离"
                | optional,
              sticky_lines | std.number.Integer | doc "固頂行數" | optional,
              sticky_lines_land
                | std.number.Integer
                | doc "横屏模式下的固顶行数"
                | optional,
              ..
            }
            | doc "懸浮窗口設置"
            | optional,
          liquid_keyboard_window
            | Array
              {
                click | String | optional,
                label
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.oneOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.isType 'Integer
                      ])
                  | optional,
                start | String | optional,
                ..
              }
            | optional,
          locale
            | std.enum.TagOrString
            | [| '"", 'zh_HK, 'zh_CN, 'zh_TW |]
            | doc "預設語言"
            | optional,
          long_text_font | String | doc "剪贴板等可能包含大段文本使用的字体" | optional,
          preview_font | String | doc "按鍵提示字型" | optional,
          preview_height | std.number.Integer | doc "按鍵提示高度" | optional,
          preview_offset | std.number.Integer | doc "按鍵提示縱向偏移" | optional,
          preview_text_size | std.number.Integer | doc "按鍵提示字號" | optional,
          proximity_correction | Bool | doc "按鍵糾錯" | optional,
          reset_ascii_mode | Bool | doc "顯示鍵盤時重置爲中文狀態" | optional,
          round_corner | Number | doc "按鍵圓角半徑" | optional,
          shadow_radius | Number | doc "按鍵陰影半徑" | optional,
          speech_opencc_config | String | doc "語音輸入簡繁轉換" | optional,
          symbol_font | String | doc "符號字型" | optional,
          symbol_text_size | std.number.Integer | doc "編碼字型" | optional,
          text_height | std.number.Integer | doc "編碼區高度" | optional,
          text_size | std.number.Integer | doc "編碼區字號" | optional,
          vertical_correction
            | Number
            | doc "触摸位置校正（竖直方向）。为了提升打字手感，可将按键的实际触摸位置相对其显示位置上下偏移一点点"
            | optional,
          vertical_gap | Number | doc "鍵盤行距" | optional,
          window
            | Array
              {
                candidate | String | optional,
                comment | String | optional,
                composition | String | optional,
                end | String | optional,
                label | String | optional,
                letter_spacing | Number | optional,
                move | String | optional,
                sep | String | optional,
                start | String | optional,
                ..
              }
            | optional,
          ..
        }
        | optional,
      ..
    }