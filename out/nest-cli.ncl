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
          AssetsOptions
            | doc m%"
            For finer control, the element can be object.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.AssetsOptions,
          CompilerOptions
            | doc m%"
            A map with keys specifying compiler options and values specifying the option setting. See https://docs.nestjs.com/cli/monorepo#global-compiler-options for details
            "%
            = {
                assets
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.AssetsOptions
                  ])
                  | doc m%"
                  Enables automatically distributing non-TypeScript assets whenever a compilation step begins (asset distribution does not happen on incremental compiles in --watch mode). Accept glob-like string and object. See https://docs.nestjs.com/cli/monorepo#assets for details.
                  "%
                  | optional,
                builder
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.enum [ "tsc", "webpack", "swc" ]
                    ],
                    predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record
                      {
                        options = predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.record
                              {
                                copyFiles = predicates.isType '"Bool",
                                extensions = predicates.allOf
                                    [
                                      predicates.isType '"Array",
                                      predicates.arrays.arrayOf
                                      (predicates.isType '"String")
                                    ],
                                filenames = predicates.allOf
                                    [
                                      predicates.isType '"Array",
                                      predicates.arrays.arrayOf
                                      (predicates.isType '"String")
                                    ],
                                includeDotfiles = predicates.isType '"Bool",
                                outDir = predicates.isType '"String",
                                quiet = predicates.isType '"Bool",
                                sync = predicates.isType '"Bool",
                                watch = predicates.isType '"Bool",
                              }
                              {  }
                              true
                              predicates.always
                            ],
                        type = predicates.allOf
                            [
                              predicates.isType '"String",
                              predicates.enum [ "tsc", "webpack", "swc" ]
                            ],
                      }
                      {  }
                      true
                      predicates.always
                    ]
                  ])
                  | optional,
                deleteOutDir
                  | Bool
                  | doc m%"
                  If true, whenever the compiler is invoked, it will first remove the compilation output directory (as configured in tsconfig.json, where the default is ./dist).
                  "%
                  | optional,
                manualRestart
                  | Bool
                  | doc m%"
                  If true, enables the shortcut `rs` to manually restart the server.
                  "%
                  | optional,
                plugins
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.PluginItems
                  ])
                  | optional,
                tsConfigPath
                  | String
                  | doc m%"
                  (monorepo only) Points at the file containing the tsconfig.json settings that will be used when nest build or nest start is called without a project option (e.g., when the default project is built or started). 'nest build' will not work as expected without this file.
                  "%
                  | optional,
                typeCheck
                  | Bool
                  | doc m%"
                  If true, enable type checking (when SWC is used). See https://docs.nestjs.com/recipes/swc#type-checking for details.
                  "%
                  | optional,
                watchAssets
                  | Bool
                  | doc m%"
                  If true, run in watch-mode, watching all non-TypeScript assets. Setting watchAssets in a top-level compilerOptions property overrides any watchAssets settings within the assets property.
                  "%
                  | optional,
                webpack
                  | Bool
                  | doc m%"
                  If true, use webpack compiler (deprecated option, use `builder` instead). If false or not present, use tsc. In monorepo mode, the default is true (use webpack), in standard mode, the default is false (use tsc). See https://docs.nestjs.com/cli/monorepo#cli-properties for details.
                  "%
                  | optional,
                webpackConfigPath
                  | String
                  | doc m%"
                  Points at a webpack options file. If not specified, Nest looks for the file webpack.config.js.
                  "%
                  | optional,
              },
          GenerateBaseDirOptions
            | doc m%"
            Base directory
            "%
            = String,
          GenerateFlatOptions
            | doc m%"
            If true, all generate commands will generate a flat structure
            "%
            = Bool,
          GenerateOptions
            | doc m%"
            A map with keys specifying global generate options and values specifying the option setting. See https://docs.nestjs.com/cli/monorepo#global-generate-options for details
            "%
            = {
                baseDir
                  | definitions.contract.GenerateBaseDirOptions
                  | optional,
                flat | definitions.contract.GenerateFlatOptions | optional,
                spec | definitions.contract.GenerateSpecOptions | optional,
              },
          GenerateSpecOptions
            | doc m%"
            If the value is boolean, a value of true enables spec generation by default and a value of false disables it. A flag passed on the CLI command line overrides this setting, as does a project-specific generateOptions setting (more below). If the value is an object, each key represents a schematic name, and the boolean value determines whether the default spec generation is enabled / disabled for that specific schematic. See https://docs.nestjs.com/cli/monorepo#global-generate-options for details.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.GenerateSpecOptions,
          GraphQLPluginOptions = {
                typeFileNameSuffix
                  | Array Dyn
                  | doc m%"
                  (GraphQL Only) GraphQL types files suffix. Default value: ['.input.ts', '.args.ts', '.entity.ts', '.model.ts']. See https://docs.nestjs.com/graphql/cli-plugin#using-the-cli-plugin for details.
                  "%
                  | optional,
                ..
              },
          PluginItems = predicates.contract_from_predicate
              definitions.predicate.PluginItems,
          PluginOptions = {
                introspectComments
                  | Bool
                  | doc m%"
                  If set to true, plugin will generate descriptions and example values for properties based on comments.
                  "%
                  | optional,
                ..
              },
          ProjectConfiguration = {
                compilerOptions
                  | definitions.contract.CompilerOptions
                  | optional,
                entryFile | String | optional,
                generateOptions
                  | definitions.contract.GenerateOptions
                  | optional,
                root | String | optional,
                sourceRoot | String | optional,
                type | String | optional,
              },
          SwaggerPluginOptions = {
                classValidatorShim
                  | Bool
                  | doc m%"
                  (Swagger Only) If set to true, the module will reuse class-validator validation decorators (e.g. @Max(10) will add max: 10 to schema definition). See https://docs.nestjs.com/openapi/cli-plugin#using-the-cli-plugin for details
                  "%
                  | optional,
                controllerFileNameSuffix
                  | String
                  | doc m%"
                  (Swagger Only) Controller files suffix. See https://docs.nestjs.com/openapi/cli-plugin#using-the-cli-plugin for details
                  "%
                  | optional,
                controllerKeyOfComment
                  | String
                  | doc m%"
                  (Swagger Only) The property key to set the comment text to on ApiOperation. See https://docs.nestjs.com/openapi/cli-plugin#using-the-cli-plugin for details
                  "%
                  | optional,
                dtoFileNameSuffix
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  (Swagger Only) DTO (Data Transfer Object) files suffix. Default value: ['.dto.ts', '.entity.ts']. See https://docs.nestjs.com/openapi/cli-plugin#using-the-cli-plugin for details
                  "%
                  | optional,
                dtoKeyOfComment
                  | String
                  | doc m%"
                  (Swagger Only) The property key to set the comment text to on ApiProperty. See https://docs.nestjs.com/openapi/cli-plugin#using-the-cli-plugin for details
                  "%
                  | optional,
                ..
              },
        },
    predicate = {
          AssetsOptions
            | doc m%"
            For finer control, the element can be object.
            "%
            = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType '"String", predicates.isType 'Record ],
                predicates.records.record
                {
                  exclude = predicates.isType '"String",
                  include = predicates.isType '"String",
                  outDir = predicates.isType '"String",
                  watchAssets = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          CompilerOptions
            | doc m%"
            A map with keys specifying compiler options and values specifying the option setting. See https://docs.nestjs.com/cli/monorepo#global-compiler-options for details
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  assets = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.AssetsOptions
                      ],
                  builder = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "tsc", "webpack", "swc" ]
                        ],
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            options = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    copyFiles = predicates.isType '"Bool",
                                    extensions = predicates.allOf
                                        [
                                          predicates.isType '"Array",
                                          predicates.arrays.arrayOf
                                          (predicates.isType '"String")
                                        ],
                                    filenames = predicates.allOf
                                        [
                                          predicates.isType '"Array",
                                          predicates.arrays.arrayOf
                                          (predicates.isType '"String")
                                        ],
                                    includeDotfiles = predicates.isType '"Bool",
                                    outDir = predicates.isType '"String",
                                    quiet = predicates.isType '"Bool",
                                    sync = predicates.isType '"Bool",
                                    watch = predicates.isType '"Bool",
                                  }
                                  {  }
                                  true
                                  predicates.always
                                ],
                            type = predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.enum [ "tsc", "webpack", "swc" ]
                                ],
                          }
                          {  }
                          true
                          predicates.always
                        ]
                      ],
                  deleteOutDir = predicates.isType '"Bool",
                  manualRestart = predicates.isType '"Bool",
                  plugins = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.PluginItems
                      ],
                  tsConfigPath = predicates.isType '"String",
                  typeCheck = predicates.isType '"Bool",
                  watchAssets = predicates.isType '"Bool",
                  webpack = predicates.isType '"Bool",
                  webpackConfigPath = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          GenerateBaseDirOptions
            | doc m%"
            Base directory
            "%
            = predicates.isType '"String",
          GenerateFlatOptions
            | doc m%"
            If true, all generate commands will generate a flat structure
            "%
            = predicates.isType '"Bool",
          GenerateOptions
            | doc m%"
            A map with keys specifying global generate options and values specifying the option setting. See https://docs.nestjs.com/cli/monorepo#global-generate-options for details
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  baseDir = definitions.predicate.GenerateBaseDirOptions,
                  flat = definitions.predicate.GenerateFlatOptions,
                  spec = definitions.predicate.GenerateSpecOptions,
                }
                {  }
                false
                predicates.never
              ],
          GenerateSpecOptions
            | doc m%"
            If the value is boolean, a value of true enables spec generation by default and a value of false disables it. A flag passed on the CLI command line overrides this setting, as does a project-specific generateOptions setting (more below). If the value is an object, each key represents a schematic name, and the boolean value determines whether the default spec generation is enabled / disabled for that specific schematic. See https://docs.nestjs.com/cli/monorepo#global-generate-options for details.
            "%
            = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType '"Bool", predicates.isType 'Record ],
                predicates.records.record
                {
                  app = predicates.isType '"Bool",
                  application = predicates.isType '"Bool",
                  cl = predicates.isType '"Bool",
                  class = predicates.isType '"Bool",
                  co = predicates.isType '"Bool",
                  config = predicates.isType '"Bool",
                  configuration = predicates.isType '"Bool",
                  controller = predicates.isType '"Bool",
                  d = predicates.isType '"Bool",
                  decorator = predicates.isType '"Bool",
                  f = predicates.isType '"Bool",
                  filter = predicates.isType '"Bool",
                  ga = predicates.isType '"Bool",
                  gateway = predicates.isType '"Bool",
                  gu = predicates.isType '"Bool",
                  guard = predicates.isType '"Bool",
                  "in" = predicates.isType '"Bool",
                  interceptor = predicates.isType '"Bool",
                  interface = predicates.isType '"Bool",
                  lib = predicates.isType '"Bool",
                  library = predicates.isType '"Bool",
                  mi = predicates.isType '"Bool",
                  middleware = predicates.isType '"Bool",
                  mo = predicates.isType '"Bool",
                  module = predicates.isType '"Bool",
                  pi = predicates.isType '"Bool",
                  pipe = predicates.isType '"Bool",
                  pr = predicates.isType '"Bool",
                  provider = predicates.isType '"Bool",
                  r = predicates.isType '"Bool",
                  res = predicates.isType '"Bool",
                  resolver = predicates.isType '"Bool",
                  resource = predicates.isType '"Bool",
                  s = predicates.isType '"Bool",
                  service = predicates.isType '"Bool",
                  sub-app = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          GraphQLPluginOptions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { typeFileNameSuffix = predicates.isType '"Array", }
                {  }
                true
                predicates.always
              ],
          PluginItems = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType '"String", predicates.isType 'Record ],
                predicates.records.record
                {
                  name = predicates.isType '"String",
                  options = predicates.anyOf
                      [
                        definitions.predicate.PluginOptions,
                        definitions.predicate.GraphQLPluginOptions,
                        definitions.predicate.SwaggerPluginOptions
                      ],
                }
                {  }
                true
                predicates.always
              ],
          PluginOptions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { introspectComments = predicates.isType '"Bool", }
                {  }
                true
                predicates.always
              ],
          ProjectConfiguration = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  compilerOptions = definitions.predicate.CompilerOptions,
                  entryFile = predicates.isType '"String",
                  generateOptions = definitions.predicate.GenerateOptions,
                  root = predicates.isType '"String",
                  sourceRoot = predicates.isType '"String",
                  type = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          SwaggerPluginOptions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  classValidatorShim = predicates.isType '"Bool",
                  controllerFileNameSuffix = predicates.isType '"String",
                  controllerKeyOfComment = predicates.isType '"String",
                  dtoFileNameSuffix = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  dtoKeyOfComment = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
        },
  }
in

{
  collection
    | String
    | doc m%"
    Points at the collection of schematics used to generate components. you generally should not change this value.
    "%
    | optional,
  compilerOptions | definitions.contract.CompilerOptions | optional,
  entryFile
    | String
    | doc m%"
    The entry file where 'nest start' work with. Default to 'main'.
    "%
    | optional,
  generateOptions | definitions.contract.GenerateOptions | optional,
  language | String | optional,
  monorepo
    | Bool
    | doc m%"
    (monorepo only) For a monorepo mode structure, this value is always true.
    "%
    | optional,
  projects
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType 'Record,
      predicates.records.record {  } {  } true
      definitions.predicate.ProjectConfiguration
    ])
    | optional,
  root
    | String
    | doc m%"
    (monorepo only) Points at the project root of the default project.
    "%
    | optional,
  sourceRoot
    | String
    | doc m%"
    Points at the root of the source code for the single project in standard mode structures, or the default project in monorepo mode structures.
    "%
    | optional,
  ..
}