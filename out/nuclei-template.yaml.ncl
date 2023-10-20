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
          "code.Request" = {
                args
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Args
                  "%
                  | optional,
                engine
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.enum [ "python", "powershell", "command" ]
                    ])
                  ])
                  | doc m%"
                  Engine
                  "%
                  | optional,
                extractors
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."extractors.Extractor"
                  ])
                  | doc m%"
                  Extractors contains the extraction mechanism for the request to identify and extract parts of the response
                  "%
                  | optional,
                id
                  | String
                  | doc m%"
                  ID is the optional ID of the Request
                  "%
                  | optional,
                matchers
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."matchers.Matcher"
                  ])
                  | doc m%"
                  Detection mechanism to identify whether the request was successful by doing pattern matching
                  "%
                  | optional,
                matchers-condition
                  | std.enum.TagOrString
                  | [| 'or, 'and |]
                  | doc m%"
                  Conditions between the matchers
                  "%
                  | optional,
                pattern
                  | String
                  | doc m%"
                  Pattern
                  "%
                  | optional,
                source
                  | String
                  | doc m%"
                  Source snippet
                  "%
                  | optional,
              },
          "dns.DNSRequestTypeHolder"
            | doc m%"
            Type is the type of DNS request to make
            "%
            = std.contract.Sequence
              [
                std.enum.TagOrString,
                [|
                  'ANY,
                  'TLSA,
                  'CAA,
                  'AAAA,
                  'TXT,
                  'MX,
                  'PTR,
                  'SOA,
                  'CNAME,
                  'DS,
                  'NS,
                  'A
                |]
              ],
          "dns.Request" = {
                attack
                  | definitions.contract."generators.AttackTypeHolder"
                  | doc m%"
                  Attack is the type of payload combinations to perform
                  "%
                  | optional,
                class
                  | std.enum.TagOrString
                  | [| 'any, 'none, 'hesiod, 'chaos, 'csnet, 'inet |]
                  | doc m%"
                  Class is the class of the DNS request
                  "%
                  | optional,
                extractors
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."extractors.Extractor"
                  ])
                  | doc m%"
                  Extractors contains the extraction mechanism for the request to identify and extract parts of the response
                  "%
                  | optional,
                id
                  | String
                  | doc m%"
                  ID is the optional ID of the DNS Request
                  "%
                  | optional,
                matchers
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."matchers.Matcher"
                  ])
                  | doc m%"
                  Detection mechanism to identify whether the request was successful by doing pattern matching
                  "%
                  | optional,
                matchers-condition
                  | std.enum.TagOrString
                  | [| 'or, 'and |]
                  | doc m%"
                  Conditions between the matchers
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  Name is the Hostname to make DNS request for
                  "%
                  | optional,
                payloads
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    {
                      ".*" = predicates.records.record {  } {  } true
                          predicates.always,
                    }
                    true
                    predicates.always
                  ])
                  | doc m%"
                  Payloads contains any payloads for the current request
                  "%
                  | optional,
                recursion
                  | Bool
                  | doc m%"
                  Recursion determines if resolver should recurse all records to get fresh results
                  "%
                  | optional,
                resolvers
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Define resolvers to use within the template
                  "%
                  | optional,
                retries
                  | std.number.Integer
                  | doc m%"
                  Retries is the number of retries for the DNS request
                  "%
                  | optional,
                trace
                  | Bool
                  | doc m%"
                  Trace performs a trace operation for the target.
                  "%
                  | optional,
                trace-max-recursion
                  | std.number.Integer
                  | doc m%"
                  TraceMaxRecursion is the number of max recursion allowed for trace operations
                  "%
                  | optional,
                type
                  | predicates.contract_from_predicate
                  definitions.predicate."dns.DNSRequestTypeHolder"
                  | doc m%"
                  Type is the type of DNS request to make
                  "%
                  | optional,
              },
          "engine.Action" = {
                action
                  | predicates.contract_from_predicate
                  definitions.predicate."engine.ActionTypeHolder"
                  | doc m%"
                  Type of actions to perform
                  "%,
                args
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    { ".*" = predicates.isType '"String", }
                    true
                    predicates.always
                  ])
                  | doc m%"
                  Args contain arguments for the headless action
                  "%
                  | optional,
                description
                  | String
                  | doc m%"
                  Description of the headless action
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  Name is the name assigned to the headless action
                  "%
                  | optional,
              },
          "engine.ActionTypeHolder"
            | doc m%"
            Type of actions to perform
            "%
            = std.contract.Sequence
              [
                std.enum.TagOrString,
                [|
                  'waitvisible,
                  'sleep,
                  'debug,
                  'keyboard,
                  'waitevent,
                  'setbody,
                  'deleteheader,
                  'setheader,
                  'addheader,
                  'setmethod,
                  'extract,
                  'getresource,
                  'waitload,
                  'files,
                  'select,
                  'time,
                  'screenshot,
                  'text,
                  'rightclick,
                  'click,
                  'script,
                  'navigate
                |]
              ],
          "extractors.Extractor" = {
                attribute
                  | String
                  | doc m%"
                  Optional attribute to extract from response XPath
                  "%
                  | optional,
                case-insensitive
                  | Bool
                  | doc m%"
                  use case insensitive extract
                  "%
                  | optional,
                dsl
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Optional attribute to extract from response dsl
                  "%
                  | optional,
                group
                  | std.number.Integer
                  | doc m%"
                  Group to extract from regex
                  "%
                  | optional,
                internal
                  | Bool
                  | doc m%"
                  Internal when set to true will allow using the value extracted in the next request for some protocols
                  "%
                  | optional,
                json
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  JSON JQ expressions to evaluate from response part
                  "%
                  | optional,
                kval
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Kval pairs to extract from response
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  Name of the extractor
                  "%
                  | optional,
                part
                  | String
                  | doc m%"
                  Part of the request response to extract data from
                  "%
                  | optional,
                regex
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Regex to extract from part
                  "%
                  | optional,
                to
                  | String
                  | doc m%"
                  save extracted values to file
                  "%
                  | optional,
                type
                  | predicates.contract_from_predicate
                  definitions.predicate."extractors.ExtractorTypeHolder",
                xpath
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  XPath allows using xpath expressions to extract items from html response
                  "%
                  | optional,
              },
          "extractors.ExtractorTypeHolder"
            | doc m%"
            Type of the extractor
            "%
            = std.contract.Sequence
              [
                std.enum.TagOrString,
                [| 'dsl, 'json, 'xpath, 'kval, 'regex |]
              ],
          "file.Request" = {
                archive
                  | Bool
                  | doc m%"
                  Process compressed archives without unpacking
                  "%
                  | optional,
                denylist
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  List of files
                  "%
                  | optional,
                extensions
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  List of extensions to perform matching on
                  "%
                  | optional,
                extractors
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."extractors.Extractor"
                  ])
                  | doc m%"
                  Extractors contains the extraction mechanism for the request to identify and extract parts of the response
                  "%
                  | optional,
                id
                  | String
                  | doc m%"
                  ID is the optional ID for the request
                  "%
                  | optional,
                matchers
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."matchers.Matcher"
                  ])
                  | doc m%"
                  Detection mechanism to identify whether the request was successful by doing pattern matching
                  "%
                  | optional,
                matchers-condition
                  | std.enum.TagOrString
                  | [| 'or, 'and |]
                  | doc m%"
                  Conditions between the matchers
                  "%
                  | optional,
                max-size
                  | String
                  | doc m%"
                  Maximum size of the file to run request on
                  "%
                  | optional,
                mime-type
                  | Bool
                  | doc m%"
                  Filter files by mime-type
                  "%
                  | optional,
                no-recursive
                  | Bool
                  | doc m%"
                  Specifies whether to not do recursive checks if folders are provided
                  "%
                  | optional,
              },
          "fuzz.Rule" = {
                fuzz
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Payloads to perform fuzzing substitutions with
                  "%
                  | optional,
                keys
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Keys of parameters to fuzz
                  "%
                  | optional,
                keys-regex
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Regex of parameter keys to fuzz
                  "%
                  | optional,
                mode
                  | std.enum.TagOrString
                  | [| 'multiple, 'single |]
                  | doc m%"
                  Mode of request rule to fuzz
                  "%
                  | optional,
                part
                  | std.enum.TagOrString
                  | [| 'query |]
                  | doc m%"
                  Part of request rule to fuzz
                  "%
                  | optional,
                type
                  | std.enum.TagOrString
                  | [| 'infix, 'postfix, 'prefix, 'replace |]
                  | doc m%"
                  Type of fuzzing rule to perform
                  "%
                  | optional,
                values
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Regex of parameter values to fuzz
                  "%
                  | optional,
              },
          "generators.AttackTypeHolder"
            | doc m%"
            Type of the attack
            "%
            = std.contract.Sequence
              [
                std.enum.TagOrString,
                [| 'clusterbomb, 'pitchfork, 'batteringram |]
              ],
          "headless.Request" = {
                attack
                  | definitions.contract."generators.AttackTypeHolder"
                  | doc m%"
                  Attack is the type of payload combinations to perform
                  "%
                  | optional,
                cookie-reuse
                  | Bool
                  | doc m%"
                  Optional setting that enables cookie reuse
                  "%
                  | optional,
                custom_user_agent
                  | String
                  | doc m%"
                  Custom user agent for the headless request
                  "%
                  | optional,
                extractors
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."extractors.Extractor"
                  ])
                  | doc m%"
                  Extractors contains the extraction mechanism for the request to identify and extract parts of the response
                  "%
                  | optional,
                fuzzing
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate."fuzz.Rule"
                  ])
                  | doc m%"
                  Fuzzing describes rule schema to fuzz headless requests
                  "%
                  | optional,
                id
                  | String
                  | doc m%"
                  Optional ID of the headless request
                  "%
                  | optional,
                matchers
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."matchers.Matcher"
                  ])
                  | doc m%"
                  Detection mechanism to identify whether the request was successful by doing pattern matching
                  "%
                  | optional,
                matchers-condition
                  | std.enum.TagOrString
                  | [| 'or, 'and |]
                  | doc m%"
                  Conditions between the matchers
                  "%
                  | optional,
                payloads
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    {
                      ".*" = predicates.records.record {  } {  } true
                          predicates.always,
                    }
                    true
                    predicates.always
                  ])
                  | doc m%"
                  Payloads contains any payloads for the current request
                  "%
                  | optional,
                steps
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."engine.Action"
                  ])
                  | doc m%"
                  List of actions to run for headless request
                  "%
                  | optional,
                stop-at-first-match
                  | Bool
                  | doc m%"
                  Stop the execution after a match is found
                  "%
                  | optional,
                user_agent
                  | predicates.contract_from_predicate
                  definitions.predicate."userAgent.UserAgentHolder"
                  | doc m%"
                  User agent for the headless request
                  "%
                  | optional,
              },
          "http.HTTPMethodTypeHolder"
            | doc m%"
            Method is the HTTP Request Method
            "%
            = std.contract.Sequence
              [
                std.enum.TagOrString,
                [|
                  'DEBUG,
                  'PURGE,
                  'PATCH,
                  'TRACE,
                  'OPTIONS,
                  'CONNECT,
                  'DELETE,
                  'PUT,
                  'POST,
                  'HEAD,
                  'GET
                |]
              ],
          "http.Request" = {
                attack
                  | predicates.contract_from_predicate
                  definitions.predicate."generators.AttackTypeHolder"
                  | doc m%"
                  Attack is the type of payload combinations to perform
                  "%
                  | optional,
                body
                  | String
                  | doc m%"
                  Body is an optional parameter which contains HTTP Request body
                  "%
                  | optional,
                cookie-reuse
                  | Bool
                  | doc m%"
                  Optional setting that enables cookie reuse
                  "%
                  | optional,
                digest-password
                  | String
                  | doc m%"
                  Optional parameter which specifies the password for digest auth
                  "%
                  | optional,
                digest-username
                  | String
                  | doc m%"
                  Optional parameter which specifies the username for digest auth
                  "%
                  | optional,
                disable-path-automerge
                  | Bool
                  | doc m%"
                  Disable merging target url path with raw request path
                  "%
                  | optional,
                extractors
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."extractors.Extractor"
                  ])
                  | doc m%"
                  Extractors contains the extraction mechanism for the request to identify and extract parts of the response
                  "%
                  | optional,
                fuzzing
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate."fuzz.Rule"
                  ])
                  | doc m%"
                  Fuzzing describes rule schema to fuzz http requests
                  "%
                  | optional,
                headers
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    { ".*" = predicates.isType '"String", }
                    true
                    predicates.always
                  ])
                  | doc m%"
                  Headers contains HTTP Headers to send with the request
                  "%
                  | optional,
                host-redirects
                  | Bool
                  | doc m%"
                  Specifies whether redirects to the same host should be followed by the HTTP Client
                  "%
                  | optional,
                id
                  | String
                  | doc m%"
                  ID for the HTTP Request
                  "%
                  | optional,
                iterate-all
                  | Bool
                  | doc m%"
                  Iterates all the values extracted from internal extractors
                  "%
                  | optional,
                matchers
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."matchers.Matcher"
                  ])
                  | doc m%"
                  Detection mechanism to identify whether the request was successful by doing pattern matching
                  "%
                  | optional,
                matchers-condition
                  | std.enum.TagOrString
                  | [| 'or, 'and |]
                  | doc m%"
                  Conditions between the matchers
                  "%
                  | optional,
                max-redirects
                  | std.number.Integer
                  | doc m%"
                  Maximum number of redirects that should be followed
                  "%
                  | optional,
                max-size
                  | std.number.Integer
                  | doc m%"
                  Maximum size of http response body to read in bytes
                  "%
                  | optional,
                method
                  | predicates.contract_from_predicate
                  definitions.predicate."http.HTTPMethodTypeHolder"
                  | doc m%"
                  Method is the HTTP Request Method
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  Optional name for the HTTP Request
                  "%
                  | optional,
                path
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Path(s) to send http requests to
                  "%
                  | optional,
                payloads
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    {
                      ".*" = predicates.records.record {  } {  } true
                          predicates.always,
                    }
                    true
                    predicates.always
                  ])
                  | doc m%"
                  Payloads contains any payloads for the current request
                  "%
                  | optional,
                pipeline
                  | Bool
                  | doc m%"
                  Pipeline defines if the attack should be performed with HTTP 1.1 Pipelining
                  "%
                  | optional,
                pipeline-concurrent-connections
                  | std.number.Integer
                  | doc m%"
                  Number of connections to create during pipelining
                  "%
                  | optional,
                pipeline-requests-per-connection
                  | std.number.Integer
                  | doc m%"
                  Number of requests to send per connection when pipelining
                  "%
                  | optional,
                race
                  | Bool
                  | doc m%"
                  Race determines if all the request have to be attempted at the same time (Race Condition)
                  "%
                  | optional,
                race_count
                  | std.number.Integer
                  | doc m%"
                  Number of times to send a request in Race Condition Attack
                  "%
                  | optional,
                raw
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  HTTP Requests in Raw Format
                  "%
                  | optional,
                read-all
                  | Bool
                  | doc m%"
                  Enables force reading of entire unsafe http request body
                  "%
                  | optional,
                redirects
                  | Bool
                  | doc m%"
                  Specifies whether redirects should be followed by the HTTP Client
                  "%
                  | optional,
                req-condition
                  | Bool
                  | doc m%"
                  Automatically assigns numbers to requests and preserves their history
                  "%
                  | optional,
                signature
                  | predicates.contract_from_predicate
                  definitions.predicate."http.SignatureTypeHolder"
                  | doc m%"
                  Signature is the HTTP Request signature Method
                  "%
                  | optional,
                skip-variables-check
                  | Bool
                  | doc m%"
                  Skips the check for unresolved variables in request
                  "%
                  | optional,
                stop-at-first-match
                  | Bool
                  | doc m%"
                  Stop the execution after a match is found
                  "%
                  | optional,
                threads
                  | std.number.Integer
                  | doc m%"
                  Threads specifies number of threads to use sending requests. This enables Connection Pooling
                  "%
                  | optional,
                unsafe
                  | Bool
                  | doc m%"
                  Unsafe specifies whether to use rawhttp engine for sending Non RFC-Compliant requests
                  "%
                  | optional,
              },
          "http.SignatureTypeHolder"
            | doc m%"
            Type of the signature
            "%
            = std.contract.Sequence [ std.enum.TagOrString, [| 'AWS |] ],
          "javascript.Request" = {
                args
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    {
                      ".*" = predicates.records.record {  } {  } true
                          predicates.always,
                    }
                    true
                    predicates.always
                  ])
                  | optional,
                attack
                  | definitions.contract."generators.AttackTypeHolder"
                  | doc m%"
                  Attack is the type of payload combinations to perform
                  "%
                  | optional,
                code
                  | String
                  | doc m%"
                  Executes inline javascript code for the request
                  "%
                  | optional,
                extractors
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."extractors.Extractor"
                  ])
                  | doc m%"
                  Extractors contains the extraction mechanism for the request to identify and extract parts of the response
                  "%
                  | optional,
                id
                  | String
                  | doc m%"
                  ID is the optional ID of the Request
                  "%
                  | optional,
                init
                  | String
                  | doc m%"
                  Init is the javascript code to execute after compiling template
                  "%
                  | optional,
                matchers
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."matchers.Matcher"
                  ])
                  | doc m%"
                  Detection mechanism to identify whether the request was successful by doing pattern matching
                  "%
                  | optional,
                matchers-condition
                  | std.enum.TagOrString
                  | [| 'or, 'and |]
                  | doc m%"
                  Conditions between the matchers
                  "%
                  | optional,
                payloads
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    {
                      ".*" = predicates.records.record {  } {  } true
                          predicates.always,
                    }
                    true
                    predicates.always
                  ])
                  | doc m%"
                  Payloads contains any payloads for the current request
                  "%
                  | optional,
                pre-condition
                  | String
                  | doc m%"
                  PreCondition is a condition which is evaluated before sending the request
                  "%
                  | optional,
                stop-at-first-match
                  | Bool
                  | doc m%"
                  Stop the execution after a match is found
                  "%
                  | optional,
                threads
                  | std.number.Integer
                  | doc m%"
                  Threads specifies number of threads to use sending requests. This enables Connection Pooling
                  "%
                  | optional,
              },
          "matchers.Matcher" = {
                binary
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Binary are the binary patterns required to be present in the response part
                  "%
                  | optional,
                case-insensitive
                  | Bool
                  | doc m%"
                  use case insensitive match
                  "%
                  | optional,
                condition
                  | std.enum.TagOrString
                  | [| 'or, 'and |]
                  | doc m%"
                  Condition between the matcher variables
                  "%
                  | optional,
                dsl
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  DSL are the dsl expressions that will be evaluated as part of nuclei matching rules
                  "%
                  | optional,
                encoding
                  | std.enum.TagOrString
                  | [| 'hex |]
                  | doc m%"
                  Optional encoding for the word fields
                  "%
                  | optional,
                match-all
                  | Bool
                  | doc m%"
                  match all matcher values ignoring condition
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  Name of the matcher
                  "%
                  | optional,
                negative
                  | Bool
                  | doc m%"
                  Negative specifies if the match should be reversed. It will only match if the condition is not true
                  "%
                  | optional,
                part
                  | String
                  | doc m%"
                  Part of response to match data from
                  "%
                  | optional,
                regex
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Regex contains regex patterns required to be present in the response part
                  "%
                  | optional,
                size
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType 'Integer)
                  ])
                  | doc m%"
                  Size is the acceptable size for the response
                  "%
                  | optional,
                status
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType 'Integer)
                  ])
                  | doc m%"
                  Status to match for the response
                  "%
                  | optional,
                type
                  | predicates.contract_from_predicate
                  definitions.predicate."matchers.MatcherTypeHolder"
                  | doc m%"
                  Type of the matcher
                  "%,
                words
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                   Words contains word patterns required to be present in the response part
                  "%
                  | optional,
                xpath
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  xpath are the XPath queries that will be evaluated against the response part of nuclei matching rules
                  "%
                  | optional,
              },
          "matchers.MatcherTypeHolder"
            | doc m%"
            Type of the matcher
            "%
            = std.contract.Sequence
              [
                std.enum.TagOrString,
                [| 'xpath, 'dsl, 'size, 'status, 'binary, 'regex, 'word |]
              ],
          "model.Classification" = {
                cpe
                  | String
                  | doc m%"
                  CPE for the template
                  "%
                  | optional,
                cve-id
                  | definitions.contract."stringslice.StringSlice"
                  | doc m%"
                  CVE IDs for the template
                  "%
                  | optional,
                cvss-metrics
                  | String
                  | doc m%"
                  CVSS Metrics for the template
                  "%
                  | optional,
                cvss-score
                  | Number
                  | doc m%"
                  CVSS Score for the template
                  "%
                  | optional,
                cwe-id
                  | definitions.contract."stringslice.StringSlice"
                  | doc m%"
                  CWE IDs for the template
                  "%
                  | optional,
                epss-percentile
                  | Number
                  | doc m%"
                  EPSS Percentile for the template
                  "%
                  | optional,
                epss-score
                  | Number
                  | doc m%"
                  EPSS Score for the template
                  "%
                  | optional,
              },
          "model.Info" = {
                author
                  | predicates.contract_from_predicate
                  definitions.predicate."stringslice.StringSlice"
                  | doc m%"
                  Author is the author of the template
                  "%
                  | optional,
                classification
                  | predicates.contract_from_predicate
                  definitions.predicate."model.Classification"
                  | doc m%"
                  Classification information for the template
                  "%
                  | optional,
                description
                  | String
                  | doc m%"
                  In-depth explanation on what the template does
                  "%
                  | optional,
                impact
                  | String
                  | doc m%"
                  In-depth explanation on the impact of the issue found by the template
                  "%
                  | optional,
                metadata
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    {
                      ".*" = predicates.records.record {  } {  } true
                          predicates.always,
                    }
                    true
                    predicates.always
                  ])
                  | doc m%"
                  Additional metadata fields for the template
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  Name is a short summary of what the template does
                  "%
                  | optional,
                reference
                  | predicates.contract_from_predicate
                  definitions.predicate."stringslice.RawStringSlice"
                  | doc m%"
                  Links relevant to the template
                  "%
                  | optional,
                remediation
                  | String
                  | doc m%"
                  In-depth explanation on how to fix the issues found by the template
                  "%
                  | optional,
                severity
                  | predicates.contract_from_predicate
                  definitions.predicate."severity.Holder"
                  | optional,
                tags
                  | definitions.contract."stringslice.StringSlice"
                  | doc m%"
                  Any tags for the template
                  "%
                  | optional,
              },
          "network.Input" = {
                data
                  | String
                  | doc m%"
                  Data is the data to send as the input
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  Optional name of the data read to provide matching on
                  "%
                  | optional,
                read
                  | std.number.Integer
                  | doc m%"
                  Number of bytes to read from socket
                  "%
                  | optional,
                type
                  | predicates.contract_from_predicate
                  definitions.predicate."network.NetworkInputTypeHolder"
                  | doc m%"
                  Type of input specified in data field
                  "%
                  | optional,
              },
          "network.NetworkInputTypeHolder"
            | doc m%"
            description=Type of input specified in data field
            "%
            = std.contract.Sequence [ std.enum.TagOrString, [| 'text, 'hex |] ],
          "network.Request" = {
                attack
                  | definitions.contract."generators.AttackTypeHolder"
                  | doc m%"
                  Attack is the type of payload combinations to perform
                  "%
                  | optional,
                exclude-ports
                  | String
                  | doc m%"
                  Exclude ports from being scanned
                  "%
                  | optional,
                extractors
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."extractors.Extractor"
                  ])
                  | doc m%"
                  Extractors contains the extraction mechanism for the request to identify and extract parts of the response
                  "%
                  | optional,
                host
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Host to send network requests to
                  "%
                  | optional,
                id
                  | String
                  | doc m%"
                  ID of the network request
                  "%
                  | optional,
                inputs
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."network.Input"
                  ])
                  | doc m%"
                  Inputs contains any input/output for the current request
                  "%
                  | optional,
                matchers
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."matchers.Matcher"
                  ])
                  | doc m%"
                  Detection mechanism to identify whether the request was successful by doing pattern matching
                  "%
                  | optional,
                matchers-condition
                  | std.enum.TagOrString
                  | [| 'or, 'and |]
                  | doc m%"
                  Conditions between the matchers
                  "%
                  | optional,
                payloads
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    {
                      ".*" = predicates.records.record {  } {  } true
                          predicates.always,
                    }
                    true
                    predicates.always
                  ])
                  | doc m%"
                  Payloads contains any payloads for the current request
                  "%
                  | optional,
                port
                  | String
                  | doc m%"
                  Port to send network requests to
                  "%
                  | optional,
                read-all
                  | Bool
                  | doc m%"
                  Read all response stream till the server stops sending
                  "%
                  | optional,
                read-size
                  | std.number.Integer
                  | doc m%"
                  Size of response to read at the end. Default is 1024 bytes
                  "%
                  | optional,
              },
          "severity.Holder"
            | doc m%"
            Seriousness of the implications of the template
            "%
            = std.contract.Sequence
              [
                std.enum.TagOrString,
                [| 'unknown, 'critical, 'high, 'medium, 'low, 'info |]
              ],
          "ssl.Request" = {
                address
                  | String
                  | doc m%"
                  Address contains address for the request
                  "%
                  | optional,
                cipher_suites
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                extractors
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."extractors.Extractor"
                  ])
                  | doc m%"
                  Extractors contains the extraction mechanism for the request to identify and extract parts of the response
                  "%
                  | optional,
                id
                  | String
                  | doc m%"
                  ID of the request
                  "%
                  | optional,
                matchers
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."matchers.Matcher"
                  ])
                  | doc m%"
                  Detection mechanism to identify whether the request was successful by doing pattern matching
                  "%
                  | optional,
                matchers-condition
                  | std.enum.TagOrString
                  | [| 'or, 'and |]
                  | doc m%"
                  Conditions between the matchers
                  "%
                  | optional,
                max_version
                  | std.enum.TagOrString
                  | [| 'tls13, 'tls12, 'tls11, 'tls10, 'sslv3 |]
                  | doc m%"
                  Max tls version - automatic if not specified.
                  "%
                  | optional,
                min_version
                  | std.enum.TagOrString
                  | [| 'tls13, 'tls12, 'tls11, 'tls10, 'sslv3 |]
                  | doc m%"
                  Minimum tls version - automatic if not specified.
                  "%
                  | optional,
                scan_mode
                  | std.enum.TagOrString
                  | [| 'auto, 'ztls, 'ctls |]
                  | doc m%"
                  Scan Mode - auto if not specified.
                  "%
                  | optional,
              },
          "stringslice.RawStringSlice" = predicates.contract_from_predicate
              definitions.predicate."stringslice.RawStringSlice",
          "stringslice.StringSlice" = predicates.contract_from_predicate
              definitions.predicate."stringslice.StringSlice",
          "templates.Template" = {
                code
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."code.Request"
                  ])
                  | doc m%"
                  Code snippets
                  "%
                  | optional,
                constants
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    {
                      ".*" = predicates.records.record {  } {  } true
                          predicates.always,
                    }
                    true
                    predicates.always
                  ])
                  | doc m%"
                  constants contains any constant for the template
                  "%
                  | optional,
                dns
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."dns.Request"
                  ])
                  | doc m%"
                  DNS requests to make for the template
                  "%
                  | optional,
                file
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."file.Request"
                  ])
                  | doc m%"
                  File requests to make for the template
                  "%
                  | optional,
                flow
                  | String
                  | doc m%"
                  Flow contains js code which defines how the template should be executed
                  "%
                  | optional,
                headless
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."headless.Request"
                  ])
                  | doc m%"
                  Headless requests to make for the template
                  "%
                  | optional,
                http
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."http.Request"
                  ])
                  | doc m%"
                  HTTP requests to make for the template
                  "%
                  | optional,
                id
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern
                    "^([a-zA-Z0-9]+[-_])*[a-zA-Z0-9]+$"
                  ])
                  | doc m%"
                  The Unique ID for the template
                  "%,
                info
                  | predicates.contract_from_predicate
                  definitions.predicate."model.Info"
                  | doc m%"
                  Info contains metadata for the template
                  "%,
                javascript
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."javascript.Request"
                  ])
                  | doc m%"
                  Javascript requests to make for the template
                  "%
                  | optional,
                network
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."network.Request"
                  ])
                  | doc m%"
                  Network requests to make for the template
                  "%
                  | optional,
                requests
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."http.Request"
                  ])
                  | doc m%"
                  HTTP requests to make for the template
                  "%
                  | optional,
                self-contained
                  | Bool
                  | doc m%"
                  Mark Requests for the template as self-contained
                  "%
                  | optional,
                signature
                  | definitions.contract."http.SignatureTypeHolder"
                  | doc m%"
                  Signature is the HTTP Request signature Method
                  "%
                  | optional,
                ssl
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."ssl.Request"
                  ])
                  | doc m%"
                  SSL requests to make for the template
                  "%
                  | optional,
                stop-at-first-match
                  | Bool
                  | doc m%"
                  Stop at first match for the template
                  "%
                  | optional,
                tcp
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."network.Request"
                  ])
                  | doc m%"
                  Network requests to make for the template
                  "%
                  | optional,
                variables
                  | predicates.contract_from_predicate
                  definitions.predicate."variables.Variable"
                  | doc m%"
                  Variables contains any variables for the current request
                  "%
                  | optional,
                websocket
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."websocket.Request"
                  ])
                  | doc m%"
                  Websocket requests to make for the template
                  "%
                  | optional,
                whois
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."whois.Request"
                  ])
                  | doc m%"
                  WHOIS requests to make for the template
                  "%
                  | optional,
                workflows
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."workflows.WorkflowTemplate"
                  ])
                  | doc m%"
                  List of workflows to execute for template
                  "%
                  | optional,
              },
          "userAgent.UserAgentHolder"
            | doc m%"
            userAgent for the headless http request
            "%
            = std.contract.Sequence
              [ std.enum.TagOrString, [| 'custom, '"default", 'off |] ],
          "variables.Variable"
            | doc m%"
            Additional variables for the request
            "%
            = {  .. },
          "websocket.Input" = {
                data
                  | String
                  | doc m%"
                  Data is the data to send as the input
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  Optional name of the data read to provide matching on
                  "%
                  | optional,
              },
          "websocket.Request" = {
                address
                  | String
                  | doc m%"
                  Address contains address for the request
                  "%
                  | optional,
                attack
                  | definitions.contract."generators.AttackTypeHolder"
                  | doc m%"
                  Attack is the type of payload combinations to perform
                  "%
                  | optional,
                extractors
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."extractors.Extractor"
                  ])
                  | doc m%"
                  Extractors contains the extraction mechanism for the request to identify and extract parts of the response
                  "%
                  | optional,
                headers
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    { ".*" = predicates.isType '"String", }
                    true
                    predicates.always
                  ])
                  | doc m%"
                  Headers contains headers for the request
                  "%
                  | optional,
                id
                  | String
                  | doc m%"
                  ID of the network request
                  "%
                  | optional,
                inputs
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."websocket.Input"
                  ])
                  | doc m%"
                  Inputs contains any input/output for the current request
                  "%
                  | optional,
                matchers
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."matchers.Matcher"
                  ])
                  | doc m%"
                  Detection mechanism to identify whether the request was successful by doing pattern matching
                  "%
                  | optional,
                matchers-condition
                  | std.enum.TagOrString
                  | [| 'or, 'and |]
                  | doc m%"
                  Conditions between the matchers
                  "%
                  | optional,
                payloads
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  }
                    {
                      ".*" = predicates.records.record {  } {  } true
                          predicates.always,
                    }
                    true
                    predicates.always
                  ])
                  | doc m%"
                  Payloads contains any payloads for the current request
                  "%
                  | optional,
              },
          "whois.Request" = {
                extractors
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."extractors.Extractor"
                  ])
                  | doc m%"
                  Extractors contains the extraction mechanism for the request to identify and extract parts of the response
                  "%
                  | optional,
                id
                  | String
                  | doc m%"
                  ID of the network request
                  "%
                  | optional,
                matchers
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."matchers.Matcher"
                  ])
                  | doc m%"
                  Detection mechanism to identify whether the request was successful by doing pattern matching
                  "%
                  | optional,
                matchers-condition
                  | std.enum.TagOrString
                  | [| 'or, 'and |]
                  | doc m%"
                  Conditions between the matchers
                  "%
                  | optional,
                query
                  | String
                  | doc m%"
                  Query contains query for the request
                  "%
                  | optional,
                server
                  | String
                  | doc m%"
                  Server contains the server url to execute the WHOIS request on
                  "%
                  | optional,
              },
          "workflows.Matcher" = {
                condition
                  | std.enum.TagOrString
                  | [| 'or, 'and |]
                  | doc m%"
                  Condition between the names
                  "%
                  | optional,
                name
                  | definitions.contract."stringslice.StringSlice"
                  | doc m%"
                  Name of items to match
                  "%
                  | optional,
                subtemplates
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."workflows.WorkflowTemplate"
                  ])
                  | doc m%"
                  Templates to run after match
                  "%
                  | optional,
              },
          "workflows.WorkflowTemplate" = {
                matchers
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."workflows.Matcher"
                  ])
                  | doc m%"
                  Matchers perform name based matching to run subtemplates for a workflow
                  "%
                  | optional,
                subtemplates
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate."workflows.WorkflowTemplate"
                  ])
                  | doc m%"
                  Subtemplates are ran if the template field Template matches
                  "%
                  | optional,
                tags
                  | definitions.contract."stringslice.StringSlice"
                  | doc m%"
                  Tags to run template based on
                  "%
                  | optional,
                template
                  | String
                  | doc m%"
                  Template or directory to execute as part of workflow
                  "%
                  | optional,
              },
        },
    predicate = {
          "code.Request" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  args = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  engine = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "python", "powershell", "command" ]
                        ])
                      ],
                  extractors = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."extractors.Extractor"
                      ],
                  id = predicates.isType '"String",
                  matchers = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."matchers.Matcher"
                      ],
                  matchers-condition = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "and", "or" ]
                      ],
                  pattern = predicates.isType '"String",
                  source = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          "dns.DNSRequestTypeHolder"
            | doc m%"
            Type is the type of DNS request to make
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [
                  "A",
                  "NS",
                  "DS",
                  "CNAME",
                  "SOA",
                  "PTR",
                  "MX",
                  "TXT",
                  "AAAA",
                  "CAA",
                  "TLSA",
                  "ANY"
                ]
              ],
          "dns.Request" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  attack = definitions.predicate."generators.AttackTypeHolder",
                  class = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [ "inet", "csnet", "chaos", "hesiod", "none", "any" ]
                      ],
                  extractors = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."extractors.Extractor"
                      ],
                  id = predicates.isType '"String",
                  matchers = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."matchers.Matcher"
                      ],
                  matchers-condition = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "and", "or" ]
                      ],
                  name = predicates.isType '"String",
                  payloads = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          ".*" = predicates.records.record {  } {  } true
                              predicates.always,
                        }
                        true
                        predicates.always
                      ],
                  recursion = predicates.isType '"Bool",
                  resolvers = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  retries = predicates.isType 'Integer,
                  trace = predicates.isType '"Bool",
                  trace-max-recursion = predicates.isType 'Integer,
                  type = definitions.predicate."dns.DNSRequestTypeHolder",
                }
                {  }
                false
                predicates.never
              ],
          "engine.Action" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "action" ],
                predicates.records.record
                {
                  action = definitions.predicate."engine.ActionTypeHolder",
                  args = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        { ".*" = predicates.isType '"String", }
                        true
                        predicates.always
                      ],
                  description = predicates.isType '"String",
                  name = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          "engine.ActionTypeHolder"
            | doc m%"
            Type of actions to perform
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [
                  "navigate",
                  "script",
                  "click",
                  "rightclick",
                  "text",
                  "screenshot",
                  "time",
                  "select",
                  "files",
                  "waitload",
                  "getresource",
                  "extract",
                  "setmethod",
                  "addheader",
                  "setheader",
                  "deleteheader",
                  "setbody",
                  "waitevent",
                  "keyboard",
                  "debug",
                  "sleep",
                  "waitvisible"
                ]
              ],
          "extractors.Extractor" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "type" ],
                predicates.records.record
                {
                  attribute = predicates.isType '"String",
                  case-insensitive = predicates.isType '"Bool",
                  dsl = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  group = predicates.isType 'Integer,
                  internal = predicates.isType '"Bool",
                  json = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  kval = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  name = predicates.isType '"String",
                  part = predicates.isType '"String",
                  regex = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  to = predicates.isType '"String",
                  type = definitions.predicate."extractors.ExtractorTypeHolder",
                  xpath = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          "extractors.ExtractorTypeHolder"
            | doc m%"
            Type of the extractor
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "regex", "kval", "xpath", "json", "dsl" ]
              ],
          "file.Request" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  archive = predicates.isType '"Bool",
                  denylist = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  extensions = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  extractors = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."extractors.Extractor"
                      ],
                  id = predicates.isType '"String",
                  matchers = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."matchers.Matcher"
                      ],
                  matchers-condition = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "and", "or" ]
                      ],
                  max-size = predicates.isType '"String",
                  mime-type = predicates.isType '"Bool",
                  no-recursive = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          "fuzz.Rule" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  fuzz = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  keys = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  keys-regex = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  mode = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "single", "multiple" ]
                      ],
                  part = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "query" ]
                      ],
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [ "replace", "prefix", "postfix", "infix" ]
                      ],
                  values = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          "generators.AttackTypeHolder"
            | doc m%"
            Type of the attack
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "batteringram", "pitchfork", "clusterbomb" ]
              ],
          "headless.Request" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  attack = definitions.predicate."generators.AttackTypeHolder",
                  cookie-reuse = predicates.isType '"Bool",
                  custom_user_agent = predicates.isType '"String",
                  extractors = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."extractors.Extractor"
                      ],
                  fuzzing = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."fuzz.Rule"
                      ],
                  id = predicates.isType '"String",
                  matchers = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."matchers.Matcher"
                      ],
                  matchers-condition = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "and", "or" ]
                      ],
                  payloads = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          ".*" = predicates.records.record {  } {  } true
                              predicates.always,
                        }
                        true
                        predicates.always
                      ],
                  steps = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."engine.Action"
                      ],
                  stop-at-first-match = predicates.isType '"Bool",
                  user_agent =
                    definitions.predicate."userAgent.UserAgentHolder",
                }
                {  }
                false
                predicates.never
              ],
          "http.HTTPMethodTypeHolder"
            | doc m%"
            Method is the HTTP Request Method
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [
                  "GET",
                  "HEAD",
                  "POST",
                  "PUT",
                  "DELETE",
                  "CONNECT",
                  "OPTIONS",
                  "TRACE",
                  "PATCH",
                  "PURGE",
                  "DEBUG"
                ]
              ],
          "http.Request" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  attack = definitions.predicate."generators.AttackTypeHolder",
                  body = predicates.isType '"String",
                  cookie-reuse = predicates.isType '"Bool",
                  digest-password = predicates.isType '"String",
                  digest-username = predicates.isType '"String",
                  disable-path-automerge = predicates.isType '"Bool",
                  extractors = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."extractors.Extractor"
                      ],
                  fuzzing = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."fuzz.Rule"
                      ],
                  headers = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        { ".*" = predicates.isType '"String", }
                        true
                        predicates.always
                      ],
                  host-redirects = predicates.isType '"Bool",
                  id = predicates.isType '"String",
                  iterate-all = predicates.isType '"Bool",
                  matchers = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."matchers.Matcher"
                      ],
                  matchers-condition = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "and", "or" ]
                      ],
                  max-redirects = predicates.isType 'Integer,
                  max-size = predicates.isType 'Integer,
                  method = definitions.predicate."http.HTTPMethodTypeHolder",
                  name = predicates.isType '"String",
                  path = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  payloads = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          ".*" = predicates.records.record {  } {  } true
                              predicates.always,
                        }
                        true
                        predicates.always
                      ],
                  pipeline = predicates.isType '"Bool",
                  pipeline-concurrent-connections = predicates.isType 'Integer,
                  pipeline-requests-per-connection = predicates.isType 'Integer,
                  race = predicates.isType '"Bool",
                  race_count = predicates.isType 'Integer,
                  raw = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  read-all = predicates.isType '"Bool",
                  redirects = predicates.isType '"Bool",
                  req-condition = predicates.isType '"Bool",
                  signature = definitions.predicate."http.SignatureTypeHolder",
                  skip-variables-check = predicates.isType '"Bool",
                  stop-at-first-match = predicates.isType '"Bool",
                  threads = predicates.isType 'Integer,
                  unsafe = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          "http.SignatureTypeHolder"
            | doc m%"
            Type of the signature
            "%
            = predicates.allOf
              [ predicates.isType '"String", predicates.enum [ "AWS" ] ],
          "javascript.Request" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  args = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          ".*" = predicates.records.record {  } {  } true
                              predicates.always,
                        }
                        true
                        predicates.always
                      ],
                  attack = definitions.predicate."generators.AttackTypeHolder",
                  code = predicates.isType '"String",
                  extractors = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."extractors.Extractor"
                      ],
                  id = predicates.isType '"String",
                  init = predicates.isType '"String",
                  matchers = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."matchers.Matcher"
                      ],
                  matchers-condition = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "and", "or" ]
                      ],
                  payloads = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          ".*" = predicates.records.record {  } {  } true
                              predicates.always,
                        }
                        true
                        predicates.always
                      ],
                  pre-condition = predicates.isType '"String",
                  stop-at-first-match = predicates.isType '"Bool",
                  threads = predicates.isType 'Integer,
                }
                {  }
                false
                predicates.never
              ],
          "matchers.Matcher" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "type" ],
                predicates.records.record
                {
                  binary = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  case-insensitive = predicates.isType '"Bool",
                  condition = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "and", "or" ]
                      ],
                  dsl = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  encoding = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "hex" ]
                      ],
                  match-all = predicates.isType '"Bool",
                  name = predicates.isType '"String",
                  negative = predicates.isType '"Bool",
                  part = predicates.isType '"String",
                  regex = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  size = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType 'Integer)
                      ],
                  status = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType 'Integer)
                      ],
                  type = definitions.predicate."matchers.MatcherTypeHolder",
                  words = predicates.allOf
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
                false
                predicates.never
              ],
          "matchers.MatcherTypeHolder"
            | doc m%"
            Type of the matcher
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [ "word", "regex", "binary", "status", "size", "dsl", "xpath" ]
              ],
          "model.Classification" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  cpe = predicates.isType '"String",
                  cve-id = definitions.predicate."stringslice.StringSlice",
                  cvss-metrics = predicates.isType '"String",
                  cvss-score = predicates.isType '"Number",
                  cwe-id = definitions.predicate."stringslice.StringSlice",
                  epss-percentile = predicates.isType '"Number",
                  epss-score = predicates.isType '"Number",
                }
                {  }
                false
                predicates.never
              ],
          "model.Info" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  author = definitions.predicate."stringslice.StringSlice",
                  classification = definitions.predicate."model.Classification",
                  description = predicates.isType '"String",
                  impact = predicates.isType '"String",
                  metadata = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          ".*" = predicates.records.record {  } {  } true
                              predicates.always,
                        }
                        true
                        predicates.always
                      ],
                  name = predicates.isType '"String",
                  reference =
                    definitions.predicate."stringslice.RawStringSlice",
                  remediation = predicates.isType '"String",
                  severity = definitions.predicate."severity.Holder",
                  tags = definitions.predicate."stringslice.StringSlice",
                }
                {  }
                false
                predicates.never
              ],
          "network.Input" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  data = predicates.isType '"String",
                  name = predicates.isType '"String",
                  read = predicates.isType 'Integer,
                  type = definitions.predicate."network.NetworkInputTypeHolder",
                }
                {  }
                false
                predicates.never
              ],
          "network.NetworkInputTypeHolder"
            | doc m%"
            description=Type of input specified in data field
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "hex", "text" ]
              ],
          "network.Request" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  attack = definitions.predicate."generators.AttackTypeHolder",
                  exclude-ports = predicates.isType '"String",
                  extractors = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."extractors.Extractor"
                      ],
                  host = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  id = predicates.isType '"String",
                  inputs = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."network.Input"
                      ],
                  matchers = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."matchers.Matcher"
                      ],
                  matchers-condition = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "and", "or" ]
                      ],
                  payloads = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          ".*" = predicates.records.record {  } {  } true
                              predicates.always,
                        }
                        true
                        predicates.always
                      ],
                  port = predicates.isType '"String",
                  read-all = predicates.isType '"Bool",
                  read-size = predicates.isType 'Integer,
                }
                {  }
                false
                predicates.never
              ],
          "severity.Holder"
            | doc m%"
            Seriousness of the implications of the template
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [ "info", "low", "medium", "high", "critical", "unknown" ]
              ],
          "ssl.Request" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  address = predicates.isType '"String",
                  cipher_suites = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  extractors = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."extractors.Extractor"
                      ],
                  id = predicates.isType '"String",
                  matchers = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."matchers.Matcher"
                      ],
                  matchers-condition = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "and", "or" ]
                      ],
                  max_version = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [ "sslv3", "tls10", "tls11", "tls12", "tls13" ]
                      ],
                  min_version = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [ "sslv3", "tls10", "tls11", "tls12", "tls13" ]
                      ],
                  scan_mode = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "ctls", "ztls", "auto" ]
                      ],
                }
                {  }
                false
                predicates.never
              ],
          "stringslice.RawStringSlice" = predicates.oneOf
              [ predicates.isType '"String", predicates.isType '"Array" ],
          "stringslice.StringSlice" = predicates.oneOf
              [ predicates.isType '"String", predicates.isType '"Array" ],
          "templates.Template" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "id", "info" ],
                predicates.records.record
                {
                  code = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."code.Request"
                      ],
                  constants = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          ".*" = predicates.records.record {  } {  } true
                              predicates.always,
                        }
                        true
                        predicates.always
                      ],
                  dns = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."dns.Request"
                      ],
                  file = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."file.Request"
                      ],
                  flow = predicates.isType '"String",
                  headless = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."headless.Request"
                      ],
                  http = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."http.Request"
                      ],
                  id = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern
                        "^([a-zA-Z0-9]+[-_])*[a-zA-Z0-9]+$"
                      ],
                  info = definitions.predicate."model.Info",
                  javascript = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."javascript.Request"
                      ],
                  network = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."network.Request"
                      ],
                  requests = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."http.Request"
                      ],
                  self-contained = predicates.isType '"Bool",
                  signature = definitions.predicate."http.SignatureTypeHolder",
                  ssl = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."ssl.Request"
                      ],
                  stop-at-first-match = predicates.isType '"Bool",
                  tcp = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."network.Request"
                      ],
                  variables = definitions.predicate."variables.Variable",
                  websocket = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."websocket.Request"
                      ],
                  whois = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."whois.Request"
                      ],
                  workflows = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."workflows.WorkflowTemplate"
                      ],
                }
                {  }
                false
                predicates.never
              ],
          "userAgent.UserAgentHolder"
            | doc m%"
            userAgent for the headless http request
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "off", "default", "custom" ]
              ],
          "variables.Variable"
            | doc m%"
            Additional variables for the request
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  } {  } true predicates.always
              ],
          "websocket.Input" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  data = predicates.isType '"String",
                  name = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          "websocket.Request" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  address = predicates.isType '"String",
                  attack = definitions.predicate."generators.AttackTypeHolder",
                  extractors = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."extractors.Extractor"
                      ],
                  headers = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        { ".*" = predicates.isType '"String", }
                        true
                        predicates.always
                      ],
                  id = predicates.isType '"String",
                  inputs = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."websocket.Input"
                      ],
                  matchers = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."matchers.Matcher"
                      ],
                  matchers-condition = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "and", "or" ]
                      ],
                  payloads = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  }
                        {
                          ".*" = predicates.records.record {  } {  } true
                              predicates.always,
                        }
                        true
                        predicates.always
                      ],
                }
                {  }
                false
                predicates.never
              ],
          "whois.Request" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  extractors = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."extractors.Extractor"
                      ],
                  id = predicates.isType '"String",
                  matchers = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."matchers.Matcher"
                      ],
                  matchers-condition = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "and", "or" ]
                      ],
                  query = predicates.isType '"String",
                  server = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          "workflows.Matcher" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  condition = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "and", "or" ]
                      ],
                  name = definitions.predicate."stringslice.StringSlice",
                  subtemplates = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."workflows.WorkflowTemplate"
                      ],
                }
                {  }
                false
                predicates.never
              ],
          "workflows.WorkflowTemplate" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  matchers = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."workflows.Matcher"
                      ],
                  subtemplates = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate."workflows.WorkflowTemplate"
                      ],
                  tags = definitions.predicate."stringslice.StringSlice",
                  template = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
        },
  }
in

definitions.contract."templates.Template"