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
          gocritic-checks = predicates.contract_from_predicate
              definitions.predicate.gocritic-checks,
          gocritic-tags = predicates.contract_from_predicate
              definitions.predicate.gocritic-tags,
          gosec-rules = predicates.contract_from_predicate
              definitions.predicate.gosec-rules,
          govet-analyzers = predicates.contract_from_predicate
              definitions.predicate.govet-analyzers,
          issue-match-linters = {
                linters
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.linters
                  ])
                  | optional,
                severity
                  | predicates.contract_from_predicate predicates.always
                  | optional,
              },
          issue-match-path = {
                path | String | optional,
                severity
                  | predicates.contract_from_predicate predicates.always
                  | optional,
              },
          issue-match-source = {
                severity
                  | predicates.contract_from_predicate predicates.always
                  | optional,
                source | String | optional,
              },
          issue-match-text = {
                severity
                  | predicates.contract_from_predicate predicates.always
                  | optional,
                text | String | optional,
              },
          linters
            | doc m%"
            Linters usable.
            "%
            = predicates.contract_from_predicate definitions.predicate.linters,
        },
    predicate = {
          gocritic-checks = predicates.enum
              [
                "appendAssign",
                "appendCombine",
                "argOrder",
                "assignOp",
                "badCall",
                "badCond",
                "badLock",
                "badRegexp",
                "badSorting",
                "boolExprSimplify",
                "builtinShadow",
                "builtinShadowDecl",
                "captLocal",
                "caseOrder",
                "codegenComment",
                "commentedOutCode",
                "commentedOutImport",
                "commentFormatting",
                "defaultCaseOrder",
                "deferUnlambda",
                "deferInLoop",
                "deprecatedComment",
                "docStub",
                "dupArg",
                "dupBranchBody",
                "dupCase",
                "dupImport",
                "dupSubExpr",
                "dynamicFmtString",
                "elseif",
                "emptyDecl",
                "emptyFallthrough",
                "emptyStringTest",
                "equalFold",
                "evalOrder",
                "exitAfterDefer",
                "exposedSyncMutex",
                "externalErrorReassign",
                "filepathJoin",
                "flagDeref",
                "flagName",
                "hexLiteral",
                "httpNoBody",
                "hugeParam",
                "ifElseChain",
                "importShadow",
                "indexAlloc",
                "initClause",
                "ioutilDeprecated",
                "mapKey",
                "methodExprCall",
                "nestingReduce",
                "newDeref",
                "nilValReturn",
                "octalLiteral",
                "offBy1",
                "paramTypeCombine",
                "preferDecodeRune",
                "preferFilepathJoin",
                "preferFprint",
                "preferStringWriter",
                "preferWriteByte",
                "ptrToRefParam",
                "rangeExprCopy",
                "rangeValCopy",
                "redundantSprint",
                "regexpMust",
                "regexpPattern",
                "regexpSimplify",
                "returnAfterHttpError",
                "ruleguard",
                "singleCaseSwitch",
                "sliceClear",
                "sloppyLen",
                "sloppyReassign",
                "sloppyTypeAssert",
                "sortSlice",
                "sprintfQuotedString",
                "sqlQuery",
                "stringConcatSimplify",
                "stringsCompare",
                "stringXbytes",
                "suspiciousSorting",
                "switchTrue",
                "syncMapLoadAndDelete",
                "timeCmpSimplify",
                "timeExprSimplify",
                "tooManyResultsChecker",
                "truncateCmp",
                "typeAssertChain",
                "typeDefFirst",
                "typeSwitchVar",
                "typeUnparen",
                "uncheckedInlineErr",
                "underef",
                "unlabelStmt",
                "unlambda",
                "unnamedResult",
                "unnecessaryBlock",
                "unnecessaryDefer",
                "unslice",
                "valSwap",
                "weakCond",
                "whyNoLint",
                "wrapperFunc",
                "yodaStyleExpr"
              ],
          gocritic-tags = predicates.enum
              [
                "diagnostic",
                "style",
                "performance",
                "experimental",
                "opinionated",
                "security"
              ],
          gosec-rules = predicates.enum
              [
                "G101",
                "G102",
                "G103",
                "G104",
                "G106",
                "G107",
                "G108",
                "G109",
                "G110",
                "G111",
                "G112",
                "G113",
                "G114",
                "G201",
                "G202",
                "G203",
                "G204",
                "G301",
                "G302",
                "G303",
                "G304",
                "G305",
                "G306",
                "G307",
                "G401",
                "G402",
                "G403",
                "G404",
                "G501",
                "G502",
                "G503",
                "G504",
                "G505",
                "G601"
              ],
          govet-analyzers = predicates.enum
              [
                "asmdecl",
                "assign",
                "atomic",
                "atomicalign",
                "bools",
                "buildtag",
                "cgocall",
                "composites",
                "copylocks",
                "deepequalerrors",
                "errorsas",
                "fieldalignment",
                "findcall",
                "framepointer",
                "httpresponse",
                "ifaceassert",
                "loopclosure",
                "lostcancel",
                "nilfunc",
                "nilness",
                "printf",
                "reflectvaluecompare",
                "shadow",
                "shift",
                "sigchanyzer",
                "sortslice",
                "stdmethods",
                "stringintconv",
                "structtag",
                "testinggoroutine",
                "tests",
                "unmarshal",
                "unreachable",
                "unsafeptr",
                "unusedresult",
                "unusedwrite"
              ],
          issue-match-linters = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  linters = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.linters
                      ],
                  severity = predicates.always,
                }
                {  }
                false
                predicates.never
              ],
          issue-match-path = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  path = predicates.isType '"String",
                  severity = predicates.always,
                }
                {  }
                false
                predicates.never
              ],
          issue-match-source = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  severity = predicates.always,
                  source = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          issue-match-text = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  severity = predicates.always,
                  text = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          linters
            | doc m%"
            Linters usable.
            "%
            = predicates.anyOf
              [
                predicates.enum
                [
                  "asasalint",
                  "asciicheck",
                  "bidichk",
                  "bodyclose",
                  "containedctx",
                  "contextcheck",
                  "cyclop",
                  "deadcode",
                  "decorder",
                  "depguard",
                  "dogsled",
                  "dupl",
                  "dupword",
                  "durationcheck",
                  "errcheck",
                  "errchkjson",
                  "errname",
                  "errorlint",
                  "execinquery",
                  "exhaustive",
                  "exhaustivestruct",
                  "exhaustruct",
                  "exportloopref",
                  "forbidigo",
                  "forcetypeassert",
                  "funlen",
                  "gci",
                  "ginkgolinter",
                  "gocheckcompilerdirectives",
                  "gochecknoglobals",
                  "gochecknoinits",
                  "gocognit",
                  "goconst",
                  "gocritic",
                  "gocyclo",
                  "godot",
                  "godox",
                  "goerr113",
                  "gofmt",
                  "gofumpt",
                  "goheader",
                  "goimports",
                  "golint",
                  "gomnd",
                  "gomoddirectives",
                  "gomodguard",
                  "goprintffuncname",
                  "gosec",
                  "gosimple",
                  "gosmopolitan",
                  "govet",
                  "grouper",
                  "ifshort",
                  "importas",
                  "ineffassign",
                  "interfacebloat",
                  "interfacer",
                  "ireturn",
                  "lll",
                  "loggercheck",
                  "maintidx",
                  "makezero",
                  "maligned",
                  "mirror",
                  "misspell",
                  "musttag",
                  "nakedret",
                  "nestif",
                  "nilerr",
                  "nilnil",
                  "nlreturn",
                  "noctx",
                  "nolintlint",
                  "nonamedreturns",
                  "nosnakecase",
                  "nosprintfhostport",
                  "paralleltest",
                  "prealloc",
                  "predeclared",
                  "promlinter",
                  "reassign",
                  "revive",
                  "rowserrcheck",
                  "scopelint",
                  "sqlclosecheck",
                  "staticcheck",
                  "structcheck",
                  "stylecheck",
                  "tagalign",
                  "tagliatelle",
                  "tenv",
                  "testableexamples",
                  "testpackage",
                  "thelper",
                  "tparallel",
                  "typecheck",
                  "unconvert",
                  "unparam",
                  "unused",
                  "usestdlibvars",
                  "varcheck",
                  "varnamelen",
                  "wastedassign",
                  "whitespace",
                  "wrapcheck",
                  "wsl",
                  "zerologlint"
                ],
                predicates.isType '"String"
              ],
        },
  }
in

{
  issues
    | {
      exclude
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf (predicates.isType '"String")
        ])
        | doc m%"
        List of regular expressions of issue texts to exclude.
        But independently from this option we use default exclude patterns. Their usage can be controlled through `exclude-use-default`.
        "%
        | optional,
      exclude-case-sensitive
        | Bool
        | doc m%"
        If set to true, exclude and exclude-rules regular expressions become case sensitive.
        "%
        | optional,
      exclude-rules
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [
            predicates.isType 'Record,
            predicates.records.record
            {
              linters = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.linters
                  ],
              path = predicates.isType '"String",
              path-except = predicates.isType '"String",
              source = predicates.isType '"String",
              text = predicates.isType '"String",
            }
            {  }
            true
            predicates.always
          ])
        ])
        | doc m%"
        Exclude configuration per-path, per-linter, per-text and per-source
        "%
        | optional,
      exclude-use-default
        | Bool
        | doc m%"
        Independently from option `exclude` we use default exclude patterns. This behavior can be disabled by this option.
        "%
        | optional,
      include
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf (predicates.isType '"String")
        ])
        | doc m%"
        The list of ids of default excludes to include or disable.
        "%
        | optional,
      max-issues-per-linter
        | predicates.contract_from_predicate
        (predicates.allOf
        [ predicates.isType 'Integer, predicates.numbers.minimum 0 ])
        | doc m%"
        Maximum issues count per one linter. Set to 0 to disable.
        "%
        | optional,
      max-same-issues
        | predicates.contract_from_predicate
        (predicates.allOf
        [ predicates.isType 'Integer, predicates.numbers.minimum 0 ])
        | doc m%"
        Maximum count of issues with the same text. Set to 0 to disable.
        "%
        | optional,
      new
        | Bool
        | doc m%"
        Show only new issues: if there are unstaged changes or untracked files, only those changes are analyzed, else only changes in HEAD~ are analyzed.
        "%
        | optional,
      new-from-patch
        | String
        | doc m%"
        Show only new issues created in git patch with this file path.
        "%
        | optional,
      new-from-rev
        | String
        | doc m%"
        Show only new issues created after this git revision.
        "%
        | optional,
      ..
    }
    | optional,
  linters
    | {
      disable
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf definitions.predicate.linters
        ])
        | doc m%"
        List of disabled linters.
        "%
        | optional,
      disable-all
        | Bool
        | doc m%"
        Whether to disable all linters. You can re-enable them with `enable` explicitly.
        "%
        | optional,
      enable
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf definitions.predicate.linters
        ])
        | doc m%"
        List of enabled linters.
        "%
        | optional,
      enable-all
        | Bool
        | doc m%"
        Whether to enable all linters. You can re-disable them with `disable` explicitly.
        "%
        | optional,
      fast
        | Bool
        | doc m%"
        Enable run of fast linters.
        "%
        | optional,
      presets
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.enum
          [
            "bugs",
            "comment",
            "complexity",
            "error",
            "format",
            "import",
            "metalinter",
            "module",
            "performance",
            "sql",
            "style",
            "test",
            "unused"
          ])
        ])
        | doc m%"
        Allow to use different presets of linters
        "%
        | optional,
      ..
    }
    | optional,
  linters-settings
    | {
      asasalint
        | {
          exclude
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf (predicates.isType '"String"),
              predicates.arrays.uniqueItems
            ])
            | doc m%"
            To specify a set of function names to exclude.
            "%
            | optional,
          ignore-test
            | Bool
            | doc m%"
            Ignore *_test.go files.
            "%
            | optional,
          use-builtin-exclusions
            | Bool
            | doc m%"
            To enable/disable the asasalint builtin exclusions of function names.
            "%
            | optional,
          ..
        }
        | optional,
      bidichk
        | {
          first-strong-isolate
            | Bool
            | doc m%"
            Disallow: FIRST-STRONG-ISOLATE
            "%
            | optional,
          left-to-right-embedding
            | Bool
            | doc m%"
            Disallow: LEFT-TO-RIGHT-EMBEDDING
            "%
            | optional,
          left-to-right-isolate
            | Bool
            | doc m%"
            Disallow: LEFT-TO-RIGHT-ISOLATE
            "%
            | optional,
          left-to-right-override
            | Bool
            | doc m%"
            Disallow: LEFT-TO-RIGHT-OVERRIDE
            "%
            | optional,
          pop-directional-formatting
            | Bool
            | doc m%"
            Disallow: POP-DIRECTIONAL-FORMATTING
            "%
            | optional,
          pop-directional-isolate
            | Bool
            | doc m%"
            Disallow: POP-DIRECTIONAL-ISOLATE
            "%
            | optional,
          right-to-left-embedding
            | Bool
            | doc m%"
            Disallow: RIGHT-TO-LEFT-EMBEDDING
            "%
            | optional,
          right-to-left-isolate
            | Bool
            | doc m%"
            Disallow: RIGHT-TO-LEFT-ISOLATE
            "%
            | optional,
          right-to-left-override
            | Bool
            | doc m%"
            Disallow: RIGHT-TO-LEFT-OVERRIDE
            "%
            | optional,
          ..
        }
        | optional,
      custom
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record {  }
          {
            "^.*$" = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "path" ],
                  predicates.records.record
                  {
                    description = predicates.isType '"String",
                    original-url = predicates.isType '"String",
                    path = predicates.isType '"String",
                  }
                  {  }
                  true
                  predicates.always
                ],
          }
          true
          predicates.always
        ])
        | doc m%"
        The custom section can be used to define linter plugins to be loaded at runtime. See README of golangci-lint for more information.
        Each custom linter should have a unique name.
        "%
        | optional,
      cyclop
        | {
          max-complexity
            | predicates.contract_from_predicate
            (predicates.allOf
            [ predicates.isType 'Integer, predicates.numbers.minimum 0 ])
            | doc m%"
            Max complexity the function can have
            "%
            | optional,
          package-average
            | predicates.contract_from_predicate
            (predicates.allOf
            [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
            | doc m%"
            Max average complexity in package
            "%
            | optional,
          skip-tests
            | Bool
            | doc m%"
            Should the linter execute on test files as well
            "%
            | optional,
          ..
        }
        | optional,
      decorder
        | {
          dec-order
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf
              (predicates.enum [ "type", "const", "var", "func" ])
            ])
            | optional,
          disable-dec-num-check
            | Bool
            | doc m%"
            Multiple global type, const and var declarations are allowed
            "%
            | optional,
          disable-dec-order-check
            | Bool
            | doc m%"
            Order of declarations is not checked
            "%
            | optional,
          disable-init-func-first-check
            | Bool
            | doc m%"
            Allow init func to be anywhere in file
            "%
            | optional,
          ..
        }
        | optional,
      depguard
        | {
          rules
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.record {  }
              {
                "^[^.]+$" = predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record
                      {
                        allow = predicates.allOf
                            [
                              predicates.isType '"Array",
                              predicates.arrays.arrayOf
                              (predicates.isType '"String"),
                              predicates.records.record {  } {  } false
                              predicates.never
                            ],
                        deny = predicates.allOf
                            [
                              predicates.isType '"Array",
                              predicates.arrays.arrayOf
                              (predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  desc = predicates.isType '"String",
                                  pkg = predicates.isType '"String",
                                }
                                {  }
                                false
                                predicates.never
                              ]),
                              predicates.records.record {  } {  } false
                              predicates.never
                            ],
                        files = predicates.allOf
                            [
                              predicates.isType '"Array",
                              predicates.arrays.arrayOf
                              (predicates.isType '"String"),
                              predicates.records.record {  } {  } false
                              predicates.never
                            ],
                      }
                      {  }
                      false
                      predicates.never
                    ],
              }
              false
              predicates.never
            ])
            | doc m%"
            Rules to apply.
            "%
            | optional,
        }
        | optional,
      dogsled
        | {
          max-blank-identifiers
            | predicates.contract_from_predicate
            (predicates.allOf
            [ predicates.isType 'Integer, predicates.numbers.minimum 0 ])
            | doc m%"
            Check assignments with too many blank identifiers.
            "%
            | optional,
          ..
        }
        | optional,
      dupl
        | {
          threshold
            | predicates.contract_from_predicate
            (predicates.allOf
            [ predicates.isType 'Integer, predicates.numbers.minimum 0 ])
            | doc m%"
            Tokens count to trigger issue.
            "%
            | optional,
          ..
        }
        | optional,
      dupword
        | {
          keywords
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf (predicates.isType '"String"),
              predicates.arrays.uniqueItems
            ])
            | doc m%"
            Keywords for detecting duplicate words. If this list is not empty, only the words defined in this list will be detected.
            "%
            | optional,
          ..
        }
        | optional,
      errcheck
        | {
          check-blank
            | Bool
            | doc m%"
            Report about assignment of errors to blank identifier
            "%
            | optional,
          check-type-assertions
            | Bool
            | doc m%"
            Report about not checking errors in type assertions, i.e.: `a := b.(MyStruct)`
            "%
            | optional,
          disable-default-exclusions
            | Bool
            | doc m%"
            To disable the errcheck built-in exclude list
            "%
            | optional,
          exclude
            | String
            | doc m%"
            DEPRECATED: use `exclude-functions` instead. Path to a file containing a list of functions to exclude from checking.
            "%
            | optional,
          exclude-functions
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf (predicates.isType '"String")
            ])
            | doc m%"
            List of functions to exclude from checking, where each entry is a single function to exclude
            "%
            | optional,
          ignore
            | String
            | doc m%"
            DEPRECATED: use `exclude-functions` instead. Comma-separated list of pairs of the form "pkg:regex".
            "%
            | optional,
          ..
        }
        | optional,
      errchkjson
        | {
          check-error-free-encoding | Bool | optional,
          report-no-exported
            | Bool
            | doc m%"
            Issue on struct that doesn't have exported fields.
            "%
            | optional,
          ..
        }
        | optional,
      errorlint
        | {
          asserts
            | Bool
            | doc m%"
            Check for plain type assertions and type switches.
            "%
            | optional,
          comparison
            | Bool
            | doc m%"
            Check for plain error comparisons
            "%
            | optional,
          errorf
            | Bool
            | doc m%"
            Check whether fmt.Errorf uses the %w verb for formatting errors
            "%
            | optional,
          errorf-multi
            | Bool
            | doc m%"
            Permit more than 1 %w verb, valid per Go 1.20
            "%
            | optional,
          ..
        }
        | optional,
      exhaustive
        | {
          check
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf (predicates.isType '"String"),
              predicates.arrays.uniqueItems
            ])
            | doc m%"
            Program elements to check for exhaustiveness.
            "%
            | optional,
          check-generated
            | Bool
            | doc m%"
            Check switch statements in generated files
            "%
            | optional,
          default-signifies-exhaustive
            | Bool
            | doc m%"
            Presence of `default` case in switch statements satisfies exhaustiveness, even if all enum members are not listed.
            "%
            | optional,
          explicit-exhaustive-map
            | Bool
            | doc m%"
            Only run exhaustive check on map literals with "//exhaustive:enforce" comment.
            "%
            | optional,
          explicit-exhaustive-switch
            | Bool
            | doc m%"
            Only run exhaustive check on switches with "//exhaustive:enforce" comment.
            "%
            | optional,
          ignore-enum-members
            | String
            | doc m%"
            Enum members matching `regex` do not have to be listed in switch statements to satisfy exhaustiveness
            "%
            | optional,
          ignore-enum-types
            | String
            | doc m%"
            Enum types matching the supplied regex do not have to be listed in switch statements to satisfy exhaustiveness.
            "%
            | optional,
          package-scope-only
            | Bool
            | doc m%"
            Consider enums only in package scopes, not in inner scopes.
            "%
            | optional,
          ..
        }
        | optional,
      exhaustivestruct
        | {
          struct-patterns
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf (predicates.isType '"String")
            ])
            | doc m%"
            Struct Patterns is list of expressions to match struct packages (written using `path` matching syntax)
            "%
            | optional,
          ..
        }
        | optional,
      exhaustruct
        | {
          exclude
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf (predicates.isType '"String")
            ])
            | doc m%"
            List of regular expressions to exclude struct packages and names from check.
            "%
            | optional,
          include
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf (predicates.isType '"String")
            ])
            | doc m%"
            List of regular expressions to match struct packages and names.
            "%
            | optional,
          ..
        }
        | optional,
      forbidigo
        | {
          analyze-types
            | Bool
            | doc m%"
            Instead of matching the literal source code, use type information to replace expressions with strings that contain the package name and (for methods and fields) the type name.
            "%
            | optional,
          exclude-godoc-examples
            | Bool
            | doc m%"
            Exclude code in godoc examples.
            "%
            | optional,
          forbid
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf
              (predicates.anyOf
              [
                predicates.isType '"String",
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    msg = predicates.isType '"String",
                    p = predicates.isType '"String",
                    pkg = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ]
              ])
            ])
            | doc m%"
            List of identifiers to forbid (written using `regexp`)
            "%
            | optional,
        }
        | optional,
      funlen
        | {
          lines
            | std.number.Integer
            | doc m%"
            Limit lines number per function.
            "%
            | optional,
          statements
            | std.number.Integer
            | doc m%"
            Limit statements number per function
            "%
            | optional,
        }
        | optional,
      gci
        | {
          custom-order
            | Bool
            | doc m%"
            Enable custom order of sections.
            "%
            | optional,
          local-prefixes
            | String
            | doc m%"
            DEPRECATED: use 'sections' and 'prefix(github.com/org/project)' instead.
            "%
            | optional,
          sections
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf (predicates.isType '"String")
            ])
            | doc m%"
            Section configuration to compare against.
            "%
            | optional,
          skip-generated
            | Bool
            | doc m%"
            Skip generated files.
            "%
            | optional,
          ..
        }
        | optional,
      ginkgolinter
        | {
          allow-havelen-zero
            | Bool
            | doc m%"
            Don't trigger warnings for HaveLen(0).
            "%
            | optional,
          suppress-async-assertion
            | Bool
            | doc m%"
            Suppress the function all in async assertion warning.
            "%
            | optional,
          suppress-compare-assertion
            | Bool
            | doc m%"
            Suppress the wrong comparison assertion warning.
            "%
            | optional,
          suppress-err-assertion
            | Bool
            | doc m%"
            Suppress the wrong error assertion warning.
            "%
            | optional,
          suppress-len-assertion
            | Bool
            | doc m%"
            Suppress the wrong length assertion warning.
            "%
            | optional,
          suppress-nil-assertion
            | Bool
            | doc m%"
            Suppress the wrong nil assertion warning.
            "%
            | optional,
          ..
        }
        | optional,
      gocognit
        | {
          min-complexity
            | std.number.Integer
            | doc m%"
            Minimal code complexity to report (we recommend 10-20).
            "%
            | optional,
          ..
        }
        | optional,
      goconst
        | {
          ignore-calls
            | Bool
            | doc m%"
            Ignore when constant is not used as function argument
            "%
            | optional,
          ignore-tests
            | Bool
            | doc m%"
            Ignore test files.
            "%
            | optional,
          match-constant
            | Bool
            | doc m%"
            Look for existing constants matching the values
            "%
            | optional,
          max
            | std.number.Integer
            | doc m%"
            Maximum value, only works with `numbers`
            "%
            | optional,
          min
            | std.number.Integer
            | doc m%"
            Minimum value, only works with `numbers`
            "%
            | optional,
          min-len
            | std.number.Integer
            | doc m%"
            Minimum length of string constant.
            "%
            | optional,
          min-occurrences
            | std.number.Integer
            | doc m%"
            Minimum occurrences count to trigger.
            "%
            | optional,
          numbers
            | Bool
            | doc m%"
            Search also for duplicated numbers.
            "%
            | optional,
          ..
        }
        | optional,
      gocritic
        | {
          disabled-checks
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf definitions.predicate.gocritic-checks
            ])
            | doc m%"
            Which checks should be disabled.
            "%
            | optional,
          disabled-tags
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf definitions.predicate.gocritic-tags
            ])
            | doc m%"
            Disable multiple checks by tags, run `GL_DEBUG=gocritic golangci-lint run` to see all tags and checks.
            "%
            | optional,
          enabled-checks
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf definitions.predicate.gocritic-checks
            ])
            | doc m%"
            Which checks should be enabled. By default, a list of stable checks is used. To see it, run `GL_DEBUG=gocritic golangci-lint run`.
            "%
            | optional,
          enabled-tags
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf definitions.predicate.gocritic-tags
            ])
            | doc m%"
            Enable multiple checks by tags, run `GL_DEBUG=gocritic golangci-lint run` to see all tags and checks.
            "%
            | optional,
          settings
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.propertyNames
              definitions.predicate.gocritic-checks,
              predicates.records.record {  } {  } true predicates.always
            ])
            | doc m%"
            Settings passed to gocritic. Properties must be valid and enabled check names.
            "%
            | optional,
          ..
        }
        | optional,
      gocyclo
        | {
          min-complexity
            | std.number.Integer
            | doc m%"
            Minimum code complexity to report (we recommend 10-20).
            "%
            | optional,
          ..
        }
        | optional,
      godot
        | {
          capital
            | Bool
            | doc m%"
            Check that each sentence starts with a capital letter.
            "%
            | optional,
          check-all
            | Bool
            | doc m%"
            DEPRECATED: Check all top-level comments, not only declarations.
            "%
            | optional,
          exclude
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf (predicates.isType '"String")
            ])
            | doc m%"
            List of regexps for excluding particular comment lines from check.
            "%
            | optional,
          period
            | Bool
            | doc m%"
            Check that each sentence ends with a period.
            "%
            | optional,
          scope
            | predicates.contract_from_predicate
            (predicates.enum [ "declarations", "toplevel", "all" ])
            | doc m%"
            Comments to be checked.
            "%
            | optional,
          ..
        }
        | optional,
      godox
        | {
          keywords
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf (predicates.isType '"String")
            ])
            | doc m%"
            Report any comments starting with one of theses keywords. This is useful for TODO or FIXME comments that might be left in the code accidentally and should be resolved before merging.
            "%
            | optional,
          ..
        }
        | optional,
      gofmt
        | {
          rewrite-rules
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf
              (predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  pattern = predicates.isType '"String",
                  replacement = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ])
            ])
            | doc m%"
            Apply the rewrite rules to the source before reformatting.
            "%
            | optional,
          simplify
            | Bool
            | doc m%"
            Simplify code.
            "%
            | optional,
          ..
        }
        | optional,
      gofumpt
        | {
          extra-rules
            | Bool
            | doc m%"
            Choose whether or not to use the extra rules that are disabled by default.
            "%
            | optional,
          lang-version
            | String
            | doc m%"
            Select the Go version to target.
            "%
            | optional,
          module-path
            | String
            | doc m%"
             Module path which contains the source code being formatted.
            "%
            | optional,
          ..
        }
        | optional,
      goheader
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType 'Record,
          predicates.allOf
          [
            predicates.records.record
            {
              values = predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      const = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.record {  }
                            { "^.+$" = predicates.isType '"String", }
                            false
                            predicates.never
                          ],
                      regexp = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.record {  }
                            { "^.+$" = predicates.isType '"String", }
                            false
                            predicates.never
                          ],
                    }
                    {  }
                    true
                    predicates.always
                  ],
            }
            {  }
            true
            predicates.always,
            predicates.oneOf
            [
              predicates.allOf
              [
                predicates.records.required [ "template" ],
                predicates.records.record
                { template = predicates.isType '"String", }
                {  }
                true
                predicates.always
              ],
              predicates.allOf
              [
                predicates.records.required [ "template-path" ],
                predicates.records.record
                { template-path = predicates.isType '"String", }
                {  }
                true
                predicates.always
              ]
            ]
          ]
        ])
        | optional,
      goimports
        | {
          local-prefixes
            | String
            | doc m%"
            Put imports beginning with prefix after 3rd-party packages. It is a comma-separated list of prefixes.
            "%
            | optional,
          ..
        }
        | optional,
      golint
        | {
          min-confidence
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Number",
              predicates.numbers.exclusiveMaximum 1,
              predicates.numbers.minimum 0
            ])
            | doc m%"
            Minimum confidence for issues.
            "%
            | optional,
          ..
        }
        | optional,
      gomnd
        | {
          checks
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf
              (predicates.enum
              [
                "argument",
                "case",
                "condition",
                "operation",
                "return",
                "assign"
              ])
            ])
            | doc m%"
            The list of enabled checks, see https://github.com/tommy-muehle/go-mnd/#checks for description.
            "%
            | optional,
          ignored-files
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf (predicates.isType '"String")
            ])
            | doc m%"
            List of file patterns to exclude from analysis.
            "%
            | optional,
          ignored-functions
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf (predicates.isType '"String")
            ])
            | doc m%"
            Comma-separated list of function patterns to exclude from the analysis.
            "%
            | optional,
          ignored-numbers
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf (predicates.isType '"String")
            ])
            | doc m%"
            List of numbers to exclude from analysis.
            "%
            | optional,
          settings
            | {
              mnd
                | {
                  checks
                    | predicates.contract_from_predicate
                    (predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.enum
                      [
                        "argument",
                        "case",
                        "condition",
                        "operation",
                        "return",
                        "assign"
                      ])
                    ])
                    | doc m%"
                    The list of enabled checks.
                    "%
                    | optional,
                  ignored-files
                    | String
                    | doc m%"
                    Comma-separated list of file patterns to exclude from the analysis.
                    "%
                    | optional,
                  ignored-functions
                    | String
                    | doc m%"
                    Comma-separated list of function patterns to exclude from the analysis.
                    "%
                    | optional,
                  ignored-numbers
                    | String
                    | doc m%"
                    Comma-separated list of numbers to exclude from the analysis.
                    "%
                    | optional,
                  ..
                }
                | optional,
              ..
            }
            | optional,
          ..
        }
        | optional,
      gomodguard
        | {
          allowed
            | {
              domains
                | predicates.contract_from_predicate
                (predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ])
                | doc m%"
                List of allowed module domains.
                "%
                | optional,
              modules
                | predicates.contract_from_predicate
                (predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ])
                | doc m%"
                List of allowed modules.
                "%
                | optional,
              ..
            }
            | optional,
          blocked
            | {
              local_replace_directives
                | Bool
                | doc m%"
                Raise lint issues if loading local path with replace directive
                "%
                | optional,
              modules
                | predicates.contract_from_predicate
                (predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    {
                      "^.+$" = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.record
                            {
                              reason = predicates.isType '"String",
                              recommendations = predicates.allOf
                                  [
                                    predicates.isType '"Array",
                                    predicates.arrays.arrayOf
                                    (predicates.isType '"String")
                                  ],
                            }
                            {  }
                            true
                            predicates.always
                          ],
                    }
                    false
                    predicates.never
                  ])
                ])
                | doc m%"
                List of blocked modules.
                "%
                | optional,
              versions
                | predicates.contract_from_predicate
                (predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    {
                      "^.*$" = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "reason" ],
                            predicates.records.record
                            {
                              reason = predicates.isType '"String",
                              version = predicates.isType '"String",
                            }
                            {  }
                            true
                            predicates.always
                          ],
                    }
                    true
                    predicates.always
                  ])
                ])
                | doc m%"
                List of blocked module version constraints.
                "%
                | optional,
              ..
            }
            | optional,
          ..
        }
        | optional,
      gosec
        | {
          concurrency
            | std.number.Integer
            | doc m%"
            Concurrency value
            "%
            | optional,
          confidence
            | std.enum.TagOrString
            | [| 'high, 'medium, 'low |]
            | doc m%"
            Filter out the issues with a lower confidence than the given value
            "%
            | optional,
          config
            | {  .. }
            | doc m%"
            To specify the configuration of rules
            "%
            | optional,
          exclude-generated
            | Bool
            | doc m%"
            Exclude generated files
            "%
            | optional,
          excludes
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf definitions.predicate.gosec-rules
            ])
            | doc m%"
            To specify a set of rules to explicitly exclude
            "%
            | optional,
          includes
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf definitions.predicate.gosec-rules
            ])
            | doc m%"
            To select a subset of rules to run
            "%
            | optional,
          severity
            | std.enum.TagOrString
            | [| 'high, 'medium, 'low |]
            | doc m%"
            Filter out the issues with a lower severity than the given value
            "%
            | optional,
          ..
        }
        | optional,
      gosimple
        | {
          checks
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf
              (predicates.anyOf
              [ predicates.enum [ "all" ], predicates.isType '"String" ])
            ])
            | optional,
          go
            | String
            | doc m%"
            Targeted Go version
            "%
            | optional,
          ..
        }
        | optional,
      gosmopolitan
        | {
          allow-time-local
            | Bool
            | doc m%"
            Allow and ignore `time.Local` usages.
            "%
            | optional,
          escape-hatches
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf (predicates.isType '"String")
            ])
            | doc m%"
            List of fully qualified names in the `full/pkg/path.name` form, to act as "i18n escape hatches".
            "%
            | optional,
          ignore-tests
            | Bool
            | doc m%"
            Ignore test files.
            "%
            | optional,
          watch-for-scripts
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf (predicates.isType '"String")
            ])
            | doc m%"
            List of Unicode scripts to watch for any usage in string literals.
            "%
            | optional,
          ..
        }
        | optional,
      govet
        | {
          check-shadowing
            | Bool
            | doc m%"
            Report shadowed variables.
            "%
            | optional,
          disable
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf definitions.predicate.govet-analyzers
            ])
            | doc m%"
            Disable analyzers by name.
            "%
            | optional,
          disable-all
            | Bool
            | doc m%"
            Disable all analyzers.
            "%
            | optional,
          enable
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf definitions.predicate.govet-analyzers
            ])
            | doc m%"
            Enable analyzers by name.
            "%
            | optional,
          enable-all
            | Bool
            | doc m%"
            Enable all analyzers.
            "%
            | optional,
          settings
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.propertyNames
              definitions.predicate.govet-analyzers,
              predicates.records.record {  }
              { "^.*$" = predicates.isType 'Record, }
              true
              predicates.always
            ])
            | doc m%"
            Settings per analyzer. Map of analyzer name to specific settings.
            Run `go tool vet help` to find out more.
            "%
            | optional,
          ..
        }
        | optional,
      grouper
        | {
          const-require-grouping | Bool | optional,
          const-require-single-const | Bool | optional,
          import-require-grouping | Bool | optional,
          import-require-single-const | Bool | optional,
          type-require-grouping | Bool | optional,
          type-require-single-const | Bool | optional,
          var-require-grouping | Bool | optional,
          var-require-single-const | Bool | optional,
          ..
        }
        | optional,
      ifshort
        | {
          max-decl-chars
            | predicates.contract_from_predicate
            (predicates.allOf
            [ predicates.isType 'Integer, predicates.numbers.minimum 1 ])
            | doc m%"
            maximum length of variable declaration measured in number of characters, after which the linter won't suggest using short syntax.
            "%
            | optional,
          max-decl-lines
            | predicates.contract_from_predicate
            (predicates.allOf
            [ predicates.isType 'Integer, predicates.numbers.minimum 1 ])
            | doc m%"
            maximum length of variable declaration measured in numbers of lines, after which the linter won't suggest using short syntax. Has precedence over max-decl-chars
            "%
            | optional,
          ..
        }
        | optional,
      importas
        | {
          alias
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf
              (predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "alias", "pkg" ],
                predicates.records.record
                {
                  alias = predicates.isType '"String",
                  pkg = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ])
            ])
            | doc m%"
            List of aliases
            "%
            | optional,
          no-extra-aliases
            | Bool
            | doc m%"
            Do not allow non-required aliases.
            "%
            | optional,
          no-unaliased
            | Bool
            | doc m%"
            Do not allow unaliased imports of aliased packages.
            "%
            | optional,
          ..
        }
        | optional,
      interfacebloat
        | {
          max
            | std.number.Integer
            | doc m%"
            The maximum number of methods allowed for an interface.
            "%
            | optional,
          ..
        }
        | optional,
      ireturn
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType 'Record,
          predicates.anyOf
          [
            predicates.allOf
            [
              predicates.not
              (predicates.records.record { allow = predicates.const "reject", }
              {  }
              true
              predicates.always),
              predicates.records.required [ "allow" ],
              predicates.records.record {  } {  } true predicates.always
            ],
            predicates.allOf
            [
              predicates.records.required [ "reject" ],
              predicates.records.record {  } {  } true predicates.always
            ]
          ],
          predicates.records.record
          {
            allowed = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.enum [ "anon", "error", "empty", "stdlib" ]
                  ])
                ],
            reject = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.enum [ "anon", "error", "empty", "stdlib" ]
                  ])
                ],
          }
          {  }
          true
          predicates.always
        ])
        | doc m%"
        Use either `reject` or `allow` properties for interfaces matching.
        "%
        | optional,
      lll
        | {
          line-length
            | predicates.contract_from_predicate
            (predicates.allOf
            [ predicates.isType 'Integer, predicates.numbers.minimum 1 ])
            | doc m%"
            Maximum allowed line length, lines longer will be reported.
            "%
            | optional,
          tab-width
            | predicates.contract_from_predicate
            (predicates.allOf
            [ predicates.isType 'Integer, predicates.numbers.minimum 0 ])
            | doc m%"
            Width of "\t" in spaces.
            "%
            | optional,
          ..
        }
        | optional,
      loggercheck
        | {
          kitlog
            | Bool
            | doc m%"
            Allow check for the github.com/go-kit/log library.
            "%
            | optional,
          klog
            | Bool
            | doc m%"
            Allow check for the k8s.io/klog/v2 library.
            "%
            | optional,
          logr
            | Bool
            | doc m%"
            Allow check for the github.com/go-logr/logr library.
            "%
            | optional,
          no-printf-like
            | Bool
            | doc m%"
            Require printf-like format specifier (%s, %d for example) not present.
            "%
            | optional,
          require-string-key
            | Bool
            | doc m%"
            Require all logging keys to be inlined constant strings.
            "%
            | optional,
          rules
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf (predicates.isType '"String")
            ])
            | doc m%"
            List of custom rules to check against, where each rule is a single logger pattern, useful for wrapped loggers.
            "%
            | optional,
          zap
            | Bool
            | doc m%"
            Allow check for the "sugar logger" from go.uber.org/zap library.
            "%
            | optional,
          ..
        }
        | optional,
      maintidx
        | {
          under
            | Number
            | doc m%"
            Minimum accatpable maintainability index level (see https://docs.microsoft.com/en-us/visualstudio/code-quality/code-metrics-maintainability-index-range-and-meaning?view=vs-2022)
            "%
            | optional,
          ..
        }
        | doc m%"
        Maintainability index https://docs.microsoft.com/en-us/visualstudio/code-quality/code-metrics-maintainability-index-range-and-meaning?view=vs-2022
        "%
        | optional,
      makezero
        | {
          suggest-new
            | Bool
            | doc m%"
            Allow only slices initialized with a length of zero.
            "%
            | optional,
          ..
        }
        | optional,
      maligned
        | {
          suggest-new
            | Bool
            | doc m%"
            Whether to print struct with more effective memory layout.
            "%
            | optional,
          ..
        }
        | optional,
      misspell
        | {
          ignore-words
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf (predicates.isType '"String")
            ])
            | doc m%"
            List of words to ignore.
            "%
            | optional,
          locale
            | predicates.contract_from_predicate
            (predicates.enum [ "US", "UK" ])
            | optional,
          ..
        }
        | doc m%"
        Correct spellings using locale preferences for US or UK. Default is to use a neutral variety of English.
        "%
        | optional,
      musttag
        | {
          functions
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf
              (predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  arg-pos = predicates.isType 'Integer,
                  name = predicates.isType '"String",
                  tag = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ])
            ])
            | optional,
          ..
        }
        | optional,
      nakedret
        | {
          max-func-lines
            | predicates.contract_from_predicate
            (predicates.allOf
            [ predicates.isType 'Integer, predicates.numbers.minimum 0 ])
            | doc m%"
            Report if a function has more lines of code than this value and it has naked returns.
            "%
            | optional,
          ..
        }
        | optional,
      nestif
        | {
          min-complexity
            | std.number.Integer
            | doc m%"
            Minimum complexity of "if" statements to report.
            "%
            | optional,
          ..
        }
        | optional,
      nilnil
        | {
          checked-types
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf
              (predicates.enum [ "ptr", "func", "iface", "map", "chan" ])
            ])
            | doc m%"
            Order of return types to check.
            "%
            | optional,
          ..
        }
        | optional,
      nlreturn
        | {
          block-size
            | predicates.contract_from_predicate
            (predicates.allOf
            [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
            | doc m%"
            set block size that is still ok
            "%
            | optional,
          ..
        }
        | optional,
      nolintlint
        | {
          allow-no-explanation
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf definitions.predicate.linters
            ])
            | doc m%"
            Exclude these linters from requiring an explanation.
            "%
            | optional,
          allow-unused
            | Bool
            | doc m%"
            Enable to ensure that nolint directives are all used.
            "%
            | optional,
          require-explanation
            | Bool
            | doc m%"
            Enable to require an explanation of nonzero length after each nolint directive.
            "%
            | optional,
          require-specific
            | Bool
            | doc m%"
            Enable to require nolint directives to mention the specific linter being suppressed.
            "%
            | optional,
          ..
        }
        | optional,
      nonamedreturns
        | {
          report-error-in-defer
            | Bool
            | doc m%"
            Report named error if it is assigned inside defer.
            "%
            | optional,
          ..
        }
        | optional,
      paralleltest
        | {
          ignore-missing
            | Bool
            | doc m%"
            Ignore missing calls to `t.Parallel()` and only report incorrect uses of it.
            "%
            | optional,
          ..
        }
        | optional,
      prealloc
        | {
          for-loops
            | Bool
            | doc m%"
            Report preallocation suggestions on for loops.
            "%
            | optional,
          range-loops
            | Bool
            | doc m%"
            Report preallocation suggestions on range loops.
            "%
            | optional,
          simple
            | Bool
            | doc m%"
            Report preallocation suggestions only on simple loops that have no returns/breaks/continues/gotos in them.
            "%
            | optional,
          ..
        }
        | doc m%"
        We do not recommend using this linter before doing performance profiling.
        For most programs usage of `prealloc` will be premature optimization.
        "%
        | optional,
      predeclared
        | {
          ignored
            | String
            | doc m%"
            Comma-separated list of predeclared identifiers to not report on.
            "%
            | optional,
          q
            | Bool
            | doc m%"
            Include method names and field names (i.e., qualified names) in checks.
            "%
            | optional,
          ..
        }
        | optional,
      promlinter
        | {
          disabled-linters
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf
              (predicates.enum
              [
                "Help",
                "MetricUnits",
                "Counter",
                "HistogramSummaryReserved",
                "MetricTypeInName",
                "ReservedChars",
                "CamelCase",
                "UnitAbbreviations"
              ])
            ])
            | optional,
          strict
            | predicates.contract_from_predicate predicates.always
            | optional,
          ..
        }
        | optional,
      reassign
        | {
          patterns
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf (predicates.isType '"String")
            ])
            | optional,
          ..
        }
        | optional,
      revive
        | {
          confidence | Number | optional,
          enable-all-rules | Bool | optional,
          ignore-generated-header | Bool | optional,
          max-open-files | std.number.Integer | optional,
          rules
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf
              (predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  arguments = predicates.isType '"Array",
                  disabled = predicates.isType '"Bool",
                  name = predicates.isType '"String",
                  severity = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "warning", "error" ]
                      ],
                }
                {  }
                true
                predicates.always
              ])
            ])
            | optional,
          severity | std.enum.TagOrString | [| 'error, 'warning |] | optional,
          ..
        }
        | optional,
      rowserrcheck
        | {
          packages
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf (predicates.isType '"String")
            ])
            | optional,
          ..
        }
        | optional,
      staticcheck
        | {
          checks
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf
              (predicates.anyOf
              [ predicates.enum [ "all" ], predicates.isType '"String" ])
            ])
            | optional,
          go
            | String
            | doc m%"
            Targeted Go version
            "%
            | optional,
          ..
        }
        | optional,
      stylecheck
        | {
          checks
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf
              (predicates.anyOf
              [ predicates.enum [ "all" ], predicates.isType '"String" ])
            ])
            | optional,
          dot-import-whitelist
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf (predicates.isType '"String")
            ])
            | doc m%"
            By default, ST1001 forbids all uses of dot imports in non-test packages. This setting allows setting a whitelist of import paths that can be dot-imported anywhere.
            "%
            | optional,
          go
            | String
            | doc m%"
            Targeted Go version
            "%
            | optional,
          http-status-code-whitelist
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf
              (predicates.enum
              [
                "100",
                "101",
                "102",
                "103",
                "200",
                "201",
                "202",
                "203",
                "204",
                "205",
                "206",
                "207",
                "208",
                "226",
                "300",
                "301",
                "302",
                "303",
                "304",
                "305",
                "306",
                "307",
                "308",
                "400",
                "401",
                "402",
                "403",
                "404",
                "405",
                "406",
                "407",
                "408",
                "409",
                "410",
                "411",
                "412",
                "413",
                "414",
                "415",
                "416",
                "417",
                "418",
                "421",
                "422",
                "423",
                "424",
                "425",
                "426",
                "428",
                "429",
                "431",
                "451",
                "500",
                "501",
                "502",
                "503",
                "504",
                "505",
                "506",
                "507",
                "508",
                "510",
                "511"
              ])
            ])
            | doc m%"
            ST1013 recommends using constants from the net/http package instead of hard-coding numeric HTTP status codes. This setting specifies a list of numeric status codes that this check does not complain about.
            "%
            | optional,
          initialisms
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf (predicates.isType '"String")
            ])
            | doc m%"
            ST1003 check, among other things, for the correct capitalization of initialisms. The set of known initialisms can be configured with this option.
            "%
            | optional,
          ..
        }
        | optional,
      tagalign
        | {
          align
            | Bool
            | doc m%"
            Align and sort can be used together or separately.
            "%
            | optional,
          order
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf (predicates.isType '"String")
            ])
            | doc m%"
            Specify the order of tags, the other tags will be sorted by name.
            "%
            | optional,
          sort
            | Bool
            | doc m%"
            Whether enable tags sort.
            "%
            | optional,
          ..
        }
        | optional,
      tagliatelle
        | {
          case
            | {
              rules
                | predicates.contract_from_predicate
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record {  }
                  {
                    "^.+$" = predicates.enum
                        [
                          "camel",
                          "pascal",
                          "kebab",
                          "snake",
                          "goCamel",
                          "goPascal",
                          "goKebab",
                          "goSnake",
                          "upper",
                          "upperSnake",
                          "lower",
                          "header"
                        ],
                  }
                  true
                  predicates.always
                ])
                | optional,
              use-field-name
                | Bool
                | doc m%"
                Use the struct field name to check the name of the struct tag.
                "%
                | optional,
              ..
            }
            | optional,
          ..
        }
        | optional,
      tenv
        | {
          all
            | Bool
            | doc m%"
            The option `all` will run against whole test files (`_test.go`) regardless of method/function signatures.
            "%
            | optional,
          ..
        }
        | optional,
      testpackage
        | {
          allow-packages
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf (predicates.isType '"String"),
              predicates.arrays.uniqueItems
            ])
            | doc m%"
            List of packages that don't end with _test that tests are allowed to be in.
            "%
            | optional,
          skip-regexp
            | String
            | doc m%"
            Files with names matching this regular expression are skipped.
            "%
            | optional,
          ..
        }
        | optional,
      thelper
        | {
          benchmark
            | {
              begin
                | Bool
                | doc m%"
                Check if `b.Helper()` begins helper function.
                "%
                | optional,
              first
                | Bool
                | doc m%"
                Check if *testing.B is first param of helper function.
                "%
                | optional,
              name
                | Bool
                | doc m%"
                Check if *testing.B param has b name.
                "%
                | optional,
              ..
            }
            | optional,
          fuzz
            | {
              begin
                | Bool
                | doc m%"
                Check if `f.Helper()` begins helper function.
                "%
                | optional,
              first
                | Bool
                | doc m%"
                Check if *testing.F is first param of helper function.
                "%
                | optional,
              name
                | Bool
                | doc m%"
                Check if *testing.F param has f name.
                "%
                | optional,
              ..
            }
            | optional,
          tb
            | {
              begin
                | Bool
                | doc m%"
                Check if `tb.Helper()` begins helper function.
                "%
                | optional,
              first
                | Bool
                | doc m%"
                Check if *testing.TB is first param of helper function.
                "%
                | optional,
              name
                | Bool
                | doc m%"
                Check if *testing.TB param has tb name.
                "%
                | optional,
              ..
            }
            | optional,
          test
            | {
              begin
                | Bool
                | doc m%"
                Check if `t.Helper()` begins helper function.
                "%
                | optional,
              first
                | Bool
                | doc m%"
                Check if *testing.T is first param of helper function.
                "%
                | optional,
              name
                | Bool
                | doc m%"
                Check if *testing.T param has t name.
                "%
                | optional,
              ..
            }
            | optional,
          ..
        }
        | optional,
      unparam
        | {
          check-exported
            | Bool
            | doc m%"
            Inspect exported functions. Set to true if no external program/library imports your code.
            
            WARNING: if you enable this setting, unparam will report a lot of false-positives in text editors:
            if it's called for subdir of a project it can't find external interfaces. All text editor integrations
            with golangci-lint call it on a directory with the changed file.
            "%
            | optional,
          ..
        }
        | optional,
      usestdlibvars
        | {
          constant-kind
            | Bool
            | doc m%"
            Suggest the use of constant.Kind.String().
            "%
            | optional,
          crypto-hash
            | Bool
            | doc m%"
            Suggest the use of crypto.Hash.String().
            "%
            | optional,
          default-rpc-path
            | Bool
            | doc m%"
            Suggest the use of rpc.DefaultXXPath.
            "%
            | optional,
          http-method
            | Bool
            | doc m%"
            Suggest the use of http.MethodXX.
            "%
            | optional,
          http-status-code
            | Bool
            | doc m%"
            Suggest the use of http.StatusXX.
            "%
            | optional,
          os-dev-null
            | Bool
            | doc m%"
            Suggest the use of os.DevNull.
            "%
            | optional,
          sql-isolation-level
            | Bool
            | doc m%"
            Suggest the use of sql.LevelXX.String().
            "%
            | optional,
          syslog-priority
            | Bool
            | doc m%"
            Suggest the use of syslog.Priority.
            "%
            | optional,
          time-layout
            | Bool
            | doc m%"
            Suggest the use of time.Layout.
            "%
            | optional,
          time-month
            | Bool
            | doc m%"
            Suggest the use of time.Month.String().
            "%
            | optional,
          time-weekday
            | Bool
            | doc m%"
            Suggest the use of time.Weekday.String().
            "%
            | optional,
          tls-signature-scheme
            | Bool
            | doc m%"
            Suggest the use of tls.SignatureScheme.String().
            "%
            | optional,
          ..
        }
        | optional,
      varcheck
        | {
          exported-fields
            | Bool
            | doc m%"
            Check usage of exported variables
            "%
            | optional,
          ..
        }
        | optional,
      varnamelen
        | {
          check-receiver
            | Bool
            | doc m%"
            Check method receiver names.
            "%
            | optional,
          check-return
            | Bool
            | doc m%"
            Check named return values.
            "%
            | optional,
          check-type-param
            | Bool
            | doc m%"
            Check type parameters.
            "%
            | optional,
          ignore-chan-recv-ok
            | Bool
            | doc m%"
            Ignore `ok` variables that hold the bool return value of a channel receive.
            "%
            | optional,
          ignore-decls
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf (predicates.isType '"String")
            ])
            | doc m%"
            Optional list of variable declarations that should be ignored completely.
            "%
            | optional,
          ignore-map-index-ok
            | Bool
            | doc m%"
            Ignore `ok` variables that hold the bool return value of a map index.
            "%
            | optional,
          ignore-names
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf (predicates.isType '"String")
            ])
            | doc m%"
            Optional list of variable names that should be ignored completely.
            "%
            | optional,
          ignore-type-assert-ok
            | Bool
            | doc m%"
            Ignore `ok` variables that hold the bool return value of a type assertion
            "%
            | optional,
          max-distance
            | std.number.Integer
            | doc m%"
            Variables used in at most this N-many lines will be ignored.
            "%
            | optional,
          min-name-length
            | std.number.Integer
            | doc m%"
            The minimum length of a variable's name that is considered `long`.
            "%
            | optional,
          ..
        }
        | optional,
      whitespace
        | {
          multi-func
            | Bool
            | doc m%"
            Enforces newlines (or comments) after every multi-line function signature
            "%
            | optional,
          multi-if
            | Bool
            | doc m%"
            Enforces newlines (or comments) after every multi-line if statement
            "%
            | optional,
          ..
        }
        | optional,
      wrapcheck
        | {
          ignoreInterfaceRegexps
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf (predicates.isType '"String")
            ])
            | doc m%"
            An array of glob patterns which, if matched to an underlying interface name, will ignore unwrapped errors returned from a function whose call is defined on the given interface.
            "%
            | optional,
          ignorePackageGlobs
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf (predicates.isType '"String")
            ])
            | doc m%"
            An array of glob patterns which, if any match the package of the function returning the error, will skip wrapcheck analysis for this error.
            "%
            | optional,
          ignoreSigRegexps
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf (predicates.isType '"String")
            ])
            | doc m%"
            An array of strings which specify regular expressions of signatures to ignore.
            "%
            | optional,
          ignoreSigs
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf (predicates.isType '"String")
            ])
            | doc m%"
            An array of strings which specify substrings of signatures to ignore.
            "%
            | optional,
          ..
        }
        | optional,
      wsl
        | {
          allow-assign-and-anything
            | Bool
            | doc m%"
            Controls if you may cuddle assignments and anything without needing an empty line between them.
            "%
            | optional,
          allow-assign-and-call
            | Bool
            | doc m%"
            Allow calls and assignments to be cuddled as long as the lines have any matching variables, fields or types.
            "%
            | optional,
          allow-cuddle-declarations
            | Bool
            | doc m%"
            Allow declarations (var) to be cuddled.
            "%
            | optional,
          allow-cuddle-with-calls
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf (predicates.isType '"String")
            ])
            | doc m%"
            A list of call idents that everything can be cuddled with.
            "%
            | optional,
          allow-cuddle-with-rhs
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf (predicates.isType '"String")
            ])
            | doc m%"
            AllowCuddleWithRHS is a list of right hand side variables that is allowed to be cuddled with anything.
            "%
            | optional,
          allow-multiline-assign
            | Bool
            | doc m%"
            Allow multiline assignments to be cuddled.
            "%
            | optional,
          allow-separated-leading-comment
            | Bool
            | doc m%"
            Allow leading comments to be separated with empty lines.
            "%
            | optional,
          allow-trailing-comment
            | Bool
            | doc m%"
            Allow trailing comments in ending of blocks.
            "%
            | optional,
          error-variable-names
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf (predicates.isType '"String")
            ])
            | doc m%"
            When force-err-cuddling is enabled this is a list of names used for error variables to check for in the conditional.
            "%
            | optional,
          force-case-trailing-whitespace
            | predicates.contract_from_predicate
            (predicates.allOf
            [ predicates.isType 'Integer, predicates.numbers.minimum 0 ])
            | doc m%"
            Force newlines in end of case at this limit (0 = never).
            "%
            | optional,
          force-err-cuddling
            | Bool
            | doc m%"
            Causes an error when an If statement that checks an error variable doesn't cuddle with the assignment of that variable.
            "%
            | optional,
          force-short-decl-cuddling
            | Bool
            | doc m%"
            Causes an error if a short declaration (:=) cuddles with anything other than another short declaration.
            "%
            | optional,
          strict-append
            | Bool
            | doc m%"
            If true, append is only allowed to be cuddled if appending value is matching variables, fields or types on line above.
            "%
            | optional,
          ..
        }
        | optional,
      ..
    }
    | doc m%"
    All available settings of specific linters.
    "%
    | optional,
  output
    | {
      format
        | predicates.contract_from_predicate
        (predicates.strings.pattern
        "^(,?(colored-line-number|line-number|json|colored-tab|tab|checkstyle|code-climate|junit-xml|github-actions|teamcity)(:[^,]+)?)+$")
        | doc m%"
        Output format to use.
        "%
        | optional,
      path-prefix
        | String
        | doc m%"
        Add a prefix to the output file references.
        "%
        | optional,
      print-issued-lines
        | Bool
        | doc m%"
        Print lines of code with issue.
        "%
        | optional,
      print-linter-name
        | Bool
        | doc m%"
        Print linter name in the end of issue text.
        "%
        | optional,
      unique-by-line
        | Bool
        | doc m%"
        Make issues output unique by line.
        "%
        | optional,
      ..
    }
    | doc m%"
    Output configuration options.
    "%
    | optional,
  run
    | {
      allow-parallel-runners
        | Bool
        | doc m%"
        Allow multiple parallel golangci-lint instances running. If disabled, golangci-lint acquires file lock on start.
        "%
        | optional,
      build-tags
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf (predicates.isType '"String")
        ])
        | doc m%"
        List of build tags to pass to all linters.
        "%
        | optional,
      concurrency
        | predicates.contract_from_predicate
        (predicates.allOf
        [ predicates.isType 'Integer, predicates.numbers.minimum 1 ])
        | doc m%"
        Number of concurrent runners. Defaults to the number of available CPU cores.
        "%
        | optional,
      go
        | String
        | doc m%"
        Targeted Go version.
        "%
        | optional,
      issue-exit-code
        | std.number.Integer
        | doc m%"
        Exit code when at least one issue was found.
        "%
        | optional,
      modules-download-mode
        | predicates.contract_from_predicate
        (predicates.enum [ "mod", "readonly", "vendor" ])
        | doc m%"
        Option to pass to "go list -mod={option}".
        See "go help modules" for more information.
        "%
        | optional,
      skip-dirs
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf (predicates.isType '"String")
        ])
        | doc m%"
        Which directories to skip: issues from them won't be reported.
        "%
        | optional,
      skip-dirs-use-default
        | Bool
        | doc m%"
        Enable skipping of directories "vendor", "third_party", "testdata", "examples", "Godeps", and "builtin".
        "%
        | optional,
      skip-files
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf (predicates.isType '"String")
        ])
        | doc m%"
        Which files to skip: they will be analyzed, but issues from them will not be reported.
        "%
        | optional,
      tests
        | Bool
        | doc m%"
        Enable inclusion of test files.
        "%
        | optional,
      timeout
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"String",
          predicates.strings.pattern "^\\d*[sm]$"
        ])
        | doc m%"
        Timeout for the analysis.
        "%
        | optional,
      ..
    }
    | doc m%"
    Options for analysis running,
    "%
    | optional,
  severity
    | {
      case-sensitive
        | Bool
        | doc m%"
        If set to true, severity-rules regular expressions become case sensitive.
        "%
        | optional,
      default-severity
        | String
        | doc m%"
        Set the default severity for issues. If severity rules are defined and the issues do not match or no severity is provided to the rule this will be the default severity applied. Severities should match the supported severity names of the selected out format.
        "%
        | optional,
      rules
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [
            predicates.oneOf
            [
              definitions.predicate.issue-match-path,
              definitions.predicate.issue-match-source,
              definitions.predicate.issue-match-linters,
              definitions.predicate.issue-match-text
            ],
            predicates.records.record
            { severity = predicates.isType '"String", }
            {  }
            true
            predicates.always
          ])
        ])
        | doc m%"
        When a list of severity rules are provided, severity information will be added to lint issues. Severity rules have the same filtering capability as exclude rules except you are allowed to specify one matcher per severity rule.
        Only affects out formats that support setting severity information.
        "%
        | optional,
      ..
    }
    | optional,
  ..
}