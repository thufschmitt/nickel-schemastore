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
          disallowNodeProcessParams = predicates.contract_from_predicate
              definitions.predicate.disallowNodeProcessParams,
          iobrokerObject = {
                _id | String,
                common | {  .. } | optional,
                type | String,
                ..
              },
          isCompactTrue = predicates.contract_from_predicate
              definitions.predicate.isCompactTrue,
          multilingual = predicates.contract_from_predicate
              definitions.predicate.multilingual,
        },
    predicate = {
          disallowNodeProcessParams = predicates.not
              (predicates.allOf
              [
                predicates.records.required [ "nodeProcessParams" ],
                predicates.records.record {  } {  } true predicates.always
              ]),
          iobrokerObject = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "_id", "type" ],
                predicates.records.record
                {
                  _id = predicates.isType '"String",
                  common = predicates.isType 'Record,
                  type = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          isCompactTrue = predicates.allOf
              [
                predicates.records.required [ "compact" ],
                predicates.records.record { compact = predicates.const true, }
                {  }
                true
                predicates.always
              ],
          multilingual = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "en" ],
                predicates.records.record {  }
                {
                  "en|de|ru|pt|nl|fr|it|es|pl|uk|zh-cn" = predicates.isType
                      '"String",
                }
                false
                predicates.never
              ],
        },
  }
in

{
  "$schema"
    | String
    | doc m%"
    JSON schema for validation
    "%
    | optional,
  common
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType 'Record,
      predicates.ifThenElse definitions.predicate.isCompactTrue
      definitions.predicate.disallowNodeProcessParams
      predicates.always,
      predicates.records.required
      [ "desc", "mode", "name", "news", "platform", "titleLang", "version" ],
      predicates.records.record
      {
        adminColumns = predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf
              (predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [ "align", "name", "path", "width" ],
                predicates.records.record
                {
                  align = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "left", "right", "center", "justify" ]
                      ],
                  edit = predicates.isType '"Bool",
                  name = predicates.anyOf
                      [
                        predicates.isType '"String",
                        definitions.predicate.multilingual
                      ],
                  objTypes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  path = predicates.isType '"String",
                  type = predicates.isType '"String",
                  width = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                }
                {  }
                true
                predicates.always
              ]),
              predicates.arrays.minItems 1
            ],
        adminTab = predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.required [ "fa-icon", "link", "name" ],
              predicates.records.record
              {
                fa-icon = predicates.isType '"String",
                ignoreConfigUpdate = predicates.isType '"Bool",
                link = predicates.isType '"String",
                name = definitions.predicate.multilingual,
                singleton = predicates.isType '"Bool",
              }
              {  }
              false
              predicates.never
            ],
        adminUI = predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.required [ "config" ],
              predicates.records.record
              {
                config = predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.enum [ "html", "json", "materialize", "none" ]
                    ],
                custom = predicates.allOf
                    [ predicates.isType '"String", predicates.const "json" ],
                tab = predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.enum [ "html", "materialize" ]
                    ],
              }
              {  }
              false
              predicates.never
            ],
        allowInit = predicates.isType '"Bool",
        authors = predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf
              (predicates.anyOf
              [
                predicates.isType '"String",
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "name" ],
                  predicates.records.record
                  {
                    email = predicates.isType '"String",
                    name = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ]
              ]),
              predicates.arrays.minItems 1
            ],
        availableModes = predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf
              (predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [
                  "none",
                  "daemon",
                  "subscribe",
                  "schedule",
                  "once",
                  "extension"
                ]
              ]),
              predicates.arrays.minItems 1
            ],
        blockedVersions = predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf (predicates.isType '"String")
            ],
        blockly = predicates.isType '"Bool",
        compact = predicates.isType '"Bool",
        connectionType = predicates.allOf
            [
              predicates.isType '"String",
              predicates.enum [ "none", "local", "cloud" ]
            ],
        controller = predicates.isType '"Bool",
        dataFolder = predicates.isType '"String",
        dataSource = predicates.allOf
            [
              predicates.isType '"String",
              predicates.enum [ "none", "poll", "push", "assumption" ]
            ],
        dependencies = predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf
              (predicates.anyOf
              [ predicates.isType 'Record, predicates.isType '"String" ])
            ],
        desc = definitions.predicate.multilingual,
        docs = predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.required [ "en" ],
              predicates.records.record {  }
              {
                "en|de|ru|pt|nl|fr|it|es|pl|uk|zh-cn" = predicates.allOf
                    [
                      predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Array"
                      ],
                      predicates.arrays.arrayOf (predicates.isType '"String"),
                      predicates.arrays.minItems 1
                    ],
              }
              false
              predicates.never
            ],
        enabled = predicates.isType '"Bool",
        eraseOnUpload = predicates.isType '"Bool",
        extIcon = predicates.isType '"String",
        getHistory = predicates.isType '"Bool",
        globalDependencies = predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf
              (predicates.anyOf
              [ predicates.isType 'Record, predicates.isType '"String" ])
            ],
        icon = predicates.isType '"String",
        keywords = predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf (predicates.isType '"String")
            ],
        license = predicates.allOf
            [
              predicates.isType '"String",
              predicates.enum
              [
                "Qhull",
                "NOSL",
                "CC-BY-ND-2.5",
                "O-UDA-1.0",
                "DRL-1.0",
                "ImageMagick",
                "mpich2",
                "CC-BY-SA-4.0",
                "SPL-1.0",
                "McPhee-slideshow",
                "MIT-enna",
                "OSL-2.1",
                "GFDL-1.2-or-later",
                "BSD-3-Clause-LBNL",
                "OFL-1.0-RFN",
                "Watcom-1.0",
                "MPL-1.0",
                "Aladdin",
                "etalab-2.0",
                "copyleft-next-0.3.0",
                "NLPL",
                "mplus",
                "ECL-1.0",
                "fwlw",
                "BlueOak-1.0.0",
                "JPNIC",
                "AFL-3.0",
                "CC-BY-NC-SA-2.0-FR",
                "GFDL-1.3-invariants-or-later",
                "CFITSIO",
                "GPL-1.0-only",
                "XSkat",
                "CC-BY-ND-2.0",
                "CC-BY-SA-3.0-IGO",
                "CC-BY-3.0-NL",
                "FSFUL",
                "HPND-export-US",
                "CATOSL-1.1",
                "ZPL-2.1",
                "CC-BY-NC-SA-2.0-DE",
                "OGL-UK-1.0",
                "BSD-3-Clause-No-Nuclear-Warranty",
                "TU-Berlin-2.0",
                "Saxpath",
                "ZPL-2.0",
                "Bitstream-Charter",
                "OpenSSL",
                "ClArtistic",
                "MPL-2.0-no-copyleft-exception",
                "X11",
                "FSFULLR",
                "CC-BY-4.0",
                "CC-BY-SA-3.0-DE",
                "CC-BY-SA-2.5",
                "MPEG-SSG",
                "LPPL-1.0",
                "FreeImage",
                "CERN-OHL-1.2",
                "Artistic-1.0-cl8",
                "LZMA-SDK-9.22",
                "BSD-3-Clause-No-Nuclear-License-2014",
                "CC-BY-ND-3.0-DE",
                "Afmparse",
                "CERN-OHL-S-2.0",
                "DOC",
                "GL2PS",
                "YPL-1.1",
                "GFDL-1.2-only",
                "CC-BY-NC-ND-3.0",
                "OFL-1.0-no-RFN",
                "Sendmail",
                "AGPL-3.0-only",
                "CECILL-2.0",
                "MIT-advertising",
                "snprintf",
                "CC-BY-ND-3.0",
                "CC-BY-2.5-AU",
                "NAIST-2003",
                "NBPL-1.0",
                "Ruby",
                "HPND-doc",
                "OSL-2.0",
                "GPL-2.0-only",
                "SMPPL",
                "LZMA-SDK-9.11-to-9.20",
                "OLDAP-2.6",
                "Parity-7.0.0",
                "Clips",
                "Symlinks",
                "OLDAP-1.1",
                "NICTA-1.0",
                "python-ldap",
                "LiLiQ-Rplus-1.1",
                "BSD-2-Clause-Patent",
                "CC-BY-SA-1.0",
                "LGPL-2.0-or-later",
                "Intel-ACPI",
                "CERN-OHL-P-2.0",
                "SSH-short",
                "Kazlib",
                "TOSL",
                "GLWTPL",
                "BSD-3-Clause-Modification",
                "OLDAP-2.2",
                "BSD-3-Clause-No-Nuclear-License",
                "TORQUE-1.1",
                "PSF-2.0",
                "CDDL-1.1",
                "CDL-1.0",
                "OSET-PL-2.1",
                "EUPL-1.2",
                "CAL-1.0",
                "OPL-UK-3.0",
                "Cronyx",
                "GFDL-1.1-or-later",
                "AFL-2.1",
                "AFL-1.2",
                "FDK-AAC",
                "BSD-1-Clause",
                "psfrag",
                "OFL-1.1-RFN",
                "CECILL-1.0",
                "TCP-wrappers",
                "CC-BY-NC-ND-2.0",
                "APL-1.0",
                "Knuth-CTAN",
                "MIT-testregex",
                "OSL-3.0",
                "Linux-man-pages-copyleft-2-para",
                "OLDAP-2.0.1",
                "Beerware",
                "Apache-2.0",
                "CAL-1.0-Combined-Work-Exception",
                "BSD-3-Clause-Sun",
                "MakeIndex",
                "GFDL-1.1-no-invariants-only",
                "UCL-1.0",
                "NASA-1.3",
                "IJG",
                "Xfig",
                "Noweb",
                "Mup",
                "CC-BY-2.0",
                "ODC-By-1.0",
                "blessing",
                "SSH-OpenSSH",
                "CC-BY-NC-2.0",
                "LPPL-1.2",
                "GFDL-1.3-invariants-only",
                "GFDL-1.2-no-invariants-only",
                "OFL-1.0",
                "SISSL-1.2",
                "TPL-1.0",
                "lsof",
                "AGPL-1.0-or-later",
                "MITNFA",
                "metamail",
                "Imlib2",
                "AFL-2.0",
                "EUPL-1.0",
                "AAL",
                "ssh-keyscan",
                "Soundex",
                "W3C-19980720",
                "W3C",
                "BitTorrent-1.1",
                "Spencer-99",
                "Sleepycat",
                "DL-DE-ZERO-2.0",
                "BSD-3-Clause",
                "BSD-4-Clause-Shortened",
                "SHL-0.51",
                "LGPL-2.1-only",
                "Parity-6.0.0",
                "MIT-0",
                "CC-PDDC",
                "ulem",
                "xinetd",
                "Linux-man-pages-1-para",
                "OLDAP-2.8",
                "OML",
                "ICU",
                "SGI-B-2.0",
                "ANTLR-PD-fallback",
                "dvipdfm",
                "EPL-2.0",
                "OLDAP-1.3",
                "Linux-man-pages-copyleft",
                "OFL-1.1-no-RFN",
                "ISC",
                "GFDL-1.1-invariants-only",
                "Adobe-2006",
                "CC-BY-NC-ND-1.0",
                "DSDP",
                "D-FSL-1.0",
                "SHL-0.5",
                "SchemeReport",
                "MulanPSL-1.0",
                "NTP",
                "Jam",
                "CC-BY-SA-2.0-UK",
                "BSD-3-Clause-Attribution",
                "Lucida-Bitmap-Fonts",
                "Zimbra-1.4",
                "CUA-OPL-1.0",
                "BSD-2-Clause",
                "Community-Spec-1.0",
                "OLDAP-2.0",
                "diffmark",
                "Abstyles",
                "Zeeff",
                "Brian-Gladman-3-Clause",
                "Bitstream-Vera",
                "Naumen",
                "SGI-OpenGL",
                "CC-BY-SA-2.1-JP",
                "CC-BY-ND-4.0",
                "MIT-Wu",
                "gnuplot",
                "SAX-PD",
                "HPND-doc-sell",
                "BitTorrent-1.0",
                "HP-1989",
                "OCLC-2.0",
                "MS-LPL",
                "Artistic-2.0",
                "GFDL-1.2-invariants-or-later",
                "JSON",
                "checkmk",
                "CC-BY-NC-SA-4.0",
                "Graphics-Gems",
                "GD",
                "0BSD",
                "MIT",
                "OCCT-PL",
                "LGPL-3.0-only",
                "AdaCore-doc",
                "CC-BY-NC-3.0",
                "Spencer-94",
                "HTMLTIDY",
                "GFDL-1.2-no-invariants-or-later",
                "BSD-4.3TAHOE",
                "Giftware",
                "MPL-1.1",
                "OGDL-Taiwan-1.0",
                "OLDAP-2.7",
                "RSA-MD",
                "Ferguson-Twofish",
                "BSD-Source-Code",
                "ASWF-Digital-Assets-1.0",
                "YPL-1.0",
                "OLDAP-2.1",
                "Glulxe",
                "PostgreSQL",
                "Fair",
                "APSL-1.0",
                "GPL-1.0-or-later",
                "libutil-David-Nugent",
                "SCEA",
                "BSD-3-Clause-No-Military-License",
                "Xnet",
                "MIT-feh",
                "AGPL-1.0-only",
                "Nokia",
                "Cornell-Lossless-JPEG",
                "swrule",
                "OSL-1.1",
                "EPL-1.0",
                "XFree86-1.1",
                "UCAR",
                "copyleft-next-0.3.1",
                "IJG-short",
                "Plexus",
                "Apache-1.1",
                "UPL-1.0",
                "HPND-DEC",
                "HP-1986",
                "GFDL-1.1-only",
                "QPL-1.0",
                "libpng-2.0",
                "Zlib",
                "GFDL-1.3-or-later",
                "CERN-OHL-1.1",
                "SugarCRM-1.1.3",
                "VSL-1.0",
                "NRL",
                "Zend-2.0",
                "OGL-Canada-2.0",
                "EUDatagrid",
                "MulanPSL-2.0",
                "Newsletr",
                "BSD-4-Clause-UC",
                "PolyForm-Small-Business-1.0.0",
                "MirOS",
                "Adobe-Utopia",
                "GFDL-1.1-no-invariants-or-later",
                "RPL-1.5",
                "TMate",
                "libtiff",
                "GPL-3.0-only",
                "CC-BY-SA-3.0",
                "Unicode-DFS-2016",
                "CC-BY-NC-3.0-DE",
                "NPL-1.0",
                "eGenix",
                "PolyForm-Noncommercial-1.0.0",
                "Crossword",
                "IEC-Code-Components-EULA",
                "HPND",
                "EFL-1.0",
                "OLDAP-1.4",
                "MMIXware",
                "OpenPBS-2.3",
                "Unicode-TOU",
                "CC-BY-3.0-DE",
                "EUPL-1.1",
                "SL",
                "Motosoto",
                "Caldera",
                "BSD-Inferno-Nettverk",
                "TAPR-OHL-1.0",
                "CC-BY-NC-SA-3.0",
                "CC-BY-NC-SA-1.0",
                "BSD-3-Clause-Open-MPI",
                "CC-BY-1.0",
                "PHP-3.01",
                "PADL",
                "AFL-1.1",
                "MIT-CMU",
                "BSD-3-Clause-flex",
                "ODbL-1.0",
                "CC-BY-NC-4.0",
                "Python-2.0.1",
                "IPA",
                "AML",
                "libselinux-1.0",
                "CC-BY-3.0-AT",
                "QPL-1.0-INRIA-2004",
                "GFDL-1.1-invariants-or-later",
                "Rdisc",
                "BSD-Attribution-HPND-disclaimer",
                "Xerox",
                "LPPL-1.1",
                "OGL-UK-3.0",
                "Minpack",
                "APSL-1.2",
                "Eurosym",
                "BSD-Advertising-Acknowledgement",
                "CC-BY-NC-SA-2.0-UK",
                "X11-distribute-modifications-variant",
                "w3m",
                "pnmstitch",
                "CPAL-1.0",
                "SISSL",
                "LiLiQ-R-1.1",
                "CC-BY-NC-SA-2.0",
                "Unlicense",
                "Linux-OpenIB",
                "LOOP",
                "CDLA-Sharing-1.0",
                "CC-BY-3.0",
                "OLDAP-2.4",
                "CMU-Mach",
                "LiLiQ-P-1.1",
                "LGPL-2.0-only",
                "APAFML",
                "Entessa",
                "CNRI-Python",
                "OGC-1.0",
                "HPND-UC",
                "CC-BY-3.0-IGO",
                "MTLL",
                "HPND-Markus-Kuhn",
                "CC-BY-NC-ND-3.0-IGO",
                "MS-RL",
                "AMDPLPA",
                "LAL-1.2",
                "OLDAP-2.2.1",
                "curl",
                "OLDAP-1.2",
                "Inner-Net-2.0",
                "TermReadKey",
                "Artistic-1.0",
                "CECILL-1.1",
                "IPL-1.0",
                "LPL-1.02",
                "Baekmuk",
                "NLOD-1.0",
                "Sendmail-8.23",
                "NGPL",
                "SSPL-1.0",
                "NCSA",
                "CC0-1.0",
                "CECILL-C",
                "Furuseth",
                "JasPer-2.0",
                "LGPL-3.0-or-later",
                "Libpng",
                "Linux-man-pages-copyleft-var",
                "OLDAP-2.2.2",
                "FreeBSD-DOC",
                "CC-BY-NC-ND-3.0-DE",
                "NIST-PD-fallback",
                "Widget-Workshop",
                "RPL-1.1",
                "ASWF-Digital-Assets-1.1",
                "Net-SNMP",
                "CC-BY-NC-SA-2.5",
                "Unicode-DFS-2015",
                "Intel",
                "SGP4",
                "Zimbra-1.3",
                "OGTSL",
                "PDDL-1.0",
                "UnixCrypt",
                "CERN-OHL-W-2.0",
                "GFDL-1.3-only",
                "CC-BY-NC-2.5",
                "ErlPL-1.1",
                "magaz",
                "Borceux",
                "App-s2p",
                "CC-BY-NC-ND-4.0",
                "CECILL-2.1",
                "OGL-UK-2.0",
                "BSD-Protection",
                "CECILL-B",
                "BSD-Systemics",
                "OSL-1.0",
                "EPICS",
                "GFDL-1.3-no-invariants-only",
                "RPSL-1.0",
                "CPL-1.0",
                "EFL-2.0",
                "NPL-1.1",
                "Cube",
                "HPND-sell-regexpr",
                "CC-BY-NC-SA-3.0-DE",
                "AMPAS",
                "NLOD-2.0",
                "TTWL",
                "SWL",
                "MIT-Modern-Variant",
                "FSFULLRWD",
                "NCGL-UK-2.0",
                "NTP-0",
                "SGI-B-1.0",
                "BSD-3-Clause-HP",
                "CNRI-Python-GPL-Compatible",
                "CDLA-Permissive-1.0",
                "CC-BY-NC-SA-3.0-IGO",
                "OPL-1.0",
                "Frameworx-1.0",
                "Zed",
                "RHeCos-1.1",
                "Boehm-GC",
                "Martin-Birgmeier",
                "CC-BY-SA-3.0-AT",
                "LGPL-2.1-or-later",
                "W3C-20150513",
                "Kastrup",
                "MPL-2.0",
                "CPOL-1.02",
                "Vim",
                "zlib-acknowledgement",
                "MIT-open-group",
                "iMatix",
                "MIT-Festival",
                "URT-RLE",
                "C-UDA-1.0",
                "ZPL-1.1",
                "CrystalStacker",
                "CC-BY-NC-ND-2.5",
                "CC-BY-NC-1.0",
                "GFDL-1.2-invariants-only",
                "HPND-sell-variant-MIT-disclaimer",
                "MS-PL",
                "HPND-Pbmplus",
                "OFL-1.1",
                "Leptonica",
                "SunPro",
                "WTFPL",
                "CDDL-1.0",
                "OFFIS",
                "Latex2e",
                "GFDL-1.3-no-invariants-or-later",
                "xpp",
                "LPPL-1.3c",
                "xlock",
                "DL-DE-BY-2.0",
                "VOSTROM",
                "APSL-1.1",
                "ECL-2.0",
                "bzip2-1.0.6",
                "Xdebug-1.03",
                "PHP-3.0",
                "TCL",
                "SGI-B-1.1",
                "Python-2.0",
                "APSL-2.0",
                "Wsuipa",
                "Apache-1.0",
                "BSL-1.0",
                "ANTLR-PD",
                "LAL-1.3",
                "HPND-export-US-modify",
                "Arphic-1999",
                "Dotseqn",
                "Info-ZIP",
                "psutils",
                "NIST-PD",
                "GPL-2.0-or-later",
                "BSD-4.3RENO",
                "HPND-sell-variant",
                "CNRI-Jython",
                "COIL-1.0",
                "FSFAP",
                "LPL-1.0",
                "OLFL-1.3",
                "Adobe-Glyph",
                "NIST-Software",
                "TTYP0",
                "LGPLLR",
                "CC-BY-ND-1.0",
                "Elastic-2.0",
                "FBM",
                "LPPL-1.3a",
                "AGPL-3.0-or-later",
                "Barr",
                "CDLA-Permissive-2.0",
                "GPL-3.0-or-later",
                "NetCDF",
                "Bahyph",
                "CC-BY-3.0-US",
                "dtoa",
                "CC-BY-2.5",
                "Condor-1.1",
                "check-cvs",
                "mpi-permissive",
                "RSCPL",
                "Latex2e-translated-notice",
                "TU-Berlin-1.0",
                "SMLNJ",
                "TPDL",
                "Multics",
                "BSD-4-Clause",
                "BSD-2-Clause-Views",
                "Glide",
                "OPUBL-1.0",
                "CC-BY-SA-2.0",
                "HaskellReport",
                "JPL-image",
                "IBM-pibs",
                "FTL",
                "SNIA",
                "Hippocratic-2.1",
                "SimPL-2.0",
                "BSD-3-Clause-Clear",
                "Spencer-86",
                "BUSL-1.1",
                "ADSL",
                "OLDAP-2.3",
                "Interbase-1.0",
                "OLDAP-2.5",
                "Artistic-1.0-Perl",
                "gSOAP-1.3b",
                "NPOSL-3.0"
              ]
            ],
        localLinks = predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.record {  }
              {
                ".+" = predicates.anyOf
                    [
                      predicates.isType '"String",
                      predicates.allOf
                      [
                        predicates.records.required [ "link" ],
                        predicates.records.record
                        {
                          color = predicates.isType '"String",
                          icon = predicates.isType '"String",
                          link = predicates.isType '"String",
                          pro = predicates.isType '"Bool",
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
              }
              true
              predicates.always
            ],
        logTransporter = predicates.isType '"Bool",
        loglevel = predicates.allOf
            [
              predicates.isType '"String",
              predicates.enum [ "silly", "debug", "info", "warn", "error" ]
            ],
        main = predicates.isType '"String",
        materialize = predicates.isType '"Bool",
        materializeTab = predicates.isType '"Bool",
        messagebox = predicates.isType '"Bool",
        messages = predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf
              (predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "buttons", "text", "title" ],
                predicates.records.record
                {
                  buttons = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.enum [ "ok", "agree", "cancel" ])
                      ],
                  condition = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          operand = predicates.enum [ "or", "and" ],
                          rules = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.isType '"String")
                              ],
                        }
                        {  }
                        false
                        predicates.never
                      ],
                  level = predicates.enum [ "info", "warn", "error" ],
                  link = predicates.isType '"String",
                  linkText = definitions.predicate.multilingual,
                  text = definitions.predicate.multilingual,
                  title = definitions.predicate.multilingual,
                }
                {  }
                false
                predicates.never
              ])
            ],
        mode = predicates.allOf
            [
              predicates.isType '"String",
              predicates.enum
              [ "none", "daemon", "subscribe", "schedule", "once", "extension" ]
            ],
        name = predicates.allOf
            [
              predicates.isType '"String",
              predicates.strings.pattern
              "^(?![i|I][o|O][b|B][r|R][o|O][k|K][e|E][r|R])"
            ],
        news = predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.maxProperties 20,
              predicates.records.minProperties 1,
              predicates.records.record {  }
              {
                "^(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)(?:-((?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\\.(?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\\+([0-9a-zA-Z-]+(?:\\.[0-9a-zA-Z-]+)*))?$" =
                  definitions.predicate.multilingual,
              }
              false
              predicates.never
            ],
        noConfig = predicates.isType '"Bool",
        noIntro = predicates.isType '"Bool",
        noRepository = predicates.isType '"Bool",
        nodeProcessParams = predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf (predicates.isType '"String")
            ],
        nogit = predicates.isType '"Bool",
        nondeletable = predicates.isType '"Bool",
        onlyWWW = predicates.isType '"Bool",
        os = predicates.anyOf
            [
              predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "linux", "darwin", "win32" ]
              ],
              predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.enum [ "linux", "darwin", "win32" ]
                ]),
                predicates.arrays.minItems 1
              ]
            ],
        osDependencies = predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.record {  }
              {
                "linux|darwin|win32" = predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ],
              }
              false
              predicates.never
            ],
        platform = predicates.allOf
            [
              predicates.isType '"String",
              predicates.enum [ "Javascript/Node.js" ]
            ],
        plugins = predicates.isType 'Record,
        preserveSettings = predicates.allOf
            [
              predicates.anyOf
              [ predicates.isType '"String", predicates.isType '"Array" ],
              predicates.arrays.arrayOf (predicates.isType '"String")
            ],
        readme = predicates.isType '"String",
        restartAdapters = predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf (predicates.isType '"String")
            ],
        restartSchedule = predicates.isType '"String",
        schedule = predicates.isType '"String",
        serviceStates = predicates.anyOf
            [ predicates.isType '"Bool", predicates.isType '"String" ],
        singleton = predicates.isType '"Bool",
        singletonHost = predicates.isType '"Bool",
        stopBeforeUpdate = predicates.isType '"Bool",
        stopTimeout = predicates.allOf
            [
              predicates.isType '"Number",
              predicates.numbers.multipleOf 1,
              predicates.numbers.minimum 0
            ],
        subscribable = predicates.isType '"Bool",
        subscribe = predicates.isType '"String",
        supportCustoms = predicates.isType '"Bool",
        supportStopInstance = predicates.anyOf
            [
              predicates.isType '"Bool",
              predicates.allOf
              [
                predicates.isType '"Number",
                predicates.numbers.multipleOf 1,
                predicates.numbers.minimum 1000
              ]
            ],
        supportedMessages = predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.record
              {
                custom = predicates.isType '"Bool",
                getHistory = predicates.isType '"Bool",
                notifications = predicates.isType '"Bool",
                stopInstance = predicates.anyOf
                    [
                      predicates.isType '"Bool",
                      predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.multipleOf 1,
                        predicates.numbers.minimum 1000
                      ]
                    ],
              }
              {  }
              false
              predicates.never
            ],
        tier = predicates.allOf
            [
              predicates.isType '"Number",
              predicates.numbers.maximum 3,
              predicates.numbers.minimum 1
            ],
        title = predicates.isType '"String",
        titleLang = definitions.predicate.multilingual,
        type = predicates.allOf
            [
              predicates.isType '"String",
              predicates.enum
              [
                "alarm",
                "climate-control",
                "communication",
                "date-and-time",
                "energy",
                "metering",
                "garden",
                "general",
                "geoposition",
                "hardware",
                "health",
                "household",
                "infrastructure",
                "iot-systems",
                "lighting",
                "logic",
                "messaging",
                "misc-data",
                "multimedia",
                "network",
                "protocols",
                "storage",
                "utility",
                "vehicle",
                "visualization",
                "visualization-icons",
                "visualization-widgets",
                "weather"
              ]
            ],
        unsafePerm = predicates.isType '"Bool",
        version = predicates.allOf
            [
              predicates.isType '"String",
              predicates.strings.pattern
              "^(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)(?:-((?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\\.(?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\\+([0-9a-zA-Z-]+(?:\\.[0-9a-zA-Z-]+)*))?$"
            ],
        visWidgets = predicates.allOf
            [
              predicates.isType 'Record,
              predicates.records.minProperties 1,
              predicates.records.record {  }
              {
                ".+" = predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.required
                      [ "components", "i18n", "url" ],
                      predicates.records.record
                      {
                        components = predicates.allOf
                            [
                              predicates.isType '"Array",
                              predicates.arrays.arrayOf
                              (predicates.isType '"String"),
                              predicates.arrays.minItems 1
                            ],
                        i18n = predicates.anyOf
                            [
                              predicates.const true,
                              predicates.const "component",
                              predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record {  }
                                { ".+" = definitions.predicate.multilingual, }
                                true
                                predicates.always
                              ]
                            ],
                        url = predicates.isType '"String",
                      }
                      {  }
                      true
                      predicates.always
                    ],
              }
              true
              predicates.always
            ],
        wakeup = predicates.isType '"Bool",
        webByVersion = predicates.isType '"Bool",
        webExtendable = predicates.isType '"Bool",
        webExtension = predicates.isType '"String",
        webPreSettings = predicates.isType 'Record,
        webservers = predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf (predicates.isType '"String")
            ],
        welcomeScreen = predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf
              (predicates.anyOf
              [ predicates.isType '"String", predicates.isType 'Record ])
            ],
        welcomeScreenPro = predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf
              (predicates.anyOf
              [ predicates.isType '"String", predicates.isType 'Record ])
            ],
        wwwDontUpload = predicates.isType '"Bool",
      }
      {  }
      false
      predicates.never
    ])
    | doc m%"
    Contains all common instance attributes
    "%,
  encryptedNative
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    Array of config attributes which will be automatically encrypted when stored via Admin configuration page and automatically decrypted at adapter runtime, e.g. ["password", "token"]
    "%
    | optional,
  instanceObjects
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.iobrokerObject
    ])
    | doc m%"
    Objects which will be created for each instance
    "%
    | optional,
  native
    | {  .. }
    | doc m%"
    Predefined attributes which are accessible in index_m.html and at runtime via adapter.config.<attribute>, e.g. {"port": 1234, "password": "secret"}
    "%
    | optional,
  notifications
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf
      (predicates.allOf
      [
        predicates.isType 'Record,
        predicates.records.required
        [ "categories", "description", "name", "scope" ],
        predicates.records.record
        {
          categories = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required
                  [
                    "category",
                    "description",
                    "limit",
                    "name",
                    "regex",
                    "severity"
                  ],
                  predicates.records.record
                  {
                    category = predicates.isType '"String",
                    description = definitions.predicate.multilingual,
                    limit = predicates.isType '"Number",
                    name = definitions.predicate.multilingual,
                    regex = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    severity = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "info", "notify", "alert" ]
                        ],
                  }
                  {  }
                  false
                  predicates.never
                ])
              ],
          description = definitions.predicate.multilingual,
          name = definitions.predicate.multilingual,
          scope = predicates.isType '"String",
        }
        {  }
        false
        predicates.never
      ])
    ])
    | doc m%"
    Register notifications for the built-in notification system
    "%
    | optional,
  objects
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.iobrokerObject
    ])
    | doc m%"
    Objects which will be created for the adapter
    "%
    | optional,
  protectedNative
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    Array of config attributes which will only be accessible by the own adapter, e.g. ["password"]
    "%
    | optional,
}