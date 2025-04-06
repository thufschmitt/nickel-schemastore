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
      project
        | {
          corePackage
            | std.enum.TagOrString
            | [| 'SERIOUS, 'LIGHT |]
            | doc "Project core package."
            | optional,
          description
            | String
            | doc "Description of the new project."
            | optional,
          envVariables
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record {} {} true
                    (_js2n__-prdslib.isType '"String")
                ])
            | doc "List of environment variables of project configuration."
            | optional,
          name
            | String
            | doc "The name of the new project. Duplicates are allowed.",
          tags
            | Array (String)
            | doc "One or more string tags. Tags do not have functional meaning, they only provide better orientation in projects."
            | optional,
        }
        | doc "Only one project can be defined."
        | optional,
      services
        | Array
          {
            buildFromGit
              | String
              | doc "A URL of a Github or Gitlab repository used for a one-time build of your service."
              | optional,
            dotEnvSecrets
              | String
              | doc "List of key-value pairs in .env format. Environment variables that are blurred by default in Zerops GUI. Can be edited or deleted in Zerops GUI."
              | optional,
            enableCdn
              | Bool
              | doc "Set true, if you want to enable CDN for the object storage bucket. Currently only relevant for object storage services."
              | optional,
            enableSubdomainAccess
              | Bool
              | doc "Set true, if you want to enable a public access to your service via a Zerops subdomain. Not suitable for production."
              | optional,
            envSecrets
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record {} {} true
                      (_js2n__-prdslib.isType '"String")
                  ])
              | doc "List of key-value pairs. Environment variables that are blurred by default in Zerops GUI. Can be edited or deleted in Zerops GUI."
              | optional,
            hostname
              | String
              | doc "The unique service identifier. Limitations: duplicates in the same project forbidden; maximum 25 characters, lowercase ASCII letters (a-z) or numbers (0-9) only.",
            maxContainers
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Integer,
                    _js2n__-prdslib.numbers.maximum 6
                  ])
              | doc "Maximum number of containers of the service."
              | optional,
            minContainers
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Integer,
                    _js2n__-prdslib.numbers.maximum 6
                  ])
              | doc "Minimum number of containers of the service."
              | optional,
            mode
              | std.enum.TagOrString
              | [| 'NON_HA, 'HA |]
              | doc "Defines the operation mode of the service."
              | optional,
            mount
              | Array (String)
              | doc "Mount shared storages to the service, buildFromGit must be filled."
              | optional,
            nginxConfig | String | doc "Insert full nginx config." | optional,
            objectStoragePolicy
              | std.enum.TagOrString
              | [|
                'public-read-write,
                'public-write,
                'public-objects-read,
                'public-read,
                'private,
                'custom
              |]
              | doc "Select a predefined AWS S3 bucket access policy."
              | optional,
            objectStorageRawPolicy
              | String
              | doc "Define your own AWS S3 bucket access policy. See AWS docs for details. Use {{ .BucketName }} placeholder if you need to use bucket name in your custom policy rules."
              | optional,
            objectStorageSize
              | Number
              | doc "Object storage size in GB."
              | optional,
            override | Bool | doc "Override existing service." | optional,
            "priority"
              | std.number.Integer
              | doc "Services are sorted before creation by priority in descending order, i.e. the higher the priority the sooner the service is created."
              | optional,
            startWithoutCode
              | Bool
              | doc "Set true, if you want to start service without code."
              | optional,
            type
              | std.enum.TagOrString
              | [|
                '"valkey@7.2",
                '"ubuntu@24.04",
                '"ubuntu@22.04",
                '"typesense@27.1",
                '"static@latest",
                '"static@1.0",
                'static,
                'sharedstorage,
                'shared-storage,
                '"seaweedfs@3",
                '"rust@nightly",
                '"rust@1.80",
                '"rust@1.78",
                '"rust@1",
                'runtime,
                '"rabbitmq@3.9",
                '"qdrant@1.12",
                '"qdrant@1.10",
                '"python@3.9",
                '"python@3.12",
                '"python@3.11",
                '"postgresql@16",
                '"postgresql@14",
                '"postgresql@12",
                '"php-nginx@8.4+1.22",
                '"php-nginx@8.4",
                '"php-nginx@8.3+1.22",
                '"php-nginx@8.3",
                '"php-nginx@8.1+1.22",
                '"php-nginx@8.1",
                '"php-apache@8.4+2.4",
                '"php-apache@8.4",
                '"php-apache@8.3+2.4",
                '"php-apache@8.3",
                '"php-apache@8.1+2.4",
                '"php-apache@8.1",
                '"php-apache@8.0+2.4",
                'objectstorage,
                'object-storage,
                '"nodejs@22",
                '"nodejs@20",
                '"nodejs@18",
                '"nginx@latest",
                '"nginx@1.22",
                '"nats@2.10",
                '"meilisearch@1.10",
                '"mariadb@10.6",
                '"keydb@6",
                '"kafka@3.8",
                '"java@latest",
                '"java@21",
                '"java@17",
                'java,
                '"golang@1",
                '"go@1.22",
                '"go@1",
                '"gleam@1.5.1",
                '"gleam@1.5",
                '"gleam@1",
                '"elixir@1.16.2",
                '"elixir@1.16",
                '"elixir@1",
                '"elasticsearch@8.16",
                '"dotnet@9",
                '"dotnet@8",
                '"dotnet@7",
                '"dotnet@6",
                '"docker@latest",
                '"docker@26.1.5",
                '"docker@26.1",
                '"docker@26",
                '"deno@latest",
                '"deno@2.0.0",
                '"deno@2",
                '"deno@1.45.5",
                '"deno@1",
                '"bun@nightly",
                '"bun@latest",
                '"bun@canary",
                '"bun@1.2.2",
                '"bun@1.2",
                '"bun@1.1.34",
                '"bun@1.1",
                '"alpine@3.20",
                '"alpine@3.19",
                '"alpine@3.18",
                '"alpine@3.17",
                '"3.20",
                '"3.19",
                '"3.18",
                '"3.17",
                '"22.04"
              |]
              | doc "Specifies the service type and version.",
            verticalAutoscaling
              | {
                cpu
                  | std.number.Integer
                  | doc "Fixed CPU thread count that each container of the service will be set to."
                  | optional,
                cpuMode
                  | std.enum.TagOrString
                  | [| 'SHARED, 'DEDICATED |]
                  | doc "CPU mode that each container of the service will be set to."
                  | optional,
                disk
                  | Number
                  | doc "Fixed disk space in GB that each container of the service will be set to."
                  | optional,
                maxCpu
                  | std.number.Integer
                  | doc "Maximum CPU thread count that each container of the service can scale up to."
                  | optional,
                maxDisk
                  | Number
                  | doc "Maximum disk space in GB that each container of the service can scale up to."
                  | optional,
                maxRam
                  | Number
                  | doc "Maximum RAM in GB that each container of the service can scale up to."
                  | optional,
                maxVCpu | std.number.Integer | optional,
                minCpu
                  | std.number.Integer
                  | doc "Minimum CPU thread count that each container of the service can scale down to."
                  | optional,
                minDisk
                  | Number
                  | doc "Minimum disk space in GB that each container of the service can scale down to."
                  | optional,
                minFreeCpuCores
                  | Number
                  | doc "Minimum number of unused CPU cores before a container starts scaling."
                  | optional,
                minFreeCpuPercent
                  | Number
                  | doc "Minimum percentage of unused CPU cores before a container starts scaling."
                  | optional,
                minFreeRamGB
                  | Number
                  | doc "Minimum unused memory in GB before a container starts scaling."
                  | optional,
                minFreeRamPercent
                  | Number
                  | doc "Minimum percentage of unused memory before a container starts scaling."
                  | optional,
                minRam
                  | Number
                  | doc "Minimum RAM in GB that each container of the service can scale down to."
                  | optional,
                minVCpu | std.number.Integer | optional,
                ram
                  | Number
                  | doc "Fixed RAM in GB that each container of the service will be set to."
                  | optional,
                startCpuCoreCount
                  | std.number.Integer
                  | doc "Number of CPU cores with which each container starts."
                  | optional,
                swapEnabled
                  | Bool
                  | doc "Whether to enable swap memory for containers. Swap is enabled by default. Refer to documentation for more details."
                  | optional,
              }
              | doc "Vertical autoscaling settings."
              | optional,
            zeropsSetup | String | optional,
            zeropsYaml
              | {
                zerops
                  | Array
                    {
                      build
                        | {
                          addToRunPrepare
                            | Array (String)
                            | doc "Defines what files or folders will be copied from the build container to the prepare runtime container. The prepare runtime container is used to customize your runtime environment."
                            | optional,
                          base
                            | Array (String)
                            | doc "Sets the base technology for the build environment. If you need to install more technologies to the build environment, set multiple values as a yaml array."
                            | optional,
                          buildCommands
                            | Array (String)
                            | doc "Defines build commands. Zerops triggers each command in the defined order in a dedicated build container."
                            | optional,
                          cache
                            | {}
                            | doc "Defines which files or folders will be cached for the next build."
                            | optional,
                          deploy | Array (String) | optional,
                          deployFiles
                            | Array (String)
                            | doc "Selects which files or folders will be deployed after the build has successfully finished. To filter out specific files or folders, use .deployignore file.",
                          envVariables
                            | _js2n__-prdslib.contract_from_predicate
                              (_js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record {} {} true
                                    (_js2n__-prdslib.isType '"String")
                                ])
                            | doc "Defines the environment variables for the build environment."
                            | optional,
                          os
                            | String
                            | doc "Sets the operating system for the runtime environment."
                            | optional,
                          prepareCommands
                            | Array (String)
                            | doc "Customises the build environment by installing additional dependencies or tools to the base build environment."
                            | optional,
                        }
                        | doc "Build pipeline configuration."
                        | optional,
                      deploy
                        | {
                          readinessCheck
                            | {
                              exec
                                | {
                                  command
                                    | String
                                    | doc "Defines a local command to be run. The command has access to the same environment variables. A single string is required. If you need to run multiple commands create a shell script or, use a multiline format as in the example below.",
                                }
                                | doc "Configures the readiness check to run a local command."
                                | optional,
                              failureTimeout
                                | std.number.Integer
                                | doc "Time until container is marked as failed."
                                | optional,
                              httpGet
                                | {
                                  host
                                    | String
                                    | doc "The readiness check is triggered from inside of your runtime container so it always uses the localhost (127.0.0.1). If you need to add a host to the request header, specify it in the host attribute."
                                    | optional,
                                  path
                                    | String
                                    | doc "Defines the URL path of the HTTP GET request.",
                                  port
                                    | std.number.Integer
                                    | doc "Defines the port of the HTTP GET request.",
                                  scheme
                                    | String
                                    | doc "The readiness check is triggered from inside of your runtime container so no https is required. If your application requires a https request, set scheme: https"
                                    | optional,
                                }
                                | doc "Configures the readiness check to request a local URL using a http GET method."
                                | optional,
                              retryPeriod
                                | std.number.Integer
                                | doc "Time interval between readiness check attempts."
                                | optional,
                            }
                            | doc "Defines a readiness check. Requires either httpGet object or exec object."
                            | optional,
                          temporaryShutdown | Bool | optional,
                        }
                        | doc "Deploy configuration."
                        | optional,
                      run
                        | {
                          base
                            | String
                            | doc "Sets the base technology for the runtime environment. If you don't specify the run.base attribute, Zerops keeps the current version for your runtime."
                            | optional,
                          crontab
                            | Array
                              {
                                allContainers
                                  | Bool
                                  | doc "If set to true, the job runs on all containers; otherwise, it runs on a single container (default: false)",
                                command
                                  | String
                                  | doc "Specifies the shell command to run at the scheduled time.",
                                timing
                                  | String
                                  | doc "Defines when the cron job runs in standard cron format.",
                                workingDir
                                  | String
                                  | doc "The directory where the command will be executed (default: /var/www)"
                                  | optional,
                              }
                            | doc "A list of cron jobs with their respective schedule (timing), the command to run (command), and additional options like allContainers and workingDir."
                            | optional,
                          documentRoot
                            | String
                            | doc "Customizes the folder that will be used as the root of the publicly accessible web server content. This attribute is available only for runtimes with webservers."
                            | optional,
                          envReplace
                            | {
                              delimiter | Array (String),
                              target | Array (String),
                            }
                            | optional,
                          envVariables
                            | _js2n__-prdslib.contract_from_predicate
                              (_js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record {} {} true
                                    (_js2n__-prdslib.isType '"String")
                                ])
                            | doc "Defines the environment variables for the runtime environment."
                            | optional,
                          healthCheck
                            | {
                              disconnectTimeout
                                | std.number.Integer
                                | doc "Time until container is disconnected and becomes publicly unavailable."
                                | optional,
                              exec
                                | {
                                  command
                                    | String
                                    | doc "Defines a local command to be run. The command has access to the same environment variables. A single string is required. If you need to run multiple commands create a shell script or, use a multiline format as in the example below.",
                                }
                                | doc "Configures the health check to run a local command."
                                | optional,
                              execPeriod
                                | std.number.Integer
                                | doc "Time interval between health check attempts."
                                | optional,
                              failureTimeout
                                | std.number.Integer
                                | doc "Time until container fails after consecutive health check failures (reset by success)."
                                | optional,
                              httpGet
                                | {
                                  host
                                    | String
                                    | doc "The readiness check is triggered from inside of your runtime container so it always uses the localhost (127.0.0.1). If you need to add a host to the request header, specify it in the host attribute."
                                    | optional,
                                  path
                                    | String
                                    | doc "Defines the URL path of the HTTP GET request.",
                                  port
                                    | std.number.Integer
                                    | doc "Defines the port of the HTTP GET request.",
                                  scheme
                                    | String
                                    | doc "The readiness check is triggered from inside of your runtime container so no https is required. If your application requires a https request, set scheme: https"
                                    | optional,
                                }
                                | doc "Configures the health check to request a local URL using a http GET method."
                                | optional,
                              recoveryTimeout
                                | std.number.Integer
                                | doc "Time until container is connected and becomes publicly available."
                                | optional,
                            }
                            | doc "Defines a health check."
                            | optional,
                          initCommands
                            | Array (String)
                            | doc "Defines one or more commands to be run each time a new runtime container is started or a container is restarted."
                            | optional,
                          os
                            | String
                            | doc "Sets the operating system for the runtime environment."
                            | optional,
                          ports
                            | Array
                              {
                                description | String | optional,
                                httpSupport
                                  | Bool
                                  | doc "Set to true if a web server is running on the port. Zerops uses this information for the configuration of public access. True is available only in combination with the TCP protocol. Default value is false."
                                  | optional,
                                port
                                  | std.number.Integer
                                  | doc "Defines the port number. You can set any port number between 10 and 65435. Ports outside this interval are reserved for internal Zerops systems.",
                                protocol
                                  | String
                                  | doc "Defines the protocol. Allowed values are TCP or UDP. Default value is TCP."
                                  | optional,
                              }
                            | doc "Specifies one or more internal ports on which your application will listen."
                            | optional,
                          prepareCommands
                            | Array (String)
                            | doc "Customises the runtime environment by installing additional dependencies or tools to the base runtime environment."
                            | optional,
                          routing
                            | {
                              redirects
                                | Array
                                  {
                                    from
                                      | String
                                      | doc "Relative or an absolute (defined by with http://) path to be matched against request location. May contain * at the end for regex.",
                                    preservePath
                                      | Bool
                                      | doc "Whether part of the path after From should be preserved. Used to forward contents of one directory to another in non-masked redirects."
                                      | optional,
                                    preserveQuery
                                      | Bool
                                      | doc "Whether query parameters should be preserved. Used in non-masked redirects."
                                      | optional,
                                    status
                                      | std.number.Integer
                                      | doc "Which HTTP status code to use for the redirect. If not set, and To and From are relative, an internal/masked redirect will be used."
                                      | optional,
                                    to
                                      | String
                                      | doc "Relative or an absolute (defined by with http://) path to redirect user to.",
                                  }
                                | optional,
                              root | String | optional,
                            }
                            | optional,
                          siteConfigPath
                            | String
                            | doc "Sets the custom webserver configuration. This attribute is available only for runtimes with webservers."
                            | optional,
                          start
                            | String
                            | doc "Defines the start command for your application."
                            | optional,
                          startCommands
                            | Array
                              {
                                command | String,
                                initCommands
                                  | Array (String)
                                  | doc "Defines one or more commands to be run each time a new runtime container is started or a container is restarted."
                                  | optional,
                                name | String | optional,
                                workingDir | String | optional,
                              }
                            | doc "Defines the start commands for the runtime environment."
                            | optional,
                        }
                        | doc "Runtime configuration."
                        | optional,
                      setup
                        | String
                        | doc "The first element setup contains the hostname of your service. A runtime service with the same hostname must exist in Zerops. Zerops supports the definition of multiple runtime services in a single zerops.yml. This is useful when you use a monorepo. Just add multiple setup elements in your zerops.yml.",
                    }
                  | doc "The top-level element is always zerops.",
              }
              | optional,
          }
        | optional,
    }