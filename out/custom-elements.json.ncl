# DO NOT EDIT
# This file was automatically generated using json-schema-to-nickel
let predicates =
{
    allOf
      : Array (Dyn -> { success: Bool, error: String }) -> Dyn -> {
        success: Bool,
        error: String
      }
      | doc m%"
      `allOf preds` succeeds if all of the predicates in `preds` succeed
      Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.7.1]
      "%
      = fun preds x => std.array.fold_right
          (fun pred acc => let result = pred x in
            if !result.success then result else acc)
          { error = "", success = true, }
          preds,
    always : Dyn -> { success: Bool, error: String }
      = std.function.const { error = "", success = true, },
    anyOf
      : Array (Dyn -> { success: Bool, error: String }) -> Dyn -> {
        success: Bool,
        error: String
      }
      | doc m%"
      `anyOf preds` succeeds if at least one of the predicates in `preds` succeeds
      Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.7.2]
      "%
      = fun preds x => (fun result => if result.success then
            { error = "", success = true, }
            else
            {
              error = m%"
                  anyOf: none of the options matched%{std.string.join "\n"
                  result.errors}
                  "%,
              success = false,
            })
          (std.array.fold_right
          (fun pred acc => let result = pred x in
            if result.success || acc.success then
            { errors = [  ], success = true, }
            else
            {
              errors = [
                      m%"
                      - %{result.error}
                      "%
                    ] @
                    acc.errors,
              success = false,
            })
          { errors = [  ], success = false, }
          preds),
    arrays = {
          additionalItems
            : (Dyn -> { success: Bool, error: String }) -> Number -> Dyn -> {
              success: Bool,
              error: String
            }
            | doc m%"
            Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.4.2]
            "%
            = fun pred start x => if !(std.is_array x) then
                { error = "", success = true, }
                else
                (let x  | Array Dyn = x in
                let value_length = std.array.length x in
                if start >= value_length then
                { error = "", success = true, }
                else
                (arrayOf pred ((std.array.slice start value_length x) | Dyn))),
          arrayOf
            : (Dyn -> { success: Bool, error: String }) -> Dyn -> {
              success: Bool,
              error: String
            }
            | doc m%"
            Apply a predicate to all elements of an array, succeeding if all
            applications succeed. If the value isn't an array, fail.
            "%
            = fun pred x => if !(std.is_array x) then
                { error = "", success = true, }
                else
                (let x  | Array Dyn = x in
                std.array.fold_right
                (fun x acc => let result = pred x in
                  if !result.success then result else acc)
                { error = "", success = true, }
                x),
          contains
            : (Dyn -> { success: Bool, error: String }) -> Dyn -> {
              success: Bool,
              error: String
            }
            | doc m%"
            Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.4.6]
            "%
            = fun pred x => if !(std.is_array x) then
                { error = "", success = true, }
                else
                (let x  | Array Dyn = x in
                (fun result => if result.success then
                  { error = "", success = true, }
                  else
                  {
                    error = m%"
                        contains: no elements matched%{std.string.join "\n"
                        result.errors}
                        "%,
                    success = false,
                  })
                (std.array.fold_right
                (fun x acc => let result = pred x in
                  if result.success || acc.success then
                  { errors = [  ], success = true, }
                  else
                  {
                    errors = [
                            m%"
                            - %{result.error}
                            "%
                          ] @
                          acc.errors,
                    success = false,
                  })
                { errors = [  ], success = false, }
                x)),
          items
            : Array (Dyn -> { success: Bool, error: String }) -> Dyn -> {
              success: Bool,
              error: String
            }
            | doc m%"
            Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.4.1]
            "%
            = fun preds x => if !(std.is_array x) then
                { error = "", success = true, }
                else
                (let x  | Array Dyn = x in
                let length_to_check =
                std.number.min (std.array.length preds) (std.array.length x)
                in
                
                std.array.fold_right
                (fun i acc => let result =
                  std.array.at i preds (std.array.at i x)
                  in
                  
                  if !result.success then result else acc)
                { error = "", success = true, }
                (std.array.range 0 length_to_check)),
          maxItems
            : Number -> Dyn -> { success: Bool, error: String }
            | doc m%"
            `maxItems n x` fails if `x` is an array of length strictly greater than `n` and succeeds otherwise.
            Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.4.3]
            "%
            = fun n x => if !(std.is_array x) then
                { error = "", success = true, }
                else
                (if (std.array.length (x | Array Dyn)) > n then
                {
                    error = m%"
                        array is longer than %{std.string.from_number n} items
                        "%,
                    success = false,
                  }
                else
                { error = "", success = true, }),
          minItems
            : Number -> Dyn -> { success: Bool, error: String }
            | doc m%"
            `minItems n x` fails if `x` is an array of length strictly smaller than `n` and succeeds otherwise.
            Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.4.4]
            "%
            = fun n x => if !(std.is_array x) then
                { error = "", success = true, }
                else
                (if (std.array.length (x | Array Dyn)) < n then
                {
                    error = m%"
                        array is shorter than %{std.string.from_number n} items
                        "%,
                    success = false,
                  }
                else
                { error = "", success = true, }),
          uniqueItems
            : Dyn -> { success: Bool, error: String }
            | doc m%"
            Succeeds for any array if its elements are pairwise distinct.
            Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.4.5]
            "%
            = let find_duplicate 
                : Array Dyn -> {
                  has_duplicate: Bool,
                  duplicate: Dyn,
                  seen: { _ : Bool }
                } =
              std.array.fold_right
                (fun elt acc => if acc.has_duplicate then acc else
                  (let index = std.serialize 'Json elt in
                  if std.record.has_field index acc.seen then
                  { duplicate = elt, has_duplicate = true, seen = acc.seen, }
                  else
                  {
                    duplicate = null,
                    has_duplicate = false,
                    seen = std.record.insert index true acc.seen,
                  }))
                { duplicate = null, has_duplicate = false, seen = {  }, }
              in
              
              fun x => if !(std.is_array x) then
                { error = "", success = true, }
                else
                (let {has_duplicate  | Dyn, duplicate  | Dyn, ..} =
                find_duplicate (x | Array Dyn)
                in
                
                if has_duplicate then
                {
                    error = m%"
                        duplicate found: %{std.serialize 'Json duplicate}
                        "%,
                    success = false,
                  }
                else
                { error = "", success = true, }),
        },
    const
      : Dyn -> Dyn -> { success: Bool, error: String }
      | doc m%"
      `const value x` succeeds if and only if `x` is equalt to `value`
      Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.1.3]
      "%
      = fun value x => if x == value then { error = "", success = true, } else
          {
            error = m%"
                expected %{std.serialize 'Json value}
                "%,
            success = false,
          },
    contract_from_predicate
      : (Dyn -> { success: Bool, error: String }) -> Dyn -> Dyn -> Dyn
      = fun predicate label value => let {success  | Dyn, error  | Dyn} =
          predicate value
          in
          
          if success then value else
          ((std.contract.blame_with_message error label) | Dyn),
    enum
      : Array Dyn -> Dyn -> { success: Bool, error: String }
      | doc m%"
      `enum values x` succeeds if and only if `x` is equal to one of the elements of `values`.
      Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.1.2]
      "%
      = let checkEqual =
        fun input variant => (input == variant) ||
            ((std.is_enum input) &&
            (((std.string.from_enum input) == variant) | Bool))
        in
        
        fun values x => std.array.fold_right
          (fun value acc => if checkEqual x value then
            { error = "", success = true, }
            else
            acc)
          {
            error = m%"
                expected one of %{std.serialize 'Json (values | Dyn)}
                "%,
            success = false,
          }
          values,
    from_simple_predicate
      : String -> (Dyn -> Bool) -> Dyn -> { success: Bool, error: String }
      | doc m%"
      Convert a simple boolean predicate into a predicate supporting error messages
      "%
      = fun error' pred x => { error = error', success = pred x, },
    ifThenElse
      : (Dyn -> { success: Bool, error: String }) -> (Dyn -> {
        success: Bool,
        error: String
      }) -> (Dyn -> { success: Bool, error: String }) -> Dyn -> {
        success: Bool,
        error: String
      }
      | doc m%"
      `ifThenElse i t e` first checks if the predicate `i` succeeds. If it does, it's equivalent to `t`, otherwise it's equivalent to `e`.
      Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.6]
      "%
      = fun i t e x => let {success  | Dyn, ..} = i x in
          if success then t x else (e x),
    isType
      : [| '"Array", '"Bool", 'Integer, 'Null, '"Number", 'Record, '"String" |]
      -> Dyn -> { success: Bool, error: String }
      = fun t => (match {'Integer => from_simple_predicate "expected an integer"
            (fun x => (std.is_number x) &&
              (std.number.is_integer (x | Number))),
            'Null => from_simple_predicate "expected `null`"
            (fun x => x == null),
            _ => from_simple_predicate
            m%"
            value is not of type %{std.string.from_enum t}
            "%
            (fun x => (std.typeof x) == t)
          })
          t,
    never : Dyn -> { success: Bool, error: String }
      = std.function.const { error = "never", success = false, },
    not
      : (Dyn -> { success: Bool, error: String }) -> Dyn -> {
        success: Bool,
        error: String
      }
      | doc m%"
      `not pred` succeeds if and only if `pred` fails
      Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.7.4]
      "%
      = fun pred x => let result = pred x in
          if result.success then
          {
              error = "Inverted predicate succeeded unexpectedly",
              success = false,
            }
          else
          { error = "", success = true, },
    numbers = {
          exclusiveMaximum
            : Number -> Dyn -> { success: Bool, error: String }
            | doc m%"
            Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.2.3]
            "%
            = fun limit x => if !(std.is_number x) then
                { error = "", success = true, }
                else
                (if (x | Number) < limit then
                { error = "", success = true, }
                else
                {
                  error = m%"
                      expected an exclusive maximum of %{std.string.from_number
                      limit}
                      "%,
                  success = false,
                }),
          exclusiveMinimum
            : Number -> Dyn -> { success: Bool, error: String }
            | doc m%"
            Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.2.5]
            "%
            = fun limit x => if !(std.is_number x) then
                { error = "", success = true, }
                else
                (if (x | Number) > limit then
                { error = "", success = true, }
                else
                {
                  error = m%"
                      expected an exclusive minimum of %{std.string.from_number
                      limit}
                      "%,
                  success = false,
                }),
          maximum
            : Number -> Dyn -> { success: Bool, error: String }
            | doc m%"
            Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.2.2]
            "%
            = fun limit x => if !(std.is_number x) then
                { error = "", success = true, }
                else
                (if (x | Number) <= limit then
                { error = "", success = true, }
                else
                {
                  error = m%"
                      expected a maximum of %{std.string.from_number limit}
                      "%,
                  success = false,
                }),
          minimum
            : Number -> Dyn -> { success: Bool, error: String }
            | doc m%"
            Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.2.4]
            "%
            = fun limit x => if !(std.is_number x) then
                { error = "", success = true, }
                else
                (if (x | Number) >= limit then
                { error = "", success = true, }
                else
                {
                  error = m%"
                      expected a minimum of %{std.string.from_number limit}
                      "%,
                  success = false,
                }),
          multipleOf
            : Number -> Dyn -> { success: Bool, error: String }
            | doc m%"
            Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.2.1]
            "%
            = fun mult x => if !(std.is_number x) then
                { error = "", success = true, }
                else
                (if std.number.is_integer ((x | Number) / mult) then
                { error = "", success = true, }
                else
                {
                  error = m%"
                      expected a multiple of %{std.string.from_number mult}
                      "%,
                  success = false,
                }),
        },
    oneOf
      : Array (Dyn -> { success: Bool, error: String }) -> Dyn -> {
        success: Bool,
        error: String
      }
      | doc m%"
      `oneOf preds` succeeds if precisely one of the predicates in `preds` succeeds
      Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.7.3]
      "%
      = fun preds x => let count_true 
            : Array { success: Bool, error: String } -> Number =
          fun results => std.array.fold_left
              (fun n b => if b.success then n + 1 else n)
              0
              results
          in
          
          let results = std.array.map (fun pred => pred x) preds in
          let count = count_true results in
          if count == 0 then
          let errors =
            std.array.map
              (fun result => m%"
                - %{result.error}
                "%)
              results
            in
            
            {
              error = m%"
                  oneOf: none of the options matched%{std.string.join "\n"
                  errors}
                  "%,
              success = false,
            }
          else
          (if count > 1 then
          {
              error = "oneOf: more than one of the options matched",
              success = false,
            }
          else
          { error = "", success = true, }),
    records = {
          dependencies
            : { _ : Dyn } -> Dyn -> { success: Bool, error: String }
            | doc m%"
            Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.5.7]
            "%
            = let mustHaveFields 
                : Array String -> { _ : Dyn } -> {
                  success: Bool,
                  error: String
                } =
              fun fields x => std.array.fold_right
                  (fun field acc => if !(std.record.has_field field x) then
                    {
                        error = m%"
                            expected field `%{field}`
                            "%,
                        success = false,
                      }
                    else
                    acc)
                  { error = "", success = true, }
                  fields
              in
              
              fun deps x => if !(std.is_record x) then
                { error = "", success = true, }
                else
                (let x  | { _ : Dyn } = x in
                std.array.fold_right
                (fun {field  | Dyn, value  | Dyn} => fun acc =>
                  if !(std.record.has_field field x) then acc else
                    (let result =
                    if std.is_array value then
                      mustHaveFields (value | Array String) x
                      else
                      (let pred  | Dyn -> { success: Bool, error: String } =
                      value
                      in
                      
                      pred (x | Dyn))
                    in
                    
                    if !result.success then
                    {
                        error = m%"
                            dependency of `%{field}` failed: %{result.error}
                            "%,
                        success = false,
                      }
                    else
                    acc))
                { error = "", success = true, }
                (std.record.to_array deps)),
          maxProperties
            : Number -> Dyn -> { success: Bool, error: String }
            | doc m%"
            `maxProperties n x` fails if `x` is a record containing stricly more than `n` fields.
            Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.5.1]
            "%
            = fun n x => if !(std.is_record x) then
                { error = "", success = true, }
                else
                (if (std.record.length (x | { _ : Dyn })) > n then
                {
                    error = m%"
                        record contains more than %{std.string.from_number
                        n} fields
                        "%,
                    success = false,
                  }
                else
                { error = "", success = true, }),
          minProperties
            : Number -> Dyn -> { success: Bool, error: String }
            | doc m%"
            `minProperties n x` fails if `x` is a record containing stricly less than `n` fields.
            Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.5.1]
            "%
            = fun n x => if !(std.is_record x) then
                { error = "", success = true, }
                else
                (if (std.record.length (x | { _ : Dyn })) < n then
                {
                    error = m%"
                        record contains fewer than %{std.string.from_number
                        n} fields
                        "%,
                    success = false,
                  }
                else
                { error = "", success = true, }),
          propertyNames
            : (Dyn -> { success: Bool, error: String }) -> Dyn -> {
              success: Bool,
              error: String
            }
            | doc m%"
            Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.5.8]
            "%
            = fun pred x => if !(std.is_record x) then
                { error = "", success = true, }
                else
                (std.array.fold_right
                (fun field acc => let result = pred (field | Dyn) in
                  if !result.success then
                  {
                      error = m%"
                          field `%{field}` did not validate against `propertyNames` schema
                          "%,
                      success = false,
                    }
                  else
                  acc)
                { error = "", success = true, }
                (std.record.fields (x | { _ : Dyn }))),
          record
            : { _ : Dyn -> { success: Bool, error: String } } -> { _ : Dyn -> {
              success: Bool,
              error: String
            } } -> Bool -> (Dyn -> { success: Bool, error: String }) -> Dyn -> {
              success: Bool,
              error: String
            }
            | doc m%"
            `record properties patternProperties additionalAllowed
            additionalProperties x` is a combination of the `properties`,
            `patternProperties` and `additionalProperties` validation keywords in
            JSON schema.
            
            Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.5]
            "%
            =
            fun properties patternProperties additionalAllowed additionalProperties x =>
              if !(std.is_record x) then { error = "", success = true, } else
                (let x  | { _ : Dyn } = x in
                let check_properties 
                  : { success: Bool, error: String, checked: { _ : Bool } } =
                std.array.fold_right
                  (fun {field  | Dyn, value  | Dyn} => fun acc =>
                    if !(std.record.has_field field x) then acc else
                      (let result = value x."%{field}" in
                      if !result.success then
                      {
                          checked : { _ : Bool }
                            = {  },
                          error = m%"
                              field `%{field}` didn't validate: %{result.error}
                              "%,
                          success = false,
                        }
                      else
                      {
                        checked = std.record.insert field true acc.checked,
                        error = acc.error,
                        success = acc.success,
                      }))
                  { checked = {  }, error = "", success = true, }
                  (std.record.to_array properties)
                in
                
                let matching_fields  : String -> { _ : Dyn } =
                fun pattern => let matcher = std.string.is_match pattern in
                    std.array.fold_left
                    (fun acc => fun {field  | Dyn, value  | Dyn} => if matcher
                        field then
                        std.record.insert field value acc
                        else
                        acc)
                    {  }
                    (std.record.to_array x)
                in
                
                let check_pattern_properties 
                  : { success: Bool, error: String, checked: { _ : Bool } } =
                std.array.fold_right
                  (fun {field  | Dyn = pattern, value  | Dyn = pred} =>
                  fun acc => let result =
                      std.array.fold_right
                        (fun {field  | Dyn, value  | Dyn} => fun acc =>
                          let result = pred value in
                            if !result.success then
                            {
                                checked : { _ : Bool }
                                  = {  },
                                error = m%"
                                    field `%{field}` didn't validate: %{result.error}
                                    "%,
                                success = false,
                              }
                            else
                            {
                              checked = std.record.insert field true
                                  acc.checked,
                              error = acc.error,
                              success = acc.success,
                            })
                        {
                          checked : { _ : Bool }
                            = {  },
                          error = "",
                          success = true,
                        }
                        (std.record.to_array (matching_fields pattern))
                      in
                      
                      if !result.success then result else
                      {
                        checked = std.array.fold_left
                            (fun r field => if !(std.record.has_field field
                              r) then
                              std.record.insert field true r
                              else
                              r)
                            acc.checked
                            (std.record.fields result.checked),
                        error = acc.error,
                        success = acc.success,
                      })
                  { checked : { _ : Bool } = {  }, error = "", success = true, }
                  (std.record.to_array patternProperties)
                in
                
                let remaining_fields =
                std.array.fold_left
                  (fun acc field => if !(std.record.has_field field acc) then
                    acc
                    else
                    (std.record.remove field acc))
                  x
                  ((std.record.fields check_properties.checked) @
                    (std.record.fields check_pattern_properties.checked))
                in
                
                let check_additional_properties 
                  : { success: Bool, error: String } =
                if (!additionalAllowed) &&
                  (!(std.record.is_empty remaining_fields)) then
                  {
                      error = m%"
                          extra fields %{std.serialize 'Json
                          ((std.record.fields remaining_fields) | Dyn)}
                          "%,
                      success = false,
                    }
                  else
                  (std.array.fold_right
                  (fun {field  | Dyn, value  | Dyn} => fun acc => let result =
                      additionalProperties value
                      in
                      
                      if !result.success then
                      {
                          error = m%"
                              field `%{field}` didn't validate: %{result.error}
                              "%,
                          success = false,
                        }
                      else
                      acc)
                  { error = "", success = true, }
                  (std.record.to_array remaining_fields))
                in
                
                if !check_properties.success then
                { error = check_properties.error, success = false, }
                else
                (if !check_pattern_properties.success then
                { error = check_pattern_properties.error, success = false, }
                else
                check_additional_properties)),
          required
            : Array String -> Dyn -> { success: Bool, error: String }
            | doc m%"
            Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.5.3]
            "%
            = fun fields x => if !(std.is_record x) then
                { error = "", success = true, }
                else
                (std.array.fold_right
                (fun field acc => if !(std.record.has_field field
                  (x | { _ : Dyn })) then
                  {
                      error = m%"
                          missing required field %{field}
                          "%,
                      success = false,
                    }
                  else
                  acc)
                { error = "", success = true, }
                fields),
        },
    strings = {
          maxLength
            : Number -> Dyn -> { success: Bool, error: String }
            | doc m%"
            Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.3.1]
            "%
            = fun limit x => if !(std.is_string x) then
                { error = "", success = true, }
                else
                (if (std.string.length (x | String)) <= limit then
                { error = "", success = true, }
                else
                {
                  error = m%"
                      expected a string of length no larger than %{std.string.from_number
                      limit}
                      "%,
                  success = false,
                }),
          minLength
            : Number -> Dyn -> { success: Bool, error: String }
            | doc m%"
            Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.3.2]
            "%
            = fun limit x => if !(std.is_string x) then
                { error = "", success = true, }
                else
                (if (std.string.length (x | String)) >= limit then
                { error = "", success = true, }
                else
                {
                  error = m%"
                      expected a string of length no smaller than %{std.string.from_number
                      limit}
                      "%,
                  success = false,
                }),
          pattern
            : String -> Dyn -> { success: Bool, error: String }
            | doc m%"
            Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.3.3]
            "%
            = fun pattern x => if !(std.is_string x) then
                { error = "", success = true, }
                else
                (if std.string.is_match pattern (x | String) then
                { error = "", success = true, }
                else
                {
                  error = m%"
                      expected a string matching the pattern `%{pattern}`
                      "%,
                  success = false,
                }),
        },
  }
in

let rec definitions =
{
    contract = {
          Attribute = {
                "default"
                  | String
                  | doc m%"
                  The default value of the attribute, if any.
                  
                  As attributes are always strings, this is the actual value, not a human
                  readable description.
                  "%
                  | optional,
                deprecated
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType '"Bool" ])
                  | doc m%"
                  Whether the attribute is deprecated.
                  If the value is a string, it's the reason for the deprecation.
                  "%
                  | optional,
                description
                  | String
                  | doc m%"
                  A markdown description.
                  "%
                  | optional,
                fieldName
                  | String
                  | doc m%"
                  The name of the field this attribute is associated with, if any.
                  "%
                  | optional,
                inheritedFrom | definitions.contract.Reference | optional,
                name | String,
                summary
                  | String
                  | doc m%"
                  A markdown summary suitable for display in a listing.
                  "%
                  | optional,
                type
                  | definitions.contract.Type
                  | doc m%"
                  The type that the attribute will be serialized/deserialized as.
                  "%
                  | optional,
                ..
              },
          ClassDeclaration = {
                deprecated
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType '"Bool" ])
                  | doc m%"
                  Whether the class or mixin is deprecated.
                  If the value is a string, it's the reason for the deprecation.
                  "%
                  | optional,
                description
                  | String
                  | doc m%"
                  A markdown description of the class.
                  "%
                  | optional,
                kind | std.enum.TagOrString | [| 'class |],
                members
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      definitions.predicate.ClassField,
                      definitions.predicate.ClassMethod
                    ])
                  ])
                  | optional,
                mixins
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Reference
                  ])
                  | doc m%"
                  Any class mixins applied in the extends clause of this class.
                  
                  If mixins are applied in the class definition, then the true superclass
                  of this class is the result of applying mixins in order to the superclass.
                  
                  Mixins must be listed in order of their application to the superclass or
                  previous mixin application. This means that the innermost mixin is listed
                  first. This may read backwards from the common order in JavaScript, but
                  matches the order of language used to describe mixin application, like
                  "S with A, B".
                  "%
                  | optional,
                name | String,
                source | definitions.contract.SourceReference | optional,
                summary
                  | String
                  | doc m%"
                  A markdown summary suitable for display in a listing.
                  "%
                  | optional,
                superclass
                  | definitions.contract.Reference
                  | doc m%"
                  The superclass of this class.
                  
                  If this class is defined with mixin applications, the prototype chain
                  includes the mixin applications and the true superclass is computed
                  from them.
                  "%
                  | optional,
                ..
              },
          ClassField = {
                "default" | String | optional,
                deprecated
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType '"Bool" ])
                  | doc m%"
                  Whether the property is deprecated.
                  If the value is a string, it's the reason for the deprecation.
                  "%
                  | optional,
                description
                  | String
                  | doc m%"
                  A markdown description of the field.
                  "%
                  | optional,
                inheritedFrom | definitions.contract.Reference | optional,
                kind | std.enum.TagOrString | [| 'field |],
                name | String,
                privacy | definitions.contract.Privacy | optional,
                readonly
                  | Bool
                  | doc m%"
                  Whether the property is read-only.
                  "%
                  | optional,
                source | definitions.contract.SourceReference | optional,
                static | Bool | optional,
                summary
                  | String
                  | doc m%"
                  A markdown summary suitable for display in a listing.
                  "%
                  | optional,
                type | definitions.contract.Type | optional,
                ..
              },
          ClassMethod = {
                deprecated
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType '"Bool" ])
                  | doc m%"
                  Whether the function is deprecated.
                  If the value is a string, it's the reason for the deprecation.
                  "%
                  | optional,
                description
                  | String
                  | doc m%"
                  A markdown description.
                  "%
                  | optional,
                inheritedFrom | definitions.contract.Reference | optional,
                kind | std.enum.TagOrString | [| 'method |],
                name | String,
                parameters
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Parameter
                  ])
                  | optional,
                privacy | definitions.contract.Privacy | optional,
                return
                  | {
                    description
                      | String
                      | doc m%"
                      A markdown description.
                      "%
                      | optional,
                    summary
                      | String
                      | doc m%"
                      A markdown summary suitable for display in a listing.
                      "%
                      | optional,
                    type | definitions.contract.Type | optional,
                    ..
                  }
                  | optional,
                source | definitions.contract.SourceReference | optional,
                static | Bool | optional,
                summary
                  | String
                  | doc m%"
                  A markdown summary suitable for display in a listing.
                  "%
                  | optional,
                ..
              },
          CssCustomProperty = {
                "default" | String | optional,
                deprecated
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType '"Bool" ])
                  | doc m%"
                  Whether the CSS custom property is deprecated.
                  If the value is a string, it's the reason for the deprecation.
                  "%
                  | optional,
                description
                  | String
                  | doc m%"
                  A markdown description.
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  The name of the property, including leading `--`.
                  "%,
                summary
                  | String
                  | doc m%"
                  A markdown summary suitable for display in a listing.
                  "%
                  | optional,
                syntax
                  | String
                  | doc m%"
                  The expected syntax of the defined property. Defaults to "*".
                  
                  The syntax must be a valid CSS [syntax string](https://developer.mozilla.org/en-US/docs/Web/CSS/@property/syntax)
                  as defined in the CSS Properties and Values API.
                  
                  Examples:
                  
                  "<color>": accepts a color
                  "<length> | <percentage>": accepts lengths or percentages but not calc expressions with a combination of the two
                  "small | medium | large": accepts one of these values set as custom idents.
                  "*": any valid token
                  "%
                  | optional,
                ..
              },
          CssPart
            | doc m%"
            The description of a CSS Part
            "%
            = {
                deprecated
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType '"Bool" ])
                  | doc m%"
                  Whether the CSS shadow part is deprecated.
                  If the value is a string, it's the reason for the deprecation.
                  "%
                  | optional,
                description
                  | String
                  | doc m%"
                  A markdown description.
                  "%
                  | optional,
                name | String,
                summary
                  | String
                  | doc m%"
                  A markdown summary suitable for display in a listing.
                  "%
                  | optional,
                ..
              },
          CustomElementDeclaration
            | doc m%"
            A description of a custom element class.
            
            Custom elements are JavaScript classes, so this extends from
            `ClassDeclaration` and adds custom-element-specific features like
            attributes, events, and slots.
            
            Note that `tagName` in this interface is optional. Tag names are not
            neccessarily part of a custom element class, but belong to the definition
            (often called the "registration") or the `customElements.define()` call.
            
            Because classes and tag names can only be registered once, there's a
            one-to-one relationship between classes and tag names. For ease of use,
            we allow the tag name here.
            
            Some packages define and register custom elements in separate modules. In
            these cases one `Module` should contain the `CustomElement` without a
            tagName, and another `Module` should contain the
            `CustomElementExport`.
            "%
            = {
                attributes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Attribute
                  ])
                  | doc m%"
                  The attributes that this element is known to understand.
                  "%
                  | optional,
                cssParts
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.CssPart
                  ])
                  | optional,
                cssProperties
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.CssCustomProperty
                  ])
                  | optional,
                customElement
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Bool", predicates.enum [ true ] ])
                  | doc m%"
                  Distinguishes a regular JavaScript class from a
                  custom element class
                  "%,
                demos
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Demo
                  ])
                  | optional,
                deprecated
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType '"Bool" ])
                  | doc m%"
                  Whether the class or mixin is deprecated.
                  If the value is a string, it's the reason for the deprecation.
                  "%
                  | optional,
                description
                  | String
                  | doc m%"
                  A markdown description of the class.
                  "%
                  | optional,
                events
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Event
                  ])
                  | doc m%"
                  The events that this element fires.
                  "%
                  | optional,
                kind | std.enum.TagOrString | [| 'class |],
                members
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      definitions.predicate.ClassField,
                      definitions.predicate.ClassMethod
                    ])
                  ])
                  | optional,
                mixins
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Reference
                  ])
                  | doc m%"
                  Any class mixins applied in the extends clause of this class.
                  
                  If mixins are applied in the class definition, then the true superclass
                  of this class is the result of applying mixins in order to the superclass.
                  
                  Mixins must be listed in order of their application to the superclass or
                  previous mixin application. This means that the innermost mixin is listed
                  first. This may read backwards from the common order in JavaScript, but
                  matches the order of language used to describe mixin application, like
                  "S with A, B".
                  "%
                  | optional,
                name | String,
                slots
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Slot
                  ])
                  | doc m%"
                  The shadow dom content slots that this element accepts.
                  "%
                  | optional,
                source | definitions.contract.SourceReference | optional,
                summary
                  | String
                  | doc m%"
                  A markdown summary suitable for display in a listing.
                  "%
                  | optional,
                superclass
                  | definitions.contract.Reference
                  | doc m%"
                  The superclass of this class.
                  
                  If this class is defined with mixin applications, the prototype chain
                  includes the mixin applications and the true superclass is computed
                  from them.
                  "%
                  | optional,
                tagName
                  | String
                  | doc m%"
                  An optional tag name that should be specified if this is a
                  self-registering element.
                  
                  Self-registering elements must also include a CustomElementExport
                  in the module's exports.
                  "%
                  | optional,
                ..
              },
          CustomElementExport
            | doc m%"
            A global custom element defintion, ie the result of a
            `customElements.define()` call.
            
            This is represented as an export because a definition makes the element
            available outside of the module it's defined it.
            "%
            = {
                declaration
                  | definitions.contract.Reference
                  | doc m%"
                  A reference to the class or other declaration that implements the
                  custom element.
                  "%,
                deprecated
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType '"Bool" ])
                  | doc m%"
                  Whether the custom-element export is deprecated.
                  For example, a future version will not register the custom element in this file.
                  If the value is a string, it's the reason for the deprecation.
                  "%
                  | optional,
                kind | std.enum.TagOrString | [| 'custom-element-definition |],
                name
                  | String
                  | doc m%"
                  The tag name of the custom element.
                  "%,
                ..
              },
          CustomElementMixinDeclaration
            | doc m%"
            A class mixin that also adds custom element related properties.
            "%
            = {
                attributes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Attribute
                  ])
                  | doc m%"
                  The attributes that this element is known to understand.
                  "%
                  | optional,
                cssParts
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.CssPart
                  ])
                  | optional,
                cssProperties
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.CssCustomProperty
                  ])
                  | optional,
                customElement
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Bool", predicates.enum [ true ] ])
                  | doc m%"
                  Distinguishes a regular JavaScript class from a
                  custom element class
                  "%,
                demos
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Demo
                  ])
                  | optional,
                deprecated
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType '"Bool" ])
                  | doc m%"
                  Whether the class or mixin is deprecated.
                  If the value is a string, it's the reason for the deprecation.
                  "%
                  | optional,
                description
                  | String
                  | doc m%"
                  A markdown description of the class.
                  "%
                  | optional,
                events
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Event
                  ])
                  | doc m%"
                  The events that this element fires.
                  "%
                  | optional,
                kind | std.enum.TagOrString | [| 'mixin |],
                members
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      definitions.predicate.ClassField,
                      definitions.predicate.ClassMethod
                    ])
                  ])
                  | optional,
                mixins
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Reference
                  ])
                  | doc m%"
                  Any class mixins applied in the extends clause of this class.
                  
                  If mixins are applied in the class definition, then the true superclass
                  of this class is the result of applying mixins in order to the superclass.
                  
                  Mixins must be listed in order of their application to the superclass or
                  previous mixin application. This means that the innermost mixin is listed
                  first. This may read backwards from the common order in JavaScript, but
                  matches the order of language used to describe mixin application, like
                  "S with A, B".
                  "%
                  | optional,
                name | String,
                parameters
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Parameter
                  ])
                  | optional,
                return
                  | {
                    description
                      | String
                      | doc m%"
                      A markdown description.
                      "%
                      | optional,
                    summary
                      | String
                      | doc m%"
                      A markdown summary suitable for display in a listing.
                      "%
                      | optional,
                    type | definitions.contract.Type | optional,
                    ..
                  }
                  | optional,
                slots
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Slot
                  ])
                  | doc m%"
                  The shadow dom content slots that this element accepts.
                  "%
                  | optional,
                source | definitions.contract.SourceReference | optional,
                summary
                  | String
                  | doc m%"
                  A markdown summary suitable for display in a listing.
                  "%
                  | optional,
                superclass
                  | definitions.contract.Reference
                  | doc m%"
                  The superclass of this class.
                  
                  If this class is defined with mixin applications, the prototype chain
                  includes the mixin applications and the true superclass is computed
                  from them.
                  "%
                  | optional,
                tagName
                  | String
                  | doc m%"
                  An optional tag name that should be specified if this is a
                  self-registering element.
                  
                  Self-registering elements must also include a CustomElementExport
                  in the module's exports.
                  "%
                  | optional,
                ..
              },
          Demo = {
                description
                  | String
                  | doc m%"
                  A markdown description of the demo.
                  "%
                  | optional,
                source | definitions.contract.SourceReference | optional,
                url
                  | String
                  | doc m%"
                  Relative URL of the demo if it's published with the package. Absolute URL
                  if it's hosted.
                  "%,
                ..
              },
          Event = {
                deprecated
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType '"Bool" ])
                  | doc m%"
                  Whether the event is deprecated.
                  If the value is a string, it's the reason for the deprecation.
                  "%
                  | optional,
                description
                  | String
                  | doc m%"
                  A markdown description.
                  "%
                  | optional,
                inheritedFrom | definitions.contract.Reference | optional,
                name | String,
                summary
                  | String
                  | doc m%"
                  A markdown summary suitable for display in a listing.
                  "%
                  | optional,
                type
                  | definitions.contract.Type
                  | doc m%"
                  The type of the event object that's fired.
                  "%,
                ..
              },
          FunctionDeclaration = {
                deprecated
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType '"Bool" ])
                  | doc m%"
                  Whether the function is deprecated.
                  If the value is a string, it's the reason for the deprecation.
                  "%
                  | optional,
                description
                  | String
                  | doc m%"
                  A markdown description.
                  "%
                  | optional,
                kind | std.enum.TagOrString | [| 'function |],
                name | String,
                parameters
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Parameter
                  ])
                  | optional,
                return
                  | {
                    description
                      | String
                      | doc m%"
                      A markdown description.
                      "%
                      | optional,
                    summary
                      | String
                      | doc m%"
                      A markdown summary suitable for display in a listing.
                      "%
                      | optional,
                    type | definitions.contract.Type | optional,
                    ..
                  }
                  | optional,
                source | definitions.contract.SourceReference | optional,
                summary
                  | String
                  | doc m%"
                  A markdown summary suitable for display in a listing.
                  "%
                  | optional,
                ..
              },
          JavaScriptExport = {
                declaration
                  | definitions.contract.Reference
                  | doc m%"
                  A reference to the exported declaration.
                  
                  In the case of aggregating exports, the reference's `module` field must be
                  defined and the `name` field must be `"*"`.
                  "%,
                deprecated
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType '"Bool" ])
                  | doc m%"
                  Whether the export is deprecated. For example, the name of the export was changed.
                  If the value is a string, it's the reason for the deprecation.
                  "%
                  | optional,
                kind | std.enum.TagOrString | [| 'js |],
                name
                  | String
                  | doc m%"
                  The name of the exported symbol.
                  
                  JavaScript has a number of ways to export objects which determine the
                  correct name to use.
                  
                  - Default exports must use the name "default".
                  - Named exports use the name that is exported. If the export is renamed
                    with the "as" clause, use the exported name.
                  - Aggregating exports (`* from`) should use the name `*`
                  "%,
                ..
              },
          JavaScriptModule = {
                declarations
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      definitions.predicate.ClassDeclaration,
                      definitions.predicate.FunctionDeclaration,
                      definitions.predicate.MixinDeclaration,
                      definitions.predicate.VariableDeclaration,
                      definitions.predicate.CustomElementDeclaration,
                      definitions.predicate.CustomElementMixinDeclaration
                    ])
                  ])
                  | doc m%"
                  The declarations of a module.
                  
                  For documentation purposes, all declarations that are reachable from
                  exports should be described here. Ie, functions and objects that may be
                  properties of exported objects, or passed as arguments to functions.
                  "%
                  | optional,
                deprecated
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType '"Bool" ])
                  | doc m%"
                  Whether the module is deprecated.
                  If the value is a string, it's the reason for the deprecation.
                  "%
                  | optional,
                description
                  | String
                  | doc m%"
                  A markdown description of the module.
                  "%
                  | optional,
                exports
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      definitions.predicate.JavaScriptExport,
                      definitions.predicate.CustomElementExport
                    ])
                  ])
                  | doc m%"
                  The exports of a module. This includes JavaScript exports and
                  custom element definitions.
                  "%
                  | optional,
                kind | std.enum.TagOrString | [| 'javascript-module |],
                path
                  | String
                  | doc m%"
                  Path to the javascript file needed to be imported. 
                  (not the path for example to a typescript file.)
                  "%,
                summary
                  | String
                  | doc m%"
                  A markdown summary suitable for display in a listing.
                  "%
                  | optional,
                ..
              },
          MixinDeclaration
            | doc m%"
            A description of a class mixin.
            
            Mixins are functions which generate a new subclass of a given superclass.
            This interfaces describes the class and custom element features that
            are added by the mixin. As such, it extends the CustomElement interface and
            ClassLike interface.
            
            Since mixins are functions, it also extends the FunctionLike interface. This
            means a mixin is callable, and has parameters and a return type.
            
            The return type is often hard or impossible to accurately describe in type
            systems like TypeScript. It requires generics and an `extends` operator
            that TypeScript lacks. Therefore it's recommended that the return type is
            left empty. The most common form of a mixin function takes a single
            argument, so consumers of this interface should assume that the return type
            is the single argument subclassed by this declaration.
            
            A mixin should not have a superclass. If a mixins composes other mixins,
            they should be listed in the `mixins` field.
            
            See [this article]{@link https://justinfagnani.com/2015/12/21/real-mixins-with-javascript-classes/}
            for more information on the classmixin pattern in JavaScript.
            "%
            = {
                deprecated
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType '"Bool" ])
                  | doc m%"
                  Whether the class or mixin is deprecated.
                  If the value is a string, it's the reason for the deprecation.
                  "%
                  | optional,
                description
                  | String
                  | doc m%"
                  A markdown description of the class.
                  "%
                  | optional,
                kind | std.enum.TagOrString | [| 'mixin |],
                members
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      definitions.predicate.ClassField,
                      definitions.predicate.ClassMethod
                    ])
                  ])
                  | optional,
                mixins
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Reference
                  ])
                  | doc m%"
                  Any class mixins applied in the extends clause of this class.
                  
                  If mixins are applied in the class definition, then the true superclass
                  of this class is the result of applying mixins in order to the superclass.
                  
                  Mixins must be listed in order of their application to the superclass or
                  previous mixin application. This means that the innermost mixin is listed
                  first. This may read backwards from the common order in JavaScript, but
                  matches the order of language used to describe mixin application, like
                  "S with A, B".
                  "%
                  | optional,
                name | String,
                parameters
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Parameter
                  ])
                  | optional,
                return
                  | {
                    description
                      | String
                      | doc m%"
                      A markdown description.
                      "%
                      | optional,
                    summary
                      | String
                      | doc m%"
                      A markdown summary suitable for display in a listing.
                      "%
                      | optional,
                    type | definitions.contract.Type | optional,
                    ..
                  }
                  | optional,
                source | definitions.contract.SourceReference | optional,
                summary
                  | String
                  | doc m%"
                  A markdown summary suitable for display in a listing.
                  "%
                  | optional,
                superclass
                  | definitions.contract.Reference
                  | doc m%"
                  The superclass of this class.
                  
                  If this class is defined with mixin applications, the prototype chain
                  includes the mixin applications and the true superclass is computed
                  from them.
                  "%
                  | optional,
                ..
              },
          Parameter = {
                "default" | String | optional,
                deprecated
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType '"Bool" ])
                  | doc m%"
                  Whether the property is deprecated.
                  If the value is a string, it's the reason for the deprecation.
                  "%
                  | optional,
                description
                  | String
                  | doc m%"
                  A markdown description of the field.
                  "%
                  | optional,
                name | String,
                "optional"
                  | Bool
                  | doc m%"
                  Whether the parameter is optional. Undefined implies non-optional.
                  "%
                  | optional,
                readonly
                  | Bool
                  | doc m%"
                  Whether the property is read-only.
                  "%
                  | optional,
                rest
                  | Bool
                  | doc m%"
                  Whether the parameter is a rest parameter. Only the last parameter may be a rest parameter.
                  Undefined implies single parameter.
                  "%
                  | optional,
                summary
                  | String
                  | doc m%"
                  A markdown summary suitable for display in a listing.
                  "%
                  | optional,
                type | definitions.contract.Type | optional,
                ..
              },
          Privacy = std.contract.Sequence
              [ std.enum.TagOrString, [| 'public, 'protected, 'private |] ],
          Reference
            | doc m%"
            A reference to an export of a module.
            
            All references are required to be publically accessible, so the canonical
            representation of a reference is the export it's available from.
            
            `package` should generally refer to an npm package name. If `package` is
            undefined then the reference is local to this package. If `module` is
            undefined the reference is local to the containing module.
            
            References to global symbols like `Array`, `HTMLElement`, or `Event` should
            use a `package` name of `"global:"`.
            "%
            = {
                module | String | optional,
                name | String,
                package | String | optional,
                ..
              },
          Slot = {
                deprecated
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType '"Bool" ])
                  | doc m%"
                  Whether the slot is deprecated.
                  If the value is a string, it's the reason for the deprecation.
                  "%
                  | optional,
                description
                  | String
                  | doc m%"
                  A markdown description.
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  The slot name, or the empty string for an unnamed slot.
                  "%,
                summary
                  | String
                  | doc m%"
                  A markdown summary suitable for display in a listing.
                  "%
                  | optional,
                ..
              },
          SourceReference
            | doc m%"
            A reference to the source of a declaration or member.
            "%
            = {
                href
                  | String
                  | doc m%"
                  An absolute URL to the source (ie. a GitHub URL).
                  "%,
                ..
              },
          Type = {
                references
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.TypeReference
                  ])
                  | doc m%"
                  An array of references to the types in the type string.
                  
                  These references have optional indices into the type string so that tools
                  can understand the references in the type string independently of the type
                  system and syntax. For example, a documentation viewer could display the
                  type `Array<FooElement | BarElement>` with cross-references to `FooElement`
                  and `BarElement` without understanding arrays, generics, or union types.
                  "%
                  | optional,
                source | definitions.contract.SourceReference | optional,
                text
                  | String
                  | doc m%"
                  The full string representation of the type, in whatever type syntax is
                  used, such as JSDoc, Closure, or TypeScript.
                  "%,
                ..
              },
          TypeReference
            | doc m%"
            A reference that is associated with a type string and optionally a range
            within the string.
            
            Start and end must both be present or not present. If they're present, they
            are indices into the associated type string. If they are missing, the entire
            type string is the symbol referenced and the name should match the type
            string.
            "%
            = {
                end | Number | optional,
                module | String | optional,
                name | String,
                package | String | optional,
                start | Number | optional,
                ..
              },
          VariableDeclaration = {
                "default" | String | optional,
                deprecated
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType '"Bool" ])
                  | doc m%"
                  Whether the property is deprecated.
                  If the value is a string, it's the reason for the deprecation.
                  "%
                  | optional,
                description
                  | String
                  | doc m%"
                  A markdown description of the field.
                  "%
                  | optional,
                kind | std.enum.TagOrString | [| 'variable |],
                name | String,
                readonly
                  | Bool
                  | doc m%"
                  Whether the property is read-only.
                  "%
                  | optional,
                source | definitions.contract.SourceReference | optional,
                summary
                  | String
                  | doc m%"
                  A markdown summary suitable for display in a listing.
                  "%
                  | optional,
                type | definitions.contract.Type | optional,
                ..
              },
        },
    predicate = {
          Attribute = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  "default" = predicates.isType '"String",
                  deprecated = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Bool"
                      ],
                  description = predicates.isType '"String",
                  fieldName = predicates.isType '"String",
                  inheritedFrom = definitions.predicate.Reference,
                  name = predicates.isType '"String",
                  summary = predicates.isType '"String",
                  type = definitions.predicate.Type,
                }
                {  }
                true
                predicates.always
              ],
          ClassDeclaration = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "kind", "name" ],
                predicates.records.record
                {
                  deprecated = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Bool"
                      ],
                  description = predicates.isType '"String",
                  kind = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "class" ]
                      ],
                  members = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.anyOf
                        [
                          definitions.predicate.ClassField,
                          definitions.predicate.ClassMethod
                        ])
                      ],
                  mixins = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.Reference
                      ],
                  name = predicates.isType '"String",
                  source = definitions.predicate.SourceReference,
                  summary = predicates.isType '"String",
                  superclass = definitions.predicate.Reference,
                }
                {  }
                true
                predicates.always
              ],
          ClassField = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "kind", "name" ],
                predicates.records.record
                {
                  "default" = predicates.isType '"String",
                  deprecated = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Bool"
                      ],
                  description = predicates.isType '"String",
                  inheritedFrom = definitions.predicate.Reference,
                  kind = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "field" ]
                      ],
                  name = predicates.isType '"String",
                  privacy = definitions.predicate.Privacy,
                  readonly = predicates.isType '"Bool",
                  source = definitions.predicate.SourceReference,
                  static = predicates.isType '"Bool",
                  summary = predicates.isType '"String",
                  type = definitions.predicate.Type,
                }
                {  }
                true
                predicates.always
              ],
          ClassMethod = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "kind", "name" ],
                predicates.records.record
                {
                  deprecated = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Bool"
                      ],
                  description = predicates.isType '"String",
                  inheritedFrom = definitions.predicate.Reference,
                  kind = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "method" ]
                      ],
                  name = predicates.isType '"String",
                  parameters = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.Parameter
                      ],
                  privacy = definitions.predicate.Privacy,
                  return = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          description = predicates.isType '"String",
                          summary = predicates.isType '"String",
                          type = definitions.predicate.Type,
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  source = definitions.predicate.SourceReference,
                  static = predicates.isType '"Bool",
                  summary = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          CssCustomProperty = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  "default" = predicates.isType '"String",
                  deprecated = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Bool"
                      ],
                  description = predicates.isType '"String",
                  name = predicates.isType '"String",
                  summary = predicates.isType '"String",
                  syntax = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          CssPart
            | doc m%"
            The description of a CSS Part
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  deprecated = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Bool"
                      ],
                  description = predicates.isType '"String",
                  name = predicates.isType '"String",
                  summary = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          CustomElementDeclaration
            | doc m%"
            A description of a custom element class.
            
            Custom elements are JavaScript classes, so this extends from
            `ClassDeclaration` and adds custom-element-specific features like
            attributes, events, and slots.
            
            Note that `tagName` in this interface is optional. Tag names are not
            neccessarily part of a custom element class, but belong to the definition
            (often called the "registration") or the `customElements.define()` call.
            
            Because classes and tag names can only be registered once, there's a
            one-to-one relationship between classes and tag names. For ease of use,
            we allow the tag name here.
            
            Some packages define and register custom elements in separate modules. In
            these cases one `Module` should contain the `CustomElement` without a
            tagName, and another `Module` should contain the
            `CustomElementExport`.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "customElement", "kind", "name" ],
                predicates.records.record
                {
                  attributes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.Attribute
                      ],
                  cssParts = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.CssPart
                      ],
                  cssProperties = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.CssCustomProperty
                      ],
                  customElement = predicates.allOf
                      [ predicates.isType '"Bool", predicates.enum [ true ] ],
                  demos = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Demo
                      ],
                  deprecated = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Bool"
                      ],
                  description = predicates.isType '"String",
                  events = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Event
                      ],
                  kind = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "class" ]
                      ],
                  members = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.anyOf
                        [
                          definitions.predicate.ClassField,
                          definitions.predicate.ClassMethod
                        ])
                      ],
                  mixins = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.Reference
                      ],
                  name = predicates.isType '"String",
                  slots = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Slot
                      ],
                  source = definitions.predicate.SourceReference,
                  summary = predicates.isType '"String",
                  superclass = definitions.predicate.Reference,
                  tagName = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          CustomElementExport
            | doc m%"
            A global custom element defintion, ie the result of a
            `customElements.define()` call.
            
            This is represented as an export because a definition makes the element
            available outside of the module it's defined it.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "declaration", "kind", "name" ],
                predicates.records.record
                {
                  declaration = definitions.predicate.Reference,
                  deprecated = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Bool"
                      ],
                  kind = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "custom-element-definition" ]
                      ],
                  name = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          CustomElementMixinDeclaration
            | doc m%"
            A class mixin that also adds custom element related properties.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "customElement", "kind", "name" ],
                predicates.records.record
                {
                  attributes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.Attribute
                      ],
                  cssParts = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.CssPart
                      ],
                  cssProperties = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.CssCustomProperty
                      ],
                  customElement = predicates.allOf
                      [ predicates.isType '"Bool", predicates.enum [ true ] ],
                  demos = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Demo
                      ],
                  deprecated = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Bool"
                      ],
                  description = predicates.isType '"String",
                  events = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Event
                      ],
                  kind = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "mixin" ]
                      ],
                  members = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.anyOf
                        [
                          definitions.predicate.ClassField,
                          definitions.predicate.ClassMethod
                        ])
                      ],
                  mixins = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.Reference
                      ],
                  name = predicates.isType '"String",
                  parameters = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.Parameter
                      ],
                  return = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          description = predicates.isType '"String",
                          summary = predicates.isType '"String",
                          type = definitions.predicate.Type,
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  slots = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Slot
                      ],
                  source = definitions.predicate.SourceReference,
                  summary = predicates.isType '"String",
                  superclass = definitions.predicate.Reference,
                  tagName = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          Demo = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "url" ],
                predicates.records.record
                {
                  description = predicates.isType '"String",
                  source = definitions.predicate.SourceReference,
                  url = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          Event = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name", "type" ],
                predicates.records.record
                {
                  deprecated = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Bool"
                      ],
                  description = predicates.isType '"String",
                  inheritedFrom = definitions.predicate.Reference,
                  name = predicates.isType '"String",
                  summary = predicates.isType '"String",
                  type = definitions.predicate.Type,
                }
                {  }
                true
                predicates.always
              ],
          FunctionDeclaration = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "kind", "name" ],
                predicates.records.record
                {
                  deprecated = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Bool"
                      ],
                  description = predicates.isType '"String",
                  kind = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "function" ]
                      ],
                  name = predicates.isType '"String",
                  parameters = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.Parameter
                      ],
                  return = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          description = predicates.isType '"String",
                          summary = predicates.isType '"String",
                          type = definitions.predicate.Type,
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  source = definitions.predicate.SourceReference,
                  summary = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          JavaScriptExport = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "declaration", "kind", "name" ],
                predicates.records.record
                {
                  declaration = definitions.predicate.Reference,
                  deprecated = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Bool"
                      ],
                  kind = predicates.allOf
                      [ predicates.isType '"String", predicates.enum [ "js" ] ],
                  name = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          JavaScriptModule = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "kind", "path" ],
                predicates.records.record
                {
                  declarations = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.anyOf
                        [
                          definitions.predicate.ClassDeclaration,
                          definitions.predicate.FunctionDeclaration,
                          definitions.predicate.MixinDeclaration,
                          definitions.predicate.VariableDeclaration,
                          definitions.predicate.CustomElementDeclaration,
                          definitions.predicate.CustomElementMixinDeclaration
                        ])
                      ],
                  deprecated = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Bool"
                      ],
                  description = predicates.isType '"String",
                  exports = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.anyOf
                        [
                          definitions.predicate.JavaScriptExport,
                          definitions.predicate.CustomElementExport
                        ])
                      ],
                  kind = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "javascript-module" ]
                      ],
                  path = predicates.isType '"String",
                  summary = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          MixinDeclaration
            | doc m%"
            A description of a class mixin.
            
            Mixins are functions which generate a new subclass of a given superclass.
            This interfaces describes the class and custom element features that
            are added by the mixin. As such, it extends the CustomElement interface and
            ClassLike interface.
            
            Since mixins are functions, it also extends the FunctionLike interface. This
            means a mixin is callable, and has parameters and a return type.
            
            The return type is often hard or impossible to accurately describe in type
            systems like TypeScript. It requires generics and an `extends` operator
            that TypeScript lacks. Therefore it's recommended that the return type is
            left empty. The most common form of a mixin function takes a single
            argument, so consumers of this interface should assume that the return type
            is the single argument subclassed by this declaration.
            
            A mixin should not have a superclass. If a mixins composes other mixins,
            they should be listed in the `mixins` field.
            
            See [this article]{@link https://justinfagnani.com/2015/12/21/real-mixins-with-javascript-classes/}
            for more information on the classmixin pattern in JavaScript.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "kind", "name" ],
                predicates.records.record
                {
                  deprecated = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Bool"
                      ],
                  description = predicates.isType '"String",
                  kind = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "mixin" ]
                      ],
                  members = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.anyOf
                        [
                          definitions.predicate.ClassField,
                          definitions.predicate.ClassMethod
                        ])
                      ],
                  mixins = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.Reference
                      ],
                  name = predicates.isType '"String",
                  parameters = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.Parameter
                      ],
                  return = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          description = predicates.isType '"String",
                          summary = predicates.isType '"String",
                          type = definitions.predicate.Type,
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  source = definitions.predicate.SourceReference,
                  summary = predicates.isType '"String",
                  superclass = definitions.predicate.Reference,
                }
                {  }
                true
                predicates.always
              ],
          Parameter = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  "default" = predicates.isType '"String",
                  deprecated = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Bool"
                      ],
                  description = predicates.isType '"String",
                  name = predicates.isType '"String",
                  "optional" = predicates.isType '"Bool",
                  readonly = predicates.isType '"Bool",
                  rest = predicates.isType '"Bool",
                  summary = predicates.isType '"String",
                  type = definitions.predicate.Type,
                }
                {  }
                true
                predicates.always
              ],
          Privacy = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "private", "protected", "public" ]
              ],
          Reference
            | doc m%"
            A reference to an export of a module.
            
            All references are required to be publically accessible, so the canonical
            representation of a reference is the export it's available from.
            
            `package` should generally refer to an npm package name. If `package` is
            undefined then the reference is local to this package. If `module` is
            undefined the reference is local to the containing module.
            
            References to global symbols like `Array`, `HTMLElement`, or `Event` should
            use a `package` name of `"global:"`.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  module = predicates.isType '"String",
                  name = predicates.isType '"String",
                  package = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          Slot = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  deprecated = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Bool"
                      ],
                  description = predicates.isType '"String",
                  name = predicates.isType '"String",
                  summary = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          SourceReference
            | doc m%"
            A reference to the source of a declaration or member.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "href" ],
                predicates.records.record
                { href = predicates.isType '"String", }
                {  }
                true
                predicates.always
              ],
          Type = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "text" ],
                predicates.records.record
                {
                  references = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.TypeReference
                      ],
                  source = definitions.predicate.SourceReference,
                  text = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          TypeReference
            | doc m%"
            A reference that is associated with a type string and optionally a range
            within the string.
            
            Start and end must both be present or not present. If they're present, they
            are indices into the associated type string. If they are missing, the entire
            type string is the symbol referenced and the name should match the type
            string.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  end = predicates.isType '"Number",
                  module = predicates.isType '"String",
                  name = predicates.isType '"String",
                  package = predicates.isType '"String",
                  start = predicates.isType '"Number",
                }
                {  }
                true
                predicates.always
              ],
          VariableDeclaration = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "kind", "name" ],
                predicates.records.record
                {
                  "default" = predicates.isType '"String",
                  deprecated = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Bool"
                      ],
                  description = predicates.isType '"String",
                  kind = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "variable" ]
                      ],
                  name = predicates.isType '"String",
                  readonly = predicates.isType '"Bool",
                  source = definitions.predicate.SourceReference,
                  summary = predicates.isType '"String",
                  type = definitions.predicate.Type,
                }
                {  }
                true
                predicates.always
              ],
        },
  }
in

{
  deprecated
    | predicates.contract_from_predicate
    (predicates.anyOf
    [ predicates.isType '"String", predicates.isType '"Bool" ])
    | doc m%"
    Whether the package is deprecated.
    If the value is a string, it's the reason for the deprecation.
    "%
    | optional,
  modules
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.JavaScriptModule
    ])
    | doc m%"
    An array of the modules this package contains.
    "%,
  readme
    | String
    | doc m%"
    The Markdown to use for the main readme of this package.
    
    This can be used to override the readme used by Github or npm if that
    file contains information irrelevant to custom element catalogs and
    documentation viewers.
    "%
    | optional,
  schemaVersion
    | String
    | doc m%"
    The version of the schema used in this file.
    "%,
  ..
}