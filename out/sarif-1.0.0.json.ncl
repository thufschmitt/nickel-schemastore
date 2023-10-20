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
          annotatedCodeLocation
            | doc m%"
            An annotation used to express code flows through a method or other locations that are related to a result.
            "%
            = {
                annotations
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.annotation,
                    predicates.arrays.minItems 1,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  A set of messages relevant to the current annotated code location.
                  "%
                  | optional,
                essential
                  | Bool
                  | doc m%"
                  OBSOLETE (use "importance" instead): True if this location is essential to understanding the code flow in which it occurs.
                  "%
                  | optional,
                fullyQualifiedLogicalName
                  | String
                  | doc m%"
                  The fully qualified name of the method or function that is executing.
                  "%
                  | optional,
                id
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType 'Integer, predicates.isType '"String" ],
                    predicates.numbers.minimum 1,
                    predicates.strings.pattern "^[1-9][0-9]*$"
                  ])
                  | doc m%"
                  OBSOLETE (use "step" instead): An identifier for the location, unique within the scope of the code flow within which it occurs.
                  "%
                  | optional,
                importance
                  | predicates.contract_from_predicate
                  (predicates.enum [ "important", "essential", "unimportant" ])
                  | doc m%"
                  Specifies the importance of this location in understanding the code flow in which it occurs. The order from most to least important is "essential", "important", "unimportant". Default: "important".
                  "%
                  | optional,
                kind
                  | predicates.contract_from_predicate
                  (predicates.enum
                  [
                    "alias",
                    "assignment",
                    "branch",
                    "call",
                    "callReturn",
                    "continuation",
                    "declaration",
                    "functionEnter",
                    "functionExit",
                    "functionReturn",
                    "usage"
                  ])
                  | doc m%"
                  Categorizes the location.
                  "%
                  | optional,
                logicalLocationKey
                  | String
                  | doc m%"
                  A key used to retrieve the annotation's logicalLocation from the logicalLocations dictionary.
                  "%
                  | optional,
                message
                  | String
                  | doc m%"
                  A message relevant to this annotation.
                  "%
                  | optional,
                module
                  | String
                  | doc m%"
                  The name of the module that contains the code that is executing.
                  "%
                  | optional,
                physicalLocation
                  | definitions.contract.physicalLocation
                  | doc m%"
                  A file location to which this annotation refers.
                  "%
                  | optional,
                properties
                  | {
                    tags
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.uniqueItems
                      ])
                      | doc m%"
                      A set of distinct strings that provide additional information.
                      "%
                      | optional,
                    ..
                  }
                  | doc m%"
                  Key/value pairs that provide additional information about the code location.
                  "%
                  | optional,
                snippet
                  | String
                  | doc m%"
                  The source code at the specified location.
                  "%
                  | optional,
                state
                  | {  .. }
                  | doc m%"
                  A dictionary, each of whose keys specifies a variable or expression, the associated value of which represents the variable or expression value. For an annotation of kind 'continuation', for example, this dictionary might hold the current assumed values of a set of global variables.
                  "%
                  | optional,
                step
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType 'Integer, predicates.numbers.minimum 0 ])
                  | doc m%"
                  The 0-based sequence number of the location in the code flow within which it occurs.
                  "%
                  | optional,
                taintKind
                  | predicates.contract_from_predicate
                  (predicates.enum [ "source", "sink", "sanitizer" ])
                  | doc m%"
                  Classifies state transitions in code locations relevant to a taint analysis.
                  "%
                  | optional,
                target
                  | String
                  | doc m%"
                  The fully qualified name of the target on which this location operates. For an annotation of kind 'call', for example, the target refers to the fully qualified logical name of the function called from this location.
                  "%
                  | optional,
                targetKey
                  | String
                  | doc m%"
                  A key used to retrieve the target's logicalLocation from the logicalLocations dictionary.
                  "%
                  | optional,
                threadId
                  | std.number.Integer
                  | doc m%"
                  The thread identifier of the code that is executing.
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
                  An ordered set of strings that comprise input or return values for the current operation. For an annotation of kind 'call', for example, this property may hold the ordered list of arguments passed to the callee.
                  "%
                  | optional,
              },
          annotation = {
                locations
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.physicalLocation,
                    predicates.arrays.minItems 1
                  ])
                  | doc m%"
                  An array of 'physicalLocation' objects associated with the annotation.
                  "%,
                message
                  | String
                  | doc m%"
                  A message relevant to a code location
                  "%,
                ..
              },
          codeFlow = {
                locations
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.annotatedCodeLocation,
                    predicates.arrays.minItems 1
                  ])
                  | doc m%"
                  An array of 'annotatedCodeLocation' objects, each of which describes a single location visited by the tool in the course of producing the result.
                  "%,
                message
                  | String
                  | doc m%"
                  A message relevant to the code flow
                  "%
                  | optional,
                properties
                  | {
                    tags
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.uniqueItems
                      ])
                      | doc m%"
                      A set of distinct strings that provide additional information.
                      "%
                      | optional,
                    ..
                  }
                  | doc m%"
                  Key/value pairs that provide additional information about the code flow.
                  "%
                  | optional,
                ..
              },
          exception = {
                innerExceptions
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.exception
                  ])
                  | doc m%"
                  An array of exception objects each of which is considered a cause of this exception.
                  "%
                  | optional,
                kind
                  | String
                  | doc m%"
                  A string that identifies the kind of exception, for example, the fully qualified type name of an object that was thrown, or the symbolic name of a signal.
                  "%
                  | optional,
                message
                  | String
                  | doc m%"
                  A string that describes the exception.
                  "%
                  | optional,
                stack
                  | definitions.contract.stack
                  | doc m%"
                  The sequence of function calls leading to the exception.
                  "%
                  | optional,
                ..
              },
          file
            | doc m%"
            A single file. In some cases, this file might be nested within another file.
            "%
            = predicates.contract_from_predicate definitions.predicate.file,
          fileChange
            | doc m%"
            A change to a single file.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.fileChange,
          fix
            | doc m%"
            A proposed fix for the problem represented by a result object. A fix specifies a set of file to modify. For each file, it specifies a set of bytes to remove, and provides a set of new bytes to replace them.
            "%
            = {
                description
                  | String
                  | doc m%"
                  A string that describes the proposed fix, enabling viewers to present a proposed change to an end user.
                  "%,
                fileChanges
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.fileChange
                  ])
                  | doc m%"
                  One or more file changes that comprise a fix for a result.
                  "%,
              },
          formattedRuleMessage
            | doc m%"
            Contains information that can be used to construct a formatted message that describes a result.
            "%
            = {
                arguments
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  An array of strings that will be used, in combination with a message format, to construct a result message.
                  "%
                  | optional,
                formatId
                  | String
                  | doc m%"
                  A string that identifies the message format used to format the message that describes this result. The value of formatId must correspond to one of the names in the set of name/value pairs contained in the 'messageFormats' property of the rule object whose 'id' property matches the 'ruleId' property of this result.
                  "%,
              },
          hash
            | doc m%"
            A hash value of some file or collection of files, together with the algorithm used to compute the hash.
            "%
            = {
                algorithm
                  | predicates.contract_from_predicate
                  (predicates.enum
                  [
                    "authentihash",
                    "blake256",
                    "blake512",
                    "ecoh",
                    "fsb",
                    "gost",
                    "groestl",
                    "has160",
                    "haval",
                    "jh",
                    "md2",
                    "md4",
                    "md5",
                    "md6",
                    "radioGatun",
                    "ripeMD",
                    "ripeMD128",
                    "ripeMD160",
                    "ripeMD320",
                    "sdhash",
                    "sha1",
                    "sha224",
                    "sha256",
                    "sha384",
                    "sha512",
                    "sha3",
                    "skein",
                    "snefru",
                    "spectralHash",
                    "ssdeep",
                    "swifft",
                    "tiger",
                    "tlsh",
                    "whirlpool"
                  ])
                  | doc m%"
                  The name of the algorithm used to compute the hash value specified in the 'value' property.
                  "%,
                value
                  | String
                  | doc m%"
                  The hash value of some file or collection of files, computed by the algorithm named in the 'algorithm' property.
                  "%,
              },
          invocation
            | doc m%"
            The runtime environment of the analysis tool run.
            "%
            = {
                account
                  | String
                  | doc m%"
                  The account that ran the analysis tool.
                  "%
                  | optional,
                commandLine
                  | String
                  | doc m%"
                  The command line used to invoke the tool.
                  "%
                  | optional,
                endTime
                  | String
                  | doc m%"
                  The date and time at which the run ended. See "Date/time properties" in the  SARIF spec for the required format.
                  "%
                  | optional,
                environmentVariables
                  | {  .. }
                  | doc m%"
                  The environment variables associated with the analysis tool process, expressed as key/value pairs.
                  "%
                  | optional,
                fileName
                  | String
                  | doc m%"
                  The fully qualified path to the analysis tool.
                  "%
                  | optional,
                machine
                  | String
                  | doc m%"
                  The machine that hosted the analysis tool run.
                  "%
                  | optional,
                processId
                  | std.number.Integer
                  | doc m%"
                  The process id for the analysis tool run.
                  "%
                  | optional,
                properties
                  | {
                    tags
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.uniqueItems
                      ])
                      | doc m%"
                      A set of distinct strings that provide additional information.
                      "%
                      | optional,
                    ..
                  }
                  | doc m%"
                  Key/value pairs that provide additional information about the run.
                  "%
                  | optional,
                responseFiles
                  | {  .. }
                  | doc m%"
                  The contents of any response files specified on the tool's command line.
                  "%
                  | optional,
                startTime
                  | String
                  | doc m%"
                  The date and time at which the run started. See "Date/time properties" in the SARIF spec for the required format.
                  "%
                  | optional,
                workingDirectory
                  | String
                  | doc m%"
                  The working directory for the analysis rool run.
                  "%
                  | optional,
              },
          location
            | doc m%"
            The location where an analysis tool produced a result.
            "%
            = {
                analysisTarget
                  | definitions.contract.physicalLocation
                  | doc m%"
                  Identifies the file that the analysis tool was instructed to scan. This need not be the same as the file where the result actually occurred.
                  "%
                  | optional,
                decoratedName
                  | String
                  | doc m%"
                  The machine-readable fully qualified name for the logical location where the analysis tool produced the result, such as the mangled function name provided by a C++ compiler that encodes calling convention, return type and other details along with the function name.
                  "%
                  | optional,
                fullyQualifiedLogicalName
                  | String
                  | doc m%"
                  The human-readable fully qualified name of the logical location where the analysis tool produced the result. If 'logicalLocationKey' is not specified, this member is can used to retrieve the location logicalLocation from the logicalLocations dictionary, if one exists.
                  "%
                  | optional,
                logicalLocationKey
                  | String
                  | doc m%"
                  A key used to retrieve the location logicalLocation from the logicalLocations dictionary, when the string specified by 'fullyQualifiedLogicalName' is not unique.
                  "%
                  | optional,
                properties
                  | {
                    tags
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.uniqueItems
                      ])
                      | doc m%"
                      A set of distinct strings that provide additional information.
                      "%
                      | optional,
                    ..
                  }
                  | doc m%"
                  Key/value pairs that provide additional information about the location.
                  "%
                  | optional,
                resultFile
                  | definitions.contract.physicalLocation
                  | doc m%"
                  Identifies the file where the analysis tool produced the result.
                  "%
                  | optional,
              },
          logicalLocation
            | doc m%"
            A logical location of a construct that produced a result.
            "%
            = {
                kind
                  | String
                  | doc m%"
                  The type of construct this logicalLocationComponent refers to. Should be one of 'function', 'member', 'module', 'namespace', 'package', 'resource', or 'type', if any of those accurately describe the construct.
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  Identifies the construct in which the result occurred. For example, this property might contain the name of a class or a method.
                  "%
                  | optional,
                parentKey
                  | String
                  | doc m%"
                  Identifies the key of the immediate parent of the construct in which the result was detected. For example, this property might point to a logical location that represents the namespace that holds a type.
                  "%
                  | optional,
              },
          notification
            | doc m%"
            Describes a condition relevant to the tool itself, as opposed to being relevant to a target being analyzed by the tool.
            "%
            = {
                exception
                  | definitions.contract.exception
                  | doc m%"
                  The runtime exception, if any, relevant to this notification.
                  "%
                  | optional,
                id
                  | String
                  | doc m%"
                  An identifier for the condition that was encountered.
                  "%
                  | optional,
                level
                  | predicates.contract_from_predicate
                  (predicates.enum [ "note", "warning", "error" ])
                  | doc m%"
                  A value specifying the severity level of the notification.
                  "%
                  | optional,
                message
                  | String
                  | doc m%"
                  A string that describes the condition that was encountered.
                  "%,
                physicalLocation
                  | definitions.contract.physicalLocation
                  | doc m%"
                  The file and region relevant to this notification.
                  "%
                  | optional,
                properties
                  | {
                    tags
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.uniqueItems
                      ])
                      | doc m%"
                      A set of distinct strings that provide additional information.
                      "%
                      | optional,
                    ..
                  }
                  | doc m%"
                  Key/value pairs that provide additional information about the notification.
                  "%
                  | optional,
                ruleId
                  | String
                  | doc m%"
                  The stable, unique identifier of the rule (if any) to which this notification is relevant. If 'ruleKey' is not specified, this member can be used to retrieve rule metadata from the rules dictionary, if it exists.
                  "%
                  | optional,
                ruleKey
                  | String
                  | doc m%"
                  A key used to retrieve the rule metadata from the rules dictionary that is relevant to the notification.
                  "%
                  | optional,
                threadId
                  | std.number.Integer
                  | doc m%"
                  The thread identifier of the code that generated the notification.
                  "%
                  | optional,
                time
                  | String
                  | doc m%"
                  The date and time at which the analysis tool generated the notification.
                  "%
                  | optional,
              },
          physicalLocation
            | doc m%"
            A physical location relevant to a result. Specifies a reference to a programming artifact together with a range of bytes or characters within that artifact.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.physicalLocation,
          region
            | doc m%"
            A region within a file where a result was detected.
            "%
            = {
                endColumn
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType 'Integer, predicates.numbers.minimum 1 ])
                  | doc m%"
                  The column number of the last character in the region.
                  "%
                  | optional,
                endLine
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType 'Integer, predicates.numbers.minimum 1 ])
                  | doc m%"
                  The line number of the last character in the region.
                  "%
                  | optional,
                length
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType 'Integer, predicates.numbers.minimum 0 ])
                  | doc m%"
                  The length of the region in bytes or characters.
                  "%
                  | optional,
                offset
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType 'Integer, predicates.numbers.minimum 0 ])
                  | doc m%"
                  The zero-based offset from the beginning of the file of the first byte or character in the region.
                  "%
                  | optional,
                startColumn
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType 'Integer, predicates.numbers.minimum 1 ])
                  | doc m%"
                  The column number of the first character in the region.
                  "%
                  | optional,
                startLine
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType 'Integer, predicates.numbers.minimum 1 ])
                  | doc m%"
                  The line number of the first character in the region.
                  "%
                  | optional,
              },
          replacement
            | doc m%"
            The replacement of a single range of bytes in a file. Specifies the location within the file where the replacement is to be made, the number of bytes to remove at that location, and a sequence of bytes to insert at that location.
            "%
            = {
                deletedLength
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType 'Integer, predicates.numbers.minimum 1 ])
                  | doc m%"
                  The number of bytes to delete, starting at the byte offset specified by offset, measured from the beginning of the file.
                  "%
                  | optional,
                insertedBytes
                  | String
                  | doc m%"
                  The MIME Base64-encoded byte sequence to be inserted at the byte offset specified by the 'offset' property, measured from the beginning of the file.
                  "%
                  | optional,
                offset
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType 'Integer, predicates.numbers.minimum 0 ])
                  | doc m%"
                  A non-negative integer specifying the offset in bytes from the beginning of the file at which bytes are to be removed, inserted or both. An offset of 0 shall denote the first byte in the file.
                  "%,
              },
          result
            | doc m%"
            A result produced by an analysis tool.
            "%
            = {
                baselineState
                  | predicates.contract_from_predicate
                  (predicates.enum [ "new", "existing", "absent" ])
                  | doc m%"
                  The state of a result relative to a baseline of a previous run.
                  "%
                  | optional,
                codeFlows
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.codeFlow,
                    predicates.arrays.minItems 1,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  An array of 'codeFlow' objects relevant to the result.
                  "%
                  | optional,
                fixes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.fix,
                    predicates.arrays.minItems 1,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  An array of 'fix' objects, each of which represents a proposed fix to the problem indicated by the result.
                  "%
                  | optional,
                formattedRuleMessage
                  | definitions.contract.formattedRuleMessage
                  | doc m%"
                  A 'formattedRuleMessage' object that can be used to construct a formatted message that describes the result. If the 'formattedMessage' property is present on a result, the 'fullMessage' property shall not be present. If the 'fullMessage' property is present on an result, the 'formattedMessage' property shall not be present
                  "%
                  | optional,
                id
                  | String
                  | doc m%"
                  A unique identifier for the result.
                  "%
                  | optional,
                level
                  | predicates.contract_from_predicate
                  (predicates.enum
                  [ "notApplicable", "pass", "note", "warning", "error" ])
                  | doc m%"
                  A value specifying the severity level of the result. If this property is not present, its implied value is 'warning'.
                  "%
                  | optional,
                locations
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.location,
                    predicates.arrays.minItems 1,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  One or more locations where the result occurred. Specify only one location unless the problem indicated by the result can only be corrected by making a change at every specified location.
                  "%
                  | optional,
                message
                  | String
                  | doc m%"
                  A string that describes the result. The first sentence of the message only will be displayed when visible space is limited.
                  "%
                  | optional,
                properties
                  | {
                    tags
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.uniqueItems
                      ])
                      | doc m%"
                      A set of distinct strings that provide additional information.
                      "%
                      | optional,
                    ..
                  }
                  | doc m%"
                  Key/value pairs that provide additional information about the result.
                  "%
                  | optional,
                relatedLocations
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.annotatedCodeLocation,
                    predicates.arrays.minItems 1,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  A grouped set of locations and messages, if available, that represent code areas that are related to this result.
                  "%
                  | optional,
                ruleId
                  | String
                  | doc m%"
                  The stable, unique identifier of the rule (if any) to which this notification is relevant. If 'ruleKey' is not specified, this member can be used to retrieve rule metadata from the rules dictionary, if it exists.
                  "%
                  | optional,
                ruleKey
                  | String
                  | doc m%"
                  A key used to retrieve the rule metadata from the rules dictionary that is relevant to the notification.
                  "%
                  | optional,
                snippet
                  | String
                  | doc m%"
                  A source code or other file fragment that illustrates the result.
                  "%
                  | optional,
                stacks
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.stack,
                    predicates.arrays.minItems 1,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  An array of 'stack' objects relevant to the result.
                  "%
                  | optional,
                suppressionStates
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.enum
                    [ "suppressedInSource", "suppressedExternally" ])
                  ])
                  | optional,
                toolFingerprintContribution
                  | String
                  | doc m%"
                  A string that contributes to the unique identity of the result.
                  "%
                  | optional,
              },
          rule
            | doc m%"
            Describes an analysis rule.
            "%
            = {
                defaultLevel
                  | predicates.contract_from_predicate
                  (predicates.enum [ "note", "warning", "error" ])
                  | doc m%"
                  A value specifying the default severity level of the result.
                  "%
                  | optional,
                fullDescription
                  | String
                  | doc m%"
                  A string that describes the rule. Should, as far as possible, provide details sufficient to enable resolution of any problem indicated by the result.
                  "%
                  | optional,
                helpUri
                  | String
                  | doc m%"
                  A URI where the primary documentation for the rule can be found.
                  "%
                  | optional,
                id
                  | String
                  | doc m%"
                  A stable, opaque identifier for the rule.
                  "%,
                messageFormats
                  | {  .. }
                  | doc m%"
                  A set of name/value pairs with arbitrary names. The value within each name/value pair shall consist of plain text interspersed with placeholders, which can be used to format a message in combination with an arbitrary number of additional string arguments.
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  A rule identifier that is understandable to an end user.
                  "%
                  | optional,
                properties
                  | {
                    tags
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.uniqueItems
                      ])
                      | doc m%"
                      A set of distinct strings that provide additional information.
                      "%
                      | optional,
                    ..
                  }
                  | doc m%"
                  Key/value pairs that provide additional information about the rule.
                  "%
                  | optional,
                shortDescription
                  | String
                  | doc m%"
                  A concise description of the rule. Should be a single sentence that is understandable when visible space is limited to a single line of text.
                  "%
                  | optional,
              },
          run
            | doc m%"
            Describes a single run of an analysis tool, and contains the output of that run.
            "%
            = {
                architecture
                  | String
                  | doc m%"
                  The hardware architecture for which the run was targeted.
                  "%
                  | optional,
                automationId
                  | String
                  | doc m%"
                  A global identifier that allows the run to be correlated with other artifacts produced by a larger automation process.
                  "%
                  | optional,
                baselineId
                  | String
                  | doc m%"
                  The 'id' property of a separate (potentially external) SARIF 'run' instance that comprises the baseline that was used to compute result 'baselineState' properties for the run.
                  "%
                  | optional,
                configurationNotifications
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.notification
                  ])
                  | doc m%"
                  A list of conditions detected by the tool that are relevant to the tool's configuration.
                  "%
                  | optional,
                files
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate.file
                  ])
                  | doc m%"
                  A dictionary, each of whose keys is a URI and each of whose values is an array of file objects representing the location of a single file scanned during the run.
                  "%
                  | optional,
                id
                  | String
                  | doc m%"
                  An identifier for the run.
                  "%
                  | optional,
                invocation
                  | definitions.contract.invocation
                  | doc m%"
                  Describes the runtime environment, including parameterization, of the analysis tool run.
                  "%
                  | optional,
                logicalLocations
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate.logicalLocation
                  ])
                  | doc m%"
                  A dictionary, each of whose keys specifies a logical location such as a namespace, type or function.
                  "%
                  | optional,
                results
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.result,
                    predicates.arrays.minItems 0,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  The set of results contained in an SARIF log. The results array can be omitted when a run is solely exporting rules metadata. It must be present (but may be empty) in the event that a log file represents an actual scan.
                  "%
                  | optional,
                rules
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate.rule
                  ])
                  | doc m%"
                  A dictionary, each of whose keys is a string and each of whose values is a 'rule' object, that describe all rules associated with an analysis tool or a specific run of an analysis tool.
                  "%
                  | optional,
                stableId
                  | String
                  | doc m%"
                  A stable identifier for a run, for example, 'nightly Clang analyzer run'. Multiple runs of the same type can have the same stableId.
                  "%
                  | optional,
                tool
                  | definitions.contract.tool
                  | doc m%"
                  Information about the tool or tool pipeline that generated the results in this run. A run can only contain results produced by a single tool or tool pipeline. A run can aggregate results from multiple log files, as long as context around the tool run (tool command-line arguments and the like) is identical for all aggregated files.
                  "%,
                toolNotifications
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.notification
                  ])
                  | doc m%"
                  A list of runtime conditions detected by the tool in the course of the analysis.
                  "%
                  | optional,
              },
          stack
            | doc m%"
            A call stack that is relevant to a result.
            "%
            = {
                frames
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.stackFrame,
                    predicates.arrays.minItems 1
                  ])
                  | doc m%"
                  An array of stack frames that represent a sequence of calls, rendered in reverse chronological order, that comprise the call stack.
                  "%,
                message
                  | String
                  | doc m%"
                  A message relevant to this call stack.
                  "%
                  | optional,
                properties
                  | {
                    tags
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.uniqueItems
                      ])
                      | doc m%"
                      A set of distinct strings that provide additional information.
                      "%
                      | optional,
                    ..
                  }
                  | doc m%"
                  Key/value pairs that provide additional information about the stack.
                  "%
                  | optional,
              },
          stackFrame
            | doc m%"
            A function call within a stack trace.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.stackFrame,
          tool
            | doc m%"
            The analysis tool that was run.
            "%
            = {
                fileVersion
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern "[0-9]+(\\.[0-9]+){3}"
                  ])
                  | doc m%"
                  The binary version of the tool's primary executable file (for operating systems such as Windows that provide that information).
                  "%
                  | optional,
                fullName
                  | String
                  | doc m%"
                  The name of the tool along with its version and any other useful identifying information, such as its locale.
                  "%
                  | optional,
                language
                  | String
                  | doc m%"
                  The tool language (expressed as an ISO 649 two-letter lowercase culture code) and region (expressed as an ISO 3166 two-letter uppercase subculture code associated with a country or region).
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  The name of the tool.
                  "%,
                properties
                  | {
                    tags
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.uniqueItems
                      ])
                      | doc m%"
                      A set of distinct strings that provide additional information.
                      "%
                      | optional,
                    ..
                  }
                  | doc m%"
                  Key/value pairs that provide additional information about the tool.
                  "%
                  | optional,
                sarifLoggerVersion
                  | String
                  | doc m%"
                  A version that uniquely identifies the SARIF logging component that generated this file, if it is versioned separately from the tool.
                  "%
                  | optional,
                semanticVersion
                  | String
                  | doc m%"
                  The tool version in the format specified by Semantic Versioning 2.0.
                  "%
                  | optional,
                version
                  | String
                  | doc m%"
                  The tool version, in whatever format the tool natively provides.
                  "%
                  | optional,
              },
        },
    predicate = {
          annotatedCodeLocation
            | doc m%"
            An annotation used to express code flows through a method or other locations that are related to a result.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  annotations = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.annotation,
                        predicates.arrays.minItems 1,
                        predicates.arrays.uniqueItems
                      ],
                  essential = predicates.isType '"Bool",
                  fullyQualifiedLogicalName = predicates.isType '"String",
                  id = predicates.allOf
                      [
                        predicates.anyOf
                        [
                          predicates.isType 'Integer,
                          predicates.isType '"String"
                        ],
                        predicates.numbers.minimum 1,
                        predicates.strings.pattern "^[1-9][0-9]*$"
                      ],
                  importance = predicates.enum
                      [ "important", "essential", "unimportant" ],
                  kind = predicates.enum
                      [
                        "alias",
                        "assignment",
                        "branch",
                        "call",
                        "callReturn",
                        "continuation",
                        "declaration",
                        "functionEnter",
                        "functionExit",
                        "functionReturn",
                        "usage"
                      ],
                  logicalLocationKey = predicates.isType '"String",
                  message = predicates.isType '"String",
                  module = predicates.isType '"String",
                  physicalLocation = definitions.predicate.physicalLocation,
                  properties = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          tags = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.isType '"String"),
                                predicates.arrays.uniqueItems
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  snippet = predicates.isType '"String",
                  state = predicates.isType 'Record,
                  step = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum 0
                      ],
                  taintKind = predicates.enum [ "source", "sink", "sanitizer" ],
                  target = predicates.isType '"String",
                  targetKey = predicates.isType '"String",
                  threadId = predicates.isType 'Integer,
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
          annotation = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "locations", "message" ],
                predicates.records.record
                {
                  locations = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.physicalLocation,
                        predicates.arrays.minItems 1
                      ],
                  message = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          codeFlow = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "locations" ],
                predicates.records.record
                {
                  locations = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.annotatedCodeLocation,
                        predicates.arrays.minItems 1
                      ],
                  message = predicates.isType '"String",
                  properties = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          tags = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.isType '"String"),
                                predicates.arrays.uniqueItems
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                true
                predicates.always
              ],
          exception = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  innerExceptions = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.exception
                      ],
                  kind = predicates.isType '"String",
                  message = predicates.isType '"String",
                  stack = definitions.predicate.stack,
                }
                {  }
                true
                predicates.always
              ],
          file
            | doc m%"
            A single file. In some cases, this file might be nested within another file.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  contents = predicates.isType '"String",
                  hashes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.hash,
                        predicates.arrays.minItems 1,
                        predicates.arrays.uniqueItems
                      ],
                  length = predicates.isType 'Integer,
                  mimeType = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern "[^/]+/.+"
                      ],
                  offset = predicates.isType 'Integer,
                  parentKey = predicates.isType '"String",
                  properties = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          tags = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.isType '"String"),
                                predicates.arrays.uniqueItems
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  uri = predicates.isType '"String",
                  uriBaseId = predicates.isType '"String",
                }
                {  }
                false
                predicates.never,
                predicates.records.dependencies { uriBaseId = [ "uri" ], }
              ],
          fileChange
            | doc m%"
            A change to a single file.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "replacements", "uri" ],
                predicates.records.record
                {
                  replacements = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.replacement,
                        predicates.arrays.minItems 1
                      ],
                  uri = predicates.isType '"String",
                  uriBaseId = predicates.isType '"String",
                }
                {  }
                false
                predicates.never,
                predicates.records.dependencies { uriBaseId = [ "uri" ], }
              ],
          fix
            | doc m%"
            A proposed fix for the problem represented by a result object. A fix specifies a set of file to modify. For each file, it specifies a set of bytes to remove, and provides a set of new bytes to replace them.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "description", "fileChanges" ],
                predicates.records.record
                {
                  description = predicates.isType '"String",
                  fileChanges = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.fileChange
                      ],
                }
                {  }
                false
                predicates.never
              ],
          formattedRuleMessage
            | doc m%"
            Contains information that can be used to construct a formatted message that describes a result.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "formatId" ],
                predicates.records.record
                {
                  arguments = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  formatId = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          hash
            | doc m%"
            A hash value of some file or collection of files, together with the algorithm used to compute the hash.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "algorithm", "value" ],
                predicates.records.record
                {
                  algorithm = predicates.enum
                      [
                        "authentihash",
                        "blake256",
                        "blake512",
                        "ecoh",
                        "fsb",
                        "gost",
                        "groestl",
                        "has160",
                        "haval",
                        "jh",
                        "md2",
                        "md4",
                        "md5",
                        "md6",
                        "radioGatun",
                        "ripeMD",
                        "ripeMD128",
                        "ripeMD160",
                        "ripeMD320",
                        "sdhash",
                        "sha1",
                        "sha224",
                        "sha256",
                        "sha384",
                        "sha512",
                        "sha3",
                        "skein",
                        "snefru",
                        "spectralHash",
                        "ssdeep",
                        "swifft",
                        "tiger",
                        "tlsh",
                        "whirlpool"
                      ],
                  value = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          invocation
            | doc m%"
            The runtime environment of the analysis tool run.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  account = predicates.isType '"String",
                  commandLine = predicates.isType '"String",
                  endTime = predicates.isType '"String",
                  environmentVariables = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        predicates.always
                      ],
                  fileName = predicates.isType '"String",
                  machine = predicates.isType '"String",
                  processId = predicates.isType 'Integer,
                  properties = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          tags = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.isType '"String"),
                                predicates.arrays.uniqueItems
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  responseFiles = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        predicates.always
                      ],
                  startTime = predicates.isType '"String",
                  workingDirectory = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          location
            | doc m%"
            The location where an analysis tool produced a result.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  analysisTarget = definitions.predicate.physicalLocation,
                  decoratedName = predicates.isType '"String",
                  fullyQualifiedLogicalName = predicates.isType '"String",
                  logicalLocationKey = predicates.isType '"String",
                  properties = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          tags = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.isType '"String"),
                                predicates.arrays.uniqueItems
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  resultFile = definitions.predicate.physicalLocation,
                }
                {  }
                false
                predicates.never
              ],
          logicalLocation
            | doc m%"
            A logical location of a construct that produced a result.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  kind = predicates.isType '"String",
                  name = predicates.isType '"String",
                  parentKey = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          notification
            | doc m%"
            Describes a condition relevant to the tool itself, as opposed to being relevant to a target being analyzed by the tool.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "message" ],
                predicates.records.record
                {
                  exception = definitions.predicate.exception,
                  id = predicates.isType '"String",
                  level = predicates.enum [ "note", "warning", "error" ],
                  message = predicates.isType '"String",
                  physicalLocation = definitions.predicate.physicalLocation,
                  properties = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          tags = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.isType '"String"),
                                predicates.arrays.uniqueItems
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  ruleId = predicates.isType '"String",
                  ruleKey = predicates.isType '"String",
                  threadId = predicates.isType 'Integer,
                  time = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          physicalLocation
            | doc m%"
            A physical location relevant to a result. Specifies a reference to a programming artifact together with a range of bytes or characters within that artifact.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  region = definitions.predicate.region,
                  uri = predicates.isType '"String",
                  uriBaseId = predicates.isType '"String",
                }
                {  }
                false
                predicates.never,
                predicates.records.dependencies { uriBaseId = [ "uri" ], }
              ],
          region
            | doc m%"
            A region within a file where a result was detected.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  endColumn = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum 1
                      ],
                  endLine = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum 1
                      ],
                  length = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum 0
                      ],
                  offset = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum 0
                      ],
                  startColumn = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum 1
                      ],
                  startLine = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum 1
                      ],
                }
                {  }
                false
                predicates.never
              ],
          replacement
            | doc m%"
            The replacement of a single range of bytes in a file. Specifies the location within the file where the replacement is to be made, the number of bytes to remove at that location, and a sequence of bytes to insert at that location.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "offset" ],
                predicates.records.record
                {
                  deletedLength = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum 1
                      ],
                  insertedBytes = predicates.isType '"String",
                  offset = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum 0
                      ],
                }
                {  }
                false
                predicates.never
              ],
          result
            | doc m%"
            A result produced by an analysis tool.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  baselineState = predicates.enum
                      [ "new", "existing", "absent" ],
                  codeFlows = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.codeFlow,
                        predicates.arrays.minItems 1,
                        predicates.arrays.uniqueItems
                      ],
                  fixes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.fix,
                        predicates.arrays.minItems 1,
                        predicates.arrays.uniqueItems
                      ],
                  formattedRuleMessage =
                    definitions.predicate.formattedRuleMessage,
                  id = predicates.isType '"String",
                  level = predicates.enum
                      [ "notApplicable", "pass", "note", "warning", "error" ],
                  locations = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.location,
                        predicates.arrays.minItems 1,
                        predicates.arrays.uniqueItems
                      ],
                  message = predicates.isType '"String",
                  properties = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          tags = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.isType '"String"),
                                predicates.arrays.uniqueItems
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  relatedLocations = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.annotatedCodeLocation,
                        predicates.arrays.minItems 1,
                        predicates.arrays.uniqueItems
                      ],
                  ruleId = predicates.isType '"String",
                  ruleKey = predicates.isType '"String",
                  snippet = predicates.isType '"String",
                  stacks = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.stack,
                        predicates.arrays.minItems 1,
                        predicates.arrays.uniqueItems
                      ],
                  suppressionStates = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.enum
                        [ "suppressedInSource", "suppressedExternally" ])
                      ],
                  toolFingerprintContribution = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          rule
            | doc m%"
            Describes an analysis rule.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "id" ],
                predicates.records.record
                {
                  defaultLevel = predicates.enum [ "note", "warning", "error" ],
                  fullDescription = predicates.isType '"String",
                  helpUri = predicates.isType '"String",
                  id = predicates.isType '"String",
                  messageFormats = predicates.isType 'Record,
                  name = predicates.isType '"String",
                  properties = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          tags = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.isType '"String"),
                                predicates.arrays.uniqueItems
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  shortDescription = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          run
            | doc m%"
            Describes a single run of an analysis tool, and contains the output of that run.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "tool" ],
                predicates.records.record
                {
                  architecture = predicates.isType '"String",
                  automationId = predicates.isType '"String",
                  baselineId = predicates.isType '"String",
                  configurationNotifications = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.notification
                      ],
                  files = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate.file
                      ],
                  id = predicates.isType '"String",
                  invocation = definitions.predicate.invocation,
                  logicalLocations = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate.logicalLocation
                      ],
                  results = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.result,
                        predicates.arrays.minItems 0,
                        predicates.arrays.uniqueItems
                      ],
                  rules = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate.rule
                      ],
                  stableId = predicates.isType '"String",
                  tool = definitions.predicate.tool,
                  toolNotifications = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.notification
                      ],
                }
                {  }
                false
                predicates.never
              ],
          stack
            | doc m%"
            A call stack that is relevant to a result.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "frames" ],
                predicates.records.record
                {
                  frames = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.stackFrame,
                        predicates.arrays.minItems 1
                      ],
                  message = predicates.isType '"String",
                  properties = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          tags = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.isType '"String"),
                                predicates.arrays.uniqueItems
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                }
                {  }
                false
                predicates.never
              ],
          stackFrame
            | doc m%"
            A function call within a stack trace.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "fullyQualifiedLogicalName" ],
                predicates.records.record
                {
                  address = predicates.isType 'Integer,
                  column = predicates.isType 'Integer,
                  fullyQualifiedLogicalName = predicates.isType '"String",
                  line = predicates.isType 'Integer,
                  logicalLocationKey = predicates.isType '"String",
                  message = predicates.isType '"String",
                  module = predicates.isType '"String",
                  offset = predicates.isType 'Integer,
                  parameters = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  properties = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          tags = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.isType '"String"),
                                predicates.arrays.uniqueItems
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  threadId = predicates.isType 'Integer,
                  uri = predicates.isType '"String",
                  uriBaseId = predicates.isType '"String",
                }
                {  }
                false
                predicates.never,
                predicates.records.dependencies
                {
                  column = [ "line" ],
                  line = [ "uri" ],
                  uriBaseId = [ "uri" ],
                }
              ],
          tool
            | doc m%"
            The analysis tool that was run.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  fileVersion = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern "[0-9]+(\\.[0-9]+){3}"
                      ],
                  fullName = predicates.isType '"String",
                  language = predicates.isType '"String",
                  name = predicates.isType '"String",
                  properties = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          tags = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.isType '"String"),
                                predicates.arrays.uniqueItems
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  sarifLoggerVersion = predicates.isType '"String",
                  semanticVersion = predicates.isType '"String",
                  version = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
        },
  }
in

predicates.contract_from_predicate
(predicates.allOf
[
  predicates.isType 'Record,
  predicates.records.required [ "runs", "version" ],
  predicates.records.record
  {
    "$schema" = predicates.isType '"String",
    runs = predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf definitions.predicate.run,
          predicates.arrays.minItems 1
        ],
    version = predicates.enum [ "1.0.0" ],
  }
  {  }
  false
  predicates.never
])