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
          AppImageOptions = {
                artifactName
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The [artifact file name template](/configuration/configuration#artifact-file-name-template).
                  "%
                  | optional,
                category
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The [application category](https://specifications.freedesktop.org/menu-spec/latest/apa.html#main-category-registry).
                  "%
                  | optional,
                description
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  As [description](/configuration/configuration#Metadata-description) from application package.json, but allows you to specify different for Linux.
                  "%
                  | optional,
                desktop
                  | predicates.contract_from_predicate predicates.always
                  | doc m%"
                  The [Desktop file](https://developer.gnome.org/integration-guide/stable/desktop-files.html.en) entries (name to value).
                  "%
                  | optional,
                license
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The path to EULA license file. Defaults to `license.txt` or `eula.txt` (or uppercase variants). Only plain text is supported.
                  "%
                  | optional,
                mimeTypes
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ],
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  The mime types in addition to specified in the file associations. Use it if you don't want to register a new mime type, but reuse existing.
                  "%
                  | optional,
                publish
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.GithubOptions,
                    definitions.predicate.S3Options,
                    definitions.predicate.SpacesOptions,
                    definitions.predicate.GenericServerOptions,
                    definitions.predicate.BintrayOptions,
                    definitions.predicate.CustomPublishOptions,
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.anyOf
                      [
                        definitions.predicate.GithubOptions,
                        definitions.predicate.S3Options,
                        definitions.predicate.SpacesOptions,
                        definitions.predicate.GenericServerOptions,
                        definitions.predicate.BintrayOptions,
                        definitions.predicate.CustomPublishOptions,
                        predicates.isType '"String"
                      ])
                    ],
                    predicates.anyOf
                    [ predicates.isType 'Null, predicates.isType '"String" ]
                  ])
                  | optional,
                synopsis
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The [short description](https://www.debian.org/doc/debian-policy/ch-controlfields.html#s-f-Description).
                  "%
                  | optional,
                systemIntegration
                  | std.enum.TagOrString
                  | [| 'doNotAsk, 'ask |]
                  | doc m%"
                  The system integration installation.
                  "%
                  | optional,
              },
          AppXOptions = {
                addAutoLaunchExtension
                  | Bool
                  | doc m%"
                  Whether to add auto launch extension. Defaults to `true` if [electron-winstore-auto-launch](https://github.com/felixrieseberg/electron-winstore-auto-launch) in the dependencies.
                  "%
                  | optional,
                applicationId
                  | String
                  | doc m%"
                  The application id. Defaults to `identityName`. Can't start with numbers.
                  "%
                  | optional,
                artifactName
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The [artifact file name template](/configuration/configuration#artifact-file-name-template).
                  "%
                  | optional,
                backgroundColor
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The background color of the app tile. See [Visual Elements](https://msdn.microsoft.com/en-us/library/windows/apps/br211471.aspx).
                  "%
                  | optional,
                displayName
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  A friendly name that can be displayed to users. Corresponds to [Properties.DisplayName](https://msdn.microsoft.com/en-us/library/windows/apps/br211432.aspx).
                  Defaults to the application product name.
                  "%
                  | optional,
                electronUpdaterAware | Bool | optional,
                identityName
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The name. Corresponds to [Identity.Name](https://msdn.microsoft.com/en-us/library/windows/apps/br211441.aspx). Defaults to the [application name](/configuration/configuration#Metadata-name).
                  "%
                  | optional,
                languages
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ],
                    predicates.anyOf
                    [ predicates.isType 'Null, predicates.isType '"String" ]
                  ])
                  | doc m%"
                  The list of [supported languages](https://docs.microsoft.com/en-us/windows/uwp/globalizing/manage-language-and-region#specify-the-supported-languages-in-the-apps-manifest) that will be listed in the Windows Store.
                  The first entry (index 0) will be the default language.
                  Defaults to en-US if omitted.
                  "%
                  | optional,
                makeappxArgs
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ],
                    predicates.isType 'Null
                  ])
                  | optional,
                publish
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.GithubOptions,
                    definitions.predicate.S3Options,
                    definitions.predicate.SpacesOptions,
                    definitions.predicate.GenericServerOptions,
                    definitions.predicate.BintrayOptions,
                    definitions.predicate.CustomPublishOptions,
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.anyOf
                      [
                        definitions.predicate.GithubOptions,
                        definitions.predicate.S3Options,
                        definitions.predicate.SpacesOptions,
                        definitions.predicate.GenericServerOptions,
                        definitions.predicate.BintrayOptions,
                        definitions.predicate.CustomPublishOptions,
                        predicates.isType '"String"
                      ])
                    ],
                    predicates.anyOf
                    [ predicates.isType 'Null, predicates.isType '"String" ]
                  ])
                  | optional,
                publisher
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The Windows Store publisher. Not used if AppX is build for testing. See [AppX Package Code Signing](#appx-package-code-signing) below.
                  "%
                  | optional,
                publisherDisplayName
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  A friendly name for the publisher that can be displayed to users. Corresponds to [Properties.PublisherDisplayName](https://msdn.microsoft.com/en-us/library/windows/apps/br211460.aspx).
                  Defaults to company name from the application metadata.
                  "%
                  | optional,
                setBuildNumber
                  | Bool
                  | doc m%"
                  Whether to set build number. See https://github.com/electron-userland/electron-builder/issues/3875
                  "%
                  | optional,
                showNameOnTiles
                  | Bool
                  | doc m%"
                  Whether to overlay the app's name on top of tile images on the Start screen. Defaults to `false`. (https://docs.microsoft.com/en-us/uwp/schemas/appxpackage/uapmanifestschema/element-uap-shownameontiles) in the dependencies.
                  "%
                  | optional,
              },
          AsarOptions = {
                externalAllowed
                  | Bool
                  | doc m%"
                  Allows external asar files.
                  "%
                  | optional,
                ordering
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | optional,
                smartUnpack
                  | Bool
                  | doc m%"
                  Whether to automatically unpack executables files.
                  "%
                  | optional,
              },
          BintrayOptions
            | doc m%"
            [Bintray](https://bintray.com/) options. Requires an API key. An API key can be obtained from the user [profile](https://bintray.com/profile/edit) page ("Edit Your Profile" -> API Key).
            Define `BT_TOKEN` environment variable.
            "%
            = {
                component
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The Bintray component (Debian only).
                  "%
                  | optional,
                distribution
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The Bintray distribution (Debian only).
                  "%
                  | optional,
                owner
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The owner.
                  "%
                  | optional,
                package
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The Bintray package name.
                  "%
                  | optional,
                provider
                  | std.enum.TagOrString
                  | [| 'bintray |]
                  | doc m%"
                  The provider. Must be `bintray`.
                  "%,
                publishAutoUpdate
                  | Bool
                  | doc m%"
                  Whether to publish auto update info files.
                  
                  Auto update relies only on the first provider in the list (you can specify several publishers).
                  Thus, probably, there`s no need to upload the metadata files for the other configured providers. But by default will be uploaded.
                  "%
                  | optional,
                publisherName
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ],
                    predicates.isType 'Null
                  ])
                  | optional,
                repo
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The Bintray repository name.
                  "%
                  | optional,
                token
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | optional,
                updaterCacheDirName
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | optional,
                user
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The Bintray user account. Used in cases where the owner is an organization.
                  "%
                  | optional,
              },
          CustomPublishOptions = predicates.contract_from_predicate
              definitions.predicate.CustomPublishOptions,
          DebOptions = {
                afterInstall
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | optional,
                afterRemove
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | optional,
                artifactName
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The [artifact file name template](/configuration/configuration#artifact-file-name-template).
                  "%
                  | optional,
                category
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The [application category](https://specifications.freedesktop.org/menu-spec/latest/apa.html#main-category-registry).
                  "%
                  | optional,
                compression
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.enum [ "bzip2", "gz", "xz" ]
                    ],
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  The compression type.
                  "%
                  | optional,
                depends
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ],
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  Package dependencies. Defaults to `["gconf2", "gconf-service", "libnotify4", "libappindicator1", "libxtst6", "libnss3"]`.
                  "%
                  | optional,
                description
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  As [description](/configuration/configuration#Metadata-description) from application package.json, but allows you to specify different for Linux.
                  "%
                  | optional,
                desktop
                  | predicates.contract_from_predicate predicates.always
                  | doc m%"
                  The [Desktop file](https://developer.gnome.org/integration-guide/stable/desktop-files.html.en) entries (name to value).
                  "%
                  | optional,
                fpm
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ],
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  *Advanced only* The [fpm](https://github.com/jordansissel/fpm/wiki#usage) options.
                  
                  Example: `["--before-install=build/deb-preinstall.sh", "--after-upgrade=build/deb-postinstall.sh"]`
                  "%
                  | optional,
                icon | String | optional,
                maintainer
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | optional,
                mimeTypes
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ],
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  The mime types in addition to specified in the file associations. Use it if you don't want to register a new mime type, but reuse existing.
                  "%
                  | optional,
                packageCategory
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The [package category](https://www.debian.org/doc/debian-policy/ch-controlfields.html#s-f-Section).
                  "%
                  | optional,
                "priority"
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The [Priority](https://www.debian.org/doc/debian-policy/ch-controlfields.html#s-f-Priority) attribute.
                  "%
                  | optional,
                publish
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.GithubOptions,
                    definitions.predicate.S3Options,
                    definitions.predicate.SpacesOptions,
                    definitions.predicate.GenericServerOptions,
                    definitions.predicate.BintrayOptions,
                    definitions.predicate.CustomPublishOptions,
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.anyOf
                      [
                        definitions.predicate.GithubOptions,
                        definitions.predicate.S3Options,
                        definitions.predicate.SpacesOptions,
                        definitions.predicate.GenericServerOptions,
                        definitions.predicate.BintrayOptions,
                        definitions.predicate.CustomPublishOptions,
                        predicates.isType '"String"
                      ])
                    ],
                    predicates.anyOf
                    [ predicates.isType 'Null, predicates.isType '"String" ]
                  ])
                  | optional,
                synopsis
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The [short description](https://www.debian.org/doc/debian-policy/ch-controlfields.html#s-f-Description).
                  "%
                  | optional,
                vendor
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | optional,
              },
          DmgContent = {
                name
                  | String
                  | doc m%"
                  The name of the file within the DMG. Defaults to basename of `path`.
                  "%
                  | optional,
                path
                  | String
                  | doc m%"
                  The path of the file within the DMG.
                  "%
                  | optional,
                type
                  | std.enum.TagOrString
                  | [| 'link, 'file, 'dir |]
                  | optional,
                x | Number,
                y | Number,
              },
          DmgOptions = {
                artifactName
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The [artifact file name template](/configuration/configuration#artifact-file-name-template).
                  "%
                  | optional,
                background
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The path to background image (default: `build/background.tiff` or `build/background.png` if exists). The resolution of this file determines the resolution of the installer window.
                  If background is not specified, use `window.size`. Default locations expected background size to be 540x380.
                  "%
                  | optional,
                backgroundColor
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The background color (accepts css colors). Defaults to `#ffffff` (white) if no background image.
                  "%
                  | optional,
                contents
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.DmgContent
                  ])
                  | doc m%"
                  The content — to customize icon locations.
                  "%
                  | optional,
                format
                  | std.enum.TagOrString
                  | [| 'ULFO, 'UDZO, 'UDRW, 'UDRO, 'UDCO, 'UDBZ |]
                  | doc m%"
                  The disk image format. `ULFO` (lzfse-compressed image (OS X 10.11+ only)).
                  "%
                  | optional,
                icon
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The path to DMG icon (volume icon), which will be shown when mounted, relative to the [build resources](/configuration/configuration#MetadataDirectories-buildResources) or to the project directory.
                  Defaults to the application icon (`build/icon.icns`).
                  "%
                  | optional,
                iconSize
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"Number" ])
                  | doc m%"
                  The size of all the icons inside the DMG.
                  "%
                  | optional,
                iconTextSize
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"Number" ])
                  | doc m%"
                  The size of all the icon texts inside the DMG.
                  "%
                  | optional,
                internetEnabled
                  | Bool
                  | doc m%"
                  Whether to create internet-enabled disk image (when it is downloaded using a browser it will automatically decompress the image, put the application on the desktop, unmount and remove the disk image file).
                  "%
                  | optional,
                publish
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.GithubOptions,
                    definitions.predicate.S3Options,
                    definitions.predicate.SpacesOptions,
                    definitions.predicate.GenericServerOptions,
                    definitions.predicate.BintrayOptions,
                    definitions.predicate.CustomPublishOptions,
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.anyOf
                      [
                        definitions.predicate.GithubOptions,
                        definitions.predicate.S3Options,
                        definitions.predicate.SpacesOptions,
                        definitions.predicate.GenericServerOptions,
                        definitions.predicate.BintrayOptions,
                        definitions.predicate.CustomPublishOptions,
                        predicates.isType '"String"
                      ])
                    ],
                    predicates.anyOf
                    [ predicates.isType 'Null, predicates.isType '"String" ]
                  ])
                  | optional,
                title
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The title of the produced DMG, which will be shown when mounted (volume name).
                  
                  Macro `${productName}`, `${version}` and `${name}` are supported.
                  "%
                  | optional,
                window
                  | definitions.contract.DmgWindow
                  | doc m%"
                  The DMG windows position and size.
                  "%
                  | optional,
              },
          DmgWindow = {
                height
                  | Number
                  | doc m%"
                  The height. Defaults to background image height or 380.
                  "%
                  | optional,
                width
                  | Number
                  | doc m%"
                  The width. Defaults to background image width or 540.
                  "%
                  | optional,
                x
                  | Number
                  | doc m%"
                  The X position relative to left of the screen.
                  "%
                  | optional,
                y
                  | Number
                  | doc m%"
                  The Y position relative to top of the screen.
                  "%
                  | optional,
              },
          ElectronDownloadOptions = {
                arch | String | optional,
                cache
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The [cache location](https://github.com/electron-userland/electron-download#cache-location).
                  "%
                  | optional,
                customDir
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | optional,
                customFilename
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | optional,
                isVerifyChecksum | Bool | optional,
                mirror
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The mirror.
                  "%
                  | optional,
                platform
                  | std.enum.TagOrString
                  | [| 'win32, 'mas, 'linux, 'darwin |]
                  | optional,
                strictSSL | Bool | optional,
                version | String | optional,
              },
          FileAssociation
            | doc m%"
            File associations.
            
            macOS (corresponds to [CFBundleDocumentTypes](https://developer.apple.com/library/content/documentation/General/Reference/InfoPlistKeyReference/Articles/CoreFoundationKeys.html#//apple_ref/doc/uid/20001431-101685)) and NSIS only.
            
            On Windows works only if [nsis.perMachine](https://electron.build/configuration/configuration#NsisOptions-perMachine) is set to `true`.
            "%
            = {
                description
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  *windows-only.* The description.
                  "%
                  | optional,
                ext
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ],
                    predicates.isType '"String"
                  ])
                  | doc m%"
                  The extension (minus the leading period). e.g. `png`.
                  "%,
                icon
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The path to icon (`.icns` for MacOS and `.ico` for Windows), relative to `build` (build resources directory). Defaults to `${firstExt}.icns`/`${firstExt}.ico` (if several extensions specified, first is used) or to application icon.
                  
                  Not supported on Linux, file issue if need (default icon will be `x-office-document`).
                  "%
                  | optional,
                isPackage
                  | Bool
                  | doc m%"
                  *macOS-only* Whether the document is distributed as a bundle. If set to true, the bundle directory is treated as a file. Corresponds to `LSTypeIsPackage`.
                  "%
                  | optional,
                mimeType
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  *linux-only.* The mime-type.
                  "%
                  | optional,
                name
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The name. e.g. `PNG`. Defaults to `ext`.
                  "%
                  | optional,
                role
                  | String
                  | doc m%"
                  *macOS-only* The app's role with respect to the type. The value can be `Editor`, `Viewer`, `Shell`, or `None`. Corresponds to `CFBundleTypeRole`.
                  "%
                  | optional,
              },
          FileSet = {
                filter
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ],
                    predicates.isType '"String"
                  ])
                  | doc m%"
                  The [glob patterns](/file-patterns).
                  "%
                  | optional,
                from
                  | String
                  | doc m%"
                  The source path relative to the project directory.
                  "%
                  | optional,
                to
                  | String
                  | doc m%"
                  The destination path relative to the app's content directory for `extraFiles` and the app's resource directory for `extraResources`.
                  "%
                  | optional,
              },
          GenericServerOptions
            | doc m%"
            Generic (any HTTP(S) server) options.
            In all publish options [File Macros](/file-patterns#file-macros) are supported.
            "%
            = {
                channel
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The channel.
                  "%
                  | optional,
                provider
                  | std.enum.TagOrString
                  | [| 'generic |]
                  | doc m%"
                  The provider. Must be `generic`.
                  "%,
                publishAutoUpdate
                  | Bool
                  | doc m%"
                  Whether to publish auto update info files.
                  
                  Auto update relies only on the first provider in the list (you can specify several publishers).
                  Thus, probably, there`s no need to upload the metadata files for the other configured providers. But by default will be uploaded.
                  "%
                  | optional,
                publisherName
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ],
                    predicates.isType 'Null
                  ])
                  | optional,
                updaterCacheDirName
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | optional,
                url
                  | String
                  | doc m%"
                  The base url. e.g. `https://bucket_name.s3.amazonaws.com`.
                  "%,
                useMultipleRangeRequest
                  | Bool
                  | doc m%"
                  Whether to use multiple range requests for differential update. Defaults to `true` if `url` doesn't contain `s3.amazonaws.com`.
                  "%
                  | optional,
              },
          GithubOptions
            | doc m%"
            [GitHub](https://help.github.com/articles/about-releases/) options.
            
            GitHub [personal access token](https://help.github.com/articles/creating-an-access-token-for-command-line-use/) is required. You can generate by going to [https://github.com/settings/tokens/new](https://github.com/settings/tokens/new). The access token should have the repo scope/permission.
            Define `GH_TOKEN` environment variable.
            "%
            = {
                host
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The host (including the port if need).
                  "%
                  | optional,
                owner
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The owner.
                  "%
                  | optional,
                private
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"Bool" ])
                  | doc m%"
                  Whether to use private github auto-update provider if `GH_TOKEN` environment variable is defined. See [Private GitHub Update Repo](/auto-update#private-github-update-repo).
                  "%
                  | optional,
                protocol
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.enum [ "http", "https" ]
                    ],
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  The protocol. GitHub Publisher supports only `https`.
                  "%
                  | optional,
                provider
                  | std.enum.TagOrString
                  | [| 'github |]
                  | doc m%"
                  The provider. Must be `github`.
                  "%,
                publishAutoUpdate
                  | Bool
                  | doc m%"
                  Whether to publish auto update info files.
                  
                  Auto update relies only on the first provider in the list (you can specify several publishers).
                  Thus, probably, there`s no need to upload the metadata files for the other configured providers. But by default will be uploaded.
                  "%
                  | optional,
                publisherName
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ],
                    predicates.isType 'Null
                  ])
                  | optional,
                releaseType
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.enum [ "draft", "prerelease", "release" ]
                    ],
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  The type of release. By default `draft` release will be created.
                  
                  Also you can set release type using environment variable. If `EP_DRAFT`is set to `true` — `draft`, if `EP_PRE_RELEASE`is set to `true` — `prerelease`.
                  "%
                  | optional,
                repo
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The repository name. [Detected automatically](#github-repository-and-bintray-package).
                  "%
                  | optional,
                token
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The access token to support auto-update from private github repositories. Never specify it in the configuration files. Only for [setFeedURL](/auto-update#appupdatersetfeedurloptions).
                  "%
                  | optional,
                updaterCacheDirName
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | optional,
                vPrefixedTagName
                  | Bool
                  | doc m%"
                  Whether to use `v`-prefixed tag name.
                  "%
                  | optional,
              },
          LinuxConfiguration = {
                appId
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The application id. Used as [CFBundleIdentifier](https://developer.apple.com/library/ios/documentation/General/Reference/InfoPlistKeyReference/Articles/CoreFoundationKeys.html#//apple_ref/doc/uid/20001431-102070) for MacOS and as
                  [Application User Model ID](https://msdn.microsoft.com/en-us/library/windows/desktop/dd378459(v=vs.85).aspx) for Windows (NSIS target only, Squirrel.Windows not supported). It is strongly recommended that an explicit ID is set.
                  "%
                  | optional,
                artifactName
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The [artifact file name template](/configuration/configuration#artifact-file-name-template). Defaults to `${productName}-${version}.${ext}` (some target can have other defaults, see corresponding options).
                  "%
                  | optional,
                asar
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.AsarOptions,
                    predicates.anyOf
                    [ predicates.isType 'Null, predicates.isType '"Bool" ]
                  ])
                  | doc m%"
                  Whether to package the application's source code into an archive, using [Electron's archive format](http://electron.atom.io/docs/tutorial/application-packaging/).
                  
                  Node modules, that must be unpacked, will be detected automatically, you don't need to explicitly set [asarUnpack](#configuration-asarUnpack) - please file an issue if this doesn't work.
                  "%
                  | optional,
                asarUnpack
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ],
                    predicates.anyOf
                    [ predicates.isType 'Null, predicates.isType '"String" ]
                  ])
                  | doc m%"
                  A [glob patterns](/file-patterns) relative to the [app directory](#MetadataDirectories-app), which specifies which files to unpack when creating the [asar](http://electron.atom.io/docs/tutorial/application-packaging/) archive.
                  "%
                  | optional,
                category
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The [application category](https://specifications.freedesktop.org/menu-spec/latest/apa.html#main-category-registry).
                  "%
                  | optional,
                compression
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.enum [ "maximum", "normal", "store" ]
                    ],
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  The compression level. If you want to rapidly test build, `store` can reduce build time significantly. `maximum` doesn't lead to noticeable size difference, but increase build time.
                  "%
                  | optional,
                cscKeyPassword
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | optional,
                cscLink
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | optional,
                depends
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ],
                    predicates.isType 'Null
                  ])
                  | optional,
                description
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  As [description](/configuration/configuration#Metadata-description) from application package.json, but allows you to specify different for Linux.
                  "%
                  | optional,
                desktop
                  | predicates.contract_from_predicate predicates.always
                  | doc m%"
                  The [Desktop file](https://developer.gnome.org/integration-guide/stable/desktop-files.html.en) entries (name to value).
                  "%
                  | optional,
                detectUpdateChannel
                  | Bool
                  | doc m%"
                  Whether to infer update channel from application version pre-release components. e.g. if version `0.12.1-alpha.1`, channel will be set to `alpha`. Otherwise to `latest`.
                  "%
                  | optional,
                electronUpdaterCompatibility
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The [electron-updater compatibility](/auto-update#compatibility) semver range.
                  "%
                  | optional,
                executableName
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The executable name. Defaults to `productName`.
                  Cannot be specified per target, allowed only in the `linux`.
                  "%
                  | optional,
                extraFiles
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.FileSet,
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.anyOf
                      [
                        definitions.predicate.FileSet,
                        predicates.isType '"String"
                      ])
                    ],
                    predicates.anyOf
                    [ predicates.isType 'Null, predicates.isType '"String" ]
                  ])
                  | optional,
                extraResources
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.FileSet,
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.anyOf
                      [
                        definitions.predicate.FileSet,
                        predicates.isType '"String"
                      ])
                    ],
                    predicates.anyOf
                    [ predicates.isType 'Null, predicates.isType '"String" ]
                  ])
                  | optional,
                fileAssociations
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.FileAssociation,
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      definitions.predicate.FileAssociation
                    ]
                  ])
                  | doc m%"
                  The file associations.
                  "%
                  | optional,
                files
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.FileSet,
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.anyOf
                      [
                        definitions.predicate.FileSet,
                        predicates.isType '"String"
                      ])
                    ],
                    predicates.anyOf
                    [ predicates.isType 'Null, predicates.isType '"String" ]
                  ])
                  | optional,
                forceCodeSigning
                  | Bool
                  | doc m%"
                  Whether to fail if app will be not code signed.
                  "%
                  | optional,
                generateUpdatesFilesForAllChannels
                  | Bool
                  | doc m%"
                  Please see [Building and Releasing using Channels](https://github.com/electron-userland/electron-builder/issues/1182#issuecomment-324947139).
                  "%
                  | optional,
                icon
                  | String
                  | doc m%"
                  The path to icon set directory or one png file, relative to the [build resources](/configuration/configuration#MetadataDirectories-buildResources) or to the project directory. The icon filename must contain the size (e.g. 32x32.png) of the icon.
                  By default will be generated automatically based on the macOS icns file.
                  "%
                  | optional,
                maintainer
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The maintainer. Defaults to [author](/configuration/configuration#Metadata-author).
                  "%
                  | optional,
                mimeTypes
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ],
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  The mime types in addition to specified in the file associations. Use it if you don't want to register a new mime type, but reuse existing.
                  "%
                  | optional,
                packageCategory
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  backward compatibility + to allow specify fpm-only category for all possible fpm targets in one place
                  "%
                  | optional,
                protocols
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.Protocol,
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf definitions.predicate.Protocol
                    ]
                  ])
                  | doc m%"
                  The URL protocol schemes.
                  "%
                  | optional,
                publish
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.GithubOptions,
                    definitions.predicate.S3Options,
                    definitions.predicate.SpacesOptions,
                    definitions.predicate.GenericServerOptions,
                    definitions.predicate.BintrayOptions,
                    definitions.predicate.CustomPublishOptions,
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.anyOf
                      [
                        definitions.predicate.GithubOptions,
                        definitions.predicate.S3Options,
                        definitions.predicate.SpacesOptions,
                        definitions.predicate.GenericServerOptions,
                        definitions.predicate.BintrayOptions,
                        definitions.predicate.CustomPublishOptions,
                        predicates.isType '"String"
                      ])
                    ],
                    predicates.anyOf
                    [ predicates.isType 'Null, predicates.isType '"String" ]
                  ])
                  | optional,
                releaseInfo
                  | definitions.contract.ReleaseInfo
                  | doc m%"
                  The release info. Intended for command line usage:
                  
                  ```
                  -c.releaseInfo.releaseNotes="new features"
                  ```
                  "%
                  | optional,
                synopsis
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The [short description](https://www.debian.org/doc/debian-policy/ch-controlfields.html#s-f-Description).
                  "%
                  | optional,
                target
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.TargetConfiguration,
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.anyOf
                      [
                        definitions.predicate.TargetConfiguration,
                        predicates.isType '"String"
                      ])
                    ],
                    predicates.anyOf
                    [ predicates.isType 'Null, predicates.isType '"String" ]
                  ])
                  | doc m%"
                  Target package type: list of `AppImage`, `snap`, `deb`, `rpm`, `freebsd`, `pacman`, `p5p`, `apk`, `7z`, `zip`, `tar.xz`, `tar.lz`, `tar.gz`, `tar.bz2`, `dir`.
                  
                  electron-builder [docker image](/multi-platform-build#docker) can be used to build Linux targets on any platform.
                  
                  Please [do not put an AppImage into another archive](https://github.com/probonopd/AppImageKit/wiki/Creating-AppImages#common-mistake) like a .zip or .tar.gz.
                  "%
                  | optional,
                vendor
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The vendor. Defaults to [author](/configuration/configuration#Metadata-author).
                  "%
                  | optional,
              },
          LinuxTargetSpecificOptions = {
                afterInstall
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | optional,
                afterRemove
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | optional,
                artifactName
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The [artifact file name template](/configuration/configuration#artifact-file-name-template).
                  "%
                  | optional,
                category
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The [application category](https://specifications.freedesktop.org/menu-spec/latest/apa.html#main-category-registry).
                  "%
                  | optional,
                compression
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.enum [ "bzip2", "gz", "xz" ]
                    ],
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  The compression type.
                  "%
                  | optional,
                depends
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ],
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  Package dependencies.
                  "%
                  | optional,
                description
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  As [description](/configuration/configuration#Metadata-description) from application package.json, but allows you to specify different for Linux.
                  "%
                  | optional,
                desktop
                  | predicates.contract_from_predicate predicates.always
                  | doc m%"
                  The [Desktop file](https://developer.gnome.org/integration-guide/stable/desktop-files.html.en) entries (name to value).
                  "%
                  | optional,
                fpm
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ],
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  *Advanced only* The [fpm](https://github.com/jordansissel/fpm/wiki#usage) options.
                  
                  Example: `["--before-install=build/deb-preinstall.sh", "--after-upgrade=build/deb-postinstall.sh"]`
                  "%
                  | optional,
                icon | String | optional,
                maintainer
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | optional,
                mimeTypes
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ],
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  The mime types in addition to specified in the file associations. Use it if you don't want to register a new mime type, but reuse existing.
                  "%
                  | optional,
                packageCategory
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The package category.
                  "%
                  | optional,
                publish
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.GithubOptions,
                    definitions.predicate.S3Options,
                    definitions.predicate.SpacesOptions,
                    definitions.predicate.GenericServerOptions,
                    definitions.predicate.BintrayOptions,
                    definitions.predicate.CustomPublishOptions,
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.anyOf
                      [
                        definitions.predicate.GithubOptions,
                        definitions.predicate.S3Options,
                        definitions.predicate.SpacesOptions,
                        definitions.predicate.GenericServerOptions,
                        definitions.predicate.BintrayOptions,
                        definitions.predicate.CustomPublishOptions,
                        predicates.isType '"String"
                      ])
                    ],
                    predicates.anyOf
                    [ predicates.isType 'Null, predicates.isType '"String" ]
                  ])
                  | optional,
                synopsis
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The [short description](https://www.debian.org/doc/debian-policy/ch-controlfields.html#s-f-Description).
                  "%
                  | optional,
                vendor
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | optional,
              },
          MacConfiguration = {
                appId
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The application id. Used as [CFBundleIdentifier](https://developer.apple.com/library/ios/documentation/General/Reference/InfoPlistKeyReference/Articles/CoreFoundationKeys.html#//apple_ref/doc/uid/20001431-102070) for MacOS and as
                  [Application User Model ID](https://msdn.microsoft.com/en-us/library/windows/desktop/dd378459(v=vs.85).aspx) for Windows (NSIS target only, Squirrel.Windows not supported). It is strongly recommended that an explicit ID is set.
                  "%
                  | optional,
                artifactName
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The [artifact file name template](/configuration/configuration#artifact-file-name-template). Defaults to `${productName}-${version}.${ext}` (some target can have other defaults, see corresponding options).
                  "%
                  | optional,
                asar
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.AsarOptions,
                    predicates.anyOf
                    [ predicates.isType 'Null, predicates.isType '"Bool" ]
                  ])
                  | doc m%"
                  Whether to package the application's source code into an archive, using [Electron's archive format](http://electron.atom.io/docs/tutorial/application-packaging/).
                  
                  Node modules, that must be unpacked, will be detected automatically, you don't need to explicitly set [asarUnpack](#configuration-asarUnpack) - please file an issue if this doesn't work.
                  "%
                  | optional,
                asarUnpack
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ],
                    predicates.anyOf
                    [ predicates.isType 'Null, predicates.isType '"String" ]
                  ])
                  | doc m%"
                  A [glob patterns](/file-patterns) relative to the [app directory](#MetadataDirectories-app), which specifies which files to unpack when creating the [asar](http://electron.atom.io/docs/tutorial/application-packaging/) archive.
                  "%
                  | optional,
                binaries
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ],
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  Paths of any extra binaries that need to be signed.
                  "%
                  | optional,
                bundleShortVersion
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The `CFBundleShortVersionString`. Do not use it unless you need to.
                  "%
                  | optional,
                bundleVersion
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The `CFBundleVersion`. Do not use it unless [you need to](https://github.com/electron-userland/electron-builder/issues/565#issuecomment-230678643).
                  "%
                  | optional,
                category
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The application category type, as shown in the Finder via *View -> Arrange by Application Category* when viewing the Applications directory.
                  
                  For example, `"category": "public.app-category.developer-tools"` will set the application category to *Developer Tools*.
                  
                  Valid values are listed in [Apple's documentation](https://developer.apple.com/library/ios/documentation/General/Reference/InfoPlistKeyReference/Articles/LaunchServicesKeys.html#//apple_ref/doc/uid/TP40009250-SW8).
                  "%
                  | optional,
                compression
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.enum [ "maximum", "normal", "store" ]
                    ],
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  The compression level. If you want to rapidly test build, `store` can reduce build time significantly. `maximum` doesn't lead to noticeable size difference, but increase build time.
                  "%
                  | optional,
                cscInstallerKeyPassword
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | optional,
                cscInstallerLink
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | optional,
                cscKeyPassword
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | optional,
                cscLink
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | optional,
                darkModeSupport
                  | Bool
                  | doc m%"
                  Whether a dark mode is supported. If your app does have a dark mode, you can make your app follow the system-wide dark mode setting.
                  "%
                  | optional,
                detectUpdateChannel
                  | Bool
                  | doc m%"
                  Whether to infer update channel from application version pre-release components. e.g. if version `0.12.1-alpha.1`, channel will be set to `alpha`. Otherwise to `latest`.
                  "%
                  | optional,
                electronLanguages
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ],
                    predicates.isType '"String"
                  ])
                  | doc m%"
                  The electron locales. By default Electron locales used as is.
                  "%
                  | optional,
                electronUpdaterCompatibility
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The [electron-updater compatibility](/auto-update#compatibility) semver range.
                  "%
                  | optional,
                entitlements
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The path to entitlements file for signing the app. `build/entitlements.mac.plist` will be used if exists (it is a recommended way to set).
                  MAS entitlements is specified in the [mas](/configuration/mas).
                  "%
                  | optional,
                entitlementsInherit
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The path to child entitlements which inherit the security settings for signing frameworks and bundles of a distribution. `build/entitlements.mac.inherit.plist` will be used if exists (it is a recommended way to set).
                  Otherwise [default](https://github.com/electron-userland/electron-osx-sign/blob/master/default.entitlements.darwin.inherit.plist).
                  
                  This option only applies when signing with `entitlements` provided.
                  "%
                  | optional,
                extendInfo
                  | predicates.contract_from_predicate predicates.always
                  | doc m%"
                  The extra entries for `Info.plist`.
                  "%
                  | optional,
                extraDistFiles
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ],
                    predicates.anyOf
                    [ predicates.isType 'Null, predicates.isType '"String" ]
                  ])
                  | doc m%"
                  Extra files to put in archive. Not applicable for `tar.*`.
                  "%
                  | optional,
                extraFiles
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.FileSet,
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.anyOf
                      [
                        definitions.predicate.FileSet,
                        predicates.isType '"String"
                      ])
                    ],
                    predicates.anyOf
                    [ predicates.isType 'Null, predicates.isType '"String" ]
                  ])
                  | optional,
                extraResources
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.FileSet,
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.anyOf
                      [
                        definitions.predicate.FileSet,
                        predicates.isType '"String"
                      ])
                    ],
                    predicates.anyOf
                    [ predicates.isType 'Null, predicates.isType '"String" ]
                  ])
                  | optional,
                fileAssociations
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.FileAssociation,
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      definitions.predicate.FileAssociation
                    ]
                  ])
                  | doc m%"
                  The file associations.
                  "%
                  | optional,
                files
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.FileSet,
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.anyOf
                      [
                        definitions.predicate.FileSet,
                        predicates.isType '"String"
                      ])
                    ],
                    predicates.anyOf
                    [ predicates.isType 'Null, predicates.isType '"String" ]
                  ])
                  | optional,
                forceCodeSigning
                  | Bool
                  | doc m%"
                  Whether to fail if app will be not code signed.
                  "%
                  | optional,
                gatekeeperAssess
                  | Bool
                  | doc m%"
                  Whether to let electron-osx-sign validate the signing or not.
                  "%
                  | optional,
                generateUpdatesFilesForAllChannels
                  | Bool
                  | doc m%"
                  Please see [Building and Releasing using Channels](https://github.com/electron-userland/electron-builder/issues/1182#issuecomment-324947139).
                  "%
                  | optional,
                hardenedRuntime
                  | Bool
                  | doc m%"
                  Whether your app has to be signed with hardened runtime.
                  "%
                  | optional,
                helperBundleId
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The bundle identifier to use in the application helper's plist.
                  "%
                  | optional,
                icon
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The path to application icon.
                  "%
                  | optional,
                identity
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The name of certificate to use when signing. Consider using environment variables [CSC_LINK or CSC_NAME](/code-signing) instead of specifying this option.
                  MAS installer identity is specified in the [mas](/configuration/mas).
                  "%
                  | optional,
                minimumSystemVersion
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The minimum version of macOS required for the app to run. Corresponds to `LSMinimumSystemVersion`.
                  "%
                  | optional,
                protocols
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.Protocol,
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf definitions.predicate.Protocol
                    ]
                  ])
                  | doc m%"
                  The URL protocol schemes.
                  "%
                  | optional,
                provisioningProfile
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The path to the provisioning profile to use when signing, absolute or relative to the app root.
                  "%
                  | optional,
                publish
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.GithubOptions,
                    definitions.predicate.S3Options,
                    definitions.predicate.SpacesOptions,
                    definitions.predicate.GenericServerOptions,
                    definitions.predicate.BintrayOptions,
                    definitions.predicate.CustomPublishOptions,
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.anyOf
                      [
                        definitions.predicate.GithubOptions,
                        definitions.predicate.S3Options,
                        definitions.predicate.SpacesOptions,
                        definitions.predicate.GenericServerOptions,
                        definitions.predicate.BintrayOptions,
                        definitions.predicate.CustomPublishOptions,
                        predicates.isType '"String"
                      ])
                    ],
                    predicates.anyOf
                    [ predicates.isType 'Null, predicates.isType '"String" ]
                  ])
                  | optional,
                releaseInfo
                  | definitions.contract.ReleaseInfo
                  | doc m%"
                  The release info. Intended for command line usage:
                  
                  ```
                  -c.releaseInfo.releaseNotes="new features"
                  ```
                  "%
                  | optional,
                requirements
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  Path of [requirements file](https://developer.apple.com/library/mac/documentation/Security/Conceptual/CodeSigningGuide/RequirementLang/RequirementLang.html) used in signing. Not applicable for MAS.
                  "%
                  | optional,
                target
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.TargetConfiguration,
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.anyOf
                      [
                        definitions.predicate.TargetConfiguration,
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum
                          [
                            "7z",
                            "default",
                            "dir",
                            "dmg",
                            "mas",
                            "mas-dev",
                            "pkg",
                            "tar.bz2",
                            "tar.gz",
                            "tar.lz",
                            "tar.xz",
                            "zip"
                          ]
                        ]
                      ])
                    ],
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.enum
                      [
                        "7z",
                        "default",
                        "dir",
                        "dmg",
                        "mas",
                        "mas-dev",
                        "pkg",
                        "tar.bz2",
                        "tar.gz",
                        "tar.lz",
                        "tar.xz",
                        "zip"
                      ]
                    ],
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  The target package type: list of `default`, `dmg`, `mas`, `mas-dev`, `pkg`, `7z`, `zip`, `tar.xz`, `tar.lz`, `tar.gz`, `tar.bz2`, `dir`. Defaults to `default` (dmg and zip for Squirrel.Mac).
                  "%
                  | optional,
                type
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.enum [ "development", "distribution" ]
                    ],
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  Whether to sign app for development or for distribution.
                  "%
                  | optional,
              },
          MasConfiguration = {
                appId
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The application id. Used as [CFBundleIdentifier](https://developer.apple.com/library/ios/documentation/General/Reference/InfoPlistKeyReference/Articles/CoreFoundationKeys.html#//apple_ref/doc/uid/20001431-102070) for MacOS and as
                  [Application User Model ID](https://msdn.microsoft.com/en-us/library/windows/desktop/dd378459(v=vs.85).aspx) for Windows (NSIS target only, Squirrel.Windows not supported). It is strongly recommended that an explicit ID is set.
                  "%
                  | optional,
                artifactName
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The [artifact file name template](/configuration/configuration#artifact-file-name-template). Defaults to `${productName}-${version}.${ext}` (some target can have other defaults, see corresponding options).
                  "%
                  | optional,
                asar
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.AsarOptions,
                    predicates.anyOf
                    [ predicates.isType 'Null, predicates.isType '"Bool" ]
                  ])
                  | doc m%"
                  Whether to package the application's source code into an archive, using [Electron's archive format](http://electron.atom.io/docs/tutorial/application-packaging/).
                  
                  Node modules, that must be unpacked, will be detected automatically, you don't need to explicitly set [asarUnpack](#configuration-asarUnpack) - please file an issue if this doesn't work.
                  "%
                  | optional,
                asarUnpack
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ],
                    predicates.anyOf
                    [ predicates.isType 'Null, predicates.isType '"String" ]
                  ])
                  | doc m%"
                  A [glob patterns](/file-patterns) relative to the [app directory](#MetadataDirectories-app), which specifies which files to unpack when creating the [asar](http://electron.atom.io/docs/tutorial/application-packaging/) archive.
                  "%
                  | optional,
                binaries
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ],
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  Paths of any extra binaries that need to be signed.
                  "%
                  | optional,
                bundleShortVersion
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The `CFBundleShortVersionString`. Do not use it unless you need to.
                  "%
                  | optional,
                bundleVersion
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The `CFBundleVersion`. Do not use it unless [you need to](https://github.com/electron-userland/electron-builder/issues/565#issuecomment-230678643).
                  "%
                  | optional,
                category
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The application category type, as shown in the Finder via *View -> Arrange by Application Category* when viewing the Applications directory.
                  
                  For example, `"category": "public.app-category.developer-tools"` will set the application category to *Developer Tools*.
                  
                  Valid values are listed in [Apple's documentation](https://developer.apple.com/library/ios/documentation/General/Reference/InfoPlistKeyReference/Articles/LaunchServicesKeys.html#//apple_ref/doc/uid/TP40009250-SW8).
                  "%
                  | optional,
                compression
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.enum [ "maximum", "normal", "store" ]
                    ],
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  The compression level. If you want to rapidly test build, `store` can reduce build time significantly. `maximum` doesn't lead to noticeable size difference, but increase build time.
                  "%
                  | optional,
                cscInstallerKeyPassword
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | optional,
                cscInstallerLink
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | optional,
                cscKeyPassword
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | optional,
                cscLink
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | optional,
                darkModeSupport
                  | Bool
                  | doc m%"
                  Whether a dark mode is supported. If your app does have a dark mode, you can make your app follow the system-wide dark mode setting.
                  "%
                  | optional,
                detectUpdateChannel
                  | Bool
                  | doc m%"
                  Whether to infer update channel from application version pre-release components. e.g. if version `0.12.1-alpha.1`, channel will be set to `alpha`. Otherwise to `latest`.
                  "%
                  | optional,
                electronLanguages
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ],
                    predicates.isType '"String"
                  ])
                  | doc m%"
                  The electron locales. By default Electron locales used as is.
                  "%
                  | optional,
                electronUpdaterCompatibility
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The [electron-updater compatibility](/auto-update#compatibility) semver range.
                  "%
                  | optional,
                entitlements
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The path to entitlements file for signing the app. `build/entitlements.mas.plist` will be used if exists (it is a recommended way to set).
                  Otherwise [default](https://github.com/electron-userland/electron-osx-sign/blob/master/default.entitlements.mas.plist).
                  "%
                  | optional,
                entitlementsInherit
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The path to child entitlements which inherit the security settings for signing frameworks and bundles of a distribution. `build/entitlements.mas.inherit.plist` will be used if exists (it is a recommended way to set).
                  Otherwise [default](https://github.com/electron-userland/electron-osx-sign/blob/master/default.entitlements.mas.inherit.plist).
                  "%
                  | optional,
                extendInfo
                  | predicates.contract_from_predicate predicates.always
                  | doc m%"
                  The extra entries for `Info.plist`.
                  "%
                  | optional,
                extraDistFiles
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ],
                    predicates.anyOf
                    [ predicates.isType 'Null, predicates.isType '"String" ]
                  ])
                  | doc m%"
                  Extra files to put in archive. Not applicable for `tar.*`.
                  "%
                  | optional,
                extraFiles
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.FileSet,
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.anyOf
                      [
                        definitions.predicate.FileSet,
                        predicates.isType '"String"
                      ])
                    ],
                    predicates.anyOf
                    [ predicates.isType 'Null, predicates.isType '"String" ]
                  ])
                  | optional,
                extraResources
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.FileSet,
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.anyOf
                      [
                        definitions.predicate.FileSet,
                        predicates.isType '"String"
                      ])
                    ],
                    predicates.anyOf
                    [ predicates.isType 'Null, predicates.isType '"String" ]
                  ])
                  | optional,
                fileAssociations
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.FileAssociation,
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      definitions.predicate.FileAssociation
                    ]
                  ])
                  | doc m%"
                  The file associations.
                  "%
                  | optional,
                files
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.FileSet,
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.anyOf
                      [
                        definitions.predicate.FileSet,
                        predicates.isType '"String"
                      ])
                    ],
                    predicates.anyOf
                    [ predicates.isType 'Null, predicates.isType '"String" ]
                  ])
                  | optional,
                forceCodeSigning
                  | Bool
                  | doc m%"
                  Whether to fail if app will be not code signed.
                  "%
                  | optional,
                generateUpdatesFilesForAllChannels
                  | Bool
                  | doc m%"
                  Please see [Building and Releasing using Channels](https://github.com/electron-userland/electron-builder/issues/1182#issuecomment-324947139).
                  "%
                  | optional,
                hardenedRuntime
                  | Bool
                  | doc m%"
                  Whether your app has to be signed with hardened runtime.
                  "%
                  | optional,
                helperBundleId
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The bundle identifier to use in the application helper's plist.
                  "%
                  | optional,
                icon
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The path to application icon.
                  "%
                  | optional,
                identity
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The name of certificate to use when signing. Consider using environment variables [CSC_LINK or CSC_NAME](/code-signing) instead of specifying this option.
                  MAS installer identity is specified in the [mas](/configuration/mas).
                  "%
                  | optional,
                minimumSystemVersion
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The minimum version of macOS required for the app to run. Corresponds to `LSMinimumSystemVersion`.
                  "%
                  | optional,
                protocols
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.Protocol,
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf definitions.predicate.Protocol
                    ]
                  ])
                  | doc m%"
                  The URL protocol schemes.
                  "%
                  | optional,
                provisioningProfile
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The path to the provisioning profile to use when signing, absolute or relative to the app root.
                  "%
                  | optional,
                publish
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.GithubOptions,
                    definitions.predicate.S3Options,
                    definitions.predicate.SpacesOptions,
                    definitions.predicate.GenericServerOptions,
                    definitions.predicate.BintrayOptions,
                    definitions.predicate.CustomPublishOptions,
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.anyOf
                      [
                        definitions.predicate.GithubOptions,
                        definitions.predicate.S3Options,
                        definitions.predicate.SpacesOptions,
                        definitions.predicate.GenericServerOptions,
                        definitions.predicate.BintrayOptions,
                        definitions.predicate.CustomPublishOptions,
                        predicates.isType '"String"
                      ])
                    ],
                    predicates.anyOf
                    [ predicates.isType 'Null, predicates.isType '"String" ]
                  ])
                  | optional,
                releaseInfo
                  | definitions.contract.ReleaseInfo
                  | doc m%"
                  The release info. Intended for command line usage:
                  
                  ```
                  -c.releaseInfo.releaseNotes="new features"
                  ```
                  "%
                  | optional,
                requirements
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  Path of [requirements file](https://developer.apple.com/library/mac/documentation/Security/Conceptual/CodeSigningGuide/RequirementLang/RequirementLang.html) used in signing. Not applicable for MAS.
                  "%
                  | optional,
                target
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.TargetConfiguration,
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.anyOf
                      [
                        definitions.predicate.TargetConfiguration,
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum
                          [
                            "7z",
                            "default",
                            "dir",
                            "dmg",
                            "mas",
                            "mas-dev",
                            "pkg",
                            "tar.bz2",
                            "tar.gz",
                            "tar.lz",
                            "tar.xz",
                            "zip"
                          ]
                        ]
                      ])
                    ],
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.enum
                      [
                        "7z",
                        "default",
                        "dir",
                        "dmg",
                        "mas",
                        "mas-dev",
                        "pkg",
                        "tar.bz2",
                        "tar.gz",
                        "tar.lz",
                        "tar.xz",
                        "zip"
                      ]
                    ],
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  The target package type: list of `default`, `dmg`, `mas`, `mas-dev`, `pkg`, `7z`, `zip`, `tar.xz`, `tar.lz`, `tar.gz`, `tar.bz2`, `dir`. Defaults to `default` (dmg and zip for Squirrel.Mac).
                  "%
                  | optional,
                type
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.enum [ "development", "distribution" ]
                    ],
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  Whether to sign app for development or for distribution.
                  "%
                  | optional,
              },
          MetadataDirectories = {
                app
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The application directory (containing the application package.json), defaults to `app`, `www` or working directory.
                  "%
                  | optional,
                buildResources
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The path to build resources.
                  
                  Please note — build resources is not packed into the app. If you need to use some files, e.g. as tray icon, please include required files explicitly: `"files": ["**\/*", "build/icon.*"]`
                  "%
                  | optional,
                output
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The output directory. [File macros](/file-patterns#file-macros) are supported.
                  "%
                  | optional,
              },
          MsiOptions = {
                artifactName
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The [artifact file name template](/configuration/configuration#artifact-file-name-template).
                  "%
                  | optional,
                createDesktopShortcut
                  | predicates.contract_from_predicate
                  (predicates.enum [ "always", false, true ])
                  | doc m%"
                  Whether to create desktop shortcut. Set to `always` if to recreate also on reinstall (even if removed by user).
                  "%
                  | optional,
                createStartMenuShortcut
                  | Bool
                  | doc m%"
                  Whether to create start menu shortcut.
                  "%
                  | optional,
                menuCategory
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType '"Bool" ])
                  | doc m%"
                  Whether to create submenu for start menu shortcut and program files directory. If `true`, company name will be used. Or string value.
                  "%
                  | optional,
                oneClick
                  | Bool
                  | doc m%"
                  One-click installation.
                  "%
                  | optional,
                perMachine
                  | Bool
                  | doc m%"
                  Whether to install per all users (per-machine).
                  "%
                  | optional,
                publish
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.GithubOptions,
                    definitions.predicate.S3Options,
                    definitions.predicate.SpacesOptions,
                    definitions.predicate.GenericServerOptions,
                    definitions.predicate.BintrayOptions,
                    definitions.predicate.CustomPublishOptions,
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.anyOf
                      [
                        definitions.predicate.GithubOptions,
                        definitions.predicate.S3Options,
                        definitions.predicate.SpacesOptions,
                        definitions.predicate.GenericServerOptions,
                        definitions.predicate.BintrayOptions,
                        definitions.predicate.CustomPublishOptions,
                        predicates.isType '"String"
                      ])
                    ],
                    predicates.anyOf
                    [ predicates.isType 'Null, predicates.isType '"String" ]
                  ])
                  | optional,
                runAfterFinish
                  | Bool
                  | doc m%"
                  Whether to run the installed application after finish. For assisted installer corresponding checkbox will be removed.
                  "%
                  | optional,
                shortcutName
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The name that will be used for all shortcuts. Defaults to the application name.
                  "%
                  | optional,
                upgradeCode
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The [upgrade code](https://msdn.microsoft.com/en-us/library/windows/desktop/aa372375(v=vs.85).aspx). Optional, by default generated using app id.
                  "%
                  | optional,
                warningsAsErrors
                  | Bool
                  | doc m%"
                  If `warningsAsErrors` is `true` (default): treat warnings as errors. If `warningsAsErrors` is `false`: allow warnings.
                  "%
                  | optional,
              },
          NsisOptions = {
                allowElevation
                  | Bool
                  | doc m%"
                  *assisted installer only.* Allow requesting for elevation. If false, user will have to restart installer with elevated permissions.
                  "%
                  | optional,
                allowToChangeInstallationDirectory
                  | Bool
                  | doc m%"
                  *assisted installer only.* Whether to allow user to change installation directory.
                  "%
                  | optional,
                artifactName
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The [artifact file name template](/configuration/configuration#artifact-file-name-template). Defaults to `${productName} Setup ${version}.${ext}`.
                  "%
                  | optional,
                createDesktopShortcut
                  | predicates.contract_from_predicate
                  (predicates.enum [ "always", false, true ])
                  | doc m%"
                  Whether to create desktop shortcut. Set to `always` if to recreate also on reinstall (even if removed by user).
                  "%
                  | optional,
                createStartMenuShortcut
                  | Bool
                  | doc m%"
                  Whether to create start menu shortcut.
                  "%
                  | optional,
                deleteAppDataOnUninstall
                  | Bool
                  | doc m%"
                  *one-click installer only.* Whether to delete app data on uninstall.
                  "%
                  | optional,
                differentialPackage
                  | Bool
                  | doc m%"
                  Defaults to `true` for web installer (`nsis-web`)
                  "%
                  | optional,
                displayLanguageSelector
                  | Bool
                  | doc m%"
                  Whether to display a language selection dialog. Not recommended (by default will be detected using OS language).
                  "%
                  | optional,
                guid
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  See [GUID vs Application Name](../configuration/nsis#guid-vs-application-name).
                  "%
                  | optional,
                include
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The path to NSIS include script to customize installer. Defaults to `build/installer.nsh`. See [Custom NSIS script](#custom-nsis-script).
                  "%
                  | optional,
                installerHeader
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  *assisted installer only.* `MUI_HEADERIMAGE`, relative to the [build resources](/configuration/configuration#MetadataDirectories-buildResources) or to the project directory.
                  "%
                  | optional,
                installerHeaderIcon
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  *one-click installer only.* The path to header icon (above the progress bar), relative to the [build resources](/configuration/configuration#MetadataDirectories-buildResources) or to the project directory.
                  Defaults to `build/installerHeaderIcon.ico` or application icon.
                  "%
                  | optional,
                installerIcon
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The path to installer icon, relative to the [build resources](/configuration/configuration#MetadataDirectories-buildResources) or to the project directory.
                  Defaults to `build/installerIcon.ico` or application icon.
                  "%
                  | optional,
                installerLanguages
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ],
                    predicates.anyOf
                    [ predicates.isType 'Null, predicates.isType '"String" ]
                  ])
                  | doc m%"
                  The installer languages (e.g. `en_US`, `de_DE`). Change only if you understand what do you do and for what.
                  "%
                  | optional,
                installerSidebar
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  *assisted installer only.* `MUI_WELCOMEFINISHPAGE_BITMAP`, relative to the [build resources](/configuration/configuration#MetadataDirectories-buildResources) or to the project directory.
                  Defaults to `build/installerSidebar.bmp` or `${NSISDIR}\\Contrib\\Graphics\\Wizard\\nsis3-metro.bmp`. Image size 164 × 314 pixels.
                  "%
                  | optional,
                language
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  [LCID Dec](https://msdn.microsoft.com/en-au/goglobal/bb964664.aspx), defaults to `1033`(`English - United States`).
                  "%
                  | optional,
                license
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The path to EULA license file. Defaults to `license.txt` or `eula.txt` (or uppercase variants). In addition to `txt, `rtf` and `html` supported (don't forget to use `target="_blank"` for links).
                  
                  Multiple license files in different languages are supported — use lang postfix (e.g. `_de`, `_ru`)). For example, create files `license_de.txt` and `license_en.txt` in the build resources.
                  If OS language is german, `license_de.txt` will be displayed. See map of [language code to name](https://github.com/meikidd/iso-639-1/blob/master/src/data.js).
                  
                  Appropriate license file will be selected by user OS language.
                  "%
                  | optional,
                menuCategory
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType '"Bool" ])
                  | doc m%"
                  Whether to create submenu for start menu shortcut and program files directory. If `true`, company name will be used. Or string value.
                  "%
                  | optional,
                multiLanguageInstaller
                  | Bool
                  | doc m%"
                  Whether to create multi-language installer. Defaults to `unicode` option value.
                  "%
                  | optional,
                oneClick
                  | Bool
                  | doc m%"
                  Whether to create one-click installer or assisted.
                  "%
                  | optional,
                packElevateHelper
                  | Bool
                  | doc m%"
                  Whether to pack the elevate executable (required for electron-updater if per-machine installer used or can be used in the future). Ignored if `perMachine` is set to `true`.
                  "%
                  | optional,
                perMachine
                  | Bool
                  | doc m%"
                  Whether to show install mode installer page (choice per-machine or per-user) for assisted installer. Or whether installation always per all users (per-machine).
                  
                  If `oneClick` is `true` (default): Whether to install per all users (per-machine).
                  
                  If `oneClick` is `false` and `perMachine` is `true`: no install mode installer page, always install per-machine.
                  
                  If `oneClick` is `false` and `perMachine` is `false` (default): install mode installer page.
                  "%
                  | optional,
                preCompressedFileExtensions
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ],
                    predicates.anyOf
                    [ predicates.isType 'Null, predicates.isType '"String" ]
                  ])
                  | doc m%"
                  The file extension of files that will be not compressed. Applicable only for `extraResources` and `extraFiles` files.
                  "%
                  | optional,
                publish
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.GithubOptions,
                    definitions.predicate.S3Options,
                    definitions.predicate.SpacesOptions,
                    definitions.predicate.GenericServerOptions,
                    definitions.predicate.BintrayOptions,
                    definitions.predicate.CustomPublishOptions,
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.anyOf
                      [
                        definitions.predicate.GithubOptions,
                        definitions.predicate.S3Options,
                        definitions.predicate.SpacesOptions,
                        definitions.predicate.GenericServerOptions,
                        definitions.predicate.BintrayOptions,
                        definitions.predicate.CustomPublishOptions,
                        predicates.isType '"String"
                      ])
                    ],
                    predicates.anyOf
                    [ predicates.isType 'Null, predicates.isType '"String" ]
                  ])
                  | optional,
                runAfterFinish
                  | Bool
                  | doc m%"
                  Whether to run the installed application after finish. For assisted installer corresponding checkbox will be removed.
                  "%
                  | optional,
                script
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The path to NSIS script to customize installer. Defaults to `build/installer.nsi`. See [Custom NSIS script](#custom-nsis-script).
                  "%
                  | optional,
                shortcutName
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The name that will be used for all shortcuts. Defaults to the application name.
                  "%
                  | optional,
                unicode
                  | Bool
                  | doc m%"
                  Whether to create [Unicode installer](http://nsis.sourceforge.net/Docs/Chapter1.html#intro-unicode).
                  "%
                  | optional,
                uninstallDisplayName
                  | String
                  | doc m%"
                  The uninstaller display name in the control panel.
                  "%
                  | optional,
                uninstallerIcon
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The path to uninstaller icon, relative to the [build resources](/configuration/configuration#MetadataDirectories-buildResources) or to the project directory.
                  Defaults to `build/uninstallerIcon.ico` or application icon.
                  "%
                  | optional,
                uninstallerSidebar
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  *assisted installer only.* `MUI_UNWELCOMEFINISHPAGE_BITMAP`, relative to the [build resources](/configuration/configuration#MetadataDirectories-buildResources) or to the project directory.
                  Defaults to `installerSidebar` option or `build/uninstallerSidebar.bmp` or `build/installerSidebar.bmp` or `${NSISDIR}\\Contrib\\Graphics\\Wizard\\nsis3-metro.bmp`
                  "%
                  | optional,
                useZip | Bool | optional,
                warningsAsErrors
                  | Bool
                  | doc m%"
                  If `warningsAsErrors` is `true` (default): NSIS will treat warnings as errors. If `warningsAsErrors` is `false`: NSIS will allow warnings.
                  "%
                  | optional,
              },
          NsisWebOptions
            | doc m%"
            Web Installer options.
            "%
            = {
                allowElevation
                  | Bool
                  | doc m%"
                  *assisted installer only.* Allow requesting for elevation. If false, user will have to restart installer with elevated permissions.
                  "%
                  | optional,
                allowToChangeInstallationDirectory
                  | Bool
                  | doc m%"
                  *assisted installer only.* Whether to allow user to change installation directory.
                  "%
                  | optional,
                appPackageUrl
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The application package download URL. Optional — by default computed using publish configuration.
                  
                  URL like `https://example.com/download/latest` allows web installer to be version independent (installer will download latest application package).
                  Please note — it is [full URL](https://github.com/electron-userland/electron-builder/issues/1810#issuecomment-317650878).
                  
                  Custom `X-Arch` http header is set to `32` or `64`.
                  "%
                  | optional,
                artifactName
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The [artifact file name template](/configuration/configuration#artifact-file-name-template). Defaults to `${productName} Web Setup ${version}.${ext}`.
                  "%
                  | optional,
                createDesktopShortcut
                  | predicates.contract_from_predicate
                  (predicates.enum [ "always", false, true ])
                  | doc m%"
                  Whether to create desktop shortcut. Set to `always` if to recreate also on reinstall (even if removed by user).
                  "%
                  | optional,
                createStartMenuShortcut
                  | Bool
                  | doc m%"
                  Whether to create start menu shortcut.
                  "%
                  | optional,
                deleteAppDataOnUninstall
                  | Bool
                  | doc m%"
                  *one-click installer only.* Whether to delete app data on uninstall.
                  "%
                  | optional,
                differentialPackage
                  | Bool
                  | doc m%"
                  Defaults to `true` for web installer (`nsis-web`)
                  "%
                  | optional,
                displayLanguageSelector
                  | Bool
                  | doc m%"
                  Whether to display a language selection dialog. Not recommended (by default will be detected using OS language).
                  "%
                  | optional,
                guid
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  See [GUID vs Application Name](../configuration/nsis#guid-vs-application-name).
                  "%
                  | optional,
                include
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The path to NSIS include script to customize installer. Defaults to `build/installer.nsh`. See [Custom NSIS script](#custom-nsis-script).
                  "%
                  | optional,
                installerHeader
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  *assisted installer only.* `MUI_HEADERIMAGE`, relative to the [build resources](/configuration/configuration#MetadataDirectories-buildResources) or to the project directory.
                  "%
                  | optional,
                installerHeaderIcon
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  *one-click installer only.* The path to header icon (above the progress bar), relative to the [build resources](/configuration/configuration#MetadataDirectories-buildResources) or to the project directory.
                  Defaults to `build/installerHeaderIcon.ico` or application icon.
                  "%
                  | optional,
                installerIcon
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The path to installer icon, relative to the [build resources](/configuration/configuration#MetadataDirectories-buildResources) or to the project directory.
                  Defaults to `build/installerIcon.ico` or application icon.
                  "%
                  | optional,
                installerLanguages
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ],
                    predicates.anyOf
                    [ predicates.isType 'Null, predicates.isType '"String" ]
                  ])
                  | doc m%"
                  The installer languages (e.g. `en_US`, `de_DE`). Change only if you understand what do you do and for what.
                  "%
                  | optional,
                installerSidebar
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  *assisted installer only.* `MUI_WELCOMEFINISHPAGE_BITMAP`, relative to the [build resources](/configuration/configuration#MetadataDirectories-buildResources) or to the project directory.
                  Defaults to `build/installerSidebar.bmp` or `${NSISDIR}\\Contrib\\Graphics\\Wizard\\nsis3-metro.bmp`. Image size 164 × 314 pixels.
                  "%
                  | optional,
                language
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  [LCID Dec](https://msdn.microsoft.com/en-au/goglobal/bb964664.aspx), defaults to `1033`(`English - United States`).
                  "%
                  | optional,
                license
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The path to EULA license file. Defaults to `license.txt` or `eula.txt` (or uppercase variants). In addition to `txt, `rtf` and `html` supported (don't forget to use `target="_blank"` for links).
                  
                  Multiple license files in different languages are supported — use lang postfix (e.g. `_de`, `_ru`)). For example, create files `license_de.txt` and `license_en.txt` in the build resources.
                  If OS language is german, `license_de.txt` will be displayed. See map of [language code to name](https://github.com/meikidd/iso-639-1/blob/master/src/data.js).
                  
                  Appropriate license file will be selected by user OS language.
                  "%
                  | optional,
                menuCategory
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType '"Bool" ])
                  | doc m%"
                  Whether to create submenu for start menu shortcut and program files directory. If `true`, company name will be used. Or string value.
                  "%
                  | optional,
                multiLanguageInstaller
                  | Bool
                  | doc m%"
                  Whether to create multi-language installer. Defaults to `unicode` option value.
                  "%
                  | optional,
                oneClick
                  | Bool
                  | doc m%"
                  Whether to create one-click installer or assisted.
                  "%
                  | optional,
                packElevateHelper
                  | Bool
                  | doc m%"
                  Whether to pack the elevate executable (required for electron-updater if per-machine installer used or can be used in the future). Ignored if `perMachine` is set to `true`.
                  "%
                  | optional,
                perMachine
                  | Bool
                  | doc m%"
                  Whether to show install mode installer page (choice per-machine or per-user) for assisted installer. Or whether installation always per all users (per-machine).
                  
                  If `oneClick` is `true` (default): Whether to install per all users (per-machine).
                  
                  If `oneClick` is `false` and `perMachine` is `true`: no install mode installer page, always install per-machine.
                  
                  If `oneClick` is `false` and `perMachine` is `false` (default): install mode installer page.
                  "%
                  | optional,
                preCompressedFileExtensions
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ],
                    predicates.anyOf
                    [ predicates.isType 'Null, predicates.isType '"String" ]
                  ])
                  | doc m%"
                  The file extension of files that will be not compressed. Applicable only for `extraResources` and `extraFiles` files.
                  "%
                  | optional,
                publish
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.GithubOptions,
                    definitions.predicate.S3Options,
                    definitions.predicate.SpacesOptions,
                    definitions.predicate.GenericServerOptions,
                    definitions.predicate.BintrayOptions,
                    definitions.predicate.CustomPublishOptions,
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.anyOf
                      [
                        definitions.predicate.GithubOptions,
                        definitions.predicate.S3Options,
                        definitions.predicate.SpacesOptions,
                        definitions.predicate.GenericServerOptions,
                        definitions.predicate.BintrayOptions,
                        definitions.predicate.CustomPublishOptions,
                        predicates.isType '"String"
                      ])
                    ],
                    predicates.anyOf
                    [ predicates.isType 'Null, predicates.isType '"String" ]
                  ])
                  | optional,
                runAfterFinish
                  | Bool
                  | doc m%"
                  Whether to run the installed application after finish. For assisted installer corresponding checkbox will be removed.
                  "%
                  | optional,
                script
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The path to NSIS script to customize installer. Defaults to `build/installer.nsi`. See [Custom NSIS script](#custom-nsis-script).
                  "%
                  | optional,
                shortcutName
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The name that will be used for all shortcuts. Defaults to the application name.
                  "%
                  | optional,
                unicode
                  | Bool
                  | doc m%"
                  Whether to create [Unicode installer](http://nsis.sourceforge.net/Docs/Chapter1.html#intro-unicode).
                  "%
                  | optional,
                uninstallDisplayName
                  | String
                  | doc m%"
                  The uninstaller display name in the control panel.
                  "%
                  | optional,
                uninstallerIcon
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The path to uninstaller icon, relative to the [build resources](/configuration/configuration#MetadataDirectories-buildResources) or to the project directory.
                  Defaults to `build/uninstallerIcon.ico` or application icon.
                  "%
                  | optional,
                uninstallerSidebar
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  *assisted installer only.* `MUI_UNWELCOMEFINISHPAGE_BITMAP`, relative to the [build resources](/configuration/configuration#MetadataDirectories-buildResources) or to the project directory.
                  Defaults to `installerSidebar` option or `build/uninstallerSidebar.bmp` or `build/installerSidebar.bmp` or `${NSISDIR}\\Contrib\\Graphics\\Wizard\\nsis3-metro.bmp`
                  "%
                  | optional,
                useZip | Bool | optional,
                warningsAsErrors
                  | Bool
                  | doc m%"
                  If `warningsAsErrors` is `true` (default): NSIS will treat warnings as errors. If `warningsAsErrors` is `false`: NSIS will allow warnings.
                  "%
                  | optional,
              },
          PkgBackgroundOptions
            | doc m%"
            Options for the background image in a PKG installer
            "%
            = {
                alignment
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.enum
                      [
                        "bottom",
                        "bottomleft",
                        "bottomright",
                        "center",
                        "left",
                        "right",
                        "top",
                        "topleft",
                        "topright"
                      ]
                    ],
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  Alignment of the background image.
                  Options are: center, left, right, top, bottom, topleft, topright, bottomleft, bottomright
                  "%
                  | optional,
                file
                  | String
                  | doc m%"
                  Path to the image to use as an installer background.
                  "%
                  | optional,
                scaling
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.enum [ "none", "proportional", "tofit" ]
                    ],
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  Scaling of the background image.
                  Options are: tofit, none, proportional
                  "%
                  | optional,
              },
          PkgOptions
            | doc m%"
            macOS product archive options.
            "%
            = {
                allowAnywhere
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"Bool" ])
                  | doc m%"
                  Whether can be installed at the root of any volume, including non-system volumes. Otherwise, it cannot be installed at the root of a volume.
                  
                  Corresponds to [enable_anywhere](https://developer.apple.com/library/content/documentation/DeveloperTools/Reference/DistributionDefinitionRef/Chapters/Distribution_XML_Ref.html#//apple_ref/doc/uid/TP40005370-CH100-SW70).
                  "%
                  | optional,
                allowCurrentUserHome
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"Bool" ])
                  | doc m%"
                  Whether can be installed into the current user's home directory.
                  A home directory installation is done as the current user (not as root), and it cannot write outside of the home directory.
                  If the product cannot be installed in the user's home directory and be not completely functional from user's home directory.
                  
                  Corresponds to [enable_currentUserHome](https://developer.apple.com/library/content/documentation/DeveloperTools/Reference/DistributionDefinitionRef/Chapters/Distribution_XML_Ref.html#//apple_ref/doc/uid/TP40005370-CH100-SW70).
                  "%
                  | optional,
                allowRootDirectory
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"Bool" ])
                  | doc m%"
                  Whether can be installed into the root directory. Should usually be `true` unless the product can be installed only to the user's home directory.
                  
                  Corresponds to [enable_localSystem](https://developer.apple.com/library/content/documentation/DeveloperTools/Reference/DistributionDefinitionRef/Chapters/Distribution_XML_Ref.html#//apple_ref/doc/uid/TP40005370-CH100-SW70).
                  "%
                  | optional,
                artifactName
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The [artifact file name template](/configuration/configuration#artifact-file-name-template).
                  "%
                  | optional,
                background
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.PkgBackgroundOptions,
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  Options for the background image for the installer.
                  "%
                  | optional,
                conclusion
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The path to the conclusion file. This may be used to customize the text on the final "Summary" page of the installer.
                  "%
                  | optional,
                hasStrictIdentifier
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"Bool" ])
                  | doc m%"
                  Require identical bundle identifiers at install path?
                  "%
                  | optional,
                identity
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The name of certificate to use when signing. Consider using environment variables [CSC_LINK or CSC_NAME](/code-signing) instead of specifying this option.
                  "%
                  | optional,
                installLocation
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The install location. [Do not use it](https://stackoverflow.com/questions/12863944/how-do-you-specify-a-default-install-location-to-home-with-pkgbuild) to create per-user package.
                  Mostly never you will need to change this option. `/Applications` would install it as expected into `/Applications` if the local system domain is chosen, or into `$HOME/Applications` if the home installation is chosen.
                  "%
                  | optional,
                isRelocatable
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"Bool" ])
                  | doc m%"
                  Install bundle over previous version if moved by user?
                  "%
                  | optional,
                isVersionChecked
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"Bool" ])
                  | doc m%"
                  Don't install bundle if newer version on disk?
                  "%
                  | optional,
                license
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The path to EULA license file. Defaults to `license.txt` or `eula.txt` (or uppercase variants). In addition to `txt, `rtf` and `html` supported (don't forget to use `target="_blank"` for links).
                  "%
                  | optional,
                overwriteAction
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.enum [ "update", "upgrade" ]
                    ],
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  Specifies how an existing version of the bundle on disk should be handled when the version in
                  the package is installed.
                  
                  If you specify upgrade, the bundle in the package atomi-cally replaces any version on disk;
                  this has the effect of deleting old paths that no longer exist in the new version of
                  the bundle.
                  
                  If you specify update, the bundle in the package overwrites the version on disk, and any files
                  not contained in the package will be left intact; this is appropriate when you are delivering
                  an update-only package.
                  
                  Another effect of update is that the package bundle will not be installed at all if there is
                  not already a version on disk; this allows a package to deliver an update for an app that
                  the user might have deleted.
                  "%
                  | optional,
                productbuild
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ],
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  should be not documented, only to experiment
                  "%
                  | optional,
                publish
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.GithubOptions,
                    definitions.predicate.S3Options,
                    definitions.predicate.SpacesOptions,
                    definitions.predicate.GenericServerOptions,
                    definitions.predicate.BintrayOptions,
                    definitions.predicate.CustomPublishOptions,
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.anyOf
                      [
                        definitions.predicate.GithubOptions,
                        definitions.predicate.S3Options,
                        definitions.predicate.SpacesOptions,
                        definitions.predicate.GenericServerOptions,
                        definitions.predicate.BintrayOptions,
                        definitions.predicate.CustomPublishOptions,
                        predicates.isType '"String"
                      ])
                    ],
                    predicates.anyOf
                    [ predicates.isType 'Null, predicates.isType '"String" ]
                  ])
                  | optional,
                scripts
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The scripts directory, relative to `build` (build resources directory).
                  The scripts can be in any language so long as the files are marked executable and have the appropriate shebang indicating the path to the interpreter.
                  Scripts are required to be executable (`chmod +x file`).
                  "%
                  | optional,
                welcome
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The path to the welcome file. This may be used to customize the text on the Introduction page of the installer.
                  "%
                  | optional,
              },
          PlugDescriptor = predicates.contract_from_predicate
              definitions.predicate.PlugDescriptor,
          PortableOptions
            | doc m%"
            Portable options.
            "%
            = {
                artifactName
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The [artifact file name template](/configuration/configuration#artifact-file-name-template).
                  "%
                  | optional,
                guid
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  See [GUID vs Application Name](../configuration/nsis#guid-vs-application-name).
                  "%
                  | optional,
                publish
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.GithubOptions,
                    definitions.predicate.S3Options,
                    definitions.predicate.SpacesOptions,
                    definitions.predicate.GenericServerOptions,
                    definitions.predicate.BintrayOptions,
                    definitions.predicate.CustomPublishOptions,
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.anyOf
                      [
                        definitions.predicate.GithubOptions,
                        definitions.predicate.S3Options,
                        definitions.predicate.SpacesOptions,
                        definitions.predicate.GenericServerOptions,
                        definitions.predicate.BintrayOptions,
                        definitions.predicate.CustomPublishOptions,
                        predicates.isType '"String"
                      ])
                    ],
                    predicates.anyOf
                    [ predicates.isType 'Null, predicates.isType '"String" ]
                  ])
                  | optional,
                requestExecutionLevel
                  | std.enum.TagOrString
                  | [| 'user, 'highest, 'admin |]
                  | doc m%"
                  The [requested execution level](http://nsis.sourceforge.net/Reference/RequestExecutionLevel) for Windows.
                  "%
                  | optional,
                unicode
                  | Bool
                  | doc m%"
                  Whether to create [Unicode installer](http://nsis.sourceforge.net/Docs/Chapter1.html#intro-unicode).
                  "%
                  | optional,
                unpackDirName
                  | String
                  | doc m%"
                  The unpack directory name in [TEMP](https://www.askvg.com/where-does-windows-store-temporary-files-and-how-to-change-temp-folder-location/) directory.
                  
                  Defaults to [uuid](https://github.com/segmentio/ksuid) of build (changed on each build of portable executable).
                  "%
                  | optional,
                useZip | Bool | optional,
                warningsAsErrors
                  | Bool
                  | doc m%"
                  If `warningsAsErrors` is `true` (default): NSIS will treat warnings as errors. If `warningsAsErrors` is `false`: NSIS will allow warnings.
                  "%
                  | optional,
              },
          Protocol
            | doc m%"
            URL Protocol Schemes. Protocols to associate the app with. macOS only.
            
            Please note — on macOS [you need to register an `open-url` event handler](http://electron.atom.io/docs/api/app/#event-open-url-macos).
            "%
            = {
                name
                  | String
                  | doc m%"
                  The name. e.g. `IRC server URL`.
                  "%,
                role
                  | std.enum.TagOrString
                  | [| 'Viewer, 'Shell, 'None, 'Editor |]
                  | doc m%"
                  *macOS-only* The app's role with respect to the type.
                  "%
                  | optional,
                schemes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  The schemes. e.g. `["irc", "ircs"]`.
                  "%,
              },
          PublishProvider = std.contract.Sequence
              [
                std.enum.TagOrString,
                [| 'spaces, 's3, 'github, 'generic, 'custom, 'bintray |]
              ],
          ReleaseInfo = {
                releaseDate
                  | String
                  | doc m%"
                  The release date.
                  "%
                  | optional,
                releaseName
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The release name.
                  "%
                  | optional,
                releaseNotes
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The release notes.
                  "%
                  | optional,
                releaseNotesFile
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The path to release notes file. Defaults to `release-notes-${platform}.md` (where `platform` it is current platform — `mac`, `linux` or `windows`) or `release-notes.md` in the [build resources](#MetadataDirectories-buildResources).
                  "%
                  | optional,
              },
          S3Options = {
                acl
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.enum [ "private", "public-read" ]
                    ],
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  The ACL. Set to `null` to not [add](https://github.com/electron-userland/electron-builder/issues/1822).
                  
                  Please see [required permissions for the S3 provider](https://github.com/electron-userland/electron-builder/issues/1618#issuecomment-314679128).
                  "%
                  | optional,
                bucket
                  | String
                  | doc m%"
                  The bucket name.
                  "%,
                channel
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The update channel.
                  "%
                  | optional,
                encryption
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.enum [ "AES256", "aws:kms" ]
                    ],
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  Server-side encryption algorithm to use for the object.
                  "%
                  | optional,
                endpoint
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The endpoint URI to send requests to. The default endpoint is built from the configured region.
                  The endpoint should be a string like `https://{service}.{region}.amazonaws.com`.
                  "%
                  | optional,
                path
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The directory path.
                  "%
                  | optional,
                provider
                  | std.enum.TagOrString
                  | [| 's3 |]
                  | doc m%"
                  The provider. Must be `s3`.
                  "%,
                publishAutoUpdate
                  | Bool
                  | doc m%"
                  Whether to publish auto update info files.
                  
                  Auto update relies only on the first provider in the list (you can specify several publishers).
                  Thus, probably, there`s no need to upload the metadata files for the other configured providers. But by default will be uploaded.
                  "%
                  | optional,
                publisherName
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ],
                    predicates.isType 'Null
                  ])
                  | optional,
                region
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The region. Is determined and set automatically when publishing.
                  "%
                  | optional,
                storageClass
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.enum
                      [ "REDUCED_REDUNDANCY", "STANDARD", "STANDARD_IA" ]
                    ],
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  The type of storage to use for the object.
                  "%
                  | optional,
                updaterCacheDirName
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | optional,
              },
          SnapOptions = {
                after
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ],
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  Specifies any [parts](https://snapcraft.io/docs/reference/parts) that should be built before this part.
                  Defaults to `["desktop-gtk2""]`.
                  
                  If list contains `default`, it will be replaced to default list, so, `["default", "foo"]` can be used to add custom parts `foo` in addition to defaults.
                  "%
                  | optional,
                artifactName
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The [artifact file name template](/configuration/configuration#artifact-file-name-template).
                  "%
                  | optional,
                assumes
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ],
                    predicates.anyOf
                    [ predicates.isType 'Null, predicates.isType '"String" ]
                  ])
                  | doc m%"
                  The list of features that must be supported by the core in order for this snap to install.
                  "%
                  | optional,
                buildPackages
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ],
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  The list of debian packages needs to be installed for building this snap.
                  "%
                  | optional,
                category
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The [application category](https://specifications.freedesktop.org/menu-spec/latest/apa.html#main-category-registry).
                  "%
                  | optional,
                confinement
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.enum [ "classic", "devmode", "strict" ]
                    ],
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  The type of [confinement](https://snapcraft.io/docs/reference/confinement) supported by the snap.
                  "%
                  | optional,
                description
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  As [description](/configuration/configuration#Metadata-description) from application package.json, but allows you to specify different for Linux.
                  "%
                  | optional,
                desktop
                  | predicates.contract_from_predicate predicates.always
                  | doc m%"
                  The [Desktop file](https://developer.gnome.org/integration-guide/stable/desktop-files.html.en) entries (name to value).
                  "%
                  | optional,
                environment
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.always, predicates.isType 'Null ])
                  | doc m%"
                  The custom environment. Defaults to `{"TMPDIR: "$XDG_RUNTIME_DIR"}`. If you set custom, it will be merged with default.
                  "%
                  | optional,
                grade
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.enum [ "devel", "stable" ]
                    ],
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  The quality grade of the snap. It can be either `devel` (i.e. a development version of the snap, so not to be published to the "stable" or "candidate" channels) or "stable" (i.e. a stable release or release candidate, which can be released to all channels).
                  "%
                  | optional,
                hooks
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The [hooks](https://docs.snapcraft.io/build-snaps/hooks) directory, relative to `build` (build resources directory).
                  "%
                  | optional,
                mimeTypes
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ],
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  The mime types in addition to specified in the file associations. Use it if you don't want to register a new mime type, but reuse existing.
                  "%
                  | optional,
                plugs
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.PlugDescriptor,
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.anyOf
                      [
                        definitions.predicate.PlugDescriptor,
                        predicates.isType '"String"
                      ])
                    ],
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  The list of [plugs](https://snapcraft.io/docs/reference/interfaces).
                  Defaults to `["desktop", "desktop-legacy", "home", "x11", "unity7", "browser-support", "network", "gsettings", "pulseaudio", "opengl"]`.
                  
                  If list contains `default`, it will be replaced to default list, so, `["default", "foo"]` can be used to add custom plug `foo` in addition to defaults.
                  
                  Additional attributes can be specified using object instead of just name of plug:
                  ```
                  [
                    {
                      "browser-sandbox": {
                        "interface": "browser-support",
                        "allow-sandbox": true
                      },
                    },
                    "another-simple-plug-name"
                  ]
                  ```
                  "%
                  | optional,
                publish
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.GithubOptions,
                    definitions.predicate.S3Options,
                    definitions.predicate.SpacesOptions,
                    definitions.predicate.GenericServerOptions,
                    definitions.predicate.BintrayOptions,
                    definitions.predicate.CustomPublishOptions,
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.anyOf
                      [
                        definitions.predicate.GithubOptions,
                        definitions.predicate.S3Options,
                        definitions.predicate.SpacesOptions,
                        definitions.predicate.GenericServerOptions,
                        definitions.predicate.BintrayOptions,
                        definitions.predicate.CustomPublishOptions,
                        predicates.isType '"String"
                      ])
                    ],
                    predicates.anyOf
                    [ predicates.isType 'Null, predicates.isType '"String" ]
                  ])
                  | optional,
                stagePackages
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ],
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  The list of Ubuntu packages to use that are needed to support the `app` part creation. Like `depends` for `deb`.
                  Defaults to `["libasound2", "libgconf2-4", "libnotify4", "libnspr4", "libnss3", "libpcre3", "libpulse0", "libxss1", "libxtst6"]`.
                  
                  If list contains `default`, it will be replaced to default list, so, `["default", "foo"]` can be used to add custom package `foo` in addition to defaults.
                  "%
                  | optional,
                summary
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The 78 character long summary. Defaults to [productName](/configuration/configuration#Configuration-productName).
                  "%
                  | optional,
                synopsis
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The [short description](https://www.debian.org/doc/debian-policy/ch-controlfields.html#s-f-Description).
                  "%
                  | optional,
                useTemplateApp
                  | Bool
                  | doc m%"
                  Whether to use template snap. Defaults to `true` if `stagePackages` not specified.
                  "%
                  | optional,
              },
          SpacesOptions
            | doc m%"
            [DigitalOcean Spaces](https://www.digitalocean.com/community/tutorials/an-introduction-to-digitalocean-spaces) options.
            Access key is required, define `DO_KEY_ID` and `DO_SECRET_KEY` environment variables.
            "%
            = {
                acl
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.enum [ "private", "public-read" ]
                    ],
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  The ACL. Set to `null` to not [add](https://github.com/electron-userland/electron-builder/issues/1822).
                  "%
                  | optional,
                channel
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The update channel.
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  The space name.
                  "%,
                path
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The directory path.
                  "%
                  | optional,
                provider
                  | std.enum.TagOrString
                  | [| 'spaces |]
                  | doc m%"
                  The provider. Must be `spaces`.
                  "%,
                publishAutoUpdate
                  | Bool
                  | doc m%"
                  Whether to publish auto update info files.
                  
                  Auto update relies only on the first provider in the list (you can specify several publishers).
                  Thus, probably, there`s no need to upload the metadata files for the other configured providers. But by default will be uploaded.
                  "%
                  | optional,
                publisherName
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ],
                    predicates.isType 'Null
                  ])
                  | optional,
                region
                  | String
                  | doc m%"
                  The region (e.g. `nyc3`).
                  "%,
                updaterCacheDirName
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | optional,
              },
          SquirrelWindowsOptions = {
                artifactName
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The [artifact file name template](/configuration/configuration#artifact-file-name-template).
                  "%
                  | optional,
                iconUrl
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  A URL to an ICO file to use as the application icon (displayed in Control Panel > Programs and Features). Defaults to the Electron icon.
                  
                  Please note — [local icon file url is not accepted](https://github.com/atom/grunt-electron-installer/issues/73), must be https/http.
                  
                  If you don't plan to build windows installer, you can omit it.
                  If your project repository is public on GitHub, it will be `https://github.com/${u}/${p}/blob/master/build/icon.ico?raw=true` by default.
                  "%
                  | optional,
                loadingGif
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The path to a .gif file to display during install. `build/install-spinner.gif` will be used if exists (it is a recommended way to set)
                  (otherwise [default](https://github.com/electron/windows-installer/blob/master/resources/install-spinner.gif)).
                  "%
                  | optional,
                msi
                  | Bool
                  | doc m%"
                  Whether to create an MSI installer. Defaults to `false` (MSI is not created).
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  https://github.com/electron-userland/electron-builder/issues/1743
                  "%
                  | optional,
                publish
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.GithubOptions,
                    definitions.predicate.S3Options,
                    definitions.predicate.SpacesOptions,
                    definitions.predicate.GenericServerOptions,
                    definitions.predicate.BintrayOptions,
                    definitions.predicate.CustomPublishOptions,
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.anyOf
                      [
                        definitions.predicate.GithubOptions,
                        definitions.predicate.S3Options,
                        definitions.predicate.SpacesOptions,
                        definitions.predicate.GenericServerOptions,
                        definitions.predicate.BintrayOptions,
                        definitions.predicate.CustomPublishOptions,
                        predicates.isType '"String"
                      ])
                    ],
                    predicates.anyOf
                    [ predicates.isType 'Null, predicates.isType '"String" ]
                  ])
                  | optional,
                remoteReleases
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType 'Null,
                    predicates.isType '"String",
                    predicates.isType '"Bool"
                  ])
                  | doc m%"
                  A URL to your existing updates. Or `true` to automatically set to your GitHub repository. If given, these will be downloaded to create delta updates.
                  "%
                  | optional,
                remoteToken
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  Authentication token for remote updates
                  "%
                  | optional,
                useAppIdAsId
                  | Bool
                  | doc m%"
                  Use `appId` to identify package instead of `name`.
                  "%
                  | optional,
              },
          TargetConfiguration = {
                arch
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "arm64", "armv7l", "ia32", "x64" ]
                      ])
                    ],
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.enum [ "arm64", "armv7l", "ia32", "x64" ]
                    ]
                  ])
                  | doc m%"
                  The arch or list of archs.
                  "%
                  | optional,
                target
                  | String
                  | doc m%"
                  The target name. e.g. `snap`.
                  "%,
              },
          WindowsConfiguration = {
                additionalCertificateFile
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The path to an additional certificate file you want to add to the signature block.
                  "%
                  | optional,
                appId
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The application id. Used as [CFBundleIdentifier](https://developer.apple.com/library/ios/documentation/General/Reference/InfoPlistKeyReference/Articles/CoreFoundationKeys.html#//apple_ref/doc/uid/20001431-102070) for MacOS and as
                  [Application User Model ID](https://msdn.microsoft.com/en-us/library/windows/desktop/dd378459(v=vs.85).aspx) for Windows (NSIS target only, Squirrel.Windows not supported). It is strongly recommended that an explicit ID is set.
                  "%
                  | optional,
                artifactName
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The [artifact file name template](/configuration/configuration#artifact-file-name-template). Defaults to `${productName}-${version}.${ext}` (some target can have other defaults, see corresponding options).
                  "%
                  | optional,
                asar
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.AsarOptions,
                    predicates.anyOf
                    [ predicates.isType 'Null, predicates.isType '"Bool" ]
                  ])
                  | doc m%"
                  Whether to package the application's source code into an archive, using [Electron's archive format](http://electron.atom.io/docs/tutorial/application-packaging/).
                  
                  Node modules, that must be unpacked, will be detected automatically, you don't need to explicitly set [asarUnpack](#configuration-asarUnpack) - please file an issue if this doesn't work.
                  "%
                  | optional,
                asarUnpack
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ],
                    predicates.anyOf
                    [ predicates.isType 'Null, predicates.isType '"String" ]
                  ])
                  | doc m%"
                  A [glob patterns](/file-patterns) relative to the [app directory](#MetadataDirectories-app), which specifies which files to unpack when creating the [asar](http://electron.atom.io/docs/tutorial/application-packaging/) archive.
                  "%
                  | optional,
                certificateFile
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The path to the *.pfx certificate you want to sign with. Please use it only if you cannot use env variable `CSC_LINK` (`WIN_CSC_LINK`) for some reason.
                  Please see [Code Signing](/code-signing).
                  "%
                  | optional,
                certificatePassword
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The password to the certificate provided in `certificateFile`. Please use it only if you cannot use env variable `CSC_KEY_PASSWORD` (`WIN_CSC_KEY_PASSWORD`) for some reason.
                  Please see [Code Signing](/code-signing).
                  "%
                  | optional,
                certificateSha1
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The SHA1 hash of the signing certificate. The SHA1 hash is commonly specified when multiple certificates satisfy the criteria specified by the remaining switches. Works only on Windows (or on macOS if [Parallels Desktop](https://www.parallels.com/products/desktop/) Windows 10 virtual machines exits).
                  "%
                  | optional,
                certificateSubjectName
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The name of the subject of the signing certificate. Required only for EV Code Signing and works only on Windows (or on macOS if [Parallels Desktop](https://www.parallels.com/products/desktop/) Windows 10 virtual machines exits).
                  "%
                  | optional,
                compression
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.enum [ "maximum", "normal", "store" ]
                    ],
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  The compression level. If you want to rapidly test build, `store` can reduce build time significantly. `maximum` doesn't lead to noticeable size difference, but increase build time.
                  "%
                  | optional,
                cscKeyPassword
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | optional,
                cscLink
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | optional,
                detectUpdateChannel
                  | Bool
                  | doc m%"
                  Whether to infer update channel from application version pre-release components. e.g. if version `0.12.1-alpha.1`, channel will be set to `alpha`. Otherwise to `latest`.
                  "%
                  | optional,
                electronUpdaterCompatibility
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The [electron-updater compatibility](/auto-update#compatibility) semver range.
                  "%
                  | optional,
                extraFiles
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.FileSet,
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.anyOf
                      [
                        definitions.predicate.FileSet,
                        predicates.isType '"String"
                      ])
                    ],
                    predicates.anyOf
                    [ predicates.isType 'Null, predicates.isType '"String" ]
                  ])
                  | optional,
                extraResources
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.FileSet,
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.anyOf
                      [
                        definitions.predicate.FileSet,
                        predicates.isType '"String"
                      ])
                    ],
                    predicates.anyOf
                    [ predicates.isType 'Null, predicates.isType '"String" ]
                  ])
                  | optional,
                fileAssociations
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.FileAssociation,
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      definitions.predicate.FileAssociation
                    ]
                  ])
                  | doc m%"
                  The file associations.
                  "%
                  | optional,
                files
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.FileSet,
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.anyOf
                      [
                        definitions.predicate.FileSet,
                        predicates.isType '"String"
                      ])
                    ],
                    predicates.anyOf
                    [ predicates.isType 'Null, predicates.isType '"String" ]
                  ])
                  | optional,
                forceCodeSigning
                  | Bool
                  | doc m%"
                  Whether to fail if app will be not code signed.
                  "%
                  | optional,
                generateUpdatesFilesForAllChannels
                  | Bool
                  | doc m%"
                  Please see [Building and Releasing using Channels](https://github.com/electron-userland/electron-builder/issues/1182#issuecomment-324947139).
                  "%
                  | optional,
                icon
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The path to application icon.
                  "%
                  | optional,
                legalTrademarks
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The trademarks and registered trademarks.
                  "%
                  | optional,
                protocols
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.Protocol,
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf definitions.predicate.Protocol
                    ]
                  ])
                  | doc m%"
                  The URL protocol schemes.
                  "%
                  | optional,
                publish
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.GithubOptions,
                    definitions.predicate.S3Options,
                    definitions.predicate.SpacesOptions,
                    definitions.predicate.GenericServerOptions,
                    definitions.predicate.BintrayOptions,
                    definitions.predicate.CustomPublishOptions,
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.anyOf
                      [
                        definitions.predicate.GithubOptions,
                        definitions.predicate.S3Options,
                        definitions.predicate.SpacesOptions,
                        definitions.predicate.GenericServerOptions,
                        definitions.predicate.BintrayOptions,
                        definitions.predicate.CustomPublishOptions,
                        predicates.isType '"String"
                      ])
                    ],
                    predicates.anyOf
                    [ predicates.isType 'Null, predicates.isType '"String" ]
                  ])
                  | optional,
                publisherName
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ],
                    predicates.anyOf
                    [ predicates.isType 'Null, predicates.isType '"String" ]
                  ])
                  | doc m%"
                  [The publisher name](https://github.com/electron-userland/electron-builder/issues/1187#issuecomment-278972073), exactly as in your code signed certificate. Several names can be provided.
                  Defaults to common name from your code signing certificate.
                  "%
                  | optional,
                releaseInfo
                  | definitions.contract.ReleaseInfo
                  | doc m%"
                  The release info. Intended for command line usage:
                  
                  ```
                  -c.releaseInfo.releaseNotes="new features"
                  ```
                  "%
                  | optional,
                requestedExecutionLevel
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.enum
                      [
                        "asInvoker",
                        "highestAvailable",
                        "requireAdministrator"
                      ]
                    ],
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  The [security level](https://msdn.microsoft.com/en-us/library/6ad1fshk.aspx#Anchor_9) at which the application requests to be executed.
                  Cannot be specified per target, allowed only in the `win`.
                  "%
                  | optional,
                rfc3161TimeStampServer
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The URL of the RFC 3161 time stamp server.
                  "%
                  | optional,
                sign
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.always,
                    predicates.anyOf
                    [ predicates.isType 'Null, predicates.isType '"String" ]
                  ])
                  | doc m%"
                  The custom function (or path to file or module id) to sign Windows executable.
                  "%
                  | optional,
                signAndEditExecutable
                  | Bool
                  | doc m%"
                  Whether to sign and add metadata to executable. Advanced option.
                  "%
                  | optional,
                signDlls
                  | Bool
                  | doc m%"
                  Whether to sign DLL files. Advanced option.
                  "%
                  | optional,
                signingHashAlgorithms
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "sha1", "sha256" ]
                      ])
                    ],
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  Array of signing algorithms used. For AppX `sha256` is always used.
                  "%
                  | optional,
                target
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.TargetConfiguration,
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.anyOf
                      [
                        definitions.predicate.TargetConfiguration,
                        predicates.isType '"String"
                      ])
                    ],
                    predicates.anyOf
                    [ predicates.isType 'Null, predicates.isType '"String" ]
                  ])
                  | doc m%"
                  The target package type: list of `nsis`, `nsis-web` (Web installer), `portable` ([portable](/configuration/nsis#portable) app without installation), `appx`, `msi`, `squirrel`, `7z`, `zip`, `tar.xz`, `tar.lz`, `tar.gz`, `tar.bz2`, `dir`.
                  AppX package can be built only on Windows 10.
                  
                  To use Squirrel.Windows please install `electron-builder-squirrel-windows` dependency.
                  "%
                  | optional,
                timeStampServer
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType 'Null, predicates.isType '"String" ])
                  | doc m%"
                  The URL of the time stamp server.
                  "%
                  | optional,
                verifyUpdateCodeSignature
                  | Bool
                  | doc m%"
                  Whether to verify the signature of an available update before installation.
                  The [publisher name](#publisherName) will be used for the signature verification.
                  "%
                  | optional,
              },
        },
    predicate = {
          AppImageOptions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  artifactName = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  category = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  description = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  desktop = predicates.always,
                  license = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  mimeTypes = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                        predicates.isType 'Null
                      ],
                  publish = predicates.anyOf
                      [
                        definitions.predicate.GithubOptions,
                        definitions.predicate.S3Options,
                        definitions.predicate.SpacesOptions,
                        definitions.predicate.GenericServerOptions,
                        definitions.predicate.BintrayOptions,
                        definitions.predicate.CustomPublishOptions,
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.anyOf
                          [
                            definitions.predicate.GithubOptions,
                            definitions.predicate.S3Options,
                            definitions.predicate.SpacesOptions,
                            definitions.predicate.GenericServerOptions,
                            definitions.predicate.BintrayOptions,
                            definitions.predicate.CustomPublishOptions,
                            predicates.isType '"String"
                          ])
                        ],
                        predicates.anyOf
                        [ predicates.isType 'Null, predicates.isType '"String" ]
                      ],
                  synopsis = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  systemIntegration = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "ask", "doNotAsk" ]
                      ],
                }
                {  }
                false
                predicates.never
              ],
          AppXOptions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  addAutoLaunchExtension = predicates.isType '"Bool",
                  applicationId = predicates.isType '"String",
                  artifactName = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  backgroundColor = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  displayName = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  electronUpdaterAware = predicates.isType '"Bool",
                  identityName = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  languages = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                        predicates.anyOf
                        [ predicates.isType 'Null, predicates.isType '"String" ]
                      ],
                  makeappxArgs = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                        predicates.isType 'Null
                      ],
                  publish = predicates.anyOf
                      [
                        definitions.predicate.GithubOptions,
                        definitions.predicate.S3Options,
                        definitions.predicate.SpacesOptions,
                        definitions.predicate.GenericServerOptions,
                        definitions.predicate.BintrayOptions,
                        definitions.predicate.CustomPublishOptions,
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.anyOf
                          [
                            definitions.predicate.GithubOptions,
                            definitions.predicate.S3Options,
                            definitions.predicate.SpacesOptions,
                            definitions.predicate.GenericServerOptions,
                            definitions.predicate.BintrayOptions,
                            definitions.predicate.CustomPublishOptions,
                            predicates.isType '"String"
                          ])
                        ],
                        predicates.anyOf
                        [ predicates.isType 'Null, predicates.isType '"String" ]
                      ],
                  publisher = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  publisherDisplayName = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  setBuildNumber = predicates.isType '"Bool",
                  showNameOnTiles = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          AsarOptions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  externalAllowed = predicates.isType '"Bool",
                  ordering = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  smartUnpack = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          BintrayOptions
            | doc m%"
            [Bintray](https://bintray.com/) options. Requires an API key. An API key can be obtained from the user [profile](https://bintray.com/profile/edit) page ("Edit Your Profile" -> API Key).
            Define `BT_TOKEN` environment variable.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "provider" ],
                predicates.records.record
                {
                  component = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  distribution = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  owner = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  package = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  provider = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "bintray" ]
                      ],
                  publishAutoUpdate = predicates.isType '"Bool",
                  publisherName = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                        predicates.isType 'Null
                      ],
                  repo = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  token = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  updaterCacheDirName = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  user = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                }
                {  }
                false
                predicates.never
              ],
          CustomPublishOptions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "provider" ],
                predicates.records.record
                {
                  provider = definitions.predicate.PublishProvider,
                  publishAutoUpdate = predicates.isType '"Bool",
                  publisherName = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                        predicates.isType 'Null
                      ],
                  updaterCacheDirName = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                }
                {  }
                true
                predicates.always
              ],
          DebOptions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  afterInstall = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  afterRemove = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  artifactName = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  category = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  compression = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "bzip2", "gz", "xz" ]
                        ],
                        predicates.isType 'Null
                      ],
                  depends = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                        predicates.isType 'Null
                      ],
                  description = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  desktop = predicates.always,
                  fpm = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                        predicates.isType 'Null
                      ],
                  icon = predicates.isType '"String",
                  maintainer = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  mimeTypes = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                        predicates.isType 'Null
                      ],
                  packageCategory = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  "priority" = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  publish = predicates.anyOf
                      [
                        definitions.predicate.GithubOptions,
                        definitions.predicate.S3Options,
                        definitions.predicate.SpacesOptions,
                        definitions.predicate.GenericServerOptions,
                        definitions.predicate.BintrayOptions,
                        definitions.predicate.CustomPublishOptions,
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.anyOf
                          [
                            definitions.predicate.GithubOptions,
                            definitions.predicate.S3Options,
                            definitions.predicate.SpacesOptions,
                            definitions.predicate.GenericServerOptions,
                            definitions.predicate.BintrayOptions,
                            definitions.predicate.CustomPublishOptions,
                            predicates.isType '"String"
                          ])
                        ],
                        predicates.anyOf
                        [ predicates.isType 'Null, predicates.isType '"String" ]
                      ],
                  synopsis = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  vendor = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                }
                {  }
                false
                predicates.never
              ],
          DmgContent = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "x", "y" ],
                predicates.records.record
                {
                  name = predicates.isType '"String",
                  path = predicates.isType '"String",
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "dir", "file", "link" ]
                      ],
                  x = predicates.isType '"Number",
                  y = predicates.isType '"Number",
                }
                {  }
                false
                predicates.never
              ],
          DmgOptions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  artifactName = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  background = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  backgroundColor = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  contents = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.DmgContent
                      ],
                  format = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [ "UDBZ", "UDCO", "UDRO", "UDRW", "UDZO", "ULFO" ]
                      ],
                  icon = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  iconSize = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"Number" ],
                  iconTextSize = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"Number" ],
                  internetEnabled = predicates.isType '"Bool",
                  publish = predicates.anyOf
                      [
                        definitions.predicate.GithubOptions,
                        definitions.predicate.S3Options,
                        definitions.predicate.SpacesOptions,
                        definitions.predicate.GenericServerOptions,
                        definitions.predicate.BintrayOptions,
                        definitions.predicate.CustomPublishOptions,
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.anyOf
                          [
                            definitions.predicate.GithubOptions,
                            definitions.predicate.S3Options,
                            definitions.predicate.SpacesOptions,
                            definitions.predicate.GenericServerOptions,
                            definitions.predicate.BintrayOptions,
                            definitions.predicate.CustomPublishOptions,
                            predicates.isType '"String"
                          ])
                        ],
                        predicates.anyOf
                        [ predicates.isType 'Null, predicates.isType '"String" ]
                      ],
                  title = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  window = definitions.predicate.DmgWindow,
                }
                {  }
                false
                predicates.never
              ],
          DmgWindow = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  height = predicates.isType '"Number",
                  width = predicates.isType '"Number",
                  x = predicates.isType '"Number",
                  y = predicates.isType '"Number",
                }
                {  }
                false
                predicates.never
              ],
          ElectronDownloadOptions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  arch = predicates.isType '"String",
                  cache = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  customDir = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  customFilename = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  isVerifyChecksum = predicates.isType '"Bool",
                  mirror = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  platform = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "darwin", "linux", "mas", "win32" ]
                      ],
                  strictSSL = predicates.isType '"Bool",
                  version = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          FileAssociation
            | doc m%"
            File associations.
            
            macOS (corresponds to [CFBundleDocumentTypes](https://developer.apple.com/library/content/documentation/General/Reference/InfoPlistKeyReference/Articles/CoreFoundationKeys.html#//apple_ref/doc/uid/20001431-101685)) and NSIS only.
            
            On Windows works only if [nsis.perMachine](https://electron.build/configuration/configuration#NsisOptions-perMachine) is set to `true`.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "ext" ],
                predicates.records.record
                {
                  description = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  ext = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                        predicates.isType '"String"
                      ],
                  icon = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  isPackage = predicates.isType '"Bool",
                  mimeType = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  name = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  role = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          FileSet = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  filter = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                        predicates.isType '"String"
                      ],
                  from = predicates.isType '"String",
                  to = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          GenericServerOptions
            | doc m%"
            Generic (any HTTP(S) server) options.
            In all publish options [File Macros](/file-patterns#file-macros) are supported.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "provider", "url" ],
                predicates.records.record
                {
                  channel = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  provider = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "generic" ]
                      ],
                  publishAutoUpdate = predicates.isType '"Bool",
                  publisherName = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                        predicates.isType 'Null
                      ],
                  updaterCacheDirName = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  url = predicates.isType '"String",
                  useMultipleRangeRequest = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          GithubOptions
            | doc m%"
            [GitHub](https://help.github.com/articles/about-releases/) options.
            
            GitHub [personal access token](https://help.github.com/articles/creating-an-access-token-for-command-line-use/) is required. You can generate by going to [https://github.com/settings/tokens/new](https://github.com/settings/tokens/new). The access token should have the repo scope/permission.
            Define `GH_TOKEN` environment variable.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "provider" ],
                predicates.records.record
                {
                  host = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  owner = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  private = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"Bool" ],
                  protocol = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "http", "https" ]
                        ],
                        predicates.isType 'Null
                      ],
                  provider = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "github" ]
                      ],
                  publishAutoUpdate = predicates.isType '"Bool",
                  publisherName = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                        predicates.isType 'Null
                      ],
                  releaseType = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "draft", "prerelease", "release" ]
                        ],
                        predicates.isType 'Null
                      ],
                  repo = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  token = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  updaterCacheDirName = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  vPrefixedTagName = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          LinuxConfiguration = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  appId = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  artifactName = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  asar = predicates.anyOf
                      [
                        definitions.predicate.AsarOptions,
                        predicates.anyOf
                        [ predicates.isType 'Null, predicates.isType '"Bool" ]
                      ],
                  asarUnpack = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                        predicates.anyOf
                        [ predicates.isType 'Null, predicates.isType '"String" ]
                      ],
                  category = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  compression = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "maximum", "normal", "store" ]
                        ],
                        predicates.isType 'Null
                      ],
                  cscKeyPassword = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  cscLink = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  depends = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                        predicates.isType 'Null
                      ],
                  description = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  desktop = predicates.always,
                  detectUpdateChannel = predicates.isType '"Bool",
                  electronUpdaterCompatibility = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  executableName = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  extraFiles = predicates.anyOf
                      [
                        definitions.predicate.FileSet,
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.anyOf
                          [
                            definitions.predicate.FileSet,
                            predicates.isType '"String"
                          ])
                        ],
                        predicates.anyOf
                        [ predicates.isType 'Null, predicates.isType '"String" ]
                      ],
                  extraResources = predicates.anyOf
                      [
                        definitions.predicate.FileSet,
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.anyOf
                          [
                            definitions.predicate.FileSet,
                            predicates.isType '"String"
                          ])
                        ],
                        predicates.anyOf
                        [ predicates.isType 'Null, predicates.isType '"String" ]
                      ],
                  fileAssociations = predicates.anyOf
                      [
                        definitions.predicate.FileAssociation,
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          definitions.predicate.FileAssociation
                        ]
                      ],
                  files = predicates.anyOf
                      [
                        definitions.predicate.FileSet,
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.anyOf
                          [
                            definitions.predicate.FileSet,
                            predicates.isType '"String"
                          ])
                        ],
                        predicates.anyOf
                        [ predicates.isType 'Null, predicates.isType '"String" ]
                      ],
                  forceCodeSigning = predicates.isType '"Bool",
                  generateUpdatesFilesForAllChannels = predicates.isType
                      '"Bool",
                  icon = predicates.isType '"String",
                  maintainer = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  mimeTypes = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                        predicates.isType 'Null
                      ],
                  packageCategory = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  protocols = predicates.anyOf
                      [
                        definitions.predicate.Protocol,
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          definitions.predicate.Protocol
                        ]
                      ],
                  publish = predicates.anyOf
                      [
                        definitions.predicate.GithubOptions,
                        definitions.predicate.S3Options,
                        definitions.predicate.SpacesOptions,
                        definitions.predicate.GenericServerOptions,
                        definitions.predicate.BintrayOptions,
                        definitions.predicate.CustomPublishOptions,
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.anyOf
                          [
                            definitions.predicate.GithubOptions,
                            definitions.predicate.S3Options,
                            definitions.predicate.SpacesOptions,
                            definitions.predicate.GenericServerOptions,
                            definitions.predicate.BintrayOptions,
                            definitions.predicate.CustomPublishOptions,
                            predicates.isType '"String"
                          ])
                        ],
                        predicates.anyOf
                        [ predicates.isType 'Null, predicates.isType '"String" ]
                      ],
                  releaseInfo = definitions.predicate.ReleaseInfo,
                  synopsis = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  target = predicates.anyOf
                      [
                        definitions.predicate.TargetConfiguration,
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.anyOf
                          [
                            definitions.predicate.TargetConfiguration,
                            predicates.isType '"String"
                          ])
                        ],
                        predicates.anyOf
                        [ predicates.isType 'Null, predicates.isType '"String" ]
                      ],
                  vendor = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                }
                {  }
                false
                predicates.never
              ],
          LinuxTargetSpecificOptions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  afterInstall = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  afterRemove = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  artifactName = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  category = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  compression = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "bzip2", "gz", "xz" ]
                        ],
                        predicates.isType 'Null
                      ],
                  depends = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                        predicates.isType 'Null
                      ],
                  description = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  desktop = predicates.always,
                  fpm = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                        predicates.isType 'Null
                      ],
                  icon = predicates.isType '"String",
                  maintainer = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  mimeTypes = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                        predicates.isType 'Null
                      ],
                  packageCategory = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  publish = predicates.anyOf
                      [
                        definitions.predicate.GithubOptions,
                        definitions.predicate.S3Options,
                        definitions.predicate.SpacesOptions,
                        definitions.predicate.GenericServerOptions,
                        definitions.predicate.BintrayOptions,
                        definitions.predicate.CustomPublishOptions,
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.anyOf
                          [
                            definitions.predicate.GithubOptions,
                            definitions.predicate.S3Options,
                            definitions.predicate.SpacesOptions,
                            definitions.predicate.GenericServerOptions,
                            definitions.predicate.BintrayOptions,
                            definitions.predicate.CustomPublishOptions,
                            predicates.isType '"String"
                          ])
                        ],
                        predicates.anyOf
                        [ predicates.isType 'Null, predicates.isType '"String" ]
                      ],
                  synopsis = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  vendor = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                }
                {  }
                false
                predicates.never
              ],
          MacConfiguration = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  appId = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  artifactName = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  asar = predicates.anyOf
                      [
                        definitions.predicate.AsarOptions,
                        predicates.anyOf
                        [ predicates.isType 'Null, predicates.isType '"Bool" ]
                      ],
                  asarUnpack = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                        predicates.anyOf
                        [ predicates.isType 'Null, predicates.isType '"String" ]
                      ],
                  binaries = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                        predicates.isType 'Null
                      ],
                  bundleShortVersion = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  bundleVersion = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  category = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  compression = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "maximum", "normal", "store" ]
                        ],
                        predicates.isType 'Null
                      ],
                  cscInstallerKeyPassword = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  cscInstallerLink = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  cscKeyPassword = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  cscLink = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  darkModeSupport = predicates.isType '"Bool",
                  detectUpdateChannel = predicates.isType '"Bool",
                  electronLanguages = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                        predicates.isType '"String"
                      ],
                  electronUpdaterCompatibility = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  entitlements = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  entitlementsInherit = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  extendInfo = predicates.always,
                  extraDistFiles = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                        predicates.anyOf
                        [ predicates.isType 'Null, predicates.isType '"String" ]
                      ],
                  extraFiles = predicates.anyOf
                      [
                        definitions.predicate.FileSet,
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.anyOf
                          [
                            definitions.predicate.FileSet,
                            predicates.isType '"String"
                          ])
                        ],
                        predicates.anyOf
                        [ predicates.isType 'Null, predicates.isType '"String" ]
                      ],
                  extraResources = predicates.anyOf
                      [
                        definitions.predicate.FileSet,
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.anyOf
                          [
                            definitions.predicate.FileSet,
                            predicates.isType '"String"
                          ])
                        ],
                        predicates.anyOf
                        [ predicates.isType 'Null, predicates.isType '"String" ]
                      ],
                  fileAssociations = predicates.anyOf
                      [
                        definitions.predicate.FileAssociation,
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          definitions.predicate.FileAssociation
                        ]
                      ],
                  files = predicates.anyOf
                      [
                        definitions.predicate.FileSet,
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.anyOf
                          [
                            definitions.predicate.FileSet,
                            predicates.isType '"String"
                          ])
                        ],
                        predicates.anyOf
                        [ predicates.isType 'Null, predicates.isType '"String" ]
                      ],
                  forceCodeSigning = predicates.isType '"Bool",
                  gatekeeperAssess = predicates.isType '"Bool",
                  generateUpdatesFilesForAllChannels = predicates.isType
                      '"Bool",
                  hardenedRuntime = predicates.isType '"Bool",
                  helperBundleId = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  icon = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  identity = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  minimumSystemVersion = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  protocols = predicates.anyOf
                      [
                        definitions.predicate.Protocol,
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          definitions.predicate.Protocol
                        ]
                      ],
                  provisioningProfile = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  publish = predicates.anyOf
                      [
                        definitions.predicate.GithubOptions,
                        definitions.predicate.S3Options,
                        definitions.predicate.SpacesOptions,
                        definitions.predicate.GenericServerOptions,
                        definitions.predicate.BintrayOptions,
                        definitions.predicate.CustomPublishOptions,
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.anyOf
                          [
                            definitions.predicate.GithubOptions,
                            definitions.predicate.S3Options,
                            definitions.predicate.SpacesOptions,
                            definitions.predicate.GenericServerOptions,
                            definitions.predicate.BintrayOptions,
                            definitions.predicate.CustomPublishOptions,
                            predicates.isType '"String"
                          ])
                        ],
                        predicates.anyOf
                        [ predicates.isType 'Null, predicates.isType '"String" ]
                      ],
                  releaseInfo = definitions.predicate.ReleaseInfo,
                  requirements = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  target = predicates.anyOf
                      [
                        definitions.predicate.TargetConfiguration,
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.anyOf
                          [
                            definitions.predicate.TargetConfiguration,
                            predicates.allOf
                            [
                              predicates.isType '"String",
                              predicates.enum
                              [
                                "7z",
                                "default",
                                "dir",
                                "dmg",
                                "mas",
                                "mas-dev",
                                "pkg",
                                "tar.bz2",
                                "tar.gz",
                                "tar.lz",
                                "tar.xz",
                                "zip"
                              ]
                            ]
                          ])
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum
                          [
                            "7z",
                            "default",
                            "dir",
                            "dmg",
                            "mas",
                            "mas-dev",
                            "pkg",
                            "tar.bz2",
                            "tar.gz",
                            "tar.lz",
                            "tar.xz",
                            "zip"
                          ]
                        ],
                        predicates.isType 'Null
                      ],
                  type = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "development", "distribution" ]
                        ],
                        predicates.isType 'Null
                      ],
                }
                {  }
                false
                predicates.never
              ],
          MasConfiguration = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  appId = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  artifactName = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  asar = predicates.anyOf
                      [
                        definitions.predicate.AsarOptions,
                        predicates.anyOf
                        [ predicates.isType 'Null, predicates.isType '"Bool" ]
                      ],
                  asarUnpack = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                        predicates.anyOf
                        [ predicates.isType 'Null, predicates.isType '"String" ]
                      ],
                  binaries = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                        predicates.isType 'Null
                      ],
                  bundleShortVersion = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  bundleVersion = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  category = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  compression = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "maximum", "normal", "store" ]
                        ],
                        predicates.isType 'Null
                      ],
                  cscInstallerKeyPassword = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  cscInstallerLink = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  cscKeyPassword = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  cscLink = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  darkModeSupport = predicates.isType '"Bool",
                  detectUpdateChannel = predicates.isType '"Bool",
                  electronLanguages = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                        predicates.isType '"String"
                      ],
                  electronUpdaterCompatibility = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  entitlements = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  entitlementsInherit = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  extendInfo = predicates.always,
                  extraDistFiles = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                        predicates.anyOf
                        [ predicates.isType 'Null, predicates.isType '"String" ]
                      ],
                  extraFiles = predicates.anyOf
                      [
                        definitions.predicate.FileSet,
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.anyOf
                          [
                            definitions.predicate.FileSet,
                            predicates.isType '"String"
                          ])
                        ],
                        predicates.anyOf
                        [ predicates.isType 'Null, predicates.isType '"String" ]
                      ],
                  extraResources = predicates.anyOf
                      [
                        definitions.predicate.FileSet,
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.anyOf
                          [
                            definitions.predicate.FileSet,
                            predicates.isType '"String"
                          ])
                        ],
                        predicates.anyOf
                        [ predicates.isType 'Null, predicates.isType '"String" ]
                      ],
                  fileAssociations = predicates.anyOf
                      [
                        definitions.predicate.FileAssociation,
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          definitions.predicate.FileAssociation
                        ]
                      ],
                  files = predicates.anyOf
                      [
                        definitions.predicate.FileSet,
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.anyOf
                          [
                            definitions.predicate.FileSet,
                            predicates.isType '"String"
                          ])
                        ],
                        predicates.anyOf
                        [ predicates.isType 'Null, predicates.isType '"String" ]
                      ],
                  forceCodeSigning = predicates.isType '"Bool",
                  generateUpdatesFilesForAllChannels = predicates.isType
                      '"Bool",
                  hardenedRuntime = predicates.isType '"Bool",
                  helperBundleId = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  icon = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  identity = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  minimumSystemVersion = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  protocols = predicates.anyOf
                      [
                        definitions.predicate.Protocol,
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          definitions.predicate.Protocol
                        ]
                      ],
                  provisioningProfile = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  publish = predicates.anyOf
                      [
                        definitions.predicate.GithubOptions,
                        definitions.predicate.S3Options,
                        definitions.predicate.SpacesOptions,
                        definitions.predicate.GenericServerOptions,
                        definitions.predicate.BintrayOptions,
                        definitions.predicate.CustomPublishOptions,
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.anyOf
                          [
                            definitions.predicate.GithubOptions,
                            definitions.predicate.S3Options,
                            definitions.predicate.SpacesOptions,
                            definitions.predicate.GenericServerOptions,
                            definitions.predicate.BintrayOptions,
                            definitions.predicate.CustomPublishOptions,
                            predicates.isType '"String"
                          ])
                        ],
                        predicates.anyOf
                        [ predicates.isType 'Null, predicates.isType '"String" ]
                      ],
                  releaseInfo = definitions.predicate.ReleaseInfo,
                  requirements = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  target = predicates.anyOf
                      [
                        definitions.predicate.TargetConfiguration,
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.anyOf
                          [
                            definitions.predicate.TargetConfiguration,
                            predicates.allOf
                            [
                              predicates.isType '"String",
                              predicates.enum
                              [
                                "7z",
                                "default",
                                "dir",
                                "dmg",
                                "mas",
                                "mas-dev",
                                "pkg",
                                "tar.bz2",
                                "tar.gz",
                                "tar.lz",
                                "tar.xz",
                                "zip"
                              ]
                            ]
                          ])
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum
                          [
                            "7z",
                            "default",
                            "dir",
                            "dmg",
                            "mas",
                            "mas-dev",
                            "pkg",
                            "tar.bz2",
                            "tar.gz",
                            "tar.lz",
                            "tar.xz",
                            "zip"
                          ]
                        ],
                        predicates.isType 'Null
                      ],
                  type = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "development", "distribution" ]
                        ],
                        predicates.isType 'Null
                      ],
                }
                {  }
                false
                predicates.never
              ],
          MetadataDirectories = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  app = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  buildResources = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  output = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                }
                {  }
                false
                predicates.never
              ],
          MsiOptions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  artifactName = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  createDesktopShortcut = predicates.enum
                      [ "always", false, true ],
                  createStartMenuShortcut = predicates.isType '"Bool",
                  menuCategory = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Bool"
                      ],
                  oneClick = predicates.isType '"Bool",
                  perMachine = predicates.isType '"Bool",
                  publish = predicates.anyOf
                      [
                        definitions.predicate.GithubOptions,
                        definitions.predicate.S3Options,
                        definitions.predicate.SpacesOptions,
                        definitions.predicate.GenericServerOptions,
                        definitions.predicate.BintrayOptions,
                        definitions.predicate.CustomPublishOptions,
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.anyOf
                          [
                            definitions.predicate.GithubOptions,
                            definitions.predicate.S3Options,
                            definitions.predicate.SpacesOptions,
                            definitions.predicate.GenericServerOptions,
                            definitions.predicate.BintrayOptions,
                            definitions.predicate.CustomPublishOptions,
                            predicates.isType '"String"
                          ])
                        ],
                        predicates.anyOf
                        [ predicates.isType 'Null, predicates.isType '"String" ]
                      ],
                  runAfterFinish = predicates.isType '"Bool",
                  shortcutName = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  upgradeCode = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  warningsAsErrors = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          NsisOptions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  allowElevation = predicates.isType '"Bool",
                  allowToChangeInstallationDirectory = predicates.isType
                      '"Bool",
                  artifactName = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  createDesktopShortcut = predicates.enum
                      [ "always", false, true ],
                  createStartMenuShortcut = predicates.isType '"Bool",
                  deleteAppDataOnUninstall = predicates.isType '"Bool",
                  differentialPackage = predicates.isType '"Bool",
                  displayLanguageSelector = predicates.isType '"Bool",
                  guid = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  include = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  installerHeader = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  installerHeaderIcon = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  installerIcon = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  installerLanguages = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                        predicates.anyOf
                        [ predicates.isType 'Null, predicates.isType '"String" ]
                      ],
                  installerSidebar = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  language = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  license = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  menuCategory = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Bool"
                      ],
                  multiLanguageInstaller = predicates.isType '"Bool",
                  oneClick = predicates.isType '"Bool",
                  packElevateHelper = predicates.isType '"Bool",
                  perMachine = predicates.isType '"Bool",
                  preCompressedFileExtensions = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                        predicates.anyOf
                        [ predicates.isType 'Null, predicates.isType '"String" ]
                      ],
                  publish = predicates.anyOf
                      [
                        definitions.predicate.GithubOptions,
                        definitions.predicate.S3Options,
                        definitions.predicate.SpacesOptions,
                        definitions.predicate.GenericServerOptions,
                        definitions.predicate.BintrayOptions,
                        definitions.predicate.CustomPublishOptions,
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.anyOf
                          [
                            definitions.predicate.GithubOptions,
                            definitions.predicate.S3Options,
                            definitions.predicate.SpacesOptions,
                            definitions.predicate.GenericServerOptions,
                            definitions.predicate.BintrayOptions,
                            definitions.predicate.CustomPublishOptions,
                            predicates.isType '"String"
                          ])
                        ],
                        predicates.anyOf
                        [ predicates.isType 'Null, predicates.isType '"String" ]
                      ],
                  runAfterFinish = predicates.isType '"Bool",
                  script = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  shortcutName = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  unicode = predicates.isType '"Bool",
                  uninstallDisplayName = predicates.isType '"String",
                  uninstallerIcon = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  uninstallerSidebar = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  useZip = predicates.isType '"Bool",
                  warningsAsErrors = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          NsisWebOptions
            | doc m%"
            Web Installer options.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  allowElevation = predicates.isType '"Bool",
                  allowToChangeInstallationDirectory = predicates.isType
                      '"Bool",
                  appPackageUrl = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  artifactName = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  createDesktopShortcut = predicates.enum
                      [ "always", false, true ],
                  createStartMenuShortcut = predicates.isType '"Bool",
                  deleteAppDataOnUninstall = predicates.isType '"Bool",
                  differentialPackage = predicates.isType '"Bool",
                  displayLanguageSelector = predicates.isType '"Bool",
                  guid = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  include = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  installerHeader = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  installerHeaderIcon = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  installerIcon = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  installerLanguages = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                        predicates.anyOf
                        [ predicates.isType 'Null, predicates.isType '"String" ]
                      ],
                  installerSidebar = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  language = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  license = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  menuCategory = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Bool"
                      ],
                  multiLanguageInstaller = predicates.isType '"Bool",
                  oneClick = predicates.isType '"Bool",
                  packElevateHelper = predicates.isType '"Bool",
                  perMachine = predicates.isType '"Bool",
                  preCompressedFileExtensions = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                        predicates.anyOf
                        [ predicates.isType 'Null, predicates.isType '"String" ]
                      ],
                  publish = predicates.anyOf
                      [
                        definitions.predicate.GithubOptions,
                        definitions.predicate.S3Options,
                        definitions.predicate.SpacesOptions,
                        definitions.predicate.GenericServerOptions,
                        definitions.predicate.BintrayOptions,
                        definitions.predicate.CustomPublishOptions,
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.anyOf
                          [
                            definitions.predicate.GithubOptions,
                            definitions.predicate.S3Options,
                            definitions.predicate.SpacesOptions,
                            definitions.predicate.GenericServerOptions,
                            definitions.predicate.BintrayOptions,
                            definitions.predicate.CustomPublishOptions,
                            predicates.isType '"String"
                          ])
                        ],
                        predicates.anyOf
                        [ predicates.isType 'Null, predicates.isType '"String" ]
                      ],
                  runAfterFinish = predicates.isType '"Bool",
                  script = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  shortcutName = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  unicode = predicates.isType '"Bool",
                  uninstallDisplayName = predicates.isType '"String",
                  uninstallerIcon = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  uninstallerSidebar = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  useZip = predicates.isType '"Bool",
                  warningsAsErrors = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          PkgBackgroundOptions
            | doc m%"
            Options for the background image in a PKG installer
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  alignment = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum
                          [
                            "bottom",
                            "bottomleft",
                            "bottomright",
                            "center",
                            "left",
                            "right",
                            "top",
                            "topleft",
                            "topright"
                          ]
                        ],
                        predicates.isType 'Null
                      ],
                  file = predicates.isType '"String",
                  scaling = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "none", "proportional", "tofit" ]
                        ],
                        predicates.isType 'Null
                      ],
                }
                {  }
                false
                predicates.never
              ],
          PkgOptions
            | doc m%"
            macOS product archive options.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  allowAnywhere = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"Bool" ],
                  allowCurrentUserHome = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"Bool" ],
                  allowRootDirectory = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"Bool" ],
                  artifactName = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  background = predicates.anyOf
                      [
                        definitions.predicate.PkgBackgroundOptions,
                        predicates.isType 'Null
                      ],
                  conclusion = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  hasStrictIdentifier = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"Bool" ],
                  identity = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  installLocation = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  isRelocatable = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"Bool" ],
                  isVersionChecked = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"Bool" ],
                  license = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  overwriteAction = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "update", "upgrade" ]
                        ],
                        predicates.isType 'Null
                      ],
                  productbuild = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                        predicates.isType 'Null
                      ],
                  publish = predicates.anyOf
                      [
                        definitions.predicate.GithubOptions,
                        definitions.predicate.S3Options,
                        definitions.predicate.SpacesOptions,
                        definitions.predicate.GenericServerOptions,
                        definitions.predicate.BintrayOptions,
                        definitions.predicate.CustomPublishOptions,
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.anyOf
                          [
                            definitions.predicate.GithubOptions,
                            definitions.predicate.S3Options,
                            definitions.predicate.SpacesOptions,
                            definitions.predicate.GenericServerOptions,
                            definitions.predicate.BintrayOptions,
                            definitions.predicate.CustomPublishOptions,
                            predicates.isType '"String"
                          ])
                        ],
                        predicates.anyOf
                        [ predicates.isType 'Null, predicates.isType '"String" ]
                      ],
                  scripts = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  welcome = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                }
                {  }
                false
                predicates.never
              ],
          PlugDescriptor = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  } {  } true
                (predicates.anyOf
                [
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true predicates.always
                  ],
                  predicates.isType 'Null
                ])
              ],
          PortableOptions
            | doc m%"
            Portable options.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  artifactName = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  guid = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  publish = predicates.anyOf
                      [
                        definitions.predicate.GithubOptions,
                        definitions.predicate.S3Options,
                        definitions.predicate.SpacesOptions,
                        definitions.predicate.GenericServerOptions,
                        definitions.predicate.BintrayOptions,
                        definitions.predicate.CustomPublishOptions,
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.anyOf
                          [
                            definitions.predicate.GithubOptions,
                            definitions.predicate.S3Options,
                            definitions.predicate.SpacesOptions,
                            definitions.predicate.GenericServerOptions,
                            definitions.predicate.BintrayOptions,
                            definitions.predicate.CustomPublishOptions,
                            predicates.isType '"String"
                          ])
                        ],
                        predicates.anyOf
                        [ predicates.isType 'Null, predicates.isType '"String" ]
                      ],
                  requestExecutionLevel = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "admin", "highest", "user" ]
                      ],
                  unicode = predicates.isType '"Bool",
                  unpackDirName = predicates.isType '"String",
                  useZip = predicates.isType '"Bool",
                  warningsAsErrors = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          Protocol
            | doc m%"
            URL Protocol Schemes. Protocols to associate the app with. macOS only.
            
            Please note — on macOS [you need to register an `open-url` event handler](http://electron.atom.io/docs/api/app/#event-open-url-macos).
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name", "schemes" ],
                predicates.records.record
                {
                  name = predicates.isType '"String",
                  role = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "Editor", "None", "Shell", "Viewer" ]
                      ],
                  schemes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          PublishProvider = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [ "bintray", "custom", "generic", "github", "s3", "spaces" ]
              ],
          ReleaseInfo = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  releaseDate = predicates.isType '"String",
                  releaseName = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  releaseNotes = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  releaseNotesFile = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                }
                {  }
                false
                predicates.never
              ],
          S3Options = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "bucket", "provider" ],
                predicates.records.record
                {
                  acl = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "private", "public-read" ]
                        ],
                        predicates.isType 'Null
                      ],
                  bucket = predicates.isType '"String",
                  channel = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  encryption = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "AES256", "aws:kms" ]
                        ],
                        predicates.isType 'Null
                      ],
                  endpoint = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  path = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  provider = predicates.allOf
                      [ predicates.isType '"String", predicates.enum [ "s3" ] ],
                  publishAutoUpdate = predicates.isType '"Bool",
                  publisherName = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                        predicates.isType 'Null
                      ],
                  region = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  storageClass = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum
                          [ "REDUCED_REDUNDANCY", "STANDARD", "STANDARD_IA" ]
                        ],
                        predicates.isType 'Null
                      ],
                  updaterCacheDirName = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                }
                {  }
                false
                predicates.never
              ],
          SnapOptions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  after = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                        predicates.isType 'Null
                      ],
                  artifactName = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  assumes = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                        predicates.anyOf
                        [ predicates.isType 'Null, predicates.isType '"String" ]
                      ],
                  buildPackages = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                        predicates.isType 'Null
                      ],
                  category = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  confinement = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "classic", "devmode", "strict" ]
                        ],
                        predicates.isType 'Null
                      ],
                  description = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  desktop = predicates.always,
                  environment = predicates.anyOf
                      [ predicates.always, predicates.isType 'Null ],
                  grade = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "devel", "stable" ]
                        ],
                        predicates.isType 'Null
                      ],
                  hooks = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  mimeTypes = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                        predicates.isType 'Null
                      ],
                  plugs = predicates.anyOf
                      [
                        definitions.predicate.PlugDescriptor,
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.anyOf
                          [
                            definitions.predicate.PlugDescriptor,
                            predicates.isType '"String"
                          ])
                        ],
                        predicates.isType 'Null
                      ],
                  publish = predicates.anyOf
                      [
                        definitions.predicate.GithubOptions,
                        definitions.predicate.S3Options,
                        definitions.predicate.SpacesOptions,
                        definitions.predicate.GenericServerOptions,
                        definitions.predicate.BintrayOptions,
                        definitions.predicate.CustomPublishOptions,
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.anyOf
                          [
                            definitions.predicate.GithubOptions,
                            definitions.predicate.S3Options,
                            definitions.predicate.SpacesOptions,
                            definitions.predicate.GenericServerOptions,
                            definitions.predicate.BintrayOptions,
                            definitions.predicate.CustomPublishOptions,
                            predicates.isType '"String"
                          ])
                        ],
                        predicates.anyOf
                        [ predicates.isType 'Null, predicates.isType '"String" ]
                      ],
                  stagePackages = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                        predicates.isType 'Null
                      ],
                  summary = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  synopsis = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  useTemplateApp = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          SpacesOptions
            | doc m%"
            [DigitalOcean Spaces](https://www.digitalocean.com/community/tutorials/an-introduction-to-digitalocean-spaces) options.
            Access key is required, define `DO_KEY_ID` and `DO_SECRET_KEY` environment variables.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name", "provider", "region" ],
                predicates.records.record
                {
                  acl = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "private", "public-read" ]
                        ],
                        predicates.isType 'Null
                      ],
                  channel = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  name = predicates.isType '"String",
                  path = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  provider = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "spaces" ]
                      ],
                  publishAutoUpdate = predicates.isType '"Bool",
                  publisherName = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                        predicates.isType 'Null
                      ],
                  region = predicates.isType '"String",
                  updaterCacheDirName = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                }
                {  }
                false
                predicates.never
              ],
          SquirrelWindowsOptions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  artifactName = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  iconUrl = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  loadingGif = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  msi = predicates.isType '"Bool",
                  name = predicates.isType '"String",
                  publish = predicates.anyOf
                      [
                        definitions.predicate.GithubOptions,
                        definitions.predicate.S3Options,
                        definitions.predicate.SpacesOptions,
                        definitions.predicate.GenericServerOptions,
                        definitions.predicate.BintrayOptions,
                        definitions.predicate.CustomPublishOptions,
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.anyOf
                          [
                            definitions.predicate.GithubOptions,
                            definitions.predicate.S3Options,
                            definitions.predicate.SpacesOptions,
                            definitions.predicate.GenericServerOptions,
                            definitions.predicate.BintrayOptions,
                            definitions.predicate.CustomPublishOptions,
                            predicates.isType '"String"
                          ])
                        ],
                        predicates.anyOf
                        [ predicates.isType 'Null, predicates.isType '"String" ]
                      ],
                  remoteReleases = predicates.anyOf
                      [
                        predicates.isType 'Null,
                        predicates.isType '"String",
                        predicates.isType '"Bool"
                      ],
                  remoteToken = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  useAppIdAsId = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          TargetConfiguration = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "target" ],
                predicates.records.record
                {
                  arch = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.enum [ "arm64", "armv7l", "ia32", "x64" ]
                          ])
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "arm64", "armv7l", "ia32", "x64" ]
                        ]
                      ],
                  target = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          WindowsConfiguration = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  additionalCertificateFile = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  appId = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  artifactName = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  asar = predicates.anyOf
                      [
                        definitions.predicate.AsarOptions,
                        predicates.anyOf
                        [ predicates.isType 'Null, predicates.isType '"Bool" ]
                      ],
                  asarUnpack = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                        predicates.anyOf
                        [ predicates.isType 'Null, predicates.isType '"String" ]
                      ],
                  certificateFile = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  certificatePassword = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  certificateSha1 = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  certificateSubjectName = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  compression = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "maximum", "normal", "store" ]
                        ],
                        predicates.isType 'Null
                      ],
                  cscKeyPassword = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  cscLink = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  detectUpdateChannel = predicates.isType '"Bool",
                  electronUpdaterCompatibility = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  extraFiles = predicates.anyOf
                      [
                        definitions.predicate.FileSet,
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.anyOf
                          [
                            definitions.predicate.FileSet,
                            predicates.isType '"String"
                          ])
                        ],
                        predicates.anyOf
                        [ predicates.isType 'Null, predicates.isType '"String" ]
                      ],
                  extraResources = predicates.anyOf
                      [
                        definitions.predicate.FileSet,
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.anyOf
                          [
                            definitions.predicate.FileSet,
                            predicates.isType '"String"
                          ])
                        ],
                        predicates.anyOf
                        [ predicates.isType 'Null, predicates.isType '"String" ]
                      ],
                  fileAssociations = predicates.anyOf
                      [
                        definitions.predicate.FileAssociation,
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          definitions.predicate.FileAssociation
                        ]
                      ],
                  files = predicates.anyOf
                      [
                        definitions.predicate.FileSet,
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.anyOf
                          [
                            definitions.predicate.FileSet,
                            predicates.isType '"String"
                          ])
                        ],
                        predicates.anyOf
                        [ predicates.isType 'Null, predicates.isType '"String" ]
                      ],
                  forceCodeSigning = predicates.isType '"Bool",
                  generateUpdatesFilesForAllChannels = predicates.isType
                      '"Bool",
                  icon = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  legalTrademarks = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  protocols = predicates.anyOf
                      [
                        definitions.predicate.Protocol,
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          definitions.predicate.Protocol
                        ]
                      ],
                  publish = predicates.anyOf
                      [
                        definitions.predicate.GithubOptions,
                        definitions.predicate.S3Options,
                        definitions.predicate.SpacesOptions,
                        definitions.predicate.GenericServerOptions,
                        definitions.predicate.BintrayOptions,
                        definitions.predicate.CustomPublishOptions,
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.anyOf
                          [
                            definitions.predicate.GithubOptions,
                            definitions.predicate.S3Options,
                            definitions.predicate.SpacesOptions,
                            definitions.predicate.GenericServerOptions,
                            definitions.predicate.BintrayOptions,
                            definitions.predicate.CustomPublishOptions,
                            predicates.isType '"String"
                          ])
                        ],
                        predicates.anyOf
                        [ predicates.isType 'Null, predicates.isType '"String" ]
                      ],
                  publisherName = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                        predicates.anyOf
                        [ predicates.isType 'Null, predicates.isType '"String" ]
                      ],
                  releaseInfo = definitions.predicate.ReleaseInfo,
                  requestedExecutionLevel = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum
                          [
                            "asInvoker",
                            "highestAvailable",
                            "requireAdministrator"
                          ]
                        ],
                        predicates.isType 'Null
                      ],
                  rfc3161TimeStampServer = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  sign = predicates.anyOf
                      [
                        predicates.always,
                        predicates.anyOf
                        [ predicates.isType 'Null, predicates.isType '"String" ]
                      ],
                  signAndEditExecutable = predicates.isType '"Bool",
                  signDlls = predicates.isType '"Bool",
                  signingHashAlgorithms = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.enum [ "sha1", "sha256" ]
                          ])
                        ],
                        predicates.isType 'Null
                      ],
                  target = predicates.anyOf
                      [
                        definitions.predicate.TargetConfiguration,
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.anyOf
                          [
                            definitions.predicate.TargetConfiguration,
                            predicates.isType '"String"
                          ])
                        ],
                        predicates.anyOf
                        [ predicates.isType 'Null, predicates.isType '"String" ]
                      ],
                  timeStampServer = predicates.anyOf
                      [ predicates.isType 'Null, predicates.isType '"String" ],
                  verifyUpdateCodeSignature = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
        },
  }
in

{
  "$schema"
    | predicates.contract_from_predicate
    (predicates.anyOf [ predicates.isType 'Null, predicates.isType '"String" ])
    | doc m%"
    JSON Schema for this document.
    "%
    | optional,
  afterAllArtifactBuild
    | predicates.contract_from_predicate
    (predicates.anyOf
    [
      predicates.always,
      predicates.anyOf [ predicates.isType 'Null, predicates.isType '"String" ]
    ])
    | doc m%"
    The function (or path to file or module id) to be [run after all artifacts are build](#afterAllArtifactBuild).
    "%
    | optional,
  afterPack
    | predicates.contract_from_predicate
    (predicates.anyOf
    [
      predicates.always,
      predicates.anyOf [ predicates.isType 'Null, predicates.isType '"String" ]
    ])
    | doc m%"
    The function (or path to file or module id) to be [run after pack](#afterpack) (but before pack into distributable format and sign).
    "%
    | optional,
  afterSign
    | predicates.contract_from_predicate
    (predicates.anyOf
    [
      predicates.always,
      predicates.anyOf [ predicates.isType 'Null, predicates.isType '"String" ]
    ])
    | doc m%"
    The function (or path to file or module id) to be [run after pack and sign](#aftersign) (but before pack into distributable format).
    "%
    | optional,
  apk
    | predicates.contract_from_predicate
    (predicates.anyOf
    [
      definitions.predicate.LinuxTargetSpecificOptions,
      predicates.isType 'Null
    ])
    | optional,
  appId
    | predicates.contract_from_predicate
    (predicates.anyOf [ predicates.isType 'Null, predicates.isType '"String" ])
    | doc m%"
    The application id. Used as [CFBundleIdentifier](https://developer.apple.com/library/ios/documentation/General/Reference/InfoPlistKeyReference/Articles/CoreFoundationKeys.html#//apple_ref/doc/uid/20001431-102070) for MacOS and as
    [Application User Model ID](https://msdn.microsoft.com/en-us/library/windows/desktop/dd378459(v=vs.85).aspx) for Windows (NSIS target only, Squirrel.Windows not supported). It is strongly recommended that an explicit ID is set.
    "%
    | optional,
  appImage
    | predicates.contract_from_predicate
    (predicates.anyOf
    [ definitions.predicate.AppImageOptions, predicates.isType 'Null ])
    | doc m%"
    AppImage options.
    "%
    | optional,
  appx
    | predicates.contract_from_predicate
    (predicates.anyOf
    [ definitions.predicate.AppXOptions, predicates.isType 'Null ])
    | optional,
  artifactBuildCompleted
    | predicates.contract_from_predicate
    (predicates.anyOf
    [
      predicates.always,
      predicates.anyOf [ predicates.isType 'Null, predicates.isType '"String" ]
    ])
    | doc m%"
    The function (or path to file or module id) to be run on artifact build completed.
    "%
    | optional,
  artifactBuildStarted
    | predicates.contract_from_predicate
    (predicates.anyOf
    [
      predicates.always,
      predicates.anyOf [ predicates.isType 'Null, predicates.isType '"String" ]
    ])
    | doc m%"
    The function (or path to file or module id) to be run on artifact build start.
    "%
    | optional,
  artifactName
    | predicates.contract_from_predicate
    (predicates.anyOf [ predicates.isType 'Null, predicates.isType '"String" ])
    | doc m%"
    The [artifact file name template](/configuration/configuration#artifact-file-name-template). Defaults to `${productName}-${version}.${ext}` (some target can have other defaults, see corresponding options).
    "%
    | optional,
  asar
    | predicates.contract_from_predicate
    (predicates.anyOf
    [
      definitions.predicate.AsarOptions,
      predicates.anyOf [ predicates.isType 'Null, predicates.isType '"Bool" ]
    ])
    | doc m%"
    Whether to package the application's source code into an archive, using [Electron's archive format](http://electron.atom.io/docs/tutorial/application-packaging/).
    
    Node modules, that must be unpacked, will be detected automatically, you don't need to explicitly set [asarUnpack](#configuration-asarUnpack) - please file an issue if this doesn't work.
    "%
    | optional,
  asarUnpack
    | predicates.contract_from_predicate
    (predicates.anyOf
    [
      predicates.allOf
      [
        predicates.isType '"Array",
        predicates.arrays.arrayOf (predicates.isType '"String")
      ],
      predicates.anyOf [ predicates.isType 'Null, predicates.isType '"String" ]
    ])
    | doc m%"
    A [glob patterns](/file-patterns) relative to the [app directory](#MetadataDirectories-app), which specifies which files to unpack when creating the [asar](http://electron.atom.io/docs/tutorial/application-packaging/) archive.
    "%
    | optional,
  beforeBuild
    | predicates.contract_from_predicate
    (predicates.anyOf
    [
      predicates.always,
      predicates.anyOf [ predicates.isType 'Null, predicates.isType '"String" ]
    ])
    | doc m%"
    The function (or path to file or module id) to be run before dependencies are installed or rebuilt. Works when `npmRebuild` is set to `true`. Resolving to `false` will skip dependencies install or rebuild.
    
    If provided and `node_modules` are missing, it will not invoke production dependencies check.
    "%
    | optional,
  buildDependenciesFromSource
    | Bool
    | doc m%"
    Whether to build the application native dependencies from source.
    "%
    | optional,
  buildVersion
    | predicates.contract_from_predicate
    (predicates.anyOf [ predicates.isType 'Null, predicates.isType '"String" ])
    | doc m%"
    The build version. Maps to the `CFBundleVersion` on macOS, and `FileVersion` metadata property on Windows. Defaults to the `version`.
    If `TRAVIS_BUILD_NUMBER` or `APPVEYOR_BUILD_NUMBER` or `CIRCLE_BUILD_NUM` or `BUILD_NUMBER` or `bamboo.buildNumber` env defined, it will be used as a build version (`version.build_number`).
    "%
    | optional,
  compression
    | predicates.contract_from_predicate
    (predicates.anyOf
    [
      predicates.allOf
      [
        predicates.isType '"String",
        predicates.enum [ "maximum", "normal", "store" ]
      ],
      predicates.isType 'Null
    ])
    | doc m%"
    The compression level. If you want to rapidly test build, `store` can reduce build time significantly. `maximum` doesn't lead to noticeable size difference, but increase build time.
    "%
    | optional,
  copyright
    | predicates.contract_from_predicate
    (predicates.anyOf [ predicates.isType 'Null, predicates.isType '"String" ])
    | doc m%"
    The human-readable copyright line for the app.
    "%
    | optional,
  cscKeyPassword
    | predicates.contract_from_predicate
    (predicates.anyOf [ predicates.isType 'Null, predicates.isType '"String" ])
    | optional,
  cscLink
    | predicates.contract_from_predicate
    (predicates.anyOf [ predicates.isType 'Null, predicates.isType '"String" ])
    | optional,
  deb
    | predicates.contract_from_predicate
    (predicates.anyOf
    [ definitions.predicate.DebOptions, predicates.isType 'Null ])
    | doc m%"
    Debian package options.
    "%
    | optional,
  detectUpdateChannel
    | Bool
    | doc m%"
    Whether to infer update channel from application version pre-release components. e.g. if version `0.12.1-alpha.1`, channel will be set to `alpha`. Otherwise to `latest`.
    "%
    | optional,
  directories
    | predicates.contract_from_predicate
    (predicates.anyOf
    [ definitions.predicate.MetadataDirectories, predicates.isType 'Null ])
    | optional,
  dmg
    | predicates.contract_from_predicate
    (predicates.anyOf
    [ definitions.predicate.DmgOptions, predicates.isType 'Null ])
    | doc m%"
    macOS DMG options.
    "%
    | optional,
  electronCompile
    | Bool
    | doc m%"
    Whether to use [electron-compile](http://github.com/electron/electron-compile) to compile app. Defaults to `true` if `electron-compile` in the dependencies. And `false` if in the `devDependencies` or doesn't specified.
    "%
    | optional,
  electronDist
    | String
    | doc m%"
    The path to custom Electron build (e.g. `~/electron/out/R`).
    "%
    | optional,
  electronDownload
    | definitions.contract.ElectronDownloadOptions
    | doc m%"
    The [electron-download](https://github.com/electron-userland/electron-download#usage) options.
    "%
    | optional,
  electronUpdaterCompatibility
    | predicates.contract_from_predicate
    (predicates.anyOf [ predicates.isType 'Null, predicates.isType '"String" ])
    | doc m%"
    The [electron-updater compatibility](/auto-update#compatibility) semver range.
    "%
    | optional,
  electronVersion
    | predicates.contract_from_predicate
    (predicates.anyOf [ predicates.isType 'Null, predicates.isType '"String" ])
    | doc m%"
    The version of electron you are packaging for. Defaults to version of `electron`, `electron-prebuilt` or `electron-prebuilt-compile` dependency.
    "%
    | optional,
  extends
    | predicates.contract_from_predicate
    (predicates.anyOf [ predicates.isType 'Null, predicates.isType '"String" ])
    | doc m%"
    The name of a built-in configuration preset or path to config file (relative to project dir). Currently, only `react-cra` is supported.
    
    If `react-scripts` in the app dependencies, `react-cra` will be set automatically. Set to `null` to disable automatic detection.
    "%
    | optional,
  extraFiles
    | predicates.contract_from_predicate
    (predicates.anyOf
    [
      definitions.predicate.FileSet,
      predicates.allOf
      [
        predicates.isType '"Array",
        predicates.arrays.arrayOf
        (predicates.anyOf
        [ definitions.predicate.FileSet, predicates.isType '"String" ])
      ],
      predicates.anyOf [ predicates.isType 'Null, predicates.isType '"String" ]
    ])
    | optional,
  extraMetadata
    | predicates.contract_from_predicate predicates.always
    | doc m%"
    Inject properties to `package.json`.
    "%
    | optional,
  extraResources
    | predicates.contract_from_predicate
    (predicates.anyOf
    [
      definitions.predicate.FileSet,
      predicates.allOf
      [
        predicates.isType '"Array",
        predicates.arrays.arrayOf
        (predicates.anyOf
        [ definitions.predicate.FileSet, predicates.isType '"String" ])
      ],
      predicates.anyOf [ predicates.isType 'Null, predicates.isType '"String" ]
    ])
    | optional,
  fileAssociations
    | predicates.contract_from_predicate
    (predicates.anyOf
    [
      definitions.predicate.FileAssociation,
      predicates.allOf
      [
        predicates.isType '"Array",
        predicates.arrays.arrayOf definitions.predicate.FileAssociation
      ]
    ])
    | doc m%"
    The file associations.
    "%
    | optional,
  files
    | predicates.contract_from_predicate
    (predicates.anyOf
    [
      definitions.predicate.FileSet,
      predicates.allOf
      [
        predicates.isType '"Array",
        predicates.arrays.arrayOf
        (predicates.anyOf
        [ definitions.predicate.FileSet, predicates.isType '"String" ])
      ],
      predicates.anyOf [ predicates.isType 'Null, predicates.isType '"String" ]
    ])
    | optional,
  forceCodeSigning
    | Bool
    | doc m%"
    Whether to fail if app will be not code signed.
    "%
    | optional,
  framework
    | predicates.contract_from_predicate
    (predicates.anyOf [ predicates.isType 'Null, predicates.isType '"String" ])
    | doc m%"
    The framework name. One of `electron`, `proton-native`, `libui`. Defaults to `electron`.
    "%
    | optional,
  freebsd
    | predicates.contract_from_predicate
    (predicates.anyOf
    [
      definitions.predicate.LinuxTargetSpecificOptions,
      predicates.isType 'Null
    ])
    | optional,
  generateUpdatesFilesForAllChannels
    | Bool
    | doc m%"
    Please see [Building and Releasing using Channels](https://github.com/electron-userland/electron-builder/issues/1182#issuecomment-324947139).
    "%
    | optional,
  icon
    | predicates.contract_from_predicate
    (predicates.anyOf [ predicates.isType 'Null, predicates.isType '"String" ])
    | optional,
  includePdb
    | Bool
    | doc m%"
    Whether to include PDB files.
    "%
    | optional,
  launchUiVersion
    | predicates.contract_from_predicate
    (predicates.anyOf
    [
      predicates.isType 'Null,
      predicates.isType '"String",
      predicates.isType '"Bool"
    ])
    | doc m%"
    *libui-based frameworks only* The version of LaunchUI you are packaging for. Applicable for Windows only. Defaults to version suitable for used framework version.
    "%
    | optional,
  linux
    | predicates.contract_from_predicate
    (predicates.anyOf
    [ definitions.predicate.LinuxConfiguration, predicates.isType 'Null ])
    | doc m%"
    Options related to how build Linux targets.
    "%
    | optional,
  mac
    | predicates.contract_from_predicate
    (predicates.anyOf
    [ definitions.predicate.MacConfiguration, predicates.isType 'Null ])
    | doc m%"
    Options related to how build macOS targets.
    "%
    | optional,
  mas
    | predicates.contract_from_predicate
    (predicates.anyOf
    [ definitions.predicate.MasConfiguration, predicates.isType 'Null ])
    | doc m%"
    MAS (Mac Application Store) options.
    "%
    | optional,
  msi
    | predicates.contract_from_predicate
    (predicates.anyOf
    [ definitions.predicate.MsiOptions, predicates.isType 'Null ])
    | optional,
  muonVersion
    | predicates.contract_from_predicate
    (predicates.anyOf [ predicates.isType 'Null, predicates.isType '"String" ])
    | doc m%"
    The version of muon you are packaging for.
    "%
    | optional,
  nodeGypRebuild
    | Bool
    | doc m%"
    Whether to execute `node-gyp rebuild` before starting to package the app.
    
    Don't [use](https://github.com/electron-userland/electron-builder/issues/683#issuecomment-241214075) [npm](http://electron.atom.io/docs/tutorial/using-native-node-modules/#using-npm) (neither `.npmrc`) for configuring electron headers. Use `electron-builder node-gyp-rebuild` instead.
    "%
    | optional,
  nodeVersion
    | predicates.contract_from_predicate
    (predicates.anyOf [ predicates.isType 'Null, predicates.isType '"String" ])
    | doc m%"
    *libui-based frameworks only* The version of NodeJS you are packaging for.
    You can set it to `current` to set the Node.js version that you use to run.
    "%
    | optional,
  npmArgs
    | predicates.contract_from_predicate
    (predicates.anyOf
    [
      predicates.allOf
      [
        predicates.isType '"Array",
        predicates.arrays.arrayOf (predicates.isType '"String")
      ],
      predicates.anyOf [ predicates.isType 'Null, predicates.isType '"String" ]
    ])
    | doc m%"
    Additional command line arguments to use when installing app native deps.
    "%
    | optional,
  npmRebuild
    | Bool
    | doc m%"
    Whether to [rebuild](https://docs.npmjs.com/cli/rebuild) native dependencies before starting to package the app.
    "%
    | optional,
  npmSkipBuildFromSource | Bool | optional,
  nsis
    | predicates.contract_from_predicate
    (predicates.anyOf
    [ definitions.predicate.NsisOptions, predicates.isType 'Null ])
    | optional,
  nsisWeb
    | predicates.contract_from_predicate
    (predicates.anyOf
    [ definitions.predicate.NsisWebOptions, predicates.isType 'Null ])
    | optional,
  onNodeModuleFile
    | predicates.contract_from_predicate
    (predicates.anyOf
    [
      predicates.always,
      predicates.anyOf [ predicates.isType 'Null, predicates.isType '"String" ]
    ])
    | doc m%"
    The function (or path to file or module id) to be [run on each node module](#onnodemodulefile) file.
    "%
    | optional,
  p5p
    | predicates.contract_from_predicate
    (predicates.anyOf
    [
      definitions.predicate.LinuxTargetSpecificOptions,
      predicates.isType 'Null
    ])
    | optional,
  pacman
    | predicates.contract_from_predicate
    (predicates.anyOf
    [
      definitions.predicate.LinuxTargetSpecificOptions,
      predicates.isType 'Null
    ])
    | optional,
  pkg
    | predicates.contract_from_predicate
    (predicates.anyOf
    [ definitions.predicate.PkgOptions, predicates.isType 'Null ])
    | doc m%"
    macOS PKG options.
    "%
    | optional,
  portable
    | predicates.contract_from_predicate
    (predicates.anyOf
    [ definitions.predicate.PortableOptions, predicates.isType 'Null ])
    | optional,
  productName
    | predicates.contract_from_predicate
    (predicates.anyOf [ predicates.isType 'Null, predicates.isType '"String" ])
    | doc m%"
    As [name](#Metadata-name), but allows you to specify a product name for your executable which contains spaces and other special characters not allowed in the [name property](https://docs.npmjs.com/files/package.json#name).
    "%
    | optional,
  protocols
    | predicates.contract_from_predicate
    (predicates.anyOf
    [
      definitions.predicate.Protocol,
      predicates.allOf
      [
        predicates.isType '"Array",
        predicates.arrays.arrayOf definitions.predicate.Protocol
      ]
    ])
    | doc m%"
    The URL protocol schemes.
    "%
    | optional,
  protonNodeVersion
    | predicates.contract_from_predicate
    (predicates.anyOf [ predicates.isType 'Null, predicates.isType '"String" ])
    | optional,
  publish
    | predicates.contract_from_predicate
    (predicates.anyOf
    [
      definitions.predicate.GithubOptions,
      definitions.predicate.S3Options,
      definitions.predicate.SpacesOptions,
      definitions.predicate.GenericServerOptions,
      definitions.predicate.BintrayOptions,
      definitions.predicate.CustomPublishOptions,
      predicates.allOf
      [
        predicates.isType '"Array",
        predicates.arrays.arrayOf
        (predicates.anyOf
        [
          definitions.predicate.GithubOptions,
          definitions.predicate.S3Options,
          definitions.predicate.SpacesOptions,
          definitions.predicate.GenericServerOptions,
          definitions.predicate.BintrayOptions,
          definitions.predicate.CustomPublishOptions,
          predicates.isType '"String"
        ])
      ],
      predicates.anyOf [ predicates.isType 'Null, predicates.isType '"String" ]
    ])
    | optional,
  readonly
    | Bool
    | doc m%"
    Whether to fail if the application is not signed (to prevent unsigned app if code signing configuration is not correct).
    "%
    | optional,
  releaseInfo
    | definitions.contract.ReleaseInfo
    | doc m%"
    The release info. Intended for command line usage:
    
    ```
    -c.releaseInfo.releaseNotes="new features"
    ```
    "%
    | optional,
  remoteBuild
    | Bool
    | doc m%"
    Whether to build using Electron Build Service if target not supported on current OS.
    "%
    | optional,
  removePackageScripts
    | Bool
    | doc m%"
    Whether to remove `scripts` field from `package.json` files.
    "%
    | optional,
  rpm
    | predicates.contract_from_predicate
    (predicates.anyOf
    [
      definitions.predicate.LinuxTargetSpecificOptions,
      predicates.isType 'Null
    ])
    | optional,
  snap
    | predicates.contract_from_predicate
    (predicates.anyOf
    [ definitions.predicate.SnapOptions, predicates.isType 'Null ])
    | doc m%"
    Snap options.
    "%
    | optional,
  squirrelWindows
    | predicates.contract_from_predicate
    (predicates.anyOf
    [ definitions.predicate.SquirrelWindowsOptions, predicates.isType 'Null ])
    | optional,
  target
    | predicates.contract_from_predicate
    (predicates.anyOf
    [
      definitions.predicate.TargetConfiguration,
      predicates.allOf
      [
        predicates.isType '"Array",
        predicates.arrays.arrayOf
        (predicates.anyOf
        [
          definitions.predicate.TargetConfiguration,
          predicates.isType '"String"
        ])
      ],
      predicates.anyOf [ predicates.isType 'Null, predicates.isType '"String" ]
    ])
    | optional,
  win
    | predicates.contract_from_predicate
    (predicates.anyOf
    [ definitions.predicate.WindowsConfiguration, predicates.isType 'Null ])
    | doc m%"
    Options related to how build Windows targets.
    "%
    | optional,
}