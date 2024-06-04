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
      "_js2n__-:definitions/key!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType '"String",
                _js2n__-prdslib.not (_js2n__-prdslib.strings.pattern "---"),
                _js2n__-prdslib.strings.minLength 1
              ]),
    }
    in
  {
      "editor:delete_word_left"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Delete word left"
        | optional,
      "editor:delete_word_right"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Delete word right"
        | optional,
      "editor:insert_last_word_previous_command"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Insert last word of previous command"
        | optional,
      "editor:select_right"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Select one character to the right"
        | optional,
      "editor:select_to_line_end"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Select to end of line"
        | optional,
      "editor_view:add_cursor_above"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Add cursor above"
        | optional,
      "editor_view:add_cursor_below"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Add cursor below"
        | optional,
      "editor_view:add_next_occurrence"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Add selection for next occurrence"
        | optional,
      "editor_view:backspace"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Remove the previous character"
        | optional,
      "editor_view:clear_and_copy_lines"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Copy and clear selected lines"
        | optional,
      "editor_view:clear_buffer"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Clear command editor"
        | optional,
      "editor_view:clear_lines"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Clear selected lines"
        | optional,
      "editor_view:cmd_down"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Move cursor to the bottom"
        | optional,
      "editor_view:cmd_i"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Inspect command"
        | optional,
      "editor_view:cut_all_right"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Cut all right"
        | optional,
      "editor_view:cut_word_left"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Cut word left"
        | optional,
      "editor_view:cut_word_right"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Cut word right"
        | optional,
      "editor_view:delete"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Delete"
        | optional,
      "editor_view:delete_all_left"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Delete all left"
        | optional,
      "editor_view:delete_all_right"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Delete all right"
        | optional,
      "editor_view:down"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Move cursor down"
        | optional,
      "editor_view:end"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "End"
        | optional,
      "editor_view:fold"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Fold"
        | optional,
      "editor_view:fold_selected_ranges"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Fold selected ranges"
        | optional,
      "editor_view:home"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Home"
        | optional,
      "editor_view:insert_newline"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Insert newline"
        | optional,
      "editor_view:left"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Move cursor left"
        | optional,
      "editor_view:move_backward_one_subword"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Move backward one subword"
        | optional,
      "editor_view:move_backward_one_word"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Move backward one word"
        | optional,
      "editor_view:move_forward_one_subword"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Move forward one subword"
        | optional,
      "editor_view:move_forward_one_word"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Move forward one word"
        | optional,
      "editor_view:move_to_buffer_end"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Move to the end of the buffer"
        | optional,
      "editor_view:move_to_buffer_start"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Move to the start of the buffer"
        | optional,
      "editor_view:move_to_line_end"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Move to end of line"
        | optional,
      "editor_view:move_to_line_start"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Move to start of line"
        | optional,
      "editor_view:move_to_paragraph_end"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Move to the end of the paragraph"
        | optional,
      "editor_view:move_to_paragraph_start"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Move to the start of the paragraph"
        | optional,
      "editor_view:right"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Move cursor right / accept autosuggestion"
        | optional,
      "editor_view:select_all"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Select all"
        | optional,
      "editor_view:select_down"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Select down"
        | optional,
      "editor_view:select_left"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Select one character to the left"
        | optional,
      "editor_view:select_left_by_word"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Select one word to the left"
        | optional,
      "editor_view:select_right_by_word"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Select one word to the right"
        | optional,
      "editor_view:select_to_line_start"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Select to start of line"
        | optional,
      "editor_view:select_up"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Select up"
        | optional,
      "editor_view:unfold"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Unfold"
        | optional,
      "editor_view:up"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Move cursor up"
        | optional,
      "find:find_next_occurrence"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Find the next occurrence of your search query"
        | optional,
      "find:find_prev_occurrence"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Find the previous occurrence of your search query"
        | optional,
      "input:clear_screen"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Clear screen"
        | optional,
      "input:toggle_natural_language_command_search"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Ai command suggestions"
        | optional,
      "input:toggle_workflows"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Workflows"
        | optional,
      "pane_group:add_down"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Split pane down"
        | optional,
      "pane_group:add_right"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Split pane right"
        | optional,
      "pane_group:navigate_down"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Switch panes down"
        | optional,
      "pane_group:navigate_left"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Switch panes left"
        | optional,
      "pane_group:navigate_next"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Activate next pane"
        | optional,
      "pane_group:navigate_prev"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Activate previous pane"
        | optional,
      "pane_group:navigate_right"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Switch panes right"
        | optional,
      "pane_group:navigate_up"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Switch panes up"
        | optional,
      "pane_group:resize_down"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Resize pane > move divider down"
        | optional,
      "pane_group:resize_left"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Resize pane > move divider left"
        | optional,
      "pane_group:resize_right"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Resize pane > move divider right"
        | optional,
      "pane_group:resize_up"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Resize pane > move divider up"
        | optional,
      "pane_group:toggle_maximize_pane"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Toggle maximize active pane"
        | optional,
      "terminal:bookmark_selected_block"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Bookmark selected block"
        | optional,
      "terminal:clear_blocks"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Clear blocks"
        | optional,
      "terminal:copy"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Copy"
        | optional,
      "terminal:copy_commands"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Copy command"
        | optional,
      "terminal:copy_outputs"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Copy command output"
        | optional,
      "terminal:expand_block_selection_above"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Expand selected blocks above"
        | optional,
      "terminal:expand_block_selection_below"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Expand selected blocks below"
        | optional,
      "terminal:find"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Find"
        | optional,
      "terminal:focus_input"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Focus terminal input"
        | optional,
      "terminal:open_block_list_context_menu_via_keybinding"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Open block context menu"
        | optional,
      "terminal:open_share_modal"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Share selected block"
        | optional,
      "terminal:paste"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Paste"
        | optional,
      "terminal:reinput_commands"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Reinput selected commands"
        | optional,
      "terminal:reinput_commands_with_sudo"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Reinput selected commands as root"
        | optional,
      "terminal:select_all_blocks"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Select all blocks"
        | optional,
      "terminal:select_bookmark_down"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Select the closest bookmark down"
        | optional,
      "terminal:select_bookmark_up"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Select the closest bookmark up"
        | optional,
      "terminal:select_next_block"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Select next block"
        | optional,
      "terminal:select_previous_block"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Select previous block"
        | optional,
      "workspace:activate_eighth_tab"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Switch to 8th tab"
        | optional,
      "workspace:activate_fifth_tab"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Switch to 5th tab"
        | optional,
      "workspace:activate_first_tab"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Switch to 1st tab"
        | optional,
      "workspace:activate_fourth_tab"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Switch to 4th tab"
        | optional,
      "workspace:activate_last_tab"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Switch to last tab"
        | optional,
      "workspace:activate_next_tab"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Activate next tab"
        | optional,
      "workspace:activate_prev_tab"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Activate previous tab"
        | optional,
      "workspace:activate_second_tab"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Switch to 2nd tab"
        | optional,
      "workspace:activate_seventh_tab"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Switch to 7th tab"
        | optional,
      "workspace:activate_sixth_tab"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Switch to 6th tab"
        | optional,
      "workspace:activate_third_tab"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Switch to 3rd tab"
        | optional,
      "workspace:decrease_font_size"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Decrease font size"
        | optional,
      "workspace:increase_font_size"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Increase font size"
        | optional,
      "workspace:move_tab_left"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Move tab left"
        | optional,
      "workspace:move_tab_right"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Move tab right"
        | optional,
      "workspace:reset_font_size"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Reset font size to default"
        | optional,
      "workspace:set_a11y_concise_verbosity_level"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "[a11y] set concise accessibility announcements"
        | optional,
      "workspace:set_a11y_verbose_verbosity_level"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "[a11y] set verbose accessibility announcements"
        | optional,
      "workspace:show_command_search"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Command search"
        | optional,
      "workspace:show_keybinding_settings"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Open keybindings editor"
        | optional,
      "workspace:show_settings_account_page"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Open settings: account"
        | optional,
      "workspace:show_settings_modal"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Open settings"
        | optional,
      "workspace:show_theme_chooser"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Open theme picker"
        | optional,
      "workspace:toggle_command_palette"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Toggle command palette"
        | optional,
      "workspace:toggle_launch_config_palette"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Launch configuration palette"
        | optional,
      "workspace:toggle_mouse_reporting"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Toggle mouse reporting"
        | optional,
      "workspace:toggle_navigation_palette"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Toggle navigation palette"
        | optional,
      "workspace:toggle_resource_center"
        | _js2n__-refsenv."_js2n__-:definitions/key!contract"
        | doc "Open resource center"
        | optional,
    }