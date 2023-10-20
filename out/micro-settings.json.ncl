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

let rec definitions = { contract = {  }, predicate = {  }, } in
{
  autoindent
    | Bool
    | doc m%"
    Whether to use the same indentation as a previous line
    https://github.com/zyedidia/micro/blob/master/runtime/help/options.md#options
    "%
    | optional,
  autosave
    | predicates.contract_from_predicate
    (predicates.allOf
    [ predicates.isType 'Integer, predicates.numbers.minimum 0 ])
    | doc m%"
    A delay between automatic saves
    https://github.com/zyedidia/micro/blob/master/runtime/help/options.md#options
    "%
    | optional,
  autosu
    | Bool
    | doc m%"
    Whether attempt to use super user privileges
    https://github.com/zyedidia/micro/blob/master/runtime/help/options.md#options
    "%
    | optional,
  backup
    | Bool
    | doc m%"
    Whether to backup all open buffers
    https://github.com/zyedidia/micro/blob/master/runtime/help/options.md#options
    "%
    | optional,
  backupdir
    | String
    | doc m%"
    A directory to store backups
    https://github.com/zyedidia/micro/blob/master/runtime/help/options.md#options
    "%
    | optional,
  basename
    | Bool
    | doc m%"
    Whether to show a basename instead of a full path
    https://github.com/zyedidia/micro/blob/master/runtime/help/options.md#options
    "%
    | optional,
  clipboard
    | std.enum.TagOrString
    | [| 'internal, 'terminal, 'external |]
    | doc m%"
    A way to access the system clipboard
    https://github.com/zyedidia/micro/blob/master/runtime/help/options.md#options
    "%
    | optional,
  colorcolumn
    | predicates.contract_from_predicate
    (predicates.allOf
    [ predicates.isType 'Integer, predicates.numbers.minimum 0 ])
    | doc m%"
    A position to display a column
    https://github.com/zyedidia/micro/blob/master/runtime/help/options.md#options
    "%
    | optional,
  colorscheme
    | std.enum.TagOrString
    | [|
      'zenburn,
      'twilight,
      'sunny-day,
      'solarized-tc,
      'solarized,
      'simple,
      'railscast,
      'one-dark,
      'monokai,
      'monokai-dark,
      'material-tc,
      'gruvbox-tc,
      'gruvbox,
      'gotham,
      'geany,
      'dukeubuntu-tc,
      'dukelight-tc,
      'dukedark-tc,
      'dracula-tc,
      '"default",
      'darcula,
      'cmc-tc,
      'cmc-16,
      'bubblegum,
      'atom-dark
    |]
    | doc m%"
    A color scheme
    https://github.com/zyedidia/micro/blob/master/runtime/help/options.md#options
    "%
    | optional,
  cursorline
    | Bool
    | doc m%"
    Whether to highlight a line with a cursor with a different color
    https://github.com/zyedidia/micro/blob/master/runtime/help/options.md#options
    "%
    | optional,
  diffgutter
    | Bool
    | doc m%"
    Whether to display diff inticators before lines
    https://github.com/zyedidia/micro/blob/master/runtime/help/options.md#options
    "%
    | optional,
  divchars
    | String
    | doc m%"
    Divider chars for vertical and horizontal splits
    https://github.com/zyedidia/micro/blob/master/runtime/help/options.md#options
    "%
    | optional,
  divreverse
    | Bool
    | doc m%"
    Whether to use inversed color scheme colors for splits
    https://github.com/zyedidia/micro/blob/master/runtime/help/options.md#options
    "%
    | optional,
  encoding
    | String
    | doc m%"
    An encoding used to open and save files
    https://github.com/zyedidia/micro/blob/master/runtime/help/options.md#options
    "%
    | optional,
  eofnewline
    | Bool
    | doc m%"
    Whether to add a missing trailing new line
    https://github.com/zyedidia/micro/blob/master/runtime/help/options.md#options
    "%
    | optional,
  fastdirty
    | Bool
    | doc m%"
    Whether to use a fast algorithm to determine whether a file is changed
    https://github.com/zyedidia/micro/blob/master/runtime/help/options.md#options
    "%
    | optional,
  fileformat
    | std.enum.TagOrString
    | [| 'dos, 'unix |]
    | doc m%"
    A line ending format
    https://github.com/zyedidia/micro/blob/master/runtime/help/options.md#options
    "%
    | optional,
  filetype
    | String
    | doc m%"
    A filetype for the current buffer
    https://github.com/zyedidia/micro/blob/master/runtime/help/options.md#options
    "%
    | optional,
  hlsearch
    | Bool
    | doc m%"
    Whether to highlight all instances of a searched text after a successful search
    https://github.com/zyedidia/micro/blob/master/runtime/help/options.md#options
    "%
    | optional,
  ignorecase
    | Bool
    | doc m%"
    Whether to perform case-insensitive searches
    https://github.com/zyedidia/micro/blob/master/runtime/help/options.md#options
    "%
    | optional,
  incsearch
    | Bool
    | doc m%"
    Whether to enable an incremental search in `Find` prompt
    https://github.com/zyedidia/micro/blob/master/runtime/help/options.md#options
    "%
    | optional,
  indentchar
    | predicates.contract_from_predicate
    (predicates.allOf
    [ predicates.isType '"String", predicates.strings.maxLength 1 ])
    | doc m%"
    An indentation character
    https://github.com/zyedidia/micro/blob/master/runtime/help/options.md#options
    "%
    | optional,
  infobar
    | Bool
    | doc m%"
    Whether to enable a line at the bottom where messages are printed
    https://github.com/zyedidia/micro/blob/master/runtime/help/options.md#options
    "%
    | optional,
  keepautoindent
    | Bool
    | doc m%"
    Whether add a whitespace while using autoindent
    https://github.com/zyedidia/micro/blob/master/runtime/help/options.md#options
    "%
    | optional,
  keymenu
    | Bool
    | doc m%"
    Whether to display nano-style key menu at the bottom
    https://github.com/zyedidia/micro/blob/master/runtime/help/options.md#options
    "%
    | optional,
  matchbrace
    | Bool
    | doc m%"
    Whether to underline matching braces
    https://github.com/zyedidia/micro/blob/master/runtime/help/options.md#options
    "%
    | optional,
  mkparents
    | Bool
    | doc m%"
    Whether to create missing directories
    https://github.com/zyedidia/micro/blob/master/runtime/help/options.md#options
    "%
    | optional,
  mouse
    | Bool
    | doc m%"
    Whether to enable mouse support
    https://github.com/zyedidia/micro/blob/master/runtime/help/options.md#options
    "%
    | optional,
  parsecursor
    | Bool
    | doc m%"
    Whether to extract a line number and a column to open files with from file names
    https://github.com/zyedidia/micro/blob/master/runtime/help/options.md#options
    "%
    | optional,
  paste
    | Bool
    | doc m%"
    Whether to treat characters sent from the terminal in a single chunk as a paste event
    https://github.com/zyedidia/micro/blob/master/runtime/help/options.md#options
    "%
    | optional,
  permbackup
    | Bool
    | doc m%"
    Whether to permanently save backups
    https://github.com/zyedidia/micro/blob/master/runtime/help/options.md#options
    "%
    | optional,
  pluginchannels
    | String
    | doc m%"
    A file with list of plugin channels
    https://github.com/zyedidia/micro/blob/master/runtime/help/options.md#options
    "%
    | optional,
  pluginrepos
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String"),
      predicates.arrays.uniqueItems
    ])
    | doc m%"
    Plugin repositories
    https://github.com/zyedidia/micro/blob/master/runtime/help/options.md#options
    "%
    | optional,
  readonly
    | Bool
    | doc m%"
    Whether to forbid buffer editing
    https://github.com/zyedidia/micro/blob/master/runtime/help/options.md#options
    "%
    | optional,
  relativeruler
    | Bool
    | doc m%"
    Whether to display relative line numbers
    https://github.com/zyedidia/micro/blob/master/runtime/help/options.md#options
    "%
    | optional,
  rmtrailingws
    | Bool
    | doc m%"
    Whether to remove trailing whitespaces
    https://github.com/zyedidia/micro/blob/master/runtime/help/options.md#options
    "%
    | optional,
  ruler
    | Bool
    | doc m%"
    Whether to display line numbers
    https://github.com/zyedidia/micro/blob/master/runtime/help/options.md#options
    "%
    | optional,
  savecursor
    | Bool
    | doc m%"
    Whether to save cursor position in files
    https://github.com/zyedidia/micro/blob/master/runtime/help/options.md#options
    "%
    | optional,
  savehistory
    | Bool
    | doc m%"
    Whether to save command history between closing and re-opening editor
    https://github.com/zyedidia/micro/blob/master/runtime/help/options.md#options
    "%
    | optional,
  saveundo
    | Bool
    | doc m%"
    Whether to save undo after closing file
    https://github.com/zyedidia/micro/blob/master/runtime/help/options.md#options
    "%
    | optional,
  scrollbar
    | Bool
    | doc m%"
    Whether to save undo after closing file
    https://github.com/zyedidia/micro/blob/master/runtime/help/options.md#options
    "%
    | optional,
  scrollmargin
    | std.number.Integer
    | doc m%"
    A margin at which a view starts scrolling when a cursor approaches an edge of a view
    https://github.com/zyedidia/micro/blob/master/runtime/help/options.md#options
    "%
    | optional,
  scrollspeed
    | std.number.Integer
    | doc m%"
    Line count to scroll for one scroll event
    https://github.com/zyedidia/micro/blob/master/runtime/help/options.md#options
    "%
    | optional,
  smartpaste
    | Bool
    | doc m%"
    Whether to add a leading whitespace while pasting multiple lines
    https://github.com/zyedidia/micro/blob/master/runtime/help/options.md#options
    "%
    | optional,
  softwrap
    | Bool
    | doc m%"
    Whether to wrap long lines
    https://github.com/zyedidia/micro/blob/master/runtime/help/options.md#options
    "%
    | optional,
  splitbottom
    | Bool
    | doc m%"
    Whether to create a new horizontal split below the current one
    https://github.com/zyedidia/micro/blob/master/runtime/help/options.md#options
    "%
    | optional,
  splitright
    | Bool
    | doc m%"
    Whether to create a new vertical split right of the current one
    https://github.com/zyedidia/micro/blob/master/runtime/help/options.md#options
    "%
    | optional,
  statusformatl
    | String
    | doc m%"
    Format string of left-justified part of the statusline
    https://github.com/zyedidia/micro/blob/master/runtime/help/options.md#options
    "%
    | optional,
  statusformatr
    | String
    | doc m%"
    Format string of right-justified part of the statusline
    https://github.com/zyedidia/micro/blob/master/runtime/help/options.md#options
    "%
    | optional,
  statusline
    | String
    | doc m%"
    Whether to display a status line
    https://github.com/zyedidia/micro/blob/master/runtime/help/options.md#options
    "%
    | optional,
  sucmd
    | String
    | doc m%"
    A super user command
    https://github.com/zyedidia/micro/blob/master/runtime/help/options.md#options
    "%
    | optional,
  syntax
    | Bool
    | doc m%"
    Whether to enable a syntax highlighting
    https://github.com/zyedidia/micro/blob/master/runtime/help/options.md#options
    "%
    | optional,
  tabhighlight
    | Bool
    | doc m%"
    Whether to invert tab character colors
    https://github.com/zyedidia/micro/blob/master/runtime/help/options.md#options
    "%
    | optional,
  tabmovement
    | Bool
    | doc m%"
    Whether to navigate spaces at the beginning of lines as if they are tabs
    https://github.com/zyedidia/micro/blob/master/runtime/help/options.md#options
    "%
    | optional,
  tabreverse
    | Bool
    | doc m%"
    Whether to reverse tab bar colors
    https://github.com/zyedidia/micro/blob/master/runtime/help/options.md#options
    "%
    | optional,
  tabsize
    | std.number.Integer
    | doc m%"
    A tab size
    https://github.com/zyedidia/micro/blob/master/runtime/help/options.md#options
    "%
    | optional,
  tabstospaces
    | Bool
    | doc m%"
    Whether to use spaces instead of tabs
    https://github.com/zyedidia/micro/blob/master/runtime/help/options.md#options
    "%
    | optional,
  useprimary
    | Bool
    | doc m%"
    Whether to use primary clipboard to copy selections in the background
    https://github.com/zyedidia/micro/blob/master/runtime/help/options.md#options
    "%
    | optional,
  wordwrap
    | Bool
    | doc m%"
    Whether to wrap long lines by words
    https://github.com/zyedidia/micro/blob/master/runtime/help/options.md#options
    "%
    | optional,
  xterm
    | Bool
    | doc m%"
    Whether to assume that the current terminal is `xterm`
    https://github.com/zyedidia/micro/blob/master/runtime/help/options.md#options
    "%
    | optional,
}