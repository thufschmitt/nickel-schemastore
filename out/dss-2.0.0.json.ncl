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
          dsb-AnyType = predicates.contract_from_predicate
              definitions.predicate.dsb-AnyType,
          dsb-AttachmentReferenceType = predicates.contract_from_predicate
              definitions.predicate.dsb-AttachmentReferenceType,
          dsb-Base64DataType = predicates.contract_from_predicate
              definitions.predicate.dsb-Base64DataType,
          dsb-DigestInfoType = predicates.contract_from_predicate
              definitions.predicate.dsb-DigestInfoType,
          dsb-InternationalStringType = predicates.contract_from_predicate
              definitions.predicate.dsb-InternationalStringType,
          dsb-NsPrefixMappingType = predicates.contract_from_predicate
              definitions.predicate.dsb-NsPrefixMappingType,
          dsb-ResponseBaseType = predicates.contract_from_predicate
              definitions.predicate.dsb-ResponseBaseType,
          dsb-ResultType = predicates.contract_from_predicate
              definitions.predicate.dsb-ResultType,
          dsigrw-TransformType = predicates.contract_from_predicate
              definitions.predicate.dsigrw-TransformType,
          dsigrw-TransformsType = predicates.contract_from_predicate
              definitions.predicate.dsigrw-TransformsType,
          dss2-AdditionalKeyInfoType = predicates.contract_from_predicate
              definitions.predicate.dss2-AdditionalKeyInfoType,
          dss2-AdditionalTimeInfoType = predicates.contract_from_predicate
              definitions.predicate.dss2-AdditionalTimeInfoType,
          dss2-AugmentSignatureInstructionType =
            predicates.contract_from_predicate
              definitions.predicate.dss2-AugmentSignatureInstructionType,
          dss2-AugmentedSignatureType = predicates.contract_from_predicate
              definitions.predicate.dss2-AugmentedSignatureType,
          dss2-ClaimedIdentityType = predicates.contract_from_predicate
              definitions.predicate.dss2-ClaimedIdentityType,
          dss2-DetailType = predicates.contract_from_predicate
              definitions.predicate.dss2-DetailType,
          dss2-DocumentBaseType = predicates.contract_from_predicate
              definitions.predicate.dss2-DocumentBaseType,
          dss2-DocumentHashType = predicates.contract_from_predicate
              definitions.predicate.dss2-DocumentHashType,
          dss2-DocumentType = predicates.contract_from_predicate
              definitions.predicate.dss2-DocumentType,
          dss2-DocumentWithSignatureType = predicates.contract_from_predicate
              definitions.predicate.dss2-DocumentWithSignatureType,
          dss2-IncludeObjectType = predicates.contract_from_predicate
              definitions.predicate.dss2-IncludeObjectType,
          dss2-InputDocumentsType = predicates.contract_from_predicate
              definitions.predicate.dss2-InputDocumentsType,
          dss2-IntendedAudienceType = predicates.contract_from_predicate
              definitions.predicate.dss2-IntendedAudienceType,
          dss2-KeySelectorType = predicates.contract_from_predicate
              definitions.predicate.dss2-KeySelectorType,
          dss2-ManifestResultType = predicates.contract_from_predicate
              definitions.predicate.dss2-ManifestResultType,
          dss2-OptionalInputsSignType = predicates.contract_from_predicate
              definitions.predicate.dss2-OptionalInputsSignType,
          dss2-OptionalInputsVerifyType = predicates.contract_from_predicate
              definitions.predicate.dss2-OptionalInputsVerifyType,
          dss2-OptionalOutputsSignType = predicates.contract_from_predicate
              definitions.predicate.dss2-OptionalOutputsSignType,
          dss2-OptionalOutputsVerifyType = predicates.contract_from_predicate
              definitions.predicate.dss2-OptionalOutputsVerifyType,
          dss2-PendingRequestType = predicates.contract_from_predicate
              definitions.predicate.dss2-PendingRequestType,
          dss2-ProcessingDetailsType = predicates.contract_from_predicate
              definitions.predicate.dss2-ProcessingDetailsType,
          dss2-PropertiesHolderType = predicates.contract_from_predicate
              definitions.predicate.dss2-PropertiesHolderType,
          dss2-PropertiesType = predicates.contract_from_predicate
              definitions.predicate.dss2-PropertiesType,
          dss2-PropertyType = predicates.contract_from_predicate
              definitions.predicate.dss2-PropertyType,
          dss2-ReturnTransformedDocumentType =
            predicates.contract_from_predicate
              definitions.predicate.dss2-ReturnTransformedDocumentType,
          dss2-SchemasType = predicates.contract_from_predicate
              definitions.predicate.dss2-SchemasType,
          dss2-SignRequestType = predicates.contract_from_predicate
              definitions.predicate.dss2-SignRequestType,
          dss2-SignResponseType = predicates.contract_from_predicate
              definitions.predicate.dss2-SignResponseType,
          dss2-SignatureObjectType = predicates.contract_from_predicate
              definitions.predicate.dss2-SignatureObjectType,
          dss2-SignaturePlacementType = predicates.contract_from_predicate
              definitions.predicate.dss2-SignaturePlacementType,
          dss2-SignaturePtrType = predicates.contract_from_predicate
              definitions.predicate.dss2-SignaturePtrType,
          dss2-SignedReferenceType = predicates.contract_from_predicate
              definitions.predicate.dss2-SignedReferenceType,
          dss2-SignedReferencesType = predicates.contract_from_predicate
              definitions.predicate.dss2-SignedReferencesType,
          dss2-SigningTimeInfoType = predicates.contract_from_predicate
              definitions.predicate.dss2-SigningTimeInfoType,
          "dss2-SigningTimeInfoType:SigningTimeBoundaries" =
            predicates.contract_from_predicate
              definitions.predicate."dss2-SigningTimeInfoType:SigningTimeBoundaries",
          dss2-TransformedDataType = predicates.contract_from_predicate
              definitions.predicate.dss2-TransformedDataType,
          dss2-TransformedDocumentType = predicates.contract_from_predicate
              definitions.predicate.dss2-TransformedDocumentType,
          dss2-UseVerificationTimeType = predicates.contract_from_predicate
              definitions.predicate.dss2-UseVerificationTimeType,
          dss2-VerificationTimeInfoType = predicates.contract_from_predicate
              definitions.predicate.dss2-VerificationTimeInfoType,
          dss2-VerifyManifestResultsType = predicates.contract_from_predicate
              definitions.predicate.dss2-VerifyManifestResultsType,
          dss2-VerifyRequestType = predicates.contract_from_predicate
              definitions.predicate.dss2-VerifyRequestType,
          dss2-VerifyResponseType = predicates.contract_from_predicate
              definitions.predicate.dss2-VerifyResponseType,
          dss2-X509DigestType = predicates.contract_from_predicate
              definitions.predicate.dss2-X509DigestType,
          saml2rw-NameIDType = predicates.contract_from_predicate
              definitions.predicate.saml2rw-NameIDType,
        },
    predicate = {
          dsb-AnyType = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  ID = predicates.isType '"String",
                  attRef = definitions.predicate.dsb-AttachmentReferenceType,
                  idRef = predicates.isType '"String",
                  mimeType = predicates.isType '"String",
                  val = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          dsb-AttachmentReferenceType = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "attURI" ],
                predicates.records.record
                {
                  attURI = predicates.isType '"String",
                  di = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.dsb-DigestInfoType
                      ],
                }
                {  }
                true
                predicates.always
              ],
          dsb-Base64DataType = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.minProperties 0,
                predicates.records.record
                {
                  ID = predicates.isType '"String",
                  attRef = definitions.predicate.dsb-AttachmentReferenceType,
                  idRef = predicates.isType '"String",
                  mimeType = predicates.isType '"String",
                  val = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          dsb-DigestInfoType = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "alg", "val" ],
                predicates.records.record
                {
                  alg = predicates.isType '"String",
                  val = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          dsb-InternationalStringType = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "lang" ],
                predicates.records.record
                {
                  lang = predicates.isType '"String",
                  value = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          dsb-NsPrefixMappingType = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "pre", "uri" ],
                predicates.records.record
                {
                  pre = predicates.isType '"String",
                  uri = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          dsb-ResponseBaseType = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "result" ],
                predicates.records.record
                {
                  profile = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  reqID = predicates.isType '"String",
                  respID = predicates.isType '"String",
                  result = definitions.predicate.dsb-ResultType,
                }
                {  }
                true
                predicates.always
              ],
          dsb-ResultType = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "maj" ],
                predicates.records.record
                {
                  maj = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [
                          "urn:oasis:names:tc:dss:1.0:resultmajor:Success",
                          "urn:oasis:names:tc:dss:1.0:resultmajor:RequesterError",
                          "urn:oasis:names:tc:dss:1.0:resultmajor:ResponderError",
                          "urn:oasis:names:tc:dss:1.0:resultmajor:InsufficientInformation",
                          "urn:oasis:names:tc:dss:1.0:profiles:asynchronousprocessing:resultmajor:Pending"
                        ]
                      ],
                  min = predicates.isType '"String",
                  msg = definitions.predicate.dsb-InternationalStringType,
                  pRef = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          dsigrw-TransformType = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "alg" ],
                predicates.records.record
                {
                  alg = predicates.isType '"String",
                  b64Content = predicates.isType '"String",
                  nsDecl = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.dsb-NsPrefixMappingType
                      ],
                  val = predicates.isType '"String",
                  xPath = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  xpath = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                true
                predicates.always
              ],
          dsigrw-TransformsType = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "transform" ],
                predicates.records.record
                {
                  transform = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.dsigrw-TransformType
                      ],
                }
                {  }
                true
                predicates.always
              ],
          dss2-AdditionalKeyInfoType = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.maxProperties 1,
                predicates.records.minProperties 1,
                predicates.records.record
                {
                  cert = definitions.predicate.dsb-Base64DataType,
                  crl = definitions.predicate.dsb-Base64DataType,
                  name = predicates.isType '"String",
                  ocsp = definitions.predicate.dsb-Base64DataType,
                  ocspresponse = definitions.predicate.dsb-Base64DataType,
                  poe = definitions.predicate.dsb-Base64DataType,
                  ski = predicates.isType '"String",
                  sub = predicates.isType '"String",
                  x509Digest = definitions.predicate.dss2-X509DigestType,
                }
                {  }
                true
                predicates.always
              ],
          dss2-AdditionalTimeInfoType = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "type" ],
                predicates.records.record
                {
                  ref = predicates.isType '"String",
                  type = predicates.isType '"String",
                  value = predicates.isType 'Integer,
                }
                {  }
                true
                predicates.always
              ],
          dss2-AugmentSignatureInstructionType = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { type = predicates.isType '"String", }
                {  }
                true
                predicates.always
              ],
          dss2-AugmentedSignatureType = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "sigObj" ],
                predicates.records.record
                {
                  sigObj = definitions.predicate.dss2-SignatureObjectType,
                  type = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          dss2-ClaimedIdentityType = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  name = definitions.predicate.saml2rw-NameIDType,
                  suppInfo = definitions.predicate.dsb-AnyType,
                }
                {  }
                true
                predicates.always
              ],
          dss2-DetailType = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "type" ],
                predicates.records.record
                {
                  b64Content = predicates.isType '"String",
                  code = predicates.isType '"String",
                  msg = definitions.predicate.dsb-InternationalStringType,
                  type = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          dss2-DocumentBaseType = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  ID = predicates.isType '"String",
                  refType = predicates.isType '"String",
                  refURI = predicates.isType '"String",
                  schemaRefs = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.dss2-DocumentType
                      ],
                }
                {  }
                true
                predicates.always
              ],
          dss2-DocumentHashType = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "dis" ],
                predicates.records.record
                {
                  ID = predicates.isType '"String",
                  dis = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.dsb-DigestInfoType
                      ],
                  refType = predicates.isType '"String",
                  refURI = predicates.isType '"String",
                  schemaRefs = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.dss2-DocumentType
                      ],
                  transforms = definitions.predicate.dsigrw-TransformsType,
                  whichRef = predicates.isType 'Integer,
                }
                {  }
                true
                predicates.always
              ],
          dss2-DocumentType = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "b64Data" ],
                predicates.records.record
                {
                  ID = predicates.isType '"String",
                  b64Data = definitions.predicate.dsb-Base64DataType,
                  refType = predicates.isType '"String",
                  refURI = predicates.isType '"String",
                  schemaRefs = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.dss2-DocumentType
                      ],
                }
                {  }
                true
                predicates.always
              ],
          dss2-DocumentWithSignatureType = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "doc" ],
                predicates.records.record
                { "doc" = definitions.predicate.dss2-DocumentType, }
                {  }
                true
                predicates.always
              ],
          dss2-IncludeObjectType = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  createRef = predicates.isType '"Bool",
                  hasObjectTagsAndAttributesSet = predicates.isType '"Bool",
                  objId = predicates.isType '"String",
                  whichDoc = definitions.predicate.dss2-DocumentBaseType,
                }
                {  }
                true
                predicates.always
              ],
          dss2-InputDocumentsType = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "doc" = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.dss2-DocumentType
                      ],
                  docHash = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.dss2-DocumentHashType
                      ],
                  transformed = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.dss2-TransformedDataType
                      ],
                }
                {  }
                true
                predicates.always
              ],
          dss2-IntendedAudienceType = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "recipient" ],
                predicates.records.record
                {
                  recipient = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.saml2rw-NameIDType
                      ],
                }
                {  }
                true
                predicates.always
              ],
          dss2-KeySelectorType = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.maxProperties 1,
                predicates.records.minProperties 1,
                predicates.records.record
                {
                  cert = predicates.isType '"String",
                  name = predicates.isType '"String",
                  ski = predicates.isType '"String",
                  sub = predicates.isType '"String",
                  x509Digest = definitions.predicate.dss2-X509DigestType,
                }
                {  }
                true
                predicates.always
              ],
          dss2-ManifestResultType = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "status", "xPath" ],
                predicates.records.record
                {
                  nsDecl = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.dsb-NsPrefixMappingType
                      ],
                  status = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [
                          "urn:oasis:names:tc:dss:1.0:manifeststatus:Valid",
                          "urn:oasis:names:tc:dss:1.0:manifeststatus:Invalid"
                        ]
                      ],
                  xPath = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          dss2-OptionalInputsSignType = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  addTimestamp =
                    definitions.predicate.dss2-AugmentSignatureInstructionType,
                  aud = definitions.predicate.dss2-IntendedAudienceType,
                  claimedIdentity =
                    definitions.predicate.dss2-ClaimedIdentityType,
                  incContent = predicates.isType '"Bool",
                  incObj = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.dss2-IncludeObjectType
                      ],
                  keySel = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.dss2-KeySelectorType
                      ],
                  lang = predicates.isType '"String",
                  nonce = predicates.isType 'Integer,
                  other = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.dsb-AnyType
                      ],
                  policy = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  props = definitions.predicate.dss2-PropertiesHolderType,
                  quality = predicates.isType '"String",
                  schemas = definitions.predicate.dss2-SchemasType,
                  sigAlgo = predicates.isType '"String",
                  sigPlacement =
                    definitions.predicate.dss2-SignaturePlacementType,
                  sigType = predicates.isType '"String",
                  signedRefs = definitions.predicate.dss2-SignedReferencesType,
                }
                {  }
                true
                predicates.always
              ],
          dss2-OptionalInputsVerifyType = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  addKeyInfo = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.dss2-AdditionalKeyInfoType
                      ],
                  addTimestamp =
                    definitions.predicate.dss2-AugmentSignatureInstructionType,
                  claimedIdentity =
                    definitions.predicate.dss2-ClaimedIdentityType,
                  lang = predicates.isType '"String",
                  other = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.dsb-AnyType
                      ],
                  policy = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  returnAugmented = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.dss2-AugmentSignatureInstructionType
                      ],
                  returnProcDetails = predicates.isType '"Bool",
                  returnSigner = predicates.isType '"Bool",
                  returnSigningTime = predicates.isType '"Bool",
                  returnTimestamped =
                    definitions.predicate.dss2-AugmentSignatureInstructionType,
                  returnTransformed = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.dss2-ReturnTransformedDocumentType
                      ],
                  returnVerificationTime = predicates.isType '"Bool",
                  schemas = definitions.predicate.dss2-SchemasType,
                  useVerificationTime =
                    definitions.predicate.dss2-UseVerificationTimeType,
                  verifyManifests = predicates.isType '"Bool",
                }
                {  }
                true
                predicates.always
              ],
          dss2-OptionalOutputsSignType = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  docWithSignature =
                    definitions.predicate.dss2-DocumentWithSignatureType,
                  other = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.dsb-AnyType
                      ],
                  policy = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  schemas = definitions.predicate.dss2-SchemasType,
                  transformed =
                    definitions.predicate.dss2-TransformedDocumentType,
                }
                {  }
                true
                predicates.always
              ],
          dss2-OptionalOutputsVerifyType = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  augSig = definitions.predicate.dss2-AugmentedSignatureType,
                  docWithSignature =
                    definitions.predicate.dss2-DocumentWithSignatureType,
                  other = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.dsb-AnyType
                      ],
                  policy = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  procDetails =
                    definitions.predicate.dss2-ProcessingDetailsType,
                  result = definitions.predicate.dss2-VerifyManifestResultsType,
                  schemas = definitions.predicate.dss2-SchemasType,
                  signerIdentity = definitions.predicate.saml2rw-NameIDType,
                  signingTimeInfo =
                    definitions.predicate.dss2-SigningTimeInfoType,
                  timestampedSig =
                    definitions.predicate.dss2-AugmentedSignatureType,
                  transformed =
                    definitions.predicate.dss2-TransformedDocumentType,
                  verificationTimeInfo =
                    definitions.predicate.dss2-VerificationTimeInfoType,
                }
                {  }
                true
                predicates.always
              ],
          dss2-PendingRequestType = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  claimedIdentity =
                    definitions.predicate.dss2-ClaimedIdentityType,
                  profile = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  reqID = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          dss2-ProcessingDetailsType = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  indeterminate = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.dss2-DetailType
                      ],
                  invalid = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.dss2-DetailType
                      ],
                  valid = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.dss2-DetailType
                      ],
                }
                {  }
                true
                predicates.always
              ],
          dss2-PropertiesHolderType = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  signedProps = definitions.predicate.dss2-PropertiesType,
                  unsignedProps = definitions.predicate.dss2-PropertiesType,
                }
                {  }
                true
                predicates.always
              ],
          dss2-PropertiesType = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "prop" ],
                predicates.records.record
                {
                  prop = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.dss2-PropertyType
                      ],
                }
                {  }
                true
                predicates.always
              ],
          dss2-PropertyType = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "id" ],
                predicates.records.record
                {
                  id = predicates.isType '"String",
                  val = definitions.predicate.dsb-AnyType,
                }
                {  }
                true
                predicates.always
              ],
          dss2-ReturnTransformedDocumentType = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "whichRef" ],
                predicates.records.record
                { whichRef = predicates.isType 'Integer, }
                {  }
                true
                predicates.always
              ],
          dss2-SchemasType = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "schema" ],
                predicates.records.record
                {
                  schema = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.dss2-DocumentType
                      ],
                }
                {  }
                true
                predicates.always
              ],
          dss2-SignRequestType = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  inDocs = definitions.predicate.dss2-InputDocumentsType,
                  optInp = definitions.predicate.dss2-OptionalInputsSignType,
                  profile = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  reqID = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          dss2-SignResponseType = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  optOutp = definitions.predicate.dss2-OptionalOutputsSignType,
                  profile = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  reqID = predicates.isType '"String",
                  respID = predicates.isType '"String",
                  result = definitions.predicate.dsb-ResultType,
                  sigObj = definitions.predicate.dss2-SignatureObjectType,
                }
                {  }
                true
                predicates.always
              ],
          dss2-SignatureObjectType = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.minProperties 1,
                predicates.records.record
                {
                  b64Sig = definitions.predicate.dsb-Base64DataType,
                  schemaRefs = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.dss2-DocumentBaseType
                      ],
                  sigPtr = definitions.predicate.dss2-SignaturePtrType,
                }
                {  }
                true
                predicates.always
              ],
          dss2-SignaturePlacementType = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  createEnvelopedSignature = predicates.isType '"Bool",
                  nsDecl = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.dsb-NsPrefixMappingType
                      ],
                  whichDoc = definitions.predicate.dss2-DocumentBaseType,
                  xPathAfter = predicates.isType '"String",
                  xPathFirstChildOf = predicates.isType '"String",
                  xpathAfter = predicates.isType '"String",
                  xpathFirstChildOf = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          dss2-SignaturePtrType = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "whichDoc" ],
                predicates.records.record
                {
                  nsDecl = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.dsb-NsPrefixMappingType
                      ],
                  whichDoc = definitions.predicate.dss2-DocumentBaseType,
                  xPath = predicates.isType '"String",
                  xpath = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          dss2-SignedReferenceType = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "whichDoc" ],
                predicates.records.record
                {
                  refId = predicates.isType '"String",
                  refURI = predicates.isType '"String",
                  transforms = definitions.predicate.dsigrw-TransformsType,
                  whichDoc = definitions.predicate.dss2-DocumentBaseType,
                }
                {  }
                true
                predicates.always
              ],
          dss2-SignedReferencesType = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "signedRef" ],
                predicates.records.record
                {
                  signedRef = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.dss2-SignedReferenceType
                      ],
                }
                {  }
                true
                predicates.always
              ],
          dss2-SigningTimeInfoType = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "signingTime" ],
                predicates.records.record
                {
                  signingTime = predicates.isType 'Integer,
                  signingTimeBounds =
                    definitions.predicate."dss2-SigningTimeInfoType%3ASigningTimeBoundaries",
                }
                {  }
                true
                predicates.always
              ],
          "dss2-SigningTimeInfoType:SigningTimeBoundaries" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  lowerBound = predicates.isType 'Integer,
                  upperBound = predicates.isType 'Integer,
                }
                {  }
                true
                predicates.always
              ],
          dss2-TransformedDataType = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "b64Data" ],
                predicates.records.record
                {
                  ID = predicates.isType '"String",
                  b64Data = definitions.predicate.dsb-Base64DataType,
                  refType = predicates.isType '"String",
                  refURI = predicates.isType '"String",
                  schemaRefs = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.dss2-DocumentType
                      ],
                  transforms = definitions.predicate.dsigrw-TransformsType,
                  whichRef = predicates.isType 'Integer,
                }
                {  }
                true
                predicates.always
              ],
          dss2-TransformedDocumentType = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "doc", "whichRef" ],
                predicates.records.record
                {
                  "doc" = definitions.predicate.dss2-DocumentType,
                  whichRef = predicates.isType 'Integer,
                }
                {  }
                true
                predicates.always
              ],
          dss2-UseVerificationTimeType = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.maxProperties 1,
                predicates.records.minProperties 1,
                predicates.records.record
                {
                  b64Content = predicates.isType '"String",
                  currTime = predicates.isType '"Bool",
                  specTime = predicates.isType 'Integer,
                }
                {  }
                true
                predicates.always
              ],
          dss2-VerificationTimeInfoType = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "verificationTime" ],
                predicates.records.record
                {
                  additionalTimeInfo = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.dss2-AdditionalTimeInfoType
                      ],
                  verificationTime = predicates.isType 'Integer,
                }
                {  }
                true
                predicates.always
              ],
          dss2-VerifyManifestResultsType = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "result" ],
                predicates.records.record
                {
                  result = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.dss2-ManifestResultType
                      ],
                }
                {  }
                true
                predicates.always
              ],
          dss2-VerifyRequestType = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  inDocs = definitions.predicate.dss2-InputDocumentsType,
                  optInp = definitions.predicate.dss2-OptionalInputsVerifyType,
                  profile = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  reqID = predicates.isType '"String",
                  sigObj = definitions.predicate.dss2-SignatureObjectType,
                }
                {  }
                true
                predicates.always
              ],
          dss2-VerifyResponseType = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  optOutp =
                    definitions.predicate.dss2-OptionalOutputsVerifyType,
                  profile = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  reqID = predicates.isType '"String",
                  respID = predicates.isType '"String",
                  result = definitions.predicate.dsb-ResultType,
                }
                {  }
                true
                predicates.always
              ],
          dss2-X509DigestType = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "alg" ],
                predicates.records.record
                {
                  alg = predicates.isType '"String",
                  value = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          saml2rw-NameIDType = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  format = predicates.isType '"String",
                  nameQual = predicates.isType '"String",
                  provId = predicates.isType '"String",
                  spNameQual = predicates.isType '"String",
                  spnameQualifier = predicates.isType '"String",
                  spprovidedID = predicates.isType '"String",
                  value = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
        },
  }
in

predicates.contract_from_predicate
(predicates.allOf
[
  predicates.isType 'Record,
  predicates.records.record
  {
    genericResp = definitions.predicate.dsb-ResponseBaseType,
    pendingReq = definitions.predicate.dss2-PendingRequestType,
    signReq = definitions.predicate.dss2-SignRequestType,
    signResp = definitions.predicate.dss2-SignResponseType,
    verifyReq = definitions.predicate.dss2-VerifyRequestType,
    verifyResp = definitions.predicate.dss2-VerifyResponseType,
  }
  {  }
  true
  predicates.always
])