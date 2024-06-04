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
      "_js2n__-:definitions/rule!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Bool",
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.isType '"Array"
                ],
              _js2n__-prdslib.arrays.minItems 1,
              _js2n__-prdslib.records.record
                {
                  severity =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "default",
                              "error",
                              "warning",
                              "warn",
                              "off",
                              "none"
                            ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/rules!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.records.record
              {
                align =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-refsenv."_js2n__-:definitions/rules/properties/align/definitions/options/items!predicate"
                              1,
                            _js2n__-prdslib.arrays.maxItems 6,
                            _js2n__-prdslib.arrays.uniqueItems,
                            _js2n__-prdslib.records.record
                              {
                                options =
                                  _js2n__-prdslib.oneOf
                                      [
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/align/definitions/options!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/align/definitions/options/items!predicate"
                                      ],
                                severity = _js2n__-prdslib.always,
                              } {} false _js2n__-prdslib.never
                          ]
                      ],
                arrow-parens =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-refsenv."_js2n__-:definitions/rules/properties/arrow-parens/definitions/options/items!predicate"
                              1,
                            _js2n__-prdslib.arrays.maxItems 2,
                            _js2n__-prdslib.records.record
                              {
                                options =
                                  _js2n__-prdslib.oneOf
                                      [
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/arrow-parens/definitions/options!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/arrow-parens/definitions/options/items!predicate"
                                      ],
                                severity = _js2n__-prdslib.always,
                              } {} false _js2n__-prdslib.never
                          ]
                      ],
                arrow-return-shorthand =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-refsenv."_js2n__-:definitions/rules/properties/arrow-return-shorthand/definitions/options/items!predicate"
                              1,
                            _js2n__-prdslib.arrays.maxItems 2,
                            _js2n__-prdslib.records.record
                              {
                                options =
                                  _js2n__-prdslib.oneOf
                                      [
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/arrow-return-shorthand/definitions/options!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/arrow-return-shorthand/definitions/options/items!predicate"
                                      ],
                                severity = _js2n__-prdslib.always,
                              } {} false _js2n__-prdslib.never
                          ]
                      ],
                ban =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-refsenv."_js2n__-:definitions/rules/properties/ban/definitions/options/items!predicate"
                              1,
                            _js2n__-prdslib.arrays.uniqueItems,
                            _js2n__-prdslib.records.record
                              {
                                options =
                                  _js2n__-prdslib.oneOf
                                      [
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/ban/definitions/options!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/ban/definitions/options/items!predicate"
                                      ],
                                severity = _js2n__-prdslib.always,
                              } {} false _js2n__-prdslib.never
                          ]
                      ],
                ban-comma-operator =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-prdslib.never 1,
                            _js2n__-prdslib.records.record
                              { severity = _js2n__-prdslib.always, } {} false
                              _js2n__-prdslib.never
                          ]
                      ],
                binary-expression-operand-order =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-prdslib.never 1,
                            _js2n__-prdslib.records.record
                              { severity = _js2n__-prdslib.always, } {} false
                              _js2n__-prdslib.never
                          ]
                      ],
                class-name =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-prdslib.never 1,
                            _js2n__-prdslib.records.record
                              { severity = _js2n__-prdslib.always, } {} false
                              _js2n__-prdslib.never
                          ]
                      ],
                comment-format =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-refsenv."_js2n__-:definitions/rules/properties/comment-format/definitions/options/items!predicate"
                              1,
                            _js2n__-prdslib.arrays.maxItems 5,
                            _js2n__-prdslib.arrays.uniqueItems,
                            _js2n__-prdslib.records.record
                              {
                                options =
                                  _js2n__-prdslib.oneOf
                                      [
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/comment-format/definitions/options!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/comment-format/definitions/options/items!predicate"
                                      ],
                                severity = _js2n__-prdslib.always,
                              } {} false _js2n__-prdslib.never
                          ]
                      ],
                completed-docs =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-refsenv."_js2n__-:definitions/rules/properties/completed-docs/definitions/options/items!predicate"
                              1,
                            _js2n__-prdslib.arrays.maxItems 11,
                            _js2n__-prdslib.arrays.uniqueItems,
                            _js2n__-prdslib.records.record
                              {
                                options =
                                  _js2n__-prdslib.oneOf
                                      [
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/completed-docs/definitions/options!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/completed-docs/definitions/options/items!predicate"
                                      ],
                                severity = _js2n__-prdslib.always,
                              } {} false _js2n__-prdslib.never
                          ]
                      ],
                curly =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-refsenv."_js2n__-:definitions/rules/properties/curly/definitions/options/items!predicate"
                              1,
                            _js2n__-prdslib.records.record
                              {
                                options =
                                  _js2n__-prdslib.oneOf
                                      [
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/curly/definitions/options!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/curly/definitions/options/items!predicate"
                                      ],
                                severity = _js2n__-prdslib.always,
                              } {} false _js2n__-prdslib.never
                          ]
                      ],
                cyclomatic-complexity =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-refsenv."_js2n__-:definitions/rules/properties/cyclomatic-complexity/definitions/options/items!predicate"
                              1,
                            _js2n__-prdslib.arrays.maxItems 2,
                            _js2n__-prdslib.records.record
                              {
                                options =
                                  _js2n__-prdslib.oneOf
                                      [
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/cyclomatic-complexity/definitions/options!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/cyclomatic-complexity/definitions/options/items!predicate"
                                      ],
                                severity = _js2n__-prdslib.always,
                              } {} false _js2n__-prdslib.never
                          ]
                      ],
                deprecation =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-prdslib.never 1,
                            _js2n__-prdslib.records.record
                              { severity = _js2n__-prdslib.always, } {} false
                              _js2n__-prdslib.never
                          ]
                      ],
                encoding =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-prdslib.never 1,
                            _js2n__-prdslib.records.record
                              { severity = _js2n__-prdslib.always, } {} false
                              _js2n__-prdslib.never
                          ]
                      ],
                eofline =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-prdslib.never 1,
                            _js2n__-prdslib.records.record
                              { severity = _js2n__-prdslib.always, } {} false
                              _js2n__-prdslib.never
                          ]
                      ],
                file-header =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-refsenv."_js2n__-:definitions/rules/properties/file-header/definitions/options/items!predicate"
                              1,
                            _js2n__-prdslib.arrays.maxItems 3,
                            _js2n__-prdslib.records.record
                              {
                                options =
                                  _js2n__-prdslib.oneOf
                                      [
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/file-header/definitions/options!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/file-header/definitions/options/items!predicate"
                                      ],
                                severity = _js2n__-prdslib.always,
                              } {} false _js2n__-prdslib.never
                          ]
                      ],
                file-name-casing =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"Array",
                        _js2n__-prdslib.arrays.items
                          [
                            _js2n__-prdslib.isType '"Bool",
                            _js2n__-prdslib.oneOf
                              [
                                _js2n__-refsenv."_js2n__-:definitions/rules/properties/file-name-casing/definitions/file-name-cases!predicate",
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.minProperties 1,
                                    _js2n__-prdslib.records.record {} {} true
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/file-name-casing/definitions/file-name-cases!predicate"
                                  ]
                              ]
                          ],
                        _js2n__-prdslib.arrays.minItems 2
                      ],
                forin =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-prdslib.never 1,
                            _js2n__-prdslib.records.record
                              { severity = _js2n__-prdslib.always, } {} false
                              _js2n__-prdslib.never
                          ]
                      ],
                import-blacklist =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-refsenv."_js2n__-:definitions/rules/properties/import-blacklist/definitions/options/items!predicate"
                              1,
                            _js2n__-prdslib.arrays.uniqueItems,
                            _js2n__-prdslib.records.record
                              {
                                options =
                                  _js2n__-prdslib.oneOf
                                      [
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/import-blacklist/definitions/options!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/import-blacklist/definitions/options/items!predicate"
                                      ],
                                severity = _js2n__-prdslib.always,
                              } {} false _js2n__-prdslib.never
                          ]
                      ],
                import-spacing =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-prdslib.never 1,
                            _js2n__-prdslib.records.record
                              { severity = _js2n__-prdslib.always, } {} false
                              _js2n__-prdslib.never
                          ]
                      ],
                indent =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [
                                _js2n__-prdslib.isType '"Bool",
                                _js2n__-refsenv."_js2n__-:definitions/rules/properties/indent/definitions/options/items/0!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/rules/properties/indent/definitions/options/items/1!predicate"
                              ],
                            _js2n__-prdslib.arrays.maxItems 3,
                            _js2n__-prdslib.records.record
                              {
                                options =
                                  _js2n__-prdslib.oneOf
                                      [
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/indent/definitions/options!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/indent/definitions/options/items/0!predicate"
                                      ],
                                severity = _js2n__-prdslib.always,
                              } {} false _js2n__-prdslib.never
                          ]
                      ],
                jsdoc-format =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-refsenv."_js2n__-:definitions/rules/properties/jsdoc-format/definitions/options/items!predicate"
                              1,
                            _js2n__-prdslib.records.record
                              {
                                options =
                                  _js2n__-prdslib.oneOf
                                      [
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/jsdoc-format/definitions/options!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/jsdoc-format/definitions/options/items!predicate"
                                      ],
                                severity = _js2n__-prdslib.always,
                              } {} false _js2n__-prdslib.never
                          ]
                      ],
                label-position =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-prdslib.never 1,
                            _js2n__-prdslib.records.record
                              { severity = _js2n__-prdslib.always, } {} false
                              _js2n__-prdslib.never
                          ]
                      ],
                linebreak-style =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-refsenv."_js2n__-:definitions/rules/properties/linebreak-style/definitions/options/items!predicate"
                              1,
                            _js2n__-prdslib.arrays.maxItems 2,
                            _js2n__-prdslib.records.record
                              {
                                options =
                                  _js2n__-prdslib.oneOf
                                      [
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/linebreak-style/definitions/options!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/linebreak-style/definitions/options/items!predicate"
                                      ],
                                severity = _js2n__-prdslib.always,
                              } {} false _js2n__-prdslib.never
                          ]
                      ],
                max-classes-per-file =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [
                                _js2n__-prdslib.isType '"Bool",
                                _js2n__-refsenv."_js2n__-:definitions/rules/properties/max-classes-per-file/definitions/options/items/0!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/rules/properties/max-classes-per-file/definitions/options/items/1!predicate"
                              ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-prdslib.never 3,
                            _js2n__-prdslib.arrays.maxItems 3,
                            _js2n__-prdslib.arrays.minItems 2,
                            _js2n__-prdslib.records.record
                              {
                                options =
                                  _js2n__-prdslib.oneOf
                                      [
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/max-classes-per-file/definitions/options!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/max-classes-per-file/definitions/options/items/0!predicate"
                                      ],
                                severity = _js2n__-prdslib.always,
                              } {} false _js2n__-prdslib.never
                          ]
                      ],
                max-file-line-count =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-refsenv."_js2n__-:definitions/rules/properties/max-file-line-count/definitions/options/items!predicate"
                              1,
                            _js2n__-prdslib.arrays.maxItems 2,
                            _js2n__-prdslib.records.record
                              {
                                options =
                                  _js2n__-prdslib.oneOf
                                      [
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/max-file-line-count/definitions/options!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/max-file-line-count/definitions/options/items!predicate"
                                      ],
                                severity = _js2n__-prdslib.always,
                              } {} false _js2n__-prdslib.never
                          ]
                      ],
                max-line-length =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-refsenv."_js2n__-:definitions/rules/properties/max-line-length/definitions/options/items!predicate"
                              1,
                            _js2n__-prdslib.arrays.maxItems 2,
                            _js2n__-prdslib.records.record
                              {
                                options =
                                  _js2n__-prdslib.oneOf
                                      [
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/max-line-length/definitions/options!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/max-line-length/definitions/options/items!predicate"
                                      ],
                                severity = _js2n__-prdslib.always,
                              } {} false _js2n__-prdslib.never
                          ]
                      ],
                member-ordering =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-refsenv."_js2n__-:definitions/rules/properties/member-ordering/definitions/options/items!predicate"
                              1,
                            _js2n__-prdslib.arrays.maxItems 2,
                            _js2n__-prdslib.records.record
                              {
                                options =
                                  _js2n__-prdslib.oneOf
                                      [
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/member-ordering/definitions/options!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/member-ordering/definitions/options/items!predicate"
                                      ],
                                severity = _js2n__-prdslib.always,
                              } {} false _js2n__-prdslib.never
                          ]
                      ],
                new-parens =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-prdslib.never 1,
                            _js2n__-prdslib.records.record
                              { severity = _js2n__-prdslib.always, } {} false
                              _js2n__-prdslib.never
                          ]
                      ],
                newline-before-return =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-prdslib.never 1,
                            _js2n__-prdslib.records.record
                              { severity = _js2n__-prdslib.always, } {} false
                              _js2n__-prdslib.never
                          ]
                      ],
                newline-per-chained-call =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-prdslib.never 1,
                            _js2n__-prdslib.records.record
                              { severity = _js2n__-prdslib.always, } {} false
                              _js2n__-prdslib.never
                          ]
                      ],
                no-arg =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-prdslib.never 1,
                            _js2n__-prdslib.records.record
                              { severity = _js2n__-prdslib.always, } {} false
                              _js2n__-prdslib.never
                          ]
                      ],
                no-async-without-await =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-prdslib.never 1,
                            _js2n__-prdslib.records.record {} {} false
                              _js2n__-prdslib.never
                          ]
                      ],
                no-bitwise =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-prdslib.never 1,
                            _js2n__-prdslib.records.record
                              { severity = _js2n__-prdslib.always, } {} false
                              _js2n__-prdslib.never
                          ]
                      ],
                no-conditional-assignment =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-prdslib.never 1,
                            _js2n__-prdslib.records.record
                              { severity = _js2n__-prdslib.always, } {} false
                              _js2n__-prdslib.never
                          ]
                      ],
                no-consecutive-blank-lines =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-consecutive-blank-lines/definitions/options/items!predicate"
                              1,
                            _js2n__-prdslib.arrays.maxItems 2,
                            _js2n__-prdslib.records.record
                              {
                                options =
                                  _js2n__-prdslib.oneOf
                                      [
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-consecutive-blank-lines/definitions/options!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-consecutive-blank-lines/definitions/options/items!predicate"
                                      ],
                                severity = _js2n__-prdslib.always,
                              } {} false _js2n__-prdslib.never
                          ]
                      ],
                no-console =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-console/definitions/options/items!predicate"
                              1,
                            _js2n__-prdslib.arrays.uniqueItems,
                            _js2n__-prdslib.records.record
                              {
                                options =
                                  _js2n__-prdslib.oneOf
                                      [
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-console/definitions/options!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-console/definitions/options/items!predicate"
                                      ],
                                severity = _js2n__-prdslib.always,
                              } {} false _js2n__-prdslib.never
                          ]
                      ],
                no-construct =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-prdslib.never 1,
                            _js2n__-prdslib.records.record
                              { severity = _js2n__-prdslib.always, } {} false
                              _js2n__-prdslib.never
                          ]
                      ],
                no-debugger =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-prdslib.never 1,
                            _js2n__-prdslib.records.record
                              { severity = _js2n__-prdslib.always, } {} false
                              _js2n__-prdslib.never
                          ]
                      ],
                no-default-export =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-prdslib.never 1,
                            _js2n__-prdslib.records.record
                              { severity = _js2n__-prdslib.always, } {} false
                              _js2n__-prdslib.never
                          ]
                      ],
                no-duplicate-imports =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [
                                _js2n__-prdslib.isType '"Bool",
                                _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-duplicate-imports/definitions/options!predicate"
                              ],
                            _js2n__-prdslib.arrays.maxItems 2,
                            _js2n__-prdslib.records.record
                              {
                                options =
                                  _js2n__-prdslib.oneOf
                                      [
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-duplicate-imports/definitions/options!predicate"
                                      ],
                                severity = _js2n__-prdslib.always,
                              } {} false _js2n__-prdslib.never
                          ]
                      ],
                no-duplicate-super =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-prdslib.never 1,
                            _js2n__-prdslib.records.record
                              { severity = _js2n__-prdslib.always, } {} false
                              _js2n__-prdslib.never
                          ]
                      ],
                no-duplicate-switch-case =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-prdslib.never 1,
                            _js2n__-prdslib.records.record
                              { severity = _js2n__-prdslib.always, } {} false
                              _js2n__-prdslib.never
                          ]
                      ],
                no-duplicate-variable =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-duplicate-variable/definitions/options/items!predicate"
                              1,
                            _js2n__-prdslib.arrays.maxItems 2,
                            _js2n__-prdslib.records.record
                              {
                                options =
                                  _js2n__-prdslib.oneOf
                                      [
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-duplicate-variable/definitions/options!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-duplicate-variable/definitions/options/items!predicate"
                                      ],
                                severity = _js2n__-prdslib.always,
                              } {} false _js2n__-prdslib.never
                          ]
                      ],
                no-dynamic-delete =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-prdslib.never 1,
                            _js2n__-prdslib.records.record
                              { severity = _js2n__-prdslib.always, } {} false
                              _js2n__-prdslib.never
                          ]
                      ],
                no-empty =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-empty/definitions/options/items!predicate"
                              1,
                            _js2n__-prdslib.arrays.maxItems 3,
                            _js2n__-prdslib.arrays.uniqueItems,
                            _js2n__-prdslib.records.record
                              {
                                options =
                                  _js2n__-prdslib.oneOf
                                      [
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-empty/definitions/options!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-empty/definitions/options/items!predicate"
                                      ],
                                severity = _js2n__-prdslib.always,
                              } {} false _js2n__-prdslib.never
                          ]
                      ],
                no-eval =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-prdslib.never 1,
                            _js2n__-prdslib.records.record
                              { severity = _js2n__-prdslib.always, } {} false
                              _js2n__-prdslib.never
                          ]
                      ],
                no-for-in =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-prdslib.never 1,
                            _js2n__-prdslib.records.record {} {} false
                              _js2n__-prdslib.never
                          ]
                      ],
                no-for-in-array =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-prdslib.never 1,
                            _js2n__-prdslib.records.record
                              { severity = _js2n__-prdslib.always, } {} false
                              _js2n__-prdslib.never
                          ]
                      ],
                no-implicit-dependencies =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              (_js2n__-prdslib.allOf
                                [
                                  _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-implicit-dependencies/definitions/options/items/0!predicate",
                                  _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-implicit-dependencies/definitions/options/items/1!predicate"
                                ]) 1,
                            _js2n__-prdslib.arrays.maxItems 3,
                            _js2n__-prdslib.records.record
                              {
                                options =
                                  _js2n__-prdslib.oneOf
                                      [
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-implicit-dependencies/definitions/options!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-implicit-dependencies/definitions/options/items/0!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-implicit-dependencies/definitions/options/items/1!predicate"
                                      ],
                                severity = _js2n__-prdslib.always,
                              } {} false _js2n__-prdslib.never
                          ]
                      ],
                no-import-side-effect =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-import-side-effect/definitions/options/items!predicate"
                              1,
                            _js2n__-prdslib.arrays.maxItems 2,
                            _js2n__-prdslib.records.record
                              {
                                options =
                                  _js2n__-prdslib.oneOf
                                      [
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-import-side-effect/definitions/options!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-import-side-effect/definitions/options/items!predicate"
                                      ],
                                severity = _js2n__-prdslib.always,
                              } {} false _js2n__-prdslib.never
                          ]
                      ],
                no-invalid-template-strings =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-prdslib.never 1,
                            _js2n__-prdslib.records.record
                              { severity = _js2n__-prdslib.always, } {} false
                              _js2n__-prdslib.never
                          ]
                      ],
                no-invalid-this =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-invalid-this/definitions/options/items!predicate"
                              1,
                            _js2n__-prdslib.arrays.maxItems 2,
                            _js2n__-prdslib.records.record
                              {
                                options =
                                  _js2n__-prdslib.oneOf
                                      [
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-invalid-this/definitions/options!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-invalid-this/definitions/options/items!predicate"
                                      ],
                                severity = _js2n__-prdslib.always,
                              } {} false _js2n__-prdslib.never
                          ]
                      ],
                no-irregular-whitespace =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-prdslib.never 1,
                            _js2n__-prdslib.records.record
                              { severity = _js2n__-prdslib.always, } {} false
                              _js2n__-prdslib.never
                          ]
                      ],
                no-magic-numbers =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-magic-numbers/definitions/options/items!predicate"
                              1,
                            _js2n__-prdslib.arrays.uniqueItems,
                            _js2n__-prdslib.records.record
                              {
                                options =
                                  _js2n__-prdslib.oneOf
                                      [
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-magic-numbers/definitions/options!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-magic-numbers/definitions/options/items!predicate"
                                      ],
                                severity = _js2n__-prdslib.always,
                              } {} false _js2n__-prdslib.never
                          ]
                      ],
                no-null-keyword =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-prdslib.never 1,
                            _js2n__-prdslib.records.record
                              { severity = _js2n__-prdslib.always, } {} false
                              _js2n__-prdslib.never
                          ]
                      ],
                no-null-undefined-union =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-prdslib.never 1,
                            _js2n__-prdslib.records.record {} {} false
                              _js2n__-prdslib.never
                          ]
                      ],
                no-parameter-reassignment =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-prdslib.never 1,
                            _js2n__-prdslib.records.record
                              { severity = _js2n__-prdslib.always, } {} false
                              _js2n__-prdslib.never
                          ]
                      ],
                no-reference =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-prdslib.never 1,
                            _js2n__-prdslib.records.record
                              { severity = _js2n__-prdslib.always, } {} false
                              _js2n__-prdslib.never
                          ]
                      ],
                no-require-imports =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-prdslib.never 1,
                            _js2n__-prdslib.records.record
                              { severity = _js2n__-prdslib.always, } {} false
                              _js2n__-prdslib.never
                          ]
                      ],
                no-return-await =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-prdslib.never 1,
                            _js2n__-prdslib.records.record
                              { severity = _js2n__-prdslib.always, } {} false
                              _js2n__-prdslib.never
                          ]
                      ],
                no-shadowed-variable =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-shadowed-variable/definitions/options/items!predicate"
                              1,
                            _js2n__-prdslib.arrays.maxItems 2,
                            _js2n__-prdslib.records.record
                              {
                                options =
                                  _js2n__-prdslib.oneOf
                                      [
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-shadowed-variable/definitions/options!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-shadowed-variable/definitions/options/items!predicate"
                                      ],
                                severity = _js2n__-prdslib.always,
                              } {} false _js2n__-prdslib.never
                          ]
                      ],
                no-sparse-arrays =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-prdslib.never 1,
                            _js2n__-prdslib.records.record
                              { severity = _js2n__-prdslib.always, } {} false
                              _js2n__-prdslib.never
                          ]
                      ],
                no-string-literal =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-prdslib.never 1,
                            _js2n__-prdslib.records.record
                              { severity = _js2n__-prdslib.always, } {} false
                              _js2n__-prdslib.never
                          ]
                      ],
                no-string-throw =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-prdslib.never 1,
                            _js2n__-prdslib.records.record
                              { severity = _js2n__-prdslib.always, } {} false
                              _js2n__-prdslib.never
                          ]
                      ],
                no-submodule-imports =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-submodule-imports/definitions/options/items!predicate"
                              1,
                            _js2n__-prdslib.arrays.uniqueItems,
                            _js2n__-prdslib.records.record
                              {
                                options =
                                  _js2n__-prdslib.oneOf
                                      [
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-submodule-imports/definitions/options!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-submodule-imports/definitions/options/items!predicate"
                                      ],
                                severity = _js2n__-prdslib.always,
                              } {} false _js2n__-prdslib.never
                          ]
                      ],
                no-switch-case-fall-through =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-prdslib.never 1,
                            _js2n__-prdslib.records.record
                              { severity = _js2n__-prdslib.always, } {} false
                              _js2n__-prdslib.never
                          ]
                      ],
                no-this-assignment =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-this-assignment/definitions/options/items!predicate"
                              1,
                            _js2n__-prdslib.arrays.maxItems 2,
                            _js2n__-prdslib.records.record
                              {
                                options =
                                  _js2n__-prdslib.oneOf
                                      [
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-this-assignment/definitions/options!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-this-assignment/definitions/options/items!predicate"
                                      ],
                                severity = _js2n__-prdslib.always,
                              } {} false _js2n__-prdslib.never
                          ]
                      ],
                no-trailing-whitespace =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-trailing-whitespace/definitions/options/items!predicate"
                              1,
                            _js2n__-prdslib.arrays.maxItems 5,
                            _js2n__-prdslib.arrays.uniqueItems,
                            _js2n__-prdslib.records.record
                              {
                                options =
                                  _js2n__-prdslib.oneOf
                                      [
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-trailing-whitespace/definitions/options!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-trailing-whitespace/definitions/options/items!predicate"
                                      ],
                                severity = _js2n__-prdslib.always,
                              } {} false _js2n__-prdslib.never
                          ]
                      ],
                no-unnecessary-callback-wrapper =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-prdslib.never 1,
                            _js2n__-prdslib.records.record
                              { severity = _js2n__-prdslib.always, } {} false
                              _js2n__-prdslib.never
                          ]
                      ],
                no-unnecessary-class =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-unnecessary-class/definitions/options/items!predicate"
                              1,
                            _js2n__-prdslib.arrays.maxItems 4,
                            _js2n__-prdslib.records.record
                              {
                                options =
                                  _js2n__-prdslib.oneOf
                                      [
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-unnecessary-class/definitions/options!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-unnecessary-class/definitions/options/items!predicate"
                                      ],
                                severity = _js2n__-prdslib.always,
                              } {} false _js2n__-prdslib.never
                          ]
                      ],
                no-unnecessary-initializer =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-prdslib.never 1,
                            _js2n__-prdslib.records.record
                              { severity = _js2n__-prdslib.always, } {} false
                              _js2n__-prdslib.never
                          ]
                      ],
                no-unsafe-finally =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-prdslib.never 1,
                            _js2n__-prdslib.records.record
                              { severity = _js2n__-prdslib.always, } {} false
                              _js2n__-prdslib.never
                          ]
                      ],
                no-unused-expression =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-unused-expression/definitions/options/items!predicate"
                              1,
                            _js2n__-prdslib.arrays.maxItems 4,
                            _js2n__-prdslib.arrays.uniqueItems,
                            _js2n__-prdslib.records.record
                              {
                                options =
                                  _js2n__-prdslib.oneOf
                                      [
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-unused-expression/definitions/options!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-unused-expression/definitions/options/items!predicate"
                                      ],
                                severity = _js2n__-prdslib.always,
                              } {} false _js2n__-prdslib.never
                          ]
                      ],
                no-use-before-declare =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-prdslib.never 1,
                            _js2n__-prdslib.records.record
                              { severity = _js2n__-prdslib.always, } {} false
                              _js2n__-prdslib.never
                          ]
                      ],
                no-var-keyword =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-prdslib.never 1,
                            _js2n__-prdslib.records.record
                              { severity = _js2n__-prdslib.always, } {} false
                              _js2n__-prdslib.never
                          ]
                      ],
                no-void-expression =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-void-expression/definitions/options/items!predicate"
                              1,
                            _js2n__-prdslib.arrays.maxItems 2,
                            _js2n__-prdslib.records.record
                              {
                                options =
                                  _js2n__-prdslib.oneOf
                                      [
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-void-expression/definitions/options!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-void-expression/definitions/options/items!predicate"
                                      ],
                                severity = _js2n__-prdslib.always,
                              } {} false _js2n__-prdslib.never
                          ]
                      ],
                number-literal-format =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-prdslib.never 1,
                            _js2n__-prdslib.records.record
                              { severity = _js2n__-prdslib.always, } {} false
                              _js2n__-prdslib.never
                          ]
                      ],
                object-literal-key-quotes =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-refsenv."_js2n__-:definitions/rules/properties/object-literal-key-quotes/definitions/options/items!predicate"
                              1,
                            _js2n__-prdslib.arrays.maxItems 2,
                            _js2n__-prdslib.records.record
                              {
                                options =
                                  _js2n__-prdslib.oneOf
                                      [
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/object-literal-key-quotes/definitions/options!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/object-literal-key-quotes/definitions/options/items!predicate"
                                      ],
                                severity = _js2n__-prdslib.always,
                              } {} false _js2n__-prdslib.never
                          ]
                      ],
                object-literal-shorthand =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-refsenv."_js2n__-:definitions/rules/properties/object-literal-shorthand/definitions/options/items!predicate"
                              1,
                            _js2n__-prdslib.records.record
                              {
                                options =
                                  _js2n__-prdslib.oneOf
                                      [
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/object-literal-shorthand/definitions/options!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/object-literal-shorthand/definitions/options/items!predicate"
                                      ],
                                severity = _js2n__-prdslib.always,
                              } {} false _js2n__-prdslib.never
                          ]
                      ],
                object-literal-sort-keys =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-refsenv."_js2n__-:definitions/rules/properties/object-literal-sort-keys/definitions/options/items!predicate"
                              1,
                            _js2n__-prdslib.arrays.maxItems 5,
                            _js2n__-prdslib.arrays.uniqueItems,
                            _js2n__-prdslib.records.record
                              {
                                options =
                                  _js2n__-prdslib.oneOf
                                      [
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/object-literal-sort-keys/definitions/options!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/object-literal-sort-keys/definitions/options/items!predicate"
                                      ],
                                severity = _js2n__-prdslib.always,
                              } {} false _js2n__-prdslib.never
                          ]
                      ],
                one-line =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-refsenv."_js2n__-:definitions/rules/properties/one-line/definitions/options/items!predicate"
                              1,
                            _js2n__-prdslib.arrays.maxItems 6,
                            _js2n__-prdslib.arrays.uniqueItems,
                            _js2n__-prdslib.records.record
                              {
                                options =
                                  _js2n__-prdslib.oneOf
                                      [
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/one-line/definitions/options!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/one-line/definitions/options/items!predicate"
                                      ],
                                severity = _js2n__-prdslib.always,
                              } {} false _js2n__-prdslib.never
                          ]
                      ],
                one-variable-per-declaration =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-refsenv."_js2n__-:definitions/rules/properties/one-variable-per-declaration/definitions/options/items!predicate"
                              1,
                            _js2n__-prdslib.arrays.maxItems 2,
                            _js2n__-prdslib.records.record
                              {
                                options =
                                  _js2n__-prdslib.oneOf
                                      [
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/one-variable-per-declaration/definitions/options!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/one-variable-per-declaration/definitions/options/items!predicate"
                                      ],
                                severity = _js2n__-prdslib.always,
                              } {} false _js2n__-prdslib.never
                          ]
                      ],
                only-arrow-functions =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-refsenv."_js2n__-:definitions/rules/properties/only-arrow-functions/definitions/options/items!predicate"
                              1,
                            _js2n__-prdslib.arrays.maxItems 3,
                            _js2n__-prdslib.arrays.uniqueItems,
                            _js2n__-prdslib.records.record
                              {
                                options =
                                  _js2n__-prdslib.oneOf
                                      [
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/only-arrow-functions/definitions/options!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/only-arrow-functions/definitions/options/items!predicate"
                                      ],
                                severity = _js2n__-prdslib.always,
                              } {} false _js2n__-prdslib.never
                          ]
                      ],
                ordered-imports =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-refsenv."_js2n__-:definitions/rules/properties/ordered-imports/definitions/options/items!predicate"
                              1,
                            _js2n__-prdslib.arrays.maxItems 2,
                            _js2n__-prdslib.records.record
                              {
                                options =
                                  _js2n__-prdslib.oneOf
                                      [
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/ordered-imports/definitions/options!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/ordered-imports/definitions/options/items!predicate"
                                      ],
                                severity = _js2n__-prdslib.always,
                              } {} false _js2n__-prdslib.never
                          ]
                      ],
                prefer-conditional-expression =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-refsenv."_js2n__-:definitions/rules/properties/prefer-conditional-expression/definitions/options/items!predicate"
                              1,
                            _js2n__-prdslib.arrays.maxItems 2,
                            _js2n__-prdslib.records.record
                              {
                                options =
                                  _js2n__-prdslib.oneOf
                                      [
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/prefer-conditional-expression/definitions/options!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/prefer-conditional-expression/definitions/options/items!predicate"
                                      ],
                                severity = _js2n__-prdslib.always,
                              } {} false _js2n__-prdslib.never
                          ]
                      ],
                prefer-const =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-refsenv."_js2n__-:definitions/rules/properties/prefer-const/definitions/options/items!predicate"
                              1,
                            _js2n__-prdslib.arrays.maxItems 2,
                            _js2n__-prdslib.records.record
                              {
                                options =
                                  _js2n__-prdslib.oneOf
                                      [
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/prefer-const/definitions/options!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/prefer-const/definitions/options/items!predicate"
                                      ],
                                severity = _js2n__-prdslib.always,
                              } {} false _js2n__-prdslib.never
                          ]
                      ],
                prefer-for-of =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-prdslib.never 1,
                            _js2n__-prdslib.records.record
                              { severity = _js2n__-prdslib.always, } {} false
                              _js2n__-prdslib.never
                          ]
                      ],
                prefer-function-over-method =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-refsenv."_js2n__-:definitions/rules/properties/prefer-function-over-method/definitions/options/items!predicate"
                              1,
                            _js2n__-prdslib.arrays.maxItems 3,
                            _js2n__-prdslib.arrays.uniqueItems,
                            _js2n__-prdslib.records.record
                              {
                                options =
                                  _js2n__-prdslib.oneOf
                                      [
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/prefer-function-over-method/definitions/options!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/prefer-function-over-method/definitions/options/items!predicate"
                                      ],
                                severity = _js2n__-prdslib.always,
                              } {} false _js2n__-prdslib.never
                          ]
                      ],
                prefer-method-signature =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-prdslib.never 1,
                            _js2n__-prdslib.records.record
                              { severity = _js2n__-prdslib.always, } {} false
                              _js2n__-prdslib.never
                          ]
                      ],
                prefer-object-spread =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-prdslib.never 1,
                            _js2n__-prdslib.records.record
                              { severity = _js2n__-prdslib.always, } {} false
                              _js2n__-prdslib.never
                          ]
                      ],
                prefer-switch =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-refsenv."_js2n__-:definitions/rules/properties/prefer-switch/definitions/options/items!predicate"
                              1,
                            _js2n__-prdslib.arrays.maxItems 2,
                            _js2n__-prdslib.records.record
                              {
                                options =
                                  _js2n__-prdslib.oneOf
                                      [
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/prefer-switch/definitions/options!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/prefer-switch/definitions/options/items!predicate"
                                      ],
                                severity = _js2n__-prdslib.always,
                              } {} false _js2n__-prdslib.never
                          ]
                      ],
                prefer-template =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-refsenv."_js2n__-:definitions/rules/properties/prefer-template/definitions/options/items!predicate"
                              1,
                            _js2n__-prdslib.arrays.maxItems 2,
                            _js2n__-prdslib.records.record
                              {
                                options =
                                  _js2n__-prdslib.oneOf
                                      [
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/prefer-template/definitions/options!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/prefer-template/definitions/options/items!predicate"
                                      ],
                                severity = _js2n__-prdslib.always,
                              } {} false _js2n__-prdslib.never
                          ]
                      ],
                prefer-while =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-prdslib.never 1,
                            _js2n__-prdslib.records.record {} {} false
                              _js2n__-prdslib.never
                          ]
                      ],
                promise-function-async =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-prdslib.never 1,
                            _js2n__-prdslib.records.record
                              { severity = _js2n__-prdslib.always, } {} false
                              _js2n__-prdslib.never
                          ]
                      ],
                quotemark =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-refsenv."_js2n__-:definitions/rules/properties/quotemark/definitions/options/items!predicate"
                              1,
                            _js2n__-prdslib.arrays.maxItems 5,
                            _js2n__-prdslib.arrays.uniqueItems,
                            _js2n__-prdslib.records.record
                              {
                                options =
                                  _js2n__-prdslib.oneOf
                                      [
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/quotemark/definitions/options!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/quotemark/definitions/options/items!predicate"
                                      ],
                                severity = _js2n__-prdslib.always,
                              } {} false _js2n__-prdslib.never
                          ]
                      ],
                radix =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-prdslib.never 1,
                            _js2n__-prdslib.records.record
                              { severity = _js2n__-prdslib.always, } {} false
                              _js2n__-prdslib.never
                          ]
                      ],
                restrict-plus-operands =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-prdslib.never 1,
                            _js2n__-prdslib.records.record
                              { severity = _js2n__-prdslib.always, } {} false
                              _js2n__-prdslib.never
                          ]
                      ],
                return-undefined =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-prdslib.never 1,
                            _js2n__-prdslib.records.record
                              { severity = _js2n__-prdslib.always, } {} false
                              _js2n__-prdslib.never
                          ]
                      ],
                semicolon =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [
                                _js2n__-prdslib.isType '"Bool",
                                _js2n__-refsenv."_js2n__-:definitions/rules/properties/semicolon/definitions/options/items/0!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/rules/properties/semicolon/definitions/options/items/1!predicate"
                              ],
                            _js2n__-prdslib.arrays.maxItems 3,
                            _js2n__-prdslib.records.record
                              {
                                options =
                                  _js2n__-prdslib.oneOf
                                      [
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/semicolon/definitions/options!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/semicolon/definitions/options/items/0!predicate"
                                      ],
                                severity = _js2n__-prdslib.always,
                              } {} false _js2n__-prdslib.never
                          ]
                      ],
                space-before-function-paren =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-refsenv."_js2n__-:definitions/rules/properties/space-before-function-paren/definitions/options/items!predicate"
                              1,
                            _js2n__-prdslib.arrays.maxItems 2,
                            _js2n__-prdslib.records.record
                              {
                                options =
                                  _js2n__-prdslib.oneOf
                                      [
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/space-before-function-paren/definitions/options!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/space-before-function-paren/definitions/options/items!predicate"
                                      ],
                                severity = _js2n__-prdslib.always,
                              } {} false _js2n__-prdslib.never
                          ]
                      ],
                space-within-parens =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-refsenv."_js2n__-:definitions/rules/properties/space-within-parens/definitions/options/items!predicate"
                              1,
                            _js2n__-prdslib.arrays.maxItems 2,
                            _js2n__-prdslib.records.record
                              {
                                options =
                                  _js2n__-prdslib.oneOf
                                      [
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/space-within-parens/definitions/options!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/space-within-parens/definitions/options/items!predicate"
                                      ],
                                severity = _js2n__-prdslib.always,
                              } {} false _js2n__-prdslib.never
                          ]
                      ],
                switch-default =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-prdslib.never 1,
                            _js2n__-prdslib.records.record
                              { severity = _js2n__-prdslib.always, } {} false
                              _js2n__-prdslib.never
                          ]
                      ],
                switch-final-break =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-refsenv."_js2n__-:definitions/rules/properties/switch-final-break/definitions/options/items!predicate"
                              1,
                            _js2n__-prdslib.arrays.maxItems 2,
                            _js2n__-prdslib.records.record
                              {
                                options =
                                  _js2n__-prdslib.oneOf
                                      [
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/switch-final-break/definitions/options!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/switch-final-break/definitions/options/items!predicate"
                                      ],
                                severity = _js2n__-prdslib.always,
                              } {} false _js2n__-prdslib.never
                          ]
                      ],
                trailing-comma =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-refsenv."_js2n__-:definitions/rules/properties/trailing-comma/definitions/options/items!predicate"
                              1,
                            _js2n__-prdslib.arrays.maxItems 2,
                            _js2n__-prdslib.records.record
                              {
                                options =
                                  _js2n__-prdslib.oneOf
                                      [
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/trailing-comma/definitions/options!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/trailing-comma/definitions/options/items!predicate"
                                      ],
                                severity = _js2n__-prdslib.always,
                              } {} false _js2n__-prdslib.never
                          ]
                      ],
                triple-equals =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-refsenv."_js2n__-:definitions/rules/properties/triple-equals/definitions/options/items!predicate"
                              1,
                            _js2n__-prdslib.arrays.maxItems 3,
                            _js2n__-prdslib.arrays.uniqueItems,
                            _js2n__-prdslib.records.record
                              {
                                options =
                                  _js2n__-prdslib.oneOf
                                      [
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/triple-equals/definitions/options!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/triple-equals/definitions/options/items!predicate"
                                      ],
                                severity = _js2n__-prdslib.always,
                              } {} false _js2n__-prdslib.never
                          ]
                      ],
                typeof-compare =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-prdslib.never 1,
                            _js2n__-prdslib.records.record
                              { severity = _js2n__-prdslib.always, } {} false
                              _js2n__-prdslib.never
                          ]
                      ],
                use-isnan =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-prdslib.never 1,
                            _js2n__-prdslib.records.record
                              { severity = _js2n__-prdslib.always, } {} false
                              _js2n__-prdslib.never
                          ]
                      ],
                variable-name =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-refsenv."_js2n__-:definitions/rules/properties/variable-name/definitions/options/items!predicate"
                              1,
                            _js2n__-prdslib.arrays.maxItems 7,
                            _js2n__-prdslib.arrays.uniqueItems,
                            _js2n__-prdslib.records.record
                              {
                                options =
                                  _js2n__-prdslib.oneOf
                                      [
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/variable-name/definitions/options!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/variable-name/definitions/options/items!predicate"
                                      ],
                                severity = _js2n__-prdslib.always,
                              } {} false _js2n__-prdslib.never
                          ]
                      ],
                whitespace =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.arrays.items
                              [ _js2n__-prdslib.isType '"Bool" ],
                            _js2n__-prdslib.arrays.additionalItems
                              _js2n__-refsenv."_js2n__-:definitions/rules/properties/whitespace/definitions/options/items!predicate"
                              1,
                            _js2n__-prdslib.records.record
                              {
                                options =
                                  _js2n__-prdslib.oneOf
                                      [
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/whitespace/definitions/options!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/rules/properties/whitespace/definitions/options/items!predicate"
                                      ],
                                severity = _js2n__-prdslib.always,
                              } {} false _js2n__-prdslib.never
                          ]
                      ],
              } {} true _js2n__-prdslib.always),
      "_js2n__-:definitions/rules!predicate" =
        _js2n__-prdslib.records.record
            {
              align =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-refsenv."_js2n__-:definitions/rules/properties/align/definitions/options/items!predicate"
                            1,
                          _js2n__-prdslib.arrays.maxItems 6,
                          _js2n__-prdslib.arrays.uniqueItems,
                          _js2n__-prdslib.records.record
                            {
                              options =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/align/definitions/options!predicate",
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/align/definitions/options/items!predicate"
                                    ],
                              severity = _js2n__-prdslib.always,
                            } {} false _js2n__-prdslib.never
                        ]
                    ],
              arrow-parens =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-refsenv."_js2n__-:definitions/rules/properties/arrow-parens/definitions/options/items!predicate"
                            1,
                          _js2n__-prdslib.arrays.maxItems 2,
                          _js2n__-prdslib.records.record
                            {
                              options =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/arrow-parens/definitions/options!predicate",
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/arrow-parens/definitions/options/items!predicate"
                                    ],
                              severity = _js2n__-prdslib.always,
                            } {} false _js2n__-prdslib.never
                        ]
                    ],
              arrow-return-shorthand =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-refsenv."_js2n__-:definitions/rules/properties/arrow-return-shorthand/definitions/options/items!predicate"
                            1,
                          _js2n__-prdslib.arrays.maxItems 2,
                          _js2n__-prdslib.records.record
                            {
                              options =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/arrow-return-shorthand/definitions/options!predicate",
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/arrow-return-shorthand/definitions/options/items!predicate"
                                    ],
                              severity = _js2n__-prdslib.always,
                            } {} false _js2n__-prdslib.never
                        ]
                    ],
              ban =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-refsenv."_js2n__-:definitions/rules/properties/ban/definitions/options/items!predicate"
                            1,
                          _js2n__-prdslib.arrays.uniqueItems,
                          _js2n__-prdslib.records.record
                            {
                              options =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/ban/definitions/options!predicate",
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/ban/definitions/options/items!predicate"
                                    ],
                              severity = _js2n__-prdslib.always,
                            } {} false _js2n__-prdslib.never
                        ]
                    ],
              ban-comma-operator =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record
                            { severity = _js2n__-prdslib.always, } {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              binary-expression-operand-order =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record
                            { severity = _js2n__-prdslib.always, } {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              class-name =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record
                            { severity = _js2n__-prdslib.always, } {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              comment-format =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-refsenv."_js2n__-:definitions/rules/properties/comment-format/definitions/options/items!predicate"
                            1,
                          _js2n__-prdslib.arrays.maxItems 5,
                          _js2n__-prdslib.arrays.uniqueItems,
                          _js2n__-prdslib.records.record
                            {
                              options =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/comment-format/definitions/options!predicate",
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/comment-format/definitions/options/items!predicate"
                                    ],
                              severity = _js2n__-prdslib.always,
                            } {} false _js2n__-prdslib.never
                        ]
                    ],
              completed-docs =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-refsenv."_js2n__-:definitions/rules/properties/completed-docs/definitions/options/items!predicate"
                            1,
                          _js2n__-prdslib.arrays.maxItems 11,
                          _js2n__-prdslib.arrays.uniqueItems,
                          _js2n__-prdslib.records.record
                            {
                              options =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/completed-docs/definitions/options!predicate",
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/completed-docs/definitions/options/items!predicate"
                                    ],
                              severity = _js2n__-prdslib.always,
                            } {} false _js2n__-prdslib.never
                        ]
                    ],
              curly =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-refsenv."_js2n__-:definitions/rules/properties/curly/definitions/options/items!predicate"
                            1,
                          _js2n__-prdslib.records.record
                            {
                              options =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/curly/definitions/options!predicate",
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/curly/definitions/options/items!predicate"
                                    ],
                              severity = _js2n__-prdslib.always,
                            } {} false _js2n__-prdslib.never
                        ]
                    ],
              cyclomatic-complexity =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-refsenv."_js2n__-:definitions/rules/properties/cyclomatic-complexity/definitions/options/items!predicate"
                            1,
                          _js2n__-prdslib.arrays.maxItems 2,
                          _js2n__-prdslib.records.record
                            {
                              options =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/cyclomatic-complexity/definitions/options!predicate",
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/cyclomatic-complexity/definitions/options/items!predicate"
                                    ],
                              severity = _js2n__-prdslib.always,
                            } {} false _js2n__-prdslib.never
                        ]
                    ],
              deprecation =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record
                            { severity = _js2n__-prdslib.always, } {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              encoding =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record
                            { severity = _js2n__-prdslib.always, } {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              eofline =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record
                            { severity = _js2n__-prdslib.always, } {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              file-header =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-refsenv."_js2n__-:definitions/rules/properties/file-header/definitions/options/items!predicate"
                            1,
                          _js2n__-prdslib.arrays.maxItems 3,
                          _js2n__-prdslib.records.record
                            {
                              options =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/file-header/definitions/options!predicate",
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/file-header/definitions/options/items!predicate"
                                    ],
                              severity = _js2n__-prdslib.always,
                            } {} false _js2n__-prdslib.never
                        ]
                    ],
              file-name-casing =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.items
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.oneOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/rules/properties/file-name-casing/definitions/file-name-cases!predicate",
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.minProperties 1,
                                  _js2n__-prdslib.records.record {} {} true
                                    _js2n__-refsenv."_js2n__-:definitions/rules/properties/file-name-casing/definitions/file-name-cases!predicate"
                                ]
                            ]
                        ],
                      _js2n__-prdslib.arrays.minItems 2
                    ],
              forin =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record
                            { severity = _js2n__-prdslib.always, } {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              import-blacklist =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-refsenv."_js2n__-:definitions/rules/properties/import-blacklist/definitions/options/items!predicate"
                            1,
                          _js2n__-prdslib.arrays.uniqueItems,
                          _js2n__-prdslib.records.record
                            {
                              options =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/import-blacklist/definitions/options!predicate",
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/import-blacklist/definitions/options/items!predicate"
                                    ],
                              severity = _js2n__-prdslib.always,
                            } {} false _js2n__-prdslib.never
                        ]
                    ],
              import-spacing =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record
                            { severity = _js2n__-prdslib.always, } {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              indent =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-refsenv."_js2n__-:definitions/rules/properties/indent/definitions/options/items/0!predicate",
                              _js2n__-refsenv."_js2n__-:definitions/rules/properties/indent/definitions/options/items/1!predicate"
                            ],
                          _js2n__-prdslib.arrays.maxItems 3,
                          _js2n__-prdslib.records.record
                            {
                              options =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/indent/definitions/options!predicate",
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/indent/definitions/options/items/0!predicate"
                                    ],
                              severity = _js2n__-prdslib.always,
                            } {} false _js2n__-prdslib.never
                        ]
                    ],
              jsdoc-format =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-refsenv."_js2n__-:definitions/rules/properties/jsdoc-format/definitions/options/items!predicate"
                            1,
                          _js2n__-prdslib.records.record
                            {
                              options =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/jsdoc-format/definitions/options!predicate",
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/jsdoc-format/definitions/options/items!predicate"
                                    ],
                              severity = _js2n__-prdslib.always,
                            } {} false _js2n__-prdslib.never
                        ]
                    ],
              label-position =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record
                            { severity = _js2n__-prdslib.always, } {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              linebreak-style =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-refsenv."_js2n__-:definitions/rules/properties/linebreak-style/definitions/options/items!predicate"
                            1,
                          _js2n__-prdslib.arrays.maxItems 2,
                          _js2n__-prdslib.records.record
                            {
                              options =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/linebreak-style/definitions/options!predicate",
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/linebreak-style/definitions/options/items!predicate"
                                    ],
                              severity = _js2n__-prdslib.always,
                            } {} false _js2n__-prdslib.never
                        ]
                    ],
              max-classes-per-file =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-refsenv."_js2n__-:definitions/rules/properties/max-classes-per-file/definitions/options/items/0!predicate",
                              _js2n__-refsenv."_js2n__-:definitions/rules/properties/max-classes-per-file/definitions/options/items/1!predicate"
                            ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 3,
                          _js2n__-prdslib.arrays.maxItems 3,
                          _js2n__-prdslib.arrays.minItems 2,
                          _js2n__-prdslib.records.record
                            {
                              options =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/max-classes-per-file/definitions/options!predicate",
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/max-classes-per-file/definitions/options/items/0!predicate"
                                    ],
                              severity = _js2n__-prdslib.always,
                            } {} false _js2n__-prdslib.never
                        ]
                    ],
              max-file-line-count =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-refsenv."_js2n__-:definitions/rules/properties/max-file-line-count/definitions/options/items!predicate"
                            1,
                          _js2n__-prdslib.arrays.maxItems 2,
                          _js2n__-prdslib.records.record
                            {
                              options =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/max-file-line-count/definitions/options!predicate",
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/max-file-line-count/definitions/options/items!predicate"
                                    ],
                              severity = _js2n__-prdslib.always,
                            } {} false _js2n__-prdslib.never
                        ]
                    ],
              max-line-length =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-refsenv."_js2n__-:definitions/rules/properties/max-line-length/definitions/options/items!predicate"
                            1,
                          _js2n__-prdslib.arrays.maxItems 2,
                          _js2n__-prdslib.records.record
                            {
                              options =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/max-line-length/definitions/options!predicate",
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/max-line-length/definitions/options/items!predicate"
                                    ],
                              severity = _js2n__-prdslib.always,
                            } {} false _js2n__-prdslib.never
                        ]
                    ],
              member-ordering =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-refsenv."_js2n__-:definitions/rules/properties/member-ordering/definitions/options/items!predicate"
                            1,
                          _js2n__-prdslib.arrays.maxItems 2,
                          _js2n__-prdslib.records.record
                            {
                              options =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/member-ordering/definitions/options!predicate",
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/member-ordering/definitions/options/items!predicate"
                                    ],
                              severity = _js2n__-prdslib.always,
                            } {} false _js2n__-prdslib.never
                        ]
                    ],
              new-parens =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record
                            { severity = _js2n__-prdslib.always, } {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              newline-before-return =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record
                            { severity = _js2n__-prdslib.always, } {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              newline-per-chained-call =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record
                            { severity = _js2n__-prdslib.always, } {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              no-arg =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record
                            { severity = _js2n__-prdslib.always, } {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              no-async-without-await =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              no-bitwise =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record
                            { severity = _js2n__-prdslib.always, } {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              no-conditional-assignment =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record
                            { severity = _js2n__-prdslib.always, } {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              no-consecutive-blank-lines =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-consecutive-blank-lines/definitions/options/items!predicate"
                            1,
                          _js2n__-prdslib.arrays.maxItems 2,
                          _js2n__-prdslib.records.record
                            {
                              options =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-consecutive-blank-lines/definitions/options!predicate",
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-consecutive-blank-lines/definitions/options/items!predicate"
                                    ],
                              severity = _js2n__-prdslib.always,
                            } {} false _js2n__-prdslib.never
                        ]
                    ],
              no-console =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-console/definitions/options/items!predicate"
                            1,
                          _js2n__-prdslib.arrays.uniqueItems,
                          _js2n__-prdslib.records.record
                            {
                              options =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-console/definitions/options!predicate",
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-console/definitions/options/items!predicate"
                                    ],
                              severity = _js2n__-prdslib.always,
                            } {} false _js2n__-prdslib.never
                        ]
                    ],
              no-construct =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record
                            { severity = _js2n__-prdslib.always, } {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              no-debugger =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record
                            { severity = _js2n__-prdslib.always, } {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              no-default-export =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record
                            { severity = _js2n__-prdslib.always, } {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              no-duplicate-imports =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-duplicate-imports/definitions/options!predicate"
                            ],
                          _js2n__-prdslib.arrays.maxItems 2,
                          _js2n__-prdslib.records.record
                            {
                              options =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-duplicate-imports/definitions/options!predicate"
                                    ],
                              severity = _js2n__-prdslib.always,
                            } {} false _js2n__-prdslib.never
                        ]
                    ],
              no-duplicate-super =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record
                            { severity = _js2n__-prdslib.always, } {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              no-duplicate-switch-case =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record
                            { severity = _js2n__-prdslib.always, } {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              no-duplicate-variable =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-duplicate-variable/definitions/options/items!predicate"
                            1,
                          _js2n__-prdslib.arrays.maxItems 2,
                          _js2n__-prdslib.records.record
                            {
                              options =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-duplicate-variable/definitions/options!predicate",
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-duplicate-variable/definitions/options/items!predicate"
                                    ],
                              severity = _js2n__-prdslib.always,
                            } {} false _js2n__-prdslib.never
                        ]
                    ],
              no-dynamic-delete =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record
                            { severity = _js2n__-prdslib.always, } {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              no-empty =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-empty/definitions/options/items!predicate"
                            1,
                          _js2n__-prdslib.arrays.maxItems 3,
                          _js2n__-prdslib.arrays.uniqueItems,
                          _js2n__-prdslib.records.record
                            {
                              options =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-empty/definitions/options!predicate",
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-empty/definitions/options/items!predicate"
                                    ],
                              severity = _js2n__-prdslib.always,
                            } {} false _js2n__-prdslib.never
                        ]
                    ],
              no-eval =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record
                            { severity = _js2n__-prdslib.always, } {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              no-for-in =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              no-for-in-array =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record
                            { severity = _js2n__-prdslib.always, } {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              no-implicit-dependencies =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-implicit-dependencies/definitions/options/items/0!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-implicit-dependencies/definitions/options/items/1!predicate"
                              ]) 1,
                          _js2n__-prdslib.arrays.maxItems 3,
                          _js2n__-prdslib.records.record
                            {
                              options =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-implicit-dependencies/definitions/options!predicate",
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-implicit-dependencies/definitions/options/items/0!predicate",
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-implicit-dependencies/definitions/options/items/1!predicate"
                                    ],
                              severity = _js2n__-prdslib.always,
                            } {} false _js2n__-prdslib.never
                        ]
                    ],
              no-import-side-effect =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-import-side-effect/definitions/options/items!predicate"
                            1,
                          _js2n__-prdslib.arrays.maxItems 2,
                          _js2n__-prdslib.records.record
                            {
                              options =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-import-side-effect/definitions/options!predicate",
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-import-side-effect/definitions/options/items!predicate"
                                    ],
                              severity = _js2n__-prdslib.always,
                            } {} false _js2n__-prdslib.never
                        ]
                    ],
              no-invalid-template-strings =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record
                            { severity = _js2n__-prdslib.always, } {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              no-invalid-this =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-invalid-this/definitions/options/items!predicate"
                            1,
                          _js2n__-prdslib.arrays.maxItems 2,
                          _js2n__-prdslib.records.record
                            {
                              options =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-invalid-this/definitions/options!predicate",
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-invalid-this/definitions/options/items!predicate"
                                    ],
                              severity = _js2n__-prdslib.always,
                            } {} false _js2n__-prdslib.never
                        ]
                    ],
              no-irregular-whitespace =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record
                            { severity = _js2n__-prdslib.always, } {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              no-magic-numbers =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-magic-numbers/definitions/options/items!predicate"
                            1,
                          _js2n__-prdslib.arrays.uniqueItems,
                          _js2n__-prdslib.records.record
                            {
                              options =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-magic-numbers/definitions/options!predicate",
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-magic-numbers/definitions/options/items!predicate"
                                    ],
                              severity = _js2n__-prdslib.always,
                            } {} false _js2n__-prdslib.never
                        ]
                    ],
              no-null-keyword =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record
                            { severity = _js2n__-prdslib.always, } {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              no-null-undefined-union =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              no-parameter-reassignment =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record
                            { severity = _js2n__-prdslib.always, } {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              no-reference =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record
                            { severity = _js2n__-prdslib.always, } {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              no-require-imports =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record
                            { severity = _js2n__-prdslib.always, } {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              no-return-await =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record
                            { severity = _js2n__-prdslib.always, } {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              no-shadowed-variable =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-shadowed-variable/definitions/options/items!predicate"
                            1,
                          _js2n__-prdslib.arrays.maxItems 2,
                          _js2n__-prdslib.records.record
                            {
                              options =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-shadowed-variable/definitions/options!predicate",
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-shadowed-variable/definitions/options/items!predicate"
                                    ],
                              severity = _js2n__-prdslib.always,
                            } {} false _js2n__-prdslib.never
                        ]
                    ],
              no-sparse-arrays =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record
                            { severity = _js2n__-prdslib.always, } {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              no-string-literal =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record
                            { severity = _js2n__-prdslib.always, } {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              no-string-throw =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record
                            { severity = _js2n__-prdslib.always, } {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              no-submodule-imports =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-submodule-imports/definitions/options/items!predicate"
                            1,
                          _js2n__-prdslib.arrays.uniqueItems,
                          _js2n__-prdslib.records.record
                            {
                              options =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-submodule-imports/definitions/options!predicate",
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-submodule-imports/definitions/options/items!predicate"
                                    ],
                              severity = _js2n__-prdslib.always,
                            } {} false _js2n__-prdslib.never
                        ]
                    ],
              no-switch-case-fall-through =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record
                            { severity = _js2n__-prdslib.always, } {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              no-this-assignment =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-this-assignment/definitions/options/items!predicate"
                            1,
                          _js2n__-prdslib.arrays.maxItems 2,
                          _js2n__-prdslib.records.record
                            {
                              options =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-this-assignment/definitions/options!predicate",
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-this-assignment/definitions/options/items!predicate"
                                    ],
                              severity = _js2n__-prdslib.always,
                            } {} false _js2n__-prdslib.never
                        ]
                    ],
              no-trailing-whitespace =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-trailing-whitespace/definitions/options/items!predicate"
                            1,
                          _js2n__-prdslib.arrays.maxItems 5,
                          _js2n__-prdslib.arrays.uniqueItems,
                          _js2n__-prdslib.records.record
                            {
                              options =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-trailing-whitespace/definitions/options!predicate",
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-trailing-whitespace/definitions/options/items!predicate"
                                    ],
                              severity = _js2n__-prdslib.always,
                            } {} false _js2n__-prdslib.never
                        ]
                    ],
              no-unnecessary-callback-wrapper =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record
                            { severity = _js2n__-prdslib.always, } {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              no-unnecessary-class =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-unnecessary-class/definitions/options/items!predicate"
                            1,
                          _js2n__-prdslib.arrays.maxItems 4,
                          _js2n__-prdslib.records.record
                            {
                              options =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-unnecessary-class/definitions/options!predicate",
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-unnecessary-class/definitions/options/items!predicate"
                                    ],
                              severity = _js2n__-prdslib.always,
                            } {} false _js2n__-prdslib.never
                        ]
                    ],
              no-unnecessary-initializer =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record
                            { severity = _js2n__-prdslib.always, } {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              no-unsafe-finally =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record
                            { severity = _js2n__-prdslib.always, } {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              no-unused-expression =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-unused-expression/definitions/options/items!predicate"
                            1,
                          _js2n__-prdslib.arrays.maxItems 4,
                          _js2n__-prdslib.arrays.uniqueItems,
                          _js2n__-prdslib.records.record
                            {
                              options =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-unused-expression/definitions/options!predicate",
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-unused-expression/definitions/options/items!predicate"
                                    ],
                              severity = _js2n__-prdslib.always,
                            } {} false _js2n__-prdslib.never
                        ]
                    ],
              no-use-before-declare =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record
                            { severity = _js2n__-prdslib.always, } {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              no-var-keyword =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record
                            { severity = _js2n__-prdslib.always, } {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              no-void-expression =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-void-expression/definitions/options/items!predicate"
                            1,
                          _js2n__-prdslib.arrays.maxItems 2,
                          _js2n__-prdslib.records.record
                            {
                              options =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-void-expression/definitions/options!predicate",
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/no-void-expression/definitions/options/items!predicate"
                                    ],
                              severity = _js2n__-prdslib.always,
                            } {} false _js2n__-prdslib.never
                        ]
                    ],
              number-literal-format =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record
                            { severity = _js2n__-prdslib.always, } {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              object-literal-key-quotes =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-refsenv."_js2n__-:definitions/rules/properties/object-literal-key-quotes/definitions/options/items!predicate"
                            1,
                          _js2n__-prdslib.arrays.maxItems 2,
                          _js2n__-prdslib.records.record
                            {
                              options =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/object-literal-key-quotes/definitions/options!predicate",
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/object-literal-key-quotes/definitions/options/items!predicate"
                                    ],
                              severity = _js2n__-prdslib.always,
                            } {} false _js2n__-prdslib.never
                        ]
                    ],
              object-literal-shorthand =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-refsenv."_js2n__-:definitions/rules/properties/object-literal-shorthand/definitions/options/items!predicate"
                            1,
                          _js2n__-prdslib.records.record
                            {
                              options =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/object-literal-shorthand/definitions/options!predicate",
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/object-literal-shorthand/definitions/options/items!predicate"
                                    ],
                              severity = _js2n__-prdslib.always,
                            } {} false _js2n__-prdslib.never
                        ]
                    ],
              object-literal-sort-keys =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-refsenv."_js2n__-:definitions/rules/properties/object-literal-sort-keys/definitions/options/items!predicate"
                            1,
                          _js2n__-prdslib.arrays.maxItems 5,
                          _js2n__-prdslib.arrays.uniqueItems,
                          _js2n__-prdslib.records.record
                            {
                              options =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/object-literal-sort-keys/definitions/options!predicate",
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/object-literal-sort-keys/definitions/options/items!predicate"
                                    ],
                              severity = _js2n__-prdslib.always,
                            } {} false _js2n__-prdslib.never
                        ]
                    ],
              one-line =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-refsenv."_js2n__-:definitions/rules/properties/one-line/definitions/options/items!predicate"
                            1,
                          _js2n__-prdslib.arrays.maxItems 6,
                          _js2n__-prdslib.arrays.uniqueItems,
                          _js2n__-prdslib.records.record
                            {
                              options =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/one-line/definitions/options!predicate",
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/one-line/definitions/options/items!predicate"
                                    ],
                              severity = _js2n__-prdslib.always,
                            } {} false _js2n__-prdslib.never
                        ]
                    ],
              one-variable-per-declaration =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-refsenv."_js2n__-:definitions/rules/properties/one-variable-per-declaration/definitions/options/items!predicate"
                            1,
                          _js2n__-prdslib.arrays.maxItems 2,
                          _js2n__-prdslib.records.record
                            {
                              options =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/one-variable-per-declaration/definitions/options!predicate",
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/one-variable-per-declaration/definitions/options/items!predicate"
                                    ],
                              severity = _js2n__-prdslib.always,
                            } {} false _js2n__-prdslib.never
                        ]
                    ],
              only-arrow-functions =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-refsenv."_js2n__-:definitions/rules/properties/only-arrow-functions/definitions/options/items!predicate"
                            1,
                          _js2n__-prdslib.arrays.maxItems 3,
                          _js2n__-prdslib.arrays.uniqueItems,
                          _js2n__-prdslib.records.record
                            {
                              options =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/only-arrow-functions/definitions/options!predicate",
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/only-arrow-functions/definitions/options/items!predicate"
                                    ],
                              severity = _js2n__-prdslib.always,
                            } {} false _js2n__-prdslib.never
                        ]
                    ],
              ordered-imports =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-refsenv."_js2n__-:definitions/rules/properties/ordered-imports/definitions/options/items!predicate"
                            1,
                          _js2n__-prdslib.arrays.maxItems 2,
                          _js2n__-prdslib.records.record
                            {
                              options =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/ordered-imports/definitions/options!predicate",
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/ordered-imports/definitions/options/items!predicate"
                                    ],
                              severity = _js2n__-prdslib.always,
                            } {} false _js2n__-prdslib.never
                        ]
                    ],
              prefer-conditional-expression =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-refsenv."_js2n__-:definitions/rules/properties/prefer-conditional-expression/definitions/options/items!predicate"
                            1,
                          _js2n__-prdslib.arrays.maxItems 2,
                          _js2n__-prdslib.records.record
                            {
                              options =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/prefer-conditional-expression/definitions/options!predicate",
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/prefer-conditional-expression/definitions/options/items!predicate"
                                    ],
                              severity = _js2n__-prdslib.always,
                            } {} false _js2n__-prdslib.never
                        ]
                    ],
              prefer-const =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-refsenv."_js2n__-:definitions/rules/properties/prefer-const/definitions/options/items!predicate"
                            1,
                          _js2n__-prdslib.arrays.maxItems 2,
                          _js2n__-prdslib.records.record
                            {
                              options =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/prefer-const/definitions/options!predicate",
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/prefer-const/definitions/options/items!predicate"
                                    ],
                              severity = _js2n__-prdslib.always,
                            } {} false _js2n__-prdslib.never
                        ]
                    ],
              prefer-for-of =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record
                            { severity = _js2n__-prdslib.always, } {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              prefer-function-over-method =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-refsenv."_js2n__-:definitions/rules/properties/prefer-function-over-method/definitions/options/items!predicate"
                            1,
                          _js2n__-prdslib.arrays.maxItems 3,
                          _js2n__-prdslib.arrays.uniqueItems,
                          _js2n__-prdslib.records.record
                            {
                              options =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/prefer-function-over-method/definitions/options!predicate",
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/prefer-function-over-method/definitions/options/items!predicate"
                                    ],
                              severity = _js2n__-prdslib.always,
                            } {} false _js2n__-prdslib.never
                        ]
                    ],
              prefer-method-signature =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record
                            { severity = _js2n__-prdslib.always, } {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              prefer-object-spread =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record
                            { severity = _js2n__-prdslib.always, } {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              prefer-switch =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-refsenv."_js2n__-:definitions/rules/properties/prefer-switch/definitions/options/items!predicate"
                            1,
                          _js2n__-prdslib.arrays.maxItems 2,
                          _js2n__-prdslib.records.record
                            {
                              options =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/prefer-switch/definitions/options!predicate",
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/prefer-switch/definitions/options/items!predicate"
                                    ],
                              severity = _js2n__-prdslib.always,
                            } {} false _js2n__-prdslib.never
                        ]
                    ],
              prefer-template =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-refsenv."_js2n__-:definitions/rules/properties/prefer-template/definitions/options/items!predicate"
                            1,
                          _js2n__-prdslib.arrays.maxItems 2,
                          _js2n__-prdslib.records.record
                            {
                              options =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/prefer-template/definitions/options!predicate",
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/prefer-template/definitions/options/items!predicate"
                                    ],
                              severity = _js2n__-prdslib.always,
                            } {} false _js2n__-prdslib.never
                        ]
                    ],
              prefer-while =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              promise-function-async =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record
                            { severity = _js2n__-prdslib.always, } {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              quotemark =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-refsenv."_js2n__-:definitions/rules/properties/quotemark/definitions/options/items!predicate"
                            1,
                          _js2n__-prdslib.arrays.maxItems 5,
                          _js2n__-prdslib.arrays.uniqueItems,
                          _js2n__-prdslib.records.record
                            {
                              options =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/quotemark/definitions/options!predicate",
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/quotemark/definitions/options/items!predicate"
                                    ],
                              severity = _js2n__-prdslib.always,
                            } {} false _js2n__-prdslib.never
                        ]
                    ],
              radix =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record
                            { severity = _js2n__-prdslib.always, } {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              restrict-plus-operands =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record
                            { severity = _js2n__-prdslib.always, } {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              return-undefined =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record
                            { severity = _js2n__-prdslib.always, } {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              semicolon =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-refsenv."_js2n__-:definitions/rules/properties/semicolon/definitions/options/items/0!predicate",
                              _js2n__-refsenv."_js2n__-:definitions/rules/properties/semicolon/definitions/options/items/1!predicate"
                            ],
                          _js2n__-prdslib.arrays.maxItems 3,
                          _js2n__-prdslib.records.record
                            {
                              options =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/semicolon/definitions/options!predicate",
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/semicolon/definitions/options/items/0!predicate"
                                    ],
                              severity = _js2n__-prdslib.always,
                            } {} false _js2n__-prdslib.never
                        ]
                    ],
              space-before-function-paren =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-refsenv."_js2n__-:definitions/rules/properties/space-before-function-paren/definitions/options/items!predicate"
                            1,
                          _js2n__-prdslib.arrays.maxItems 2,
                          _js2n__-prdslib.records.record
                            {
                              options =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/space-before-function-paren/definitions/options!predicate",
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/space-before-function-paren/definitions/options/items!predicate"
                                    ],
                              severity = _js2n__-prdslib.always,
                            } {} false _js2n__-prdslib.never
                        ]
                    ],
              space-within-parens =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-refsenv."_js2n__-:definitions/rules/properties/space-within-parens/definitions/options/items!predicate"
                            1,
                          _js2n__-prdslib.arrays.maxItems 2,
                          _js2n__-prdslib.records.record
                            {
                              options =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/space-within-parens/definitions/options!predicate",
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/space-within-parens/definitions/options/items!predicate"
                                    ],
                              severity = _js2n__-prdslib.always,
                            } {} false _js2n__-prdslib.never
                        ]
                    ],
              switch-default =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record
                            { severity = _js2n__-prdslib.always, } {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              switch-final-break =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-refsenv."_js2n__-:definitions/rules/properties/switch-final-break/definitions/options/items!predicate"
                            1,
                          _js2n__-prdslib.arrays.maxItems 2,
                          _js2n__-prdslib.records.record
                            {
                              options =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/switch-final-break/definitions/options!predicate",
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/switch-final-break/definitions/options/items!predicate"
                                    ],
                              severity = _js2n__-prdslib.always,
                            } {} false _js2n__-prdslib.never
                        ]
                    ],
              trailing-comma =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-refsenv."_js2n__-:definitions/rules/properties/trailing-comma/definitions/options/items!predicate"
                            1,
                          _js2n__-prdslib.arrays.maxItems 2,
                          _js2n__-prdslib.records.record
                            {
                              options =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/trailing-comma/definitions/options!predicate",
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/trailing-comma/definitions/options/items!predicate"
                                    ],
                              severity = _js2n__-prdslib.always,
                            } {} false _js2n__-prdslib.never
                        ]
                    ],
              triple-equals =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-refsenv."_js2n__-:definitions/rules/properties/triple-equals/definitions/options/items!predicate"
                            1,
                          _js2n__-prdslib.arrays.maxItems 3,
                          _js2n__-prdslib.arrays.uniqueItems,
                          _js2n__-prdslib.records.record
                            {
                              options =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/triple-equals/definitions/options!predicate",
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/triple-equals/definitions/options/items!predicate"
                                    ],
                              severity = _js2n__-prdslib.always,
                            } {} false _js2n__-prdslib.never
                        ]
                    ],
              typeof-compare =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record
                            { severity = _js2n__-prdslib.always, } {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              use-isnan =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record
                            { severity = _js2n__-prdslib.always, } {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              variable-name =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-refsenv."_js2n__-:definitions/rules/properties/variable-name/definitions/options/items!predicate"
                            1,
                          _js2n__-prdslib.arrays.maxItems 7,
                          _js2n__-prdslib.arrays.uniqueItems,
                          _js2n__-prdslib.records.record
                            {
                              options =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/variable-name/definitions/options!predicate",
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/variable-name/definitions/options/items!predicate"
                                    ],
                              severity = _js2n__-prdslib.always,
                            } {} false _js2n__-prdslib.never
                        ]
                    ],
              whitespace =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-refsenv."_js2n__-:definitions/rules/properties/whitespace/definitions/options/items!predicate"
                            1,
                          _js2n__-prdslib.records.record
                            {
                              options =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/whitespace/definitions/options!predicate",
                                      _js2n__-refsenv."_js2n__-:definitions/rules/properties/whitespace/definitions/options/items!predicate"
                                    ],
                              severity = _js2n__-prdslib.always,
                            } {} false _js2n__-prdslib.never
                        ]
                    ],
            } {} true _js2n__-prdslib.always,
      "_js2n__-:definitions/rules/properties/align/definitions/options!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.enum
                      [
                        "arguments",
                        "elements",
                        "members",
                        "parameters",
                        "statements"
                      ]
                  ]),
              _js2n__-prdslib.arrays.maxItems 5,
              _js2n__-prdslib.arrays.minItems 1,
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/rules/properties/align/definitions/options/items!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "arguments",
                  "elements",
                  "members",
                  "parameters",
                  "statements"
                ]
            ],
      "_js2n__-:definitions/rules/properties/arrow-parens/definitions/options!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.enum [ "ban-single-arg-parens" ]
                  ]),
              _js2n__-prdslib.arrays.maxItems 1,
              _js2n__-prdslib.arrays.minItems 1
            ],
      "_js2n__-:definitions/rules/properties/arrow-parens/definitions/options/items!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "ban-single-arg-parens" ]
            ],
      "_js2n__-:definitions/rules/properties/arrow-return-shorthand/definitions/options!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.enum [ "multiline" ]
                  ]),
              _js2n__-prdslib.arrays.maxItems 1,
              _js2n__-prdslib.arrays.minItems 1
            ],
      "_js2n__-:definitions/rules/properties/arrow-return-shorthand/definitions/options/items!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "multiline" ]
            ],
      "_js2n__-:definitions/rules/properties/ban/definitions/options!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"Array",
                        _js2n__-prdslib.arrays.arrayOf
                          (_js2n__-prdslib.isType '"String"),
                        _js2n__-prdslib.arrays.maxItems 3,
                        _js2n__-prdslib.arrays.minItems 1
                      ],
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.required [ "name" ],
                        _js2n__-prdslib.records.record
                          {
                            message = _js2n__-prdslib.isType '"String",
                            name =
                              _js2n__-prdslib.anyOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType '"Array",
                                        _js2n__-prdslib.arrays.arrayOf
                                          (_js2n__-prdslib.isType '"String"),
                                        _js2n__-prdslib.arrays.maxItems 3,
                                        _js2n__-prdslib.arrays.minItems 1
                                      ]
                                  ],
                          } {} false _js2n__-prdslib.never
                      ]
                  ]),
              _js2n__-prdslib.arrays.minItems 1,
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/rules/properties/ban/definitions/options/items!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.isType '"String"),
                  _js2n__-prdslib.arrays.maxItems 3,
                  _js2n__-prdslib.arrays.minItems 1
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "name" ],
                  _js2n__-prdslib.records.record
                    {
                      message = _js2n__-prdslib.isType '"String",
                      name =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    (_js2n__-prdslib.isType '"String"),
                                  _js2n__-prdslib.arrays.maxItems 3,
                                  _js2n__-prdslib.arrays.minItems 1
                                ]
                            ],
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:definitions/rules/properties/comment-format/definitions/options!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.enum
                          [
                            "check-space",
                            "check-lowercase",
                            "check-uppercase"
                          ],
                        _js2n__-prdslib.arrays.maxItems 3,
                        _js2n__-prdslib.arrays.minItems 1,
                        _js2n__-prdslib.arrays.uniqueItems
                      ],
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.maxProperties 1,
                        _js2n__-prdslib.records.minProperties 1,
                        _js2n__-prdslib.records.record
                          {
                            ignore-pattern = _js2n__-prdslib.isType '"String",
                            ignore-words =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"Array",
                                    _js2n__-prdslib.arrays.arrayOf
                                      (_js2n__-prdslib.isType '"String"),
                                    _js2n__-prdslib.arrays.uniqueItems
                                  ],
                          } {} true _js2n__-prdslib.always
                      ]
                  ]),
              _js2n__-prdslib.arrays.maxItems 4,
              _js2n__-prdslib.arrays.minItems 1,
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/rules/properties/comment-format/definitions/options/items!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum
                    [ "check-space", "check-lowercase", "check-uppercase" ],
                  _js2n__-prdslib.arrays.maxItems 3,
                  _js2n__-prdslib.arrays.minItems 1,
                  _js2n__-prdslib.arrays.uniqueItems
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.maxProperties 1,
                  _js2n__-prdslib.records.minProperties 1,
                  _js2n__-prdslib.records.record
                    {
                      ignore-pattern = _js2n__-prdslib.isType '"String",
                      ignore-words =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String"),
                              _js2n__-prdslib.arrays.uniqueItems
                            ],
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/rules/properties/completed-docs/definitions/options!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.oneOf
                  [
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.enum
                          [
                            "classes",
                            "enums",
                            "enum-members",
                            "functions",
                            "interfaces",
                            "methods",
                            "namespaces",
                            "properties",
                            "types",
                            "variables"
                          ]
                      ],
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.record
                          {
                            classes =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.record
                                      {
                                        visibilities =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [
                                                    "all",
                                                    "exported",
                                                    "internal"
                                                  ]
                                              ],
                                      } {} false _js2n__-prdslib.never
                                  ],
                            enum-members =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.record
                                      {
                                        visibilities =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [
                                                    "all",
                                                    "exported",
                                                    "internal"
                                                  ]
                                              ],
                                      } {} false _js2n__-prdslib.never
                                  ],
                            enums =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.record
                                      {
                                        visibilities =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [
                                                    "all",
                                                    "exported",
                                                    "internal"
                                                  ]
                                              ],
                                      } {} false _js2n__-prdslib.never
                                  ],
                            functions =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.record
                                      {
                                        visibilities =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [
                                                    "all",
                                                    "exported",
                                                    "internal"
                                                  ]
                                              ],
                                      } {} false _js2n__-prdslib.never
                                  ],
                            interfaces =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.record
                                      {
                                        visibilities =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [
                                                    "all",
                                                    "exported",
                                                    "internal"
                                                  ]
                                              ],
                                      } {} false _js2n__-prdslib.never
                                  ],
                            methods =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.record
                                      {
                                        locations =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [
                                                    "all",
                                                    "instance",
                                                    "static"
                                                  ]
                                              ],
                                        privacies =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [
                                                    "all",
                                                    "private",
                                                    "protected",
                                                    "public"
                                                  ]
                                              ],
                                      } {} false _js2n__-prdslib.never
                                  ],
                            namespaces =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.record
                                      {
                                        visibilities =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [
                                                    "all",
                                                    "exported",
                                                    "internal"
                                                  ]
                                              ],
                                      } {} false _js2n__-prdslib.never
                                  ],
                            properties =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.record
                                      {
                                        locations =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [
                                                    "all",
                                                    "instance",
                                                    "static"
                                                  ]
                                              ],
                                        privacies =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [
                                                    "all",
                                                    "private",
                                                    "protected",
                                                    "public"
                                                  ]
                                              ],
                                      } {} false _js2n__-prdslib.never
                                  ],
                            types =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.record
                                      {
                                        visibilities =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [
                                                    "all",
                                                    "exported",
                                                    "internal"
                                                  ]
                                              ],
                                      } {} false _js2n__-prdslib.never
                                  ],
                            variables =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.record
                                      {
                                        visibilities =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [
                                                    "all",
                                                    "exported",
                                                    "internal"
                                                  ]
                                              ],
                                      } {} false _js2n__-prdslib.never
                                  ],
                          } {} true _js2n__-prdslib.always
                      ]
                  ]),
              _js2n__-prdslib.arrays.maxItems 10,
              _js2n__-prdslib.arrays.minItems 1,
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/rules/properties/completed-docs/definitions/options/items!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum
                    [
                      "classes",
                      "enums",
                      "enum-members",
                      "functions",
                      "interfaces",
                      "methods",
                      "namespaces",
                      "properties",
                      "types",
                      "variables"
                    ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      classes =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  visibilities =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.enum
                                            [ "all", "exported", "internal" ]
                                        ],
                                } {} false _js2n__-prdslib.never
                            ],
                      enum-members =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  visibilities =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.enum
                                            [ "all", "exported", "internal" ]
                                        ],
                                } {} false _js2n__-prdslib.never
                            ],
                      enums =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  visibilities =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.enum
                                            [ "all", "exported", "internal" ]
                                        ],
                                } {} false _js2n__-prdslib.never
                            ],
                      functions =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  visibilities =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.enum
                                            [ "all", "exported", "internal" ]
                                        ],
                                } {} false _js2n__-prdslib.never
                            ],
                      interfaces =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  visibilities =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.enum
                                            [ "all", "exported", "internal" ]
                                        ],
                                } {} false _js2n__-prdslib.never
                            ],
                      methods =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  locations =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.enum
                                            [ "all", "instance", "static" ]
                                        ],
                                  privacies =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.enum
                                            [
                                              "all",
                                              "private",
                                              "protected",
                                              "public"
                                            ]
                                        ],
                                } {} false _js2n__-prdslib.never
                            ],
                      namespaces =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  visibilities =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.enum
                                            [ "all", "exported", "internal" ]
                                        ],
                                } {} false _js2n__-prdslib.never
                            ],
                      properties =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  locations =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.enum
                                            [ "all", "instance", "static" ]
                                        ],
                                  privacies =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.enum
                                            [
                                              "all",
                                              "private",
                                              "protected",
                                              "public"
                                            ]
                                        ],
                                } {} false _js2n__-prdslib.never
                            ],
                      types =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  visibilities =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.enum
                                            [ "all", "exported", "internal" ]
                                        ],
                                } {} false _js2n__-prdslib.never
                            ],
                      variables =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  visibilities =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.enum
                                            [ "all", "exported", "internal" ]
                                        ],
                                } {} false _js2n__-prdslib.never
                            ],
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/rules/properties/curly/definitions/options!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.enum [ "as-needed", "ignore-same-line" ],
                    _js2n__-prdslib.arrays.maxItems 2,
                    _js2n__-prdslib.arrays.minItems 1,
                    _js2n__-prdslib.arrays.uniqueItems
                  ])
            ],
      "_js2n__-:definitions/rules/properties/curly/definitions/options/items!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "as-needed", "ignore-same-line" ],
              _js2n__-prdslib.arrays.maxItems 2,
              _js2n__-prdslib.arrays.minItems 1,
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/rules/properties/cyclomatic-complexity/definitions/options!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"Number",
                    _js2n__-prdslib.numbers.minimum 2
                  ]),
              _js2n__-prdslib.arrays.maxItems 1,
              _js2n__-prdslib.arrays.minItems 1
            ],
      "_js2n__-:definitions/rules/properties/cyclomatic-complexity/definitions/options/items!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Number",
              _js2n__-prdslib.numbers.minimum 2
            ],
      "_js2n__-:definitions/rules/properties/file-header/definitions/options!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String"),
              _js2n__-prdslib.arrays.maxItems 2,
              _js2n__-prdslib.arrays.minItems 1
            ],
      "_js2n__-:definitions/rules/properties/file-header/definitions/options/items!predicate" =
        _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/rules/properties/file-name-casing/definitions/file-name-cases!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [ "camel-case", "pascal-case", "kebab-case", "snake-case" ]
            ],
      "_js2n__-:definitions/rules/properties/import-blacklist/definitions/options!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.oneOf
                  [
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.strings.minLength 1
                      ],
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.record {} {} true
                          (_js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.strings.minLength 1
                                  ]),
                              _js2n__-prdslib.arrays.minItems 1
                            ])
                      ],
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"Array",
                        _js2n__-prdslib.strings.minLength 1,
                        _js2n__-prdslib.arrays.arrayOf
                          (_js2n__-prdslib.isType '"String")
                      ]
                  ]),
              _js2n__-prdslib.arrays.minItems 1,
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/rules/properties/import-blacklist/definitions/options/items!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.minLength 1
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record {} {} true
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"Array",
                        _js2n__-prdslib.arrays.arrayOf
                          (_js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.strings.minLength 1
                            ]),
                        _js2n__-prdslib.arrays.minItems 1
                      ])
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.strings.minLength 1,
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.isType '"String")
                ]
            ],
      "_js2n__-:definitions/rules/properties/indent/definitions/options!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.items
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum [ "tabs", "spaces" ]
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Number",
                      _js2n__-prdslib.enum [ 2, 4 ]
                    ]
                ],
              _js2n__-prdslib.arrays.maxItems 2,
              _js2n__-prdslib.arrays.minItems 1
            ],
      "_js2n__-:definitions/rules/properties/indent/definitions/options/items/0!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "tabs", "spaces" ]
            ],
      "_js2n__-:definitions/rules/properties/indent/definitions/options/items/1!predicate" =
        _js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType '"Number", _js2n__-prdslib.enum [ 2, 4 ] ],
      "_js2n__-:definitions/rules/properties/jsdoc-format/definitions/options!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.enum [ "check-multiline-start" ]
                  ]),
              _js2n__-prdslib.arrays.maxItems 1,
              _js2n__-prdslib.arrays.minItems 0,
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/rules/properties/jsdoc-format/definitions/options/items!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "check-multiline-start" ]
            ],
      "_js2n__-:definitions/rules/properties/linebreak-style/definitions/options!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.enum [ "LF", "CRLF" ]
                  ]),
              _js2n__-prdslib.arrays.maxItems 1,
              _js2n__-prdslib.arrays.minItems 1
            ],
      "_js2n__-:definitions/rules/properties/linebreak-style/definitions/options/items!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "LF", "CRLF" ]
            ],
      "_js2n__-:definitions/rules/properties/max-classes-per-file/definitions/options!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.items
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Number",
                      _js2n__-prdslib.numbers.minimum 1
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum [ "exclude-class-expressions" ]
                    ]
                ],
              _js2n__-prdslib.arrays.maxItems 2,
              _js2n__-prdslib.arrays.minItems 1
            ],
      "_js2n__-:definitions/rules/properties/max-classes-per-file/definitions/options/items/0!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Number",
              _js2n__-prdslib.numbers.minimum 1
            ],
      "_js2n__-:definitions/rules/properties/max-classes-per-file/definitions/options/items/1!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "exclude-class-expressions" ]
            ],
      "_js2n__-:definitions/rules/properties/max-file-line-count/definitions/options!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"Number",
                    _js2n__-prdslib.numbers.minimum 1
                  ]),
              _js2n__-prdslib.arrays.maxItems 1,
              _js2n__-prdslib.arrays.minItems 1
            ],
      "_js2n__-:definitions/rules/properties/max-file-line-count/definitions/options/items!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Number",
              _js2n__-prdslib.numbers.minimum 1
            ],
      "_js2n__-:definitions/rules/properties/max-line-length/definitions/options!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.strings.maxLength 2,
              _js2n__-prdslib.strings.minLength 1,
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.oneOf
                  [
                    _js2n__-prdslib.isType '"Number",
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.record
                          {
                            check-regex = _js2n__-prdslib.isType '"Bool",
                            check-strings = _js2n__-prdslib.isType '"Bool",
                            ignore-pattern = _js2n__-prdslib.isType '"String",
                            limit = _js2n__-prdslib.isType '"Number",
                          } {} false _js2n__-prdslib.never
                      ]
                  ])
            ],
      "_js2n__-:definitions/rules/properties/max-line-length/definitions/options/items!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.isType '"Number",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      check-regex = _js2n__-prdslib.isType '"Bool",
                      check-strings = _js2n__-prdslib.isType '"Bool",
                      ignore-pattern = _js2n__-prdslib.isType '"String",
                      limit = _js2n__-prdslib.isType '"Number",
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:definitions/rules/properties/member-ordering/definitions/kinds!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.enum
                      [
                        "static-field",
                        "instance-field",
                        "static-method",
                        "instance-method",
                        "constructor",
                        "public-static-field",
                        "public-static-method",
                        "protected-static-field",
                        "protected-static-method",
                        "private-static-field",
                        "private-static-method",
                        "public-instance-field",
                        "protected-instance-field",
                        "private-instance-field",
                        "public-constructor",
                        "protected-constructor",
                        "private-constructor",
                        "public-instance-method",
                        "protected-instance-method",
                        "private-instance-method",
                        "public-static-accessor",
                        "protected-static-accessor",
                        "private-static-accessor",
                        "public-instance-accessor",
                        "protected-instance-accessor",
                        "private-instance-accessor"
                      ]
                  ]),
              _js2n__-prdslib.arrays.maxItems 15,
              _js2n__-prdslib.arrays.minItems 1,
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/rules/properties/member-ordering/definitions/kinds/items!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "static-field",
                  "instance-field",
                  "static-method",
                  "instance-method",
                  "constructor",
                  "public-static-field",
                  "public-static-method",
                  "protected-static-field",
                  "protected-static-method",
                  "private-static-field",
                  "private-static-method",
                  "public-instance-field",
                  "protected-instance-field",
                  "private-instance-field",
                  "public-constructor",
                  "protected-constructor",
                  "private-constructor",
                  "public-instance-method",
                  "protected-instance-method",
                  "private-instance-method",
                  "public-static-accessor",
                  "protected-static-accessor",
                  "private-static-accessor",
                  "public-instance-accessor",
                  "protected-instance-accessor",
                  "private-instance-accessor"
                ]
            ],
      "_js2n__-:definitions/rules/properties/member-ordering/definitions/options!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        alphabetize = _js2n__-prdslib.isType '"Bool",
                        order =
                          _js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.enum
                                      [
                                        "fields-first",
                                        "instance-sandwich",
                                        "statics-first"
                                      ]
                                  ],
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"Array",
                                    _js2n__-prdslib.arrays.arrayOf
                                      (_js2n__-prdslib.anyOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/rules/properties/member-ordering/definitions/kinds/items!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record
                                                {
                                                  kinds =
                                                    _js2n__-refsenv."_js2n__-:definitions/rules/properties/member-ordering/definitions/kinds!predicate",
                                                  name =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                } {} false _js2n__-prdslib.never
                                            ]
                                        ]),
                                    _js2n__-prdslib.arrays.maxItems 15,
                                    _js2n__-prdslib.arrays.minItems 1,
                                    _js2n__-prdslib.arrays.uniqueItems
                                  ]
                              ],
                      } {} false _js2n__-prdslib.never
                  ]),
              _js2n__-prdslib.arrays.maxItems 1,
              _js2n__-prdslib.arrays.minItems 1
            ],
      "_js2n__-:definitions/rules/properties/member-ordering/definitions/options/items!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  alphabetize = _js2n__-prdslib.isType '"Bool",
                  order =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [
                                  "fields-first",
                                  "instance-sandwich",
                                  "statics-first"
                                ]
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/rules/properties/member-ordering/definitions/kinds/items!predicate",
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Record,
                                        _js2n__-prdslib.records.record
                                          {
                                            kinds =
                                              _js2n__-refsenv."_js2n__-:definitions/rules/properties/member-ordering/definitions/kinds!predicate",
                                            name =
                                              _js2n__-prdslib.isType '"String",
                                          } {} false _js2n__-prdslib.never
                                      ]
                                  ]),
                              _js2n__-prdslib.arrays.maxItems 15,
                              _js2n__-prdslib.arrays.minItems 1,
                              _js2n__-prdslib.arrays.uniqueItems
                            ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/rules/properties/no-consecutive-blank-lines/definitions/options!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"Number",
                    _js2n__-prdslib.numbers.minimum 1
                  ]),
              _js2n__-prdslib.arrays.maxItems 1,
              _js2n__-prdslib.arrays.minItems 1
            ],
      "_js2n__-:definitions/rules/properties/no-consecutive-blank-lines/definitions/options/items!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Number",
              _js2n__-prdslib.numbers.minimum 1
            ],
      "_js2n__-:definitions/rules/properties/no-console/definitions/options!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String"),
              _js2n__-prdslib.arrays.minItems 1,
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/rules/properties/no-console/definitions/options/items!predicate" =
        _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/rules/properties/no-duplicate-imports/definitions/options!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { allow-namespace-imports = _js2n__-prdslib.isType '"Bool", } {}
                false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/rules/properties/no-duplicate-variable/definitions/options!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.enum [ "check-parameters" ]
                  ]),
              _js2n__-prdslib.arrays.maxItems 1,
              _js2n__-prdslib.arrays.minItems 1
            ],
      "_js2n__-:definitions/rules/properties/no-duplicate-variable/definitions/options/items!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "check-parameters" ]
            ],
      "_js2n__-:definitions/rules/properties/no-empty/definitions/options!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.enum
                      [ "allow-empty-catch", "allow-empty-functions" ]
                  ]),
              _js2n__-prdslib.arrays.maxItems 2,
              _js2n__-prdslib.arrays.minItems 1,
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/rules/properties/no-empty/definitions/options/items!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [ "allow-empty-catch", "allow-empty-functions" ]
            ],
      "_js2n__-:definitions/rules/properties/no-implicit-dependencies/definitions/options!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.items
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum [ "dev", "optional" ]
                    ],
                  _js2n__-prdslib.isType '"Array"
                ],
              _js2n__-prdslib.arrays.maxItems 3,
              _js2n__-prdslib.arrays.minItems 0
            ],
      "_js2n__-:definitions/rules/properties/no-implicit-dependencies/definitions/options/items/0!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "dev", "optional" ]
            ],
      "_js2n__-:definitions/rules/properties/no-implicit-dependencies/definitions/options/items/1!predicate" =
        _js2n__-prdslib.isType '"Array",
      "_js2n__-:definitions/rules/properties/no-import-side-effect/definitions/options!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      { ignore-module = _js2n__-prdslib.isType '"String", } {}
                      false _js2n__-prdslib.never
                  ]),
              _js2n__-prdslib.arrays.maxItems 1,
              _js2n__-prdslib.arrays.minItems 1
            ],
      "_js2n__-:definitions/rules/properties/no-import-side-effect/definitions/options/items!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { ignore-module = _js2n__-prdslib.isType '"String", } {} false
                _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/rules/properties/no-invalid-this/definitions/options!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.enum [ "check-function-in-method" ]
                  ]),
              _js2n__-prdslib.arrays.maxItems 1,
              _js2n__-prdslib.arrays.minItems 1
            ],
      "_js2n__-:definitions/rules/properties/no-invalid-this/definitions/options/items!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "check-function-in-method" ]
            ],
      "_js2n__-:definitions/rules/properties/no-magic-numbers/definitions/options!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"Number"),
              _js2n__-prdslib.arrays.minItems 1,
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/rules/properties/no-magic-numbers/definitions/options/items!predicate" =
        _js2n__-prdslib.isType '"Number",
      "_js2n__-:definitions/rules/properties/no-shadowed-variable/definitions/options!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        class = _js2n__-prdslib.isType '"Bool",
                        enum = _js2n__-prdslib.isType '"Bool",
                        function = _js2n__-prdslib.isType '"Bool",
                        "import" = _js2n__-prdslib.isType '"Bool",
                        interface = _js2n__-prdslib.isType '"Bool",
                        namespace = _js2n__-prdslib.isType '"Bool",
                        typeAlias = _js2n__-prdslib.isType '"Bool",
                        typeParameter = _js2n__-prdslib.isType '"Bool",
                      } {} false _js2n__-prdslib.never
                  ]),
              _js2n__-prdslib.arrays.maxItems 1,
              _js2n__-prdslib.arrays.minItems 1
            ],
      "_js2n__-:definitions/rules/properties/no-shadowed-variable/definitions/options/items!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  class = _js2n__-prdslib.isType '"Bool",
                  enum = _js2n__-prdslib.isType '"Bool",
                  function = _js2n__-prdslib.isType '"Bool",
                  "import" = _js2n__-prdslib.isType '"Bool",
                  interface = _js2n__-prdslib.isType '"Bool",
                  namespace = _js2n__-prdslib.isType '"Bool",
                  typeAlias = _js2n__-prdslib.isType '"Bool",
                  typeParameter = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/rules/properties/no-submodule-imports/definitions/options!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String"),
              _js2n__-prdslib.arrays.minItems 1,
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/rules/properties/no-submodule-imports/definitions/options/items!predicate" =
        _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/rules/properties/no-this-assignment/definitions/options!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        allow-destructuring = _js2n__-prdslib.isType '"Bool",
                        allowed-names =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.isType '"String"),
                                _js2n__-prdslib.arrays.minItems 1,
                                _js2n__-prdslib.arrays.uniqueItems
                              ],
                      } {} false _js2n__-prdslib.never
                  ]),
              _js2n__-prdslib.arrays.maxItems 1,
              _js2n__-prdslib.arrays.minItems 1
            ],
      "_js2n__-:definitions/rules/properties/no-this-assignment/definitions/options/items!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  allow-destructuring = _js2n__-prdslib.isType '"Bool",
                  allowed-names =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String"),
                          _js2n__-prdslib.arrays.minItems 1,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/rules/properties/no-trailing-whitespace/definitions/options!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.enum
                      [
                        "ignore-comments",
                        "ignore-jsdoc",
                        "ignore-template-strings",
                        "ignore-blank-lines"
                      ]
                  ]),
              _js2n__-prdslib.arrays.maxItems 4,
              _js2n__-prdslib.arrays.minItems 1,
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/rules/properties/no-trailing-whitespace/definitions/options/items!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "ignore-comments",
                  "ignore-jsdoc",
                  "ignore-template-strings",
                  "ignore-blank-lines"
                ]
            ],
      "_js2n__-:definitions/rules/properties/no-unnecessary-class/definitions/options!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.strings.maxLength 3,
              _js2n__-prdslib.strings.minLength 0,
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.enum
                      [
                        "allow-constructor-only",
                        "allow-empty-class",
                        "allow-static-only"
                      ]
                  ])
            ],
      "_js2n__-:definitions/rules/properties/no-unnecessary-class/definitions/options/items!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "allow-constructor-only",
                  "allow-empty-class",
                  "allow-static-only"
                ]
            ],
      "_js2n__-:definitions/rules/properties/no-unused-expression/definitions/options!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.enum
                      [
                        "allow-fast-null-checks",
                        "allow-new",
                        "allow-tagged-template"
                      ]
                  ]),
              _js2n__-prdslib.arrays.maxItems 3,
              _js2n__-prdslib.arrays.minItems 1,
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/rules/properties/no-unused-expression/definitions/options/items!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "allow-fast-null-checks",
                  "allow-new",
                  "allow-tagged-template"
                ]
            ],
      "_js2n__-:definitions/rules/properties/no-void-expression/definitions/options!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.enum [ "ignore-arrow-function-shorthand" ]
                  ]),
              _js2n__-prdslib.arrays.maxItems 1,
              _js2n__-prdslib.arrays.minItems 1
            ],
      "_js2n__-:definitions/rules/properties/no-void-expression/definitions/options/items!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "ignore-arrow-function-shorthand" ]
            ],
      "_js2n__-:definitions/rules/properties/object-literal-key-quotes/definitions/options!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.enum
                      [
                        "always",
                        "as-needed",
                        "consistent",
                        "consistent-as-needed"
                      ]
                  ]),
              _js2n__-prdslib.arrays.maxItems 1,
              _js2n__-prdslib.arrays.minItems 1
            ],
      "_js2n__-:definitions/rules/properties/object-literal-key-quotes/definitions/options/items!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [ "always", "as-needed", "consistent", "consistent-as-needed" ]
            ],
      "_js2n__-:definitions/rules/properties/object-literal-shorthand/definitions/options!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.enum [ "always", "never" ]
                  ]),
              _js2n__-prdslib.arrays.maxItems 2,
              _js2n__-prdslib.arrays.minItems 1,
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/rules/properties/object-literal-shorthand/definitions/options/items!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "always", "never" ]
            ],
      "_js2n__-:definitions/rules/properties/object-literal-sort-keys/definitions/options!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.enum
                      [
                        "ignore-case",
                        "locale-compare",
                        "match-declaration-order",
                        "shorthand-first"
                      ]
                  ]),
              _js2n__-prdslib.arrays.maxItems 4,
              _js2n__-prdslib.arrays.minItems 1,
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/rules/properties/object-literal-sort-keys/definitions/options/items!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "ignore-case",
                  "locale-compare",
                  "match-declaration-order",
                  "shorthand-first"
                ]
            ],
      "_js2n__-:definitions/rules/properties/one-line/definitions/options!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.enum
                      [
                        "check-catch",
                        "check-finally",
                        "check-else",
                        "check-open-brace",
                        "check-whitespace"
                      ]
                  ]),
              _js2n__-prdslib.arrays.maxItems 5,
              _js2n__-prdslib.arrays.minItems 1,
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/rules/properties/one-line/definitions/options/items!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "check-catch",
                  "check-finally",
                  "check-else",
                  "check-open-brace",
                  "check-whitespace"
                ]
            ],
      "_js2n__-:definitions/rules/properties/one-variable-per-declaration/definitions/options!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.enum [ "ignore-for-loop" ]
                  ]),
              _js2n__-prdslib.arrays.maxItems 1,
              _js2n__-prdslib.arrays.minItems 1
            ],
      "_js2n__-:definitions/rules/properties/one-variable-per-declaration/definitions/options/items!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "ignore-for-loop" ]
            ],
      "_js2n__-:definitions/rules/properties/only-arrow-functions/definitions/options!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.enum
                      [ "allow-declarations", "allow-named-functions" ]
                  ]),
              _js2n__-prdslib.arrays.maxItems 2,
              _js2n__-prdslib.arrays.minItems 1,
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/rules/properties/only-arrow-functions/definitions/options/items!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [ "allow-declarations", "allow-named-functions" ]
            ],
      "_js2n__-:definitions/rules/properties/ordered-imports/definitions/options!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        grouped-imports = _js2n__-prdslib.isType '"Bool",
                        groups =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.oneOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.required
                                            [ "match", "order" ],
                                          _js2n__-prdslib.records.record
                                            {
                                              "match" =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              name =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              order =
                                                _js2n__-prdslib.isType
                                                    '"Number",
                                            } {} true _js2n__-prdslib.always
                                        ]
                                    ])
                              ],
                        import-sources-order =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.enum
                                  [
                                    "case-insensitive",
                                    "case-insensitive-legacy",
                                    "lowercase-first",
                                    "lowercase-last",
                                    "any"
                                  ]
                              ],
                        module-source-path =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.enum [ "full", "basename" ]
                              ],
                        named-imports-order =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.enum
                                  [
                                    "case-insensitive",
                                    "case-insensitive-legacy",
                                    "lowercase-first",
                                    "lowercase-last",
                                    "any"
                                  ]
                              ],
                      } {} false _js2n__-prdslib.never
                  ]),
              _js2n__-prdslib.arrays.maxItems 1,
              _js2n__-prdslib.arrays.minItems 1
            ],
      "_js2n__-:definitions/rules/properties/ordered-imports/definitions/options/items!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  grouped-imports = _js2n__-prdslib.isType '"Bool",
                  groups =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.required
                                      [ "match", "order" ],
                                    _js2n__-prdslib.records.record
                                      {
                                        "match" =
                                          _js2n__-prdslib.isType '"String",
                                        name = _js2n__-prdslib.isType '"String",
                                        order =
                                          _js2n__-prdslib.isType '"Number",
                                      } {} true _js2n__-prdslib.always
                                  ]
                              ])
                        ],
                  import-sources-order =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "case-insensitive",
                              "case-insensitive-legacy",
                              "lowercase-first",
                              "lowercase-last",
                              "any"
                            ]
                        ],
                  module-source-path =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "full", "basename" ]
                        ],
                  named-imports-order =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "case-insensitive",
                              "case-insensitive-legacy",
                              "lowercase-first",
                              "lowercase-last",
                              "any"
                            ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/rules/properties/prefer-conditional-expression/definitions/options!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.enum [ "check-else-if" ]
                  ]),
              _js2n__-prdslib.arrays.maxItems 1,
              _js2n__-prdslib.arrays.minItems 1
            ],
      "_js2n__-:definitions/rules/properties/prefer-conditional-expression/definitions/options/items!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "check-else-if" ]
            ],
      "_js2n__-:definitions/rules/properties/prefer-const/definitions/options!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        destructuring =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.enum [ "all", "any" ]
                              ],
                      } {} false _js2n__-prdslib.never
                  ]),
              _js2n__-prdslib.arrays.maxItems 1,
              _js2n__-prdslib.arrays.minItems 1
            ],
      "_js2n__-:definitions/rules/properties/prefer-const/definitions/options/items!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  destructuring =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "all", "any" ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/rules/properties/prefer-function-over-method/definitions/options!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.enum [ "allow-public", "allow-protected" ]
                  ]),
              _js2n__-prdslib.arrays.maxItems 2,
              _js2n__-prdslib.arrays.minItems 1,
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/rules/properties/prefer-function-over-method/definitions/options/items!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "allow-public", "allow-protected" ]
            ],
      "_js2n__-:definitions/rules/properties/prefer-switch/definitions/options!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        min-cases =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Number",
                                _js2n__-prdslib.numbers.minimum 0
                              ],
                      } {} false _js2n__-prdslib.never
                  ]),
              _js2n__-prdslib.arrays.maxItems 1,
              _js2n__-prdslib.arrays.minItems 1
            ],
      "_js2n__-:definitions/rules/properties/prefer-switch/definitions/options/items!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  min-cases =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/rules/properties/prefer-template/definitions/options!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.enum [ "allow-single-concat" ]
                  ]),
              _js2n__-prdslib.arrays.maxItems 1,
              _js2n__-prdslib.arrays.minItems 1
            ],
      "_js2n__-:definitions/rules/properties/prefer-template/definitions/options/items!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "allow-single-concat" ]
            ],
      "_js2n__-:definitions/rules/properties/quotemark/definitions/options!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.enum
                      [
                        "single",
                        "double",
                        "jsx-single",
                        "jsx-double",
                        "avoid-escape",
                        "avoid-template"
                      ]
                  ]),
              _js2n__-prdslib.arrays.maxItems 4,
              _js2n__-prdslib.arrays.minItems 1,
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/rules/properties/quotemark/definitions/options/items!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "single",
                  "double",
                  "jsx-single",
                  "jsx-double",
                  "avoid-escape",
                  "avoid-template"
                ]
            ],
      "_js2n__-:definitions/rules/properties/semicolon/definitions/options!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.items
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum [ "always", "never" ]
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum
                        [
                          "ignore-interfaces",
                          "ignore-bound-class-methods",
                          "strict-bound-class-methods"
                        ]
                    ]
                ],
              _js2n__-prdslib.arrays.maxItems 3,
              _js2n__-prdslib.arrays.minItems 1
            ],
      "_js2n__-:definitions/rules/properties/semicolon/definitions/options/items/0!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "always", "never" ]
            ],
      "_js2n__-:definitions/rules/properties/semicolon/definitions/options/items/1!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "ignore-interfaces",
                  "ignore-bound-class-methods",
                  "strict-bound-class-methods"
                ]
            ],
      "_js2n__-:definitions/rules/properties/space-before-function-paren/definitions/options!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        anonymous =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.enum [ "always", "never" ]
                              ],
                        asyncArrow =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.enum [ "always", "never" ]
                              ],
                        constructor =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.enum [ "always", "never" ]
                              ],
                        method =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.enum [ "always", "never" ]
                              ],
                        named =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.enum [ "always", "never" ]
                              ],
                      } {} false _js2n__-prdslib.never
                  ]),
              _js2n__-prdslib.arrays.maxItems 1,
              _js2n__-prdslib.arrays.minItems 1
            ],
      "_js2n__-:definitions/rules/properties/space-before-function-paren/definitions/options/items!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  anonymous =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "always", "never" ]
                        ],
                  asyncArrow =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "always", "never" ]
                        ],
                  constructor =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "always", "never" ]
                        ],
                  method =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "always", "never" ]
                        ],
                  named =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "always", "never" ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/rules/properties/space-within-parens/definitions/options!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"Number",
                    _js2n__-prdslib.numbers.minimum 0
                  ]),
              _js2n__-prdslib.arrays.maxItems 1,
              _js2n__-prdslib.arrays.minItems 1
            ],
      "_js2n__-:definitions/rules/properties/space-within-parens/definitions/options/items!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Number",
              _js2n__-prdslib.numbers.minimum 0
            ],
      "_js2n__-:definitions/rules/properties/switch-final-break/definitions/options!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.enum [ "always" ]
                  ]),
              _js2n__-prdslib.arrays.maxItems 1,
              _js2n__-prdslib.arrays.minItems 1
            ],
      "_js2n__-:definitions/rules/properties/switch-final-break/definitions/options/items!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "always" ]
            ],
      "_js2n__-:definitions/rules/properties/trailing-comma/definitions/options!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        esSpecCompliant = _js2n__-prdslib.isType '"Bool",
                        multiline =
                          _js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.enum [ "always", "never" ]
                                  ],
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.record
                                      {
                                        arrays =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [
                                                    "always",
                                                    "never",
                                                    "ignore"
                                                  ]
                                              ],
                                        exports =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [
                                                    "always",
                                                    "never",
                                                    "ignore"
                                                  ]
                                              ],
                                        functions =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [
                                                    "always",
                                                    "never",
                                                    "ignore"
                                                  ]
                                              ],
                                        imports =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [
                                                    "always",
                                                    "never",
                                                    "ignore"
                                                  ]
                                              ],
                                        objects =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [
                                                    "always",
                                                    "never",
                                                    "ignore"
                                                  ]
                                              ],
                                        typeLiterals =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [
                                                    "always",
                                                    "never",
                                                    "ignore"
                                                  ]
                                              ],
                                      } {} false _js2n__-prdslib.never
                                  ]
                              ],
                        singleline =
                          _js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.enum [ "always", "never" ]
                                  ],
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.record
                                      {
                                        arrays =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [
                                                    "always",
                                                    "never",
                                                    "ignore"
                                                  ]
                                              ],
                                        exports =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [
                                                    "always",
                                                    "never",
                                                    "ignore"
                                                  ]
                                              ],
                                        functions =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [
                                                    "always",
                                                    "never",
                                                    "ignore"
                                                  ]
                                              ],
                                        imports =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [
                                                    "always",
                                                    "never",
                                                    "ignore"
                                                  ]
                                              ],
                                        objects =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [
                                                    "always",
                                                    "never",
                                                    "ignore"
                                                  ]
                                              ],
                                        typeLiterals =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [
                                                    "always",
                                                    "never",
                                                    "ignore"
                                                  ]
                                              ],
                                      } {} false _js2n__-prdslib.never
                                  ]
                              ],
                      } {} false _js2n__-prdslib.never
                  ]),
              _js2n__-prdslib.arrays.maxItems 1,
              _js2n__-prdslib.arrays.minItems 1
            ],
      "_js2n__-:definitions/rules/properties/trailing-comma/definitions/options/items!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  esSpecCompliant = _js2n__-prdslib.isType '"Bool",
                  multiline =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum [ "always", "never" ]
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  arrays =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.enum
                                            [ "always", "never", "ignore" ]
                                        ],
                                  exports =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.enum
                                            [ "always", "never", "ignore" ]
                                        ],
                                  functions =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.enum
                                            [ "always", "never", "ignore" ]
                                        ],
                                  imports =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.enum
                                            [ "always", "never", "ignore" ]
                                        ],
                                  objects =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.enum
                                            [ "always", "never", "ignore" ]
                                        ],
                                  typeLiterals =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.enum
                                            [ "always", "never", "ignore" ]
                                        ],
                                } {} false _js2n__-prdslib.never
                            ]
                        ],
                  singleline =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum [ "always", "never" ]
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  arrays =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.enum
                                            [ "always", "never", "ignore" ]
                                        ],
                                  exports =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.enum
                                            [ "always", "never", "ignore" ]
                                        ],
                                  functions =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.enum
                                            [ "always", "never", "ignore" ]
                                        ],
                                  imports =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.enum
                                            [ "always", "never", "ignore" ]
                                        ],
                                  objects =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.enum
                                            [ "always", "never", "ignore" ]
                                        ],
                                  typeLiterals =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.enum
                                            [ "always", "never", "ignore" ]
                                        ],
                                } {} false _js2n__-prdslib.never
                            ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/rules/properties/triple-equals/definitions/options!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.enum
                      [ "allow-null-check", "allow-undefined-check" ]
                  ]),
              _js2n__-prdslib.arrays.maxItems 3,
              _js2n__-prdslib.arrays.minItems 1,
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/rules/properties/triple-equals/definitions/options/items!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [ "allow-null-check", "allow-undefined-check" ]
            ],
      "_js2n__-:definitions/rules/properties/variable-name/definitions/options!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.enum
                      [
                        "check-format",
                        "require-const-for-all-caps",
                        "allow-leading-underscore",
                        "allow-trailing-underscore",
                        "allow-pascal-case",
                        "allow-snake-case",
                        "ban-keywords"
                      ]
                  ]),
              _js2n__-prdslib.arrays.maxItems 7,
              _js2n__-prdslib.arrays.minItems 1,
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/rules/properties/variable-name/definitions/options/items!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "check-format",
                  "require-const-for-all-caps",
                  "allow-leading-underscore",
                  "allow-trailing-underscore",
                  "allow-pascal-case",
                  "allow-snake-case",
                  "ban-keywords"
                ]
            ],
      "_js2n__-:definitions/rules/properties/whitespace/definitions/options!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.enum
                      [
                        "check-branch",
                        "check-decl",
                        "check-operator",
                        "check-module",
                        "check-separator",
                        "check-rest-spread",
                        "check-type",
                        "check-typecast",
                        "check-type-operator",
                        "check-preblock",
                        "check-postbrace"
                      ],
                    _js2n__-prdslib.arrays.maxItems 10,
                    _js2n__-prdslib.arrays.minItems 1,
                    _js2n__-prdslib.arrays.uniqueItems
                  ])
            ],
      "_js2n__-:definitions/rules/properties/whitespace/definitions/options/items!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "check-branch",
                  "check-decl",
                  "check-operator",
                  "check-module",
                  "check-separator",
                  "check-rest-spread",
                  "check-type",
                  "check-typecast",
                  "check-type-operator",
                  "check-preblock",
                  "check-postbrace"
                ],
              _js2n__-prdslib.arrays.maxItems 10,
              _js2n__-prdslib.arrays.minItems 1,
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/tsRules!predicate" =
        _js2n__-prdslib.records.record
            {
              adjacent-overload-signatures =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record
                            { severity = _js2n__-prdslib.always, } {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              array-type =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-refsenv."_js2n__-:definitions/tsRules/properties/array-type/definitions/options/items!predicate"
                            1,
                          _js2n__-prdslib.arrays.maxItems 2,
                          _js2n__-prdslib.records.record
                            {
                              options =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/tsRules/properties/array-type/definitions/options!predicate",
                                      _js2n__-refsenv."_js2n__-:definitions/tsRules/properties/array-type/definitions/options/items!predicate"
                                    ],
                              severity = _js2n__-prdslib.always,
                            } {} false _js2n__-prdslib.never
                        ]
                    ],
              await-promise =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-refsenv."_js2n__-:definitions/tsRules/properties/await-promise/definitions/options/items!predicate"
                            1,
                          _js2n__-prdslib.arrays.uniqueItems,
                          _js2n__-prdslib.records.record
                            {
                              options =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/tsRules/properties/await-promise/definitions/options!predicate",
                                      _js2n__-refsenv."_js2n__-:definitions/tsRules/properties/await-promise/definitions/options/items!predicate"
                                    ],
                              severity = _js2n__-prdslib.always,
                            } {} false _js2n__-prdslib.never
                        ]
                    ],
              ban-ts-ignore =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              ban-types =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-refsenv."_js2n__-:definitions/tsRules/properties/ban-types/definitions/options/items!predicate"
                            1,
                          _js2n__-prdslib.arrays.uniqueItems,
                          _js2n__-prdslib.records.record
                            {
                              options =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/tsRules/properties/ban-types/definitions/options!predicate",
                                      _js2n__-refsenv."_js2n__-:definitions/tsRules/properties/ban-types/definitions/options/items!predicate"
                                    ],
                              severity = _js2n__-prdslib.always,
                            } {} false _js2n__-prdslib.never
                        ]
                    ],
              callable-types =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record
                            { severity = _js2n__-prdslib.always, } {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              function-constructor =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              interface-name =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-refsenv."_js2n__-:definitions/tsRules/properties/interface-name/definitions/options/items!predicate"
                            1,
                          _js2n__-prdslib.arrays.maxItems 2,
                          _js2n__-prdslib.records.record
                            {
                              options =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/tsRules/properties/interface-name/definitions/options!predicate",
                                      _js2n__-refsenv."_js2n__-:definitions/tsRules/properties/interface-name/definitions/options/items!predicate"
                                    ],
                              severity = _js2n__-prdslib.always,
                            } {} false _js2n__-prdslib.never
                        ]
                    ],
              interface-over-type-literal =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record
                            { severity = _js2n__-prdslib.always, } {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              match-default-export-name =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record
                            { severity = _js2n__-prdslib.always, } {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              member-access =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-refsenv."_js2n__-:definitions/tsRules/properties/member-access/definitions/options/items!predicate"
                            1,
                          _js2n__-prdslib.arrays.maxItems 4,
                          _js2n__-prdslib.arrays.uniqueItems,
                          _js2n__-prdslib.records.record
                            {
                              options =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/tsRules/properties/member-access/definitions/options!predicate",
                                      _js2n__-refsenv."_js2n__-:definitions/tsRules/properties/member-access/definitions/options/items!predicate"
                                    ],
                              severity = _js2n__-prdslib.always,
                            } {} false _js2n__-prdslib.never
                        ]
                    ],
              no-angle-bracket-type-assertion =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record
                            { severity = _js2n__-prdslib.always, } {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              no-any =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      ignore-rest-args =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ]
                            ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 2,
                          _js2n__-prdslib.records.record
                            { severity = _js2n__-prdslib.always, } {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              no-boolean-literal-compare =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record
                            { severity = _js2n__-prdslib.always, } {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              no-empty-interface =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record
                            { severity = _js2n__-prdslib.always, } {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              no-floating-promises =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-refsenv."_js2n__-:definitions/tsRules/properties/no-floating-promises/definitions/options/items!predicate"
                            1,
                          _js2n__-prdslib.arrays.uniqueItems,
                          _js2n__-prdslib.records.record
                            {
                              options =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/tsRules/properties/no-floating-promises/definitions/options!predicate",
                                      _js2n__-refsenv."_js2n__-:definitions/tsRules/properties/no-floating-promises/definitions/options/items!predicate"
                                    ],
                              severity = _js2n__-prdslib.always,
                            } {} false _js2n__-prdslib.never
                        ]
                    ],
              no-inferrable-types =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-refsenv."_js2n__-:definitions/tsRules/properties/no-inferrable-types/definitions/options/items!predicate"
                            1,
                          _js2n__-prdslib.arrays.maxItems 3,
                          _js2n__-prdslib.arrays.uniqueItems,
                          _js2n__-prdslib.records.record
                            {
                              options =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/tsRules/properties/no-inferrable-types/definitions/options!predicate",
                                      _js2n__-refsenv."_js2n__-:definitions/tsRules/properties/no-inferrable-types/definitions/options/items!predicate"
                                    ],
                              severity = _js2n__-prdslib.always,
                            } {} false _js2n__-prdslib.never
                        ]
                    ],
              no-inferred-empty-object-type =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record
                            { severity = _js2n__-prdslib.always, } {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              no-internal-module =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record
                            { severity = _js2n__-prdslib.always, } {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              no-mergeable-namespace =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record
                            { severity = _js2n__-prdslib.always, } {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              no-misused-new =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record
                            { severity = _js2n__-prdslib.always, } {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              no-namespace =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-refsenv."_js2n__-:definitions/tsRules/properties/no-namespace/definitions/options/items!predicate"
                            1,
                          _js2n__-prdslib.arrays.maxItems 2,
                          _js2n__-prdslib.records.record
                            {
                              options =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/tsRules/properties/no-namespace/definitions/options!predicate",
                                      _js2n__-refsenv."_js2n__-:definitions/tsRules/properties/no-namespace/definitions/options/items!predicate"
                                    ],
                              severity = _js2n__-prdslib.always,
                            } {} false _js2n__-prdslib.never
                        ]
                    ],
              no-non-null-assertion =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record
                            { severity = _js2n__-prdslib.always, } {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              no-object-literal-type-assertion =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record
                            { severity = _js2n__-prdslib.always, } {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              no-parameter-properties =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record
                            { severity = _js2n__-prdslib.always, } {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              no-redundant-jsdoc =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record
                            { severity = _js2n__-prdslib.always, } {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              no-reference-import =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record
                            { severity = _js2n__-prdslib.always, } {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              no-unbound-method =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-refsenv."_js2n__-:definitions/tsRules/properties/no-unbound-method/definitions/options/items!predicate"
                            1,
                          _js2n__-prdslib.arrays.maxItems 2,
                          _js2n__-prdslib.records.record
                            {
                              options =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/tsRules/properties/no-unbound-method/definitions/options!predicate",
                                      _js2n__-refsenv."_js2n__-:definitions/tsRules/properties/no-unbound-method/definitions/options/items!predicate"
                                    ],
                              severity = _js2n__-prdslib.always,
                            } {} false _js2n__-prdslib.never
                        ]
                    ],
              no-unnecessary-qualifier =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record
                            { severity = _js2n__-prdslib.always, } {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              no-unnecessary-type-assertion =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-refsenv."_js2n__-:definitions/tsRules/properties/no-unnecessary-type-assertion/definitions/options/items!predicate"
                            1,
                          _js2n__-prdslib.arrays.uniqueItems,
                          _js2n__-prdslib.records.record
                            {
                              options =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/tsRules/properties/no-unnecessary-type-assertion/definitions/options!predicate",
                                      _js2n__-refsenv."_js2n__-:definitions/tsRules/properties/no-unnecessary-type-assertion/definitions/options/items!predicate"
                                    ],
                              severity = _js2n__-prdslib.always,
                            } {} false _js2n__-prdslib.never
                        ]
                    ],
              no-unsafe-any =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record
                            { severity = _js2n__-prdslib.always, } {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              no-unused-variable =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-refsenv."_js2n__-:definitions/tsRules/properties/no-unused-variable/definitions/options/items!predicate"
                            1,
                          _js2n__-prdslib.arrays.maxItems 3,
                          _js2n__-prdslib.arrays.uniqueItems,
                          _js2n__-prdslib.records.record
                            {
                              options =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/tsRules/properties/no-unused-variable/definitions/options!predicate",
                                      _js2n__-refsenv."_js2n__-:definitions/tsRules/properties/no-unused-variable/definitions/options/items!predicate"
                                    ],
                              severity = _js2n__-prdslib.always,
                            } {} false _js2n__-prdslib.never
                        ]
                    ],
              no-var-requires =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record
                            { severity = _js2n__-prdslib.always, } {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              prefer-readonly =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-refsenv."_js2n__-:definitions/tsRules/properties/prefer-readonly/definitions/options/items!predicate"
                            1,
                          _js2n__-prdslib.arrays.maxItems 2,
                          _js2n__-prdslib.records.record
                            {
                              options =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/tsRules/properties/prefer-readonly/definitions/options!predicate",
                                      _js2n__-refsenv."_js2n__-:definitions/tsRules/properties/prefer-readonly/definitions/options/items!predicate"
                                    ],
                              severity = _js2n__-prdslib.always,
                            } {} false _js2n__-prdslib.never
                        ]
                    ],
              strict-boolean-expressions =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-refsenv."_js2n__-:definitions/tsRules/properties/strict-boolean-expressions/definitions/options/items!predicate"
                            1,
                          _js2n__-prdslib.arrays.maxItems 6,
                          _js2n__-prdslib.arrays.uniqueItems,
                          _js2n__-prdslib.records.record
                            {
                              options =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/tsRules/properties/strict-boolean-expressions/definitions/options!predicate",
                                      _js2n__-refsenv."_js2n__-:definitions/tsRules/properties/strict-boolean-expressions/definitions/options/items!predicate"
                                    ],
                              severity = _js2n__-prdslib.always,
                            } {} false _js2n__-prdslib.never
                        ]
                    ],
              strict-type-predicates =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record
                            { severity = _js2n__-prdslib.always, } {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              type-literal-delimiter =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      singleLine =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-prdslib.enum
                                                [ "always", "never" ]
                                            ],
                                    } {} true _js2n__-prdslib.always
                                ]
                            ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 2,
                          _js2n__-prdslib.records.record
                            { severity = _js2n__-prdslib.always, } {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              typedef =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-refsenv."_js2n__-:definitions/tsRules/properties/typedef/definitions/options/items!predicate"
                            1,
                          _js2n__-prdslib.arrays.maxItems 10,
                          _js2n__-prdslib.arrays.uniqueItems,
                          _js2n__-prdslib.records.record
                            {
                              options =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/tsRules/properties/typedef/definitions/options!predicate",
                                      _js2n__-refsenv."_js2n__-:definitions/tsRules/properties/typedef/definitions/options/items!predicate"
                                    ],
                              severity = _js2n__-prdslib.always,
                            } {} false _js2n__-prdslib.never
                        ]
                    ],
              typedef-whitespace =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-refsenv."_js2n__-:definitions/tsRules/properties/typedef-whitespace/definitions/options/items/0!predicate",
                              _js2n__-refsenv."_js2n__-:definitions/tsRules/properties/typedef-whitespace/definitions/options/items/1!predicate"
                            ],
                          _js2n__-prdslib.arrays.maxItems 3,
                          _js2n__-prdslib.records.record
                            {
                              options =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/tsRules/properties/typedef-whitespace/definitions/options!predicate",
                                      _js2n__-refsenv."_js2n__-:definitions/tsRules/properties/typedef-whitespace/definitions/options/items/0!predicate"
                                    ],
                              severity = _js2n__-prdslib.always,
                            } {} false _js2n__-prdslib.never
                        ]
                    ],
              unified-signatures =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record
                            { severity = _js2n__-prdslib.always, } {} false
                            _js2n__-prdslib.never
                        ]
                    ],
              use-default-type-parameter =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"Bool" ],
                          _js2n__-prdslib.arrays.additionalItems
                            _js2n__-prdslib.never 1,
                          _js2n__-prdslib.records.record
                            { severity = _js2n__-prdslib.always, } {} false
                            _js2n__-prdslib.never
                        ]
                    ],
            } {} true _js2n__-prdslib.always,
      "_js2n__-:definitions/tsRules/properties/array-type/definitions/options!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.enum [ "array", "generic", "array-simple" ]
                  ]),
              _js2n__-prdslib.arrays.maxItems 1,
              _js2n__-prdslib.arrays.minItems 1
            ],
      "_js2n__-:definitions/tsRules/properties/array-type/definitions/options/items!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "array", "generic", "array-simple" ]
            ],
      "_js2n__-:definitions/tsRules/properties/await-promise/definitions/options!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String"),
              _js2n__-prdslib.arrays.minItems 1,
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/tsRules/properties/await-promise/definitions/options/items!predicate" =
        _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/tsRules/properties/ban-types/definitions/options!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"Array",
                    _js2n__-prdslib.arrays.arrayOf
                      (_js2n__-prdslib.isType '"String"),
                    _js2n__-prdslib.arrays.maxItems 2,
                    _js2n__-prdslib.arrays.minItems 1
                  ]),
              _js2n__-prdslib.arrays.minItems 1,
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/tsRules/properties/ban-types/definitions/options/items!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String"),
              _js2n__-prdslib.arrays.maxItems 2,
              _js2n__-prdslib.arrays.minItems 1
            ],
      "_js2n__-:definitions/tsRules/properties/interface-name/definitions/options!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.enum [ "always-prefix", "never-prefix" ]
                  ]),
              _js2n__-prdslib.arrays.maxItems 1,
              _js2n__-prdslib.arrays.minItems 1
            ],
      "_js2n__-:definitions/tsRules/properties/interface-name/definitions/options/items!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "always-prefix", "never-prefix" ]
            ],
      "_js2n__-:definitions/tsRules/properties/member-access/definitions/options!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.enum
                      [
                        "no-public",
                        "check-accessor",
                        "check-constructor",
                        "check-parameter-property"
                      ]
                  ]),
              _js2n__-prdslib.arrays.maxItems 4,
              _js2n__-prdslib.arrays.minItems 1,
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/tsRules/properties/member-access/definitions/options/items!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "no-public",
                  "check-accessor",
                  "check-constructor",
                  "check-parameter-property"
                ]
            ],
      "_js2n__-:definitions/tsRules/properties/no-floating-promises/definitions/options!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String"),
              _js2n__-prdslib.arrays.minItems 1,
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/tsRules/properties/no-floating-promises/definitions/options/items!predicate" =
        _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/tsRules/properties/no-inferrable-types/definitions/options!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.enum
                      [ "ignore-params", "ignore-properties" ]
                  ]),
              _js2n__-prdslib.arrays.maxItems 2,
              _js2n__-prdslib.arrays.minItems 1,
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/tsRules/properties/no-inferrable-types/definitions/options/items!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "ignore-params", "ignore-properties" ]
            ],
      "_js2n__-:definitions/tsRules/properties/no-namespace/definitions/options!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.enum [ "allow-declarations" ]
                  ]),
              _js2n__-prdslib.arrays.maxItems 1,
              _js2n__-prdslib.arrays.minItems 1
            ],
      "_js2n__-:definitions/tsRules/properties/no-namespace/definitions/options/items!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "allow-declarations" ]
            ],
      "_js2n__-:definitions/tsRules/properties/no-unbound-method/definitions/options!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.enum [ "ignore-static" ]
                  ]),
              _js2n__-prdslib.arrays.maxItems 1,
              _js2n__-prdslib.arrays.minItems 1
            ],
      "_js2n__-:definitions/tsRules/properties/no-unbound-method/definitions/options/items!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "ignore-static" ]
            ],
      "_js2n__-:definitions/tsRules/properties/no-unnecessary-type-assertion/definitions/options!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String"),
              _js2n__-prdslib.arrays.minItems 1,
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/tsRules/properties/no-unnecessary-type-assertion/definitions/options/items!predicate" =
        _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/tsRules/properties/no-unused-variable/definitions/options!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.oneOf
                  [
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.enum [ "check-parameters" ]
                      ],
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.record
                          { ignore-pattern = _js2n__-prdslib.isType '"String", }
                          {} false _js2n__-prdslib.never
                      ]
                  ]),
              _js2n__-prdslib.arrays.maxItems 2,
              _js2n__-prdslib.arrays.minItems 1,
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/tsRules/properties/no-unused-variable/definitions/options/items!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "check-parameters" ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    { ignore-pattern = _js2n__-prdslib.isType '"String", } {}
                    false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:definitions/tsRules/properties/prefer-readonly/definitions/options!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.enum [ "only-inline-lambdas" ]
                  ])
            ],
      "_js2n__-:definitions/tsRules/properties/prefer-readonly/definitions/options/items!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "only-inline-lambdas" ]
            ],
      "_js2n__-:definitions/tsRules/properties/strict-boolean-expressions/definitions/options!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.enum
                      [
                        "allow-null-union",
                        "allow-undefined-union",
                        "allow-string",
                        "allow-enum",
                        "allow-number",
                        "allow-mix",
                        "allow-boolean-or-undefined",
                        "ignore-rhs"
                      ]
                  ]),
              _js2n__-prdslib.arrays.maxItems 8,
              _js2n__-prdslib.arrays.minItems 1,
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/tsRules/properties/strict-boolean-expressions/definitions/options/items!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "allow-null-union",
                  "allow-undefined-union",
                  "allow-string",
                  "allow-enum",
                  "allow-number",
                  "allow-mix",
                  "allow-boolean-or-undefined",
                  "ignore-rhs"
                ]
            ],
      "_js2n__-:definitions/tsRules/properties/typedef-whitespace/definitions/options!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.items
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          call-signature =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.enum
                                    [ "nospace", "onespace", "space" ]
                                ],
                          index-signature =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.enum
                                    [ "nospace", "onespace", "space" ]
                                ],
                          parameter =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.enum
                                    [ "nospace", "onespace", "space" ]
                                ],
                          property-declaration =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.enum
                                    [ "nospace", "onespace", "space" ]
                                ],
                          variable-declaration =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.enum
                                    [ "nospace", "onespace", "space" ]
                                ],
                        } {} false _js2n__-prdslib.never
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          call-signature =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.enum
                                    [ "nospace", "onespace", "space" ]
                                ],
                          index-signature =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.enum
                                    [ "nospace", "onespace", "space" ]
                                ],
                          parameter =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.enum
                                    [ "nospace", "onespace", "space" ]
                                ],
                          property-declaration =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.enum
                                    [ "nospace", "onespace", "space" ]
                                ],
                          variable-declaration =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.enum
                                    [ "nospace", "onespace", "space" ]
                                ],
                        } {} false _js2n__-prdslib.never
                    ]
                ],
              _js2n__-prdslib.arrays.maxItems 2,
              _js2n__-prdslib.arrays.minItems 1
            ],
      "_js2n__-:definitions/tsRules/properties/typedef-whitespace/definitions/options/items/0!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  call-signature =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "nospace", "onespace", "space" ]
                        ],
                  index-signature =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "nospace", "onespace", "space" ]
                        ],
                  parameter =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "nospace", "onespace", "space" ]
                        ],
                  property-declaration =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "nospace", "onespace", "space" ]
                        ],
                  variable-declaration =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "nospace", "onespace", "space" ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/tsRules/properties/typedef-whitespace/definitions/options/items/1!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  call-signature =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "nospace", "onespace", "space" ]
                        ],
                  index-signature =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "nospace", "onespace", "space" ]
                        ],
                  parameter =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "nospace", "onespace", "space" ]
                        ],
                  property-declaration =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "nospace", "onespace", "space" ]
                        ],
                  variable-declaration =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "nospace", "onespace", "space" ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/tsRules/properties/typedef/definitions/options!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.enum
                      [
                        "call-signature",
                        "arrow-call-signature",
                        "parameter",
                        "arrow-parameter",
                        "property-declaration",
                        "variable-declaration",
                        "member-variable-declaration",
                        "object-destructuring",
                        "array-destructuring"
                      ]
                  ]),
              _js2n__-prdslib.arrays.maxItems 9,
              _js2n__-prdslib.arrays.minItems 1,
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/tsRules/properties/typedef/definitions/options/items!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "call-signature",
                  "arrow-call-signature",
                  "parameter",
                  "arrow-parameter",
                  "property-declaration",
                  "variable-declaration",
                  "member-variable-declaration",
                  "object-destructuring",
                  "array-destructuring"
                ]
            ],
    }
    in
  {
      defaultSeverity
        | std.enum.TagOrString
        | [| 'none, 'off, 'warn, 'warning, 'error |]
        | doc "The severity level used when a rule specifies \"default\" as its severity level. If undefined, \"error\" is used."
        | optional,
      extends
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.isType '"Array"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "The name of a built-in configuration preset, or a path or array of paths to other configuration files which are extended by this configuration. These values are handled using node module resolution semantics."
        | optional,
      jsRules
        | _js2n__-refsenv."_js2n__-:definitions/rules!contract"
        | doc "A map of rules that will be used to lint JavaScript files. These rules apply to `.js` and `.jsx` files."
        | optional,
      linterOptions
        | {
          exclude
            | Array (String)
            | doc "An array of globs. Any file matching these globs will not be linted. All exclude patterns are relative to the configuration file they were specified in."
            | optional,
          ..
        }
        | doc "Additional linter options."
        | optional,
      rules
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-refsenv."_js2n__-:definitions/tsRules!predicate",
              _js2n__-refsenv."_js2n__-:definitions/rules!predicate"
            ])
        | doc "A map of rules that will be used to lint TypeScript files. These rules apply to `.ts` and `.tsx` files."
        | optional,
      rulesDirectory
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.isType '"Array"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "A path to a directory or an array of paths to directories of custom rules. These values are handled using node module resolution semantics, if an `index.js` is placed in your rules directory."
        | optional,
      ..
    }