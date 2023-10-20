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
          Activation
            | doc m%"
            criteria by which a profile is auto-activated.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.Activation,
          Artifact
            | doc m%"
            items that need to be built, along with the context in which they should be built.
            "%
            = predicates.contract_from_predicate definitions.predicate.Artifact,
          ArtifactDependency
            | doc m%"
            describes a specific build dependency for an artifact.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.ArtifactDependency,
          BazelArtifact
            | doc m%"
            describes an artifact built with [Bazel](https://bazel.build/).
            "%
            = predicates.contract_from_predicate
              definitions.predicate.BazelArtifact,
          BuildConfig
            | doc m%"
            contains all the configuration for the build steps.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.BuildConfig,
          BuildHooks
            | doc m%"
            describes the list of lifecycle hooks to execute before and after each artifact build step.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.BuildHooks,
          BuildpackArtifact
            | doc m%"
            *alpha* describes an artifact built using [Cloud Native Buildpacks](https://buildpacks.io/). It can be used to build images out of project's sources without any additional configuration.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.BuildpackArtifact,
          BuildpackDependencies
            | doc m%"
            *alpha* used to specify dependencies for an artifact built by buildpacks.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.BuildpackDependencies,
          BuildpackVolume
            | doc m%"
            *alpha* used to mount host volumes or directories in the build container.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.BuildpackVolume,
          CloudRunDeploy
            | doc m%"
            *alpha* deploys the container to Google Cloud Run.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.CloudRunDeploy,
          ClusterDetails
            | doc m%"
            *beta* describes how to do an on-cluster build.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.ClusterDetails,
          ConfigDependency
            | doc m%"
            describes a dependency on another skaffold configuration.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.ConfigDependency,
          ContainerHook
            | doc m%"
            describes a lifecycle hook definition to execute on a container. The container name is inferred from the scope in which this hook is defined.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.ContainerHook,
          CustomArtifact
            | doc m%"
            *beta* describes an artifact built from a custom build script written by the user. It can be used to build images with builders that aren't directly integrated with skaffold.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.CustomArtifact,
          CustomDependencies
            | doc m%"
            *beta* used to specify dependencies for an artifact built by a custom build script. Either `dockerfile` or `paths` should be specified for file watching to work as expected.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.CustomDependencies,
          CustomTemplateTagger
            | doc m%"
            *beta* tags images with a configurable template string.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.CustomTemplateTagger,
          CustomTest
            | doc m%"
            describes the custom test command provided by the user. Custom tests are run after an image build whenever build or test dependencies are changed.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.CustomTest,
          CustomTestDependencies
            | doc m%"
            used to specify dependencies for custom test command. `paths` should be specified for file watching to work as expected.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.CustomTestDependencies,
          DateTimeTagger
            | doc m%"
            *beta* tags images with the build timestamp.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.DateTimeTagger,
          DeployConfig
            | doc m%"
            contains all the configuration needed by the deploy steps.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.DeployConfig,
          DeployHookItem
            | doc m%"
            describes a single lifecycle hook to execute before or after each deployer step.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.DeployHookItem,
          DeployHooks
            | doc m%"
            describes the list of lifecycle hooks to execute before and after each deployer step.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.DeployHooks,
          DockerArtifact
            | doc m%"
            describes an artifact built from a Dockerfile, usually using `docker build`.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.DockerArtifact,
          DockerConfig
            | doc m%"
            contains information about the docker `config.json` to mount.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.DockerConfig,
          DockerDeploy
            | doc m%"
            uses the `docker` CLI to create application containers in Docker.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.DockerDeploy,
          DockerSecret
            | doc m%"
            used to pass in --secret to docker build, `useBuildKit: true` is required.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.DockerSecret,
          DockerfileDependency
            | doc m%"
            *beta* used to specify a custom build artifact that is built from a Dockerfile. This allows skaffold to determine dependencies from the Dockerfile.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.DockerfileDependency,
          EnvTemplateTagger
            | doc m%"
            *beta* tags images with a configurable template string.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.EnvTemplateTagger,
          GitInfo
            | doc m%"
            contains information on the origin of skaffold configurations cloned from a git repository.
            "%
            = predicates.contract_from_predicate definitions.predicate.GitInfo,
          GitTagger
            | doc m%"
            *beta* tags images with the git tag or commit of the artifact's workspace.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.GitTagger,
          GoogleCloudBuild
            | doc m%"
            *beta* describes how to do a remote build on [Google Cloud Build](https://cloud.google.com/cloud-build/docs/). Docker and Jib artifacts can be built on Cloud Build. The `projectId` needs to be provided and the currently logged in user should be given permissions to trigger new builds.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.GoogleCloudBuild,
          Helm
            | doc m%"
            defines the manifests from helm releases.
            "%
            = predicates.contract_from_predicate definitions.predicate.Helm,
          HelmConventionConfig
            | doc m%"
            image config in the syntax of image.repository and image.tag.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.HelmConventionConfig,
          HelmDeployFlags
            | doc m%"
            additional option flags that are passed on the command line to `helm`.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.HelmDeployFlags,
          HelmFQNConfig
            | doc m%"
            image config to use the FullyQualifiedImageName as param to set.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.HelmFQNConfig,
          HelmImageConfig
            | doc m%"
            describes an image configuration.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.HelmImageConfig,
          HelmPackaged
            | doc m%"
            parameters for packaging helm chart (`helm package`).
            "%
            = predicates.contract_from_predicate
              definitions.predicate.HelmPackaged,
          HelmRelease
            | doc m%"
            describes a helm release to be deployed.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.HelmRelease,
          HostHook
            | doc m%"
            describes a lifecycle hook definition to execute on the host machine.
            "%
            = predicates.contract_from_predicate definitions.predicate.HostHook,
          InputDigest
            | doc m%"
            *beta* tags hashes the image content.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.InputDigest,
          JSONParseConfig
            | doc m%"
            defines the rules for parsing/outputting json logs.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.JSONParseConfig,
          JSONPatch
            | doc m%"
            patch to be applied by a profile.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.JSONPatch,
          JibArtifact
            | doc m%"
            builds images using the [Jib plugins for Maven and Gradle](https://github.com/GoogleContainerTools/jib/).
            "%
            = predicates.contract_from_predicate
              definitions.predicate.JibArtifact,
          KanikoArtifact
            | doc m%"
            describes an artifact built from a Dockerfile, with kaniko.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.KanikoArtifact,
          KanikoCache
            | doc m%"
            configures Kaniko caching. If a cache is specified, Kaniko will use a remote cache which will speed up builds.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.KanikoCache,
          KoArtifact
            | doc m%"
            builds images using [ko](https://github.com/google/ko).
            "%
            = predicates.contract_from_predicate
              definitions.predicate.KoArtifact,
          KoDependencies
            | doc m%"
            used to specify dependencies for an artifact built by ko.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.KoDependencies,
          KptDeploy
            | doc m%"
            contains all the configuration needed by the deploy steps.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.KptDeploy,
          KubectlDeploy
            | doc m%"
            *beta* uses a client side `kubectl apply` to deploy manifests. You'll need a `kubectl` CLI version installed that's compatible with your cluster.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.KubectlDeploy,
          KubectlFlags
            | doc m%"
            additional flags passed on the command line to kubectl either on every command (Global), on creations (Apply) or deletions (Delete).
            "%
            = predicates.contract_from_predicate
              definitions.predicate.KubectlFlags,
          Kustomize
            | doc m%"
            defines the paths to be modified with kustomize, along with extra flags to be passed to kustomize.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.Kustomize,
          LegacyHelmDeploy
            | doc m%"
            *beta* uses the `helm` CLI to apply the charts to the cluster.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.LegacyHelmDeploy,
          LocalBuild
            | doc m%"
            *beta* describes how to do a build on the local docker daemon and optionally push to a repository.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.LocalBuild,
          LogsConfig
            | doc m%"
            configures how container logs are printed as a result of a deployment.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.LogsConfig,
          Metadata
            | doc m%"
            holds an optional name of the project.
            "%
            = predicates.contract_from_predicate definitions.predicate.Metadata,
          NamedContainerHook
            | doc m%"
            describes a lifecycle hook definition to execute on a named container.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.NamedContainerHook,
          PlatformEmulatorInstallStep
            | doc m%"
            specifies a pre-build step to install the required tooling for QEMU emulation on the GoogleCloudBuild containers. This enables performing cross-platform builds on GoogleCloudBuild.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.PlatformEmulatorInstallStep,
          PortForwardResource
            | doc m%"
            describes a resource to port forward.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.PortForwardResource,
          Profile
            | doc m%"
            used to override any `build`, `test` or `deploy` configuration.
            "%
            = predicates.contract_from_predicate definitions.predicate.Profile,
          ProfileDependency
            | doc m%"
            describes a mapping from referenced config profiles to the current config profiles. If the current config is activated with a profile in this mapping then the dependency configs are also activated with the corresponding mapped profiles.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.ProfileDependency,
          RenderConfig
            | doc m%"
            contains all the configuration needed by the render steps.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.RenderConfig,
          RenderHookItem
            | doc m%"
            describes a single lifecycle hook to execute before or after each deployer step.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.RenderHookItem,
          RenderHooks
            | doc m%"
            describes the list of lifecycle hooks to execute before and after each render step.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.RenderHooks,
          ResourceFilter
            | doc m%"
            contains definition to filter which resource to transform.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.ResourceFilter,
          ResourceRequirement
            | doc m%"
            stores the CPU/Memory requirements for the pod.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.ResourceRequirement,
          ResourceRequirements
            | doc m%"
            describes the resource requirements for the kaniko pod.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.ResourceRequirements,
          ResourceSelectorConfig
            | doc m%"
            contains all the configuration needed by the deploy steps.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.ResourceSelectorConfig,
          ResourceType
            | doc m%"
            describes the Kubernetes resource types used for port forwarding.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.ResourceType,
          ShaTagger
            | doc m%"
            *beta* tags images with their sha256 digest.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.ShaTagger,
          SkaffoldConfig
            | doc m%"
            holds the fields parsed from the Skaffold configuration file (skaffold.yaml).
            "%
            = predicates.contract_from_predicate
              definitions.predicate.SkaffoldConfig,
          Sync
            | doc m%"
            *beta* specifies what files to sync into the container. This is a list of sync rules indicating the intent to sync for source files. If no files are listed, sync all the files and infer the destination.
            "%
            = predicates.contract_from_predicate definitions.predicate.Sync,
          SyncHookItem
            | doc m%"
            describes a single lifecycle hook to execute before or after each artifact sync step.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.SyncHookItem,
          SyncHooks
            | doc m%"
            describes the list of lifecycle hooks to execute before and after each artifact sync step.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.SyncHooks,
          SyncRule
            | doc m%"
            specifies which local files to sync to remote folders.
            "%
            = predicates.contract_from_predicate definitions.predicate.SyncRule,
          TagPolicy
            | doc m%"
            contains all the configuration for the tagging step.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.TagPolicy,
          TaggerComponent
            | doc m%"
            *beta* a component of CustomTemplateTagger.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.TaggerComponent,
          TestCase
            | doc m%"
            a list of tests to run on images that Skaffold builds.
            "%
            = predicates.contract_from_predicate definitions.predicate.TestCase,
          Transformer
            | doc m%"
            describes the supported kpt transformers.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.Transformer,
          Validator
            | doc m%"
            describes the supported kpt validators.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.Validator,
          VerifyTestCase
            | doc m%"
            a list of tests to run on images that Skaffold builds.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.VerifyTestCase,
        },
    predicate = {
          Activation
            | doc m%"
            criteria by which a profile is auto-activated.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  command = predicates.isType '"String",
                  env = predicates.isType '"String",
                  kubeContext = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Artifact
            | doc m%"
            items that need to be built, along with the context in which they should be built.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.anyOf
                [
                  predicates.records.record
                  {
                    context = predicates.isType '"String",
                    hooks = definitions.predicate.BuildHooks,
                    image = predicates.isType '"String",
                    platforms = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    requires = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          definitions.predicate.ArtifactDependency
                        ],
                    sync = definitions.predicate.Sync,
                  }
                  {  }
                  false
                  predicates.never,
                  predicates.records.record
                  {
                    context = predicates.isType '"String",
                    docker = definitions.predicate.DockerArtifact,
                    hooks = definitions.predicate.BuildHooks,
                    image = predicates.isType '"String",
                    platforms = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    requires = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          definitions.predicate.ArtifactDependency
                        ],
                    sync = definitions.predicate.Sync,
                  }
                  {  }
                  false
                  predicates.never,
                  predicates.records.record
                  {
                    bazel = definitions.predicate.BazelArtifact,
                    context = predicates.isType '"String",
                    hooks = definitions.predicate.BuildHooks,
                    image = predicates.isType '"String",
                    platforms = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    requires = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          definitions.predicate.ArtifactDependency
                        ],
                    sync = definitions.predicate.Sync,
                  }
                  {  }
                  false
                  predicates.never,
                  predicates.records.record
                  {
                    context = predicates.isType '"String",
                    hooks = definitions.predicate.BuildHooks,
                    image = predicates.isType '"String",
                    ko = definitions.predicate.KoArtifact,
                    platforms = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    requires = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          definitions.predicate.ArtifactDependency
                        ],
                    sync = definitions.predicate.Sync,
                  }
                  {  }
                  false
                  predicates.never,
                  predicates.records.record
                  {
                    context = predicates.isType '"String",
                    hooks = definitions.predicate.BuildHooks,
                    image = predicates.isType '"String",
                    jib = definitions.predicate.JibArtifact,
                    platforms = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    requires = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          definitions.predicate.ArtifactDependency
                        ],
                    sync = definitions.predicate.Sync,
                  }
                  {  }
                  false
                  predicates.never,
                  predicates.records.record
                  {
                    context = predicates.isType '"String",
                    hooks = definitions.predicate.BuildHooks,
                    image = predicates.isType '"String",
                    kaniko = definitions.predicate.KanikoArtifact,
                    platforms = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    requires = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          definitions.predicate.ArtifactDependency
                        ],
                    sync = definitions.predicate.Sync,
                  }
                  {  }
                  false
                  predicates.never,
                  predicates.records.record
                  {
                    buildpacks = definitions.predicate.BuildpackArtifact,
                    context = predicates.isType '"String",
                    hooks = definitions.predicate.BuildHooks,
                    image = predicates.isType '"String",
                    platforms = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    requires = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          definitions.predicate.ArtifactDependency
                        ],
                    sync = definitions.predicate.Sync,
                  }
                  {  }
                  false
                  predicates.never,
                  predicates.records.record
                  {
                    context = predicates.isType '"String",
                    custom = definitions.predicate.CustomArtifact,
                    hooks = definitions.predicate.BuildHooks,
                    image = predicates.isType '"String",
                    platforms = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    requires = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          definitions.predicate.ArtifactDependency
                        ],
                    sync = definitions.predicate.Sync,
                  }
                  {  }
                  false
                  predicates.never
                ],
                predicates.records.required [ "image" ],
                predicates.records.record {  } {  } true predicates.always
              ],
          ArtifactDependency
            | doc m%"
            describes a specific build dependency for an artifact.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "image" ],
                predicates.records.record
                {
                  alias = predicates.isType '"String",
                  image = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          BazelArtifact
            | doc m%"
            describes an artifact built with [Bazel](https://bazel.build/).
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "target" ],
                predicates.records.record
                {
                  args = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  target = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          BuildConfig
            | doc m%"
            contains all the configuration for the build steps.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.anyOf
                [
                  predicates.records.record
                  {
                    artifacts = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          definitions.predicate.Artifact
                        ],
                    insecureRegistries = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    platforms = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    tagPolicy = definitions.predicate.TagPolicy,
                  }
                  {  }
                  false
                  predicates.never,
                  predicates.records.record
                  {
                    artifacts = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          definitions.predicate.Artifact
                        ],
                    insecureRegistries = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    local = definitions.predicate.LocalBuild,
                    platforms = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    tagPolicy = definitions.predicate.TagPolicy,
                  }
                  {  }
                  false
                  predicates.never,
                  predicates.records.record
                  {
                    artifacts = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          definitions.predicate.Artifact
                        ],
                    googleCloudBuild = definitions.predicate.GoogleCloudBuild,
                    insecureRegistries = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    platforms = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    tagPolicy = definitions.predicate.TagPolicy,
                  }
                  {  }
                  false
                  predicates.never,
                  predicates.records.record
                  {
                    artifacts = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          definitions.predicate.Artifact
                        ],
                    cluster = definitions.predicate.ClusterDetails,
                    insecureRegistries = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    platforms = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    tagPolicy = definitions.predicate.TagPolicy,
                  }
                  {  }
                  false
                  predicates.never
                ]
              ],
          BuildHooks
            | doc m%"
            describes the list of lifecycle hooks to execute before and after each artifact build step.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  after = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.HostHook
                      ],
                  before = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.HostHook
                      ],
                }
                {  }
                false
                predicates.never
              ],
          BuildpackArtifact
            | doc m%"
            *alpha* describes an artifact built using [Cloud Native Buildpacks](https://buildpacks.io/). It can be used to build images out of project's sources without any additional configuration.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  builder = predicates.isType '"String",
                  buildpacks = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  clearCache = predicates.isType '"Bool",
                  dependencies = definitions.predicate.BuildpackDependencies,
                  env = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  projectDescriptor = predicates.isType '"String",
                  runImage = predicates.isType '"String",
                  trustBuilder = predicates.isType '"Bool",
                  volumes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.BuildpackVolume
                      ],
                }
                {  }
                false
                predicates.never
              ],
          BuildpackDependencies
            | doc m%"
            *alpha* used to specify dependencies for an artifact built by buildpacks.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  ignore = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  paths = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          BuildpackVolume
            | doc m%"
            *alpha* used to mount host volumes or directories in the build container.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "host", "target" ],
                predicates.records.record
                {
                  host = predicates.isType '"String",
                  options = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [ "ro", "rw", "volume-opt=<key>=<value>" ]
                      ],
                  target = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          CloudRunDeploy
            | doc m%"
            *alpha* deploys the container to Google Cloud Run.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  projectid = predicates.isType '"String",
                  region = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          ClusterDetails
            | doc m%"
            *beta* describes how to do an on-cluster build.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  HTTPS_PROXY = predicates.isType '"String",
                  HTTP_PROXY = predicates.isType '"String",
                  annotations = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  concurrency = predicates.isType 'Integer,
                  dockerConfig = definitions.predicate.DockerConfig,
                  namespace = predicates.isType '"String",
                  nodeSelector = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  pullSecretMountPath = predicates.isType '"String",
                  pullSecretName = predicates.isType '"String",
                  pullSecretPath = predicates.isType '"String",
                  randomDockerConfigSecret = predicates.isType '"Bool",
                  randomPullSecret = predicates.isType '"Bool",
                  resources = definitions.predicate.ResourceRequirements,
                  runAsUser = predicates.isType 'Integer,
                  serviceAccount = predicates.isType '"String",
                  timeout = predicates.isType '"String",
                  tolerations = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf predicates.always
                      ],
                  volumes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf predicates.always
                      ],
                }
                {  }
                false
                predicates.never
              ],
          ConfigDependency
            | doc m%"
            describes a dependency on another skaffold configuration.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  activeProfiles = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.ProfileDependency
                      ],
                  configs = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  git = definitions.predicate.GitInfo,
                  path = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          ContainerHook
            | doc m%"
            describes a lifecycle hook definition to execute on a container. The container name is inferred from the scope in which this hook is defined.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "command" ],
                predicates.records.record
                {
                  command = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          CustomArtifact
            | doc m%"
            *beta* describes an artifact built from a custom build script written by the user. It can be used to build images with builders that aren't directly integrated with skaffold.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  buildCommand = predicates.isType '"String",
                  dependencies = definitions.predicate.CustomDependencies,
                }
                {  }
                false
                predicates.never
              ],
          CustomDependencies
            | doc m%"
            *beta* used to specify dependencies for an artifact built by a custom build script. Either `dockerfile` or `paths` should be specified for file watching to work as expected.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  command = predicates.isType '"String",
                  dockerfile = definitions.predicate.DockerfileDependency,
                  ignore = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  paths = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          CustomTemplateTagger
            | doc m%"
            *beta* tags images with a configurable template string.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "template" ],
                predicates.records.record
                {
                  components = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.TaggerComponent
                      ],
                  template = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          CustomTest
            | doc m%"
            describes the custom test command provided by the user. Custom tests are run after an image build whenever build or test dependencies are changed.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "command" ],
                predicates.records.record
                {
                  command = predicates.isType '"String",
                  dependencies = definitions.predicate.CustomTestDependencies,
                  timeoutSeconds = predicates.isType 'Integer,
                }
                {  }
                false
                predicates.never
              ],
          CustomTestDependencies
            | doc m%"
            used to specify dependencies for custom test command. `paths` should be specified for file watching to work as expected.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  command = predicates.isType '"String",
                  ignore = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  paths = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          DateTimeTagger
            | doc m%"
            *beta* tags images with the build timestamp.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  format = predicates.isType '"String",
                  timezone = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          DeployConfig
            | doc m%"
            contains all the configuration needed by the deploy steps.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  cloudrun = definitions.predicate.CloudRunDeploy,
                  docker = definitions.predicate.DockerDeploy,
                  helm = definitions.predicate.LegacyHelmDeploy,
                  kpt = definitions.predicate.KptDeploy,
                  kubeContext = predicates.isType '"String",
                  kubectl = definitions.predicate.KubectlDeploy,
                  logs = definitions.predicate.LogsConfig,
                  statusCheck = predicates.isType '"Bool",
                  statusCheckDeadlineSeconds = predicates.isType 'Integer,
                }
                {  }
                false
                predicates.never
              ],
          DeployHookItem
            | doc m%"
            describes a single lifecycle hook to execute before or after each deployer step.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  container = definitions.predicate.NamedContainerHook,
                  host = definitions.predicate.HostHook,
                }
                {  }
                false
                predicates.never
              ],
          DeployHooks
            | doc m%"
            describes the list of lifecycle hooks to execute before and after each deployer step.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  after = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.DeployHookItem
                      ],
                  before = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.DeployHookItem
                      ],
                }
                {  }
                false
                predicates.never
              ],
          DockerArtifact
            | doc m%"
            describes an artifact built from a Dockerfile, usually using `docker build`.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  addHost = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  buildArgs = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  cacheFrom = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  cliFlags = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  dockerfile = predicates.isType '"String",
                  network = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [ "host", "bridge", "container:<name|id>", "none" ]
                      ],
                  noCache = predicates.isType '"Bool",
                  pullParent = predicates.isType '"Bool",
                  secrets = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.DockerSecret
                      ],
                  squash = predicates.isType '"Bool",
                  ssh = predicates.isType '"String",
                  target = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          DockerConfig
            | doc m%"
            contains information about the docker `config.json` to mount.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  path = predicates.isType '"String",
                  secretName = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          DockerDeploy
            | doc m%"
            uses the `docker` CLI to create application containers in Docker.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "images" ],
                predicates.records.record
                {
                  images = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  useCompose = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          DockerSecret
            | doc m%"
            used to pass in --secret to docker build, `useBuildKit: true` is required.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "id" ],
                predicates.records.record
                {
                  env = predicates.isType '"String",
                  id = predicates.isType '"String",
                  src = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          DockerfileDependency
            | doc m%"
            *beta* used to specify a custom build artifact that is built from a Dockerfile. This allows skaffold to determine dependencies from the Dockerfile.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  buildArgs = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  path = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          EnvTemplateTagger
            | doc m%"
            *beta* tags images with a configurable template string.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "template" ],
                predicates.records.record
                { template = predicates.isType '"String", }
                {  }
                false
                predicates.never
              ],
          GitInfo
            | doc m%"
            contains information on the origin of skaffold configurations cloned from a git repository.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "repo" ],
                predicates.records.record
                {
                  path = predicates.isType '"String",
                  ref = predicates.isType '"String",
                  repo = predicates.isType '"String",
                  sync = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          GitTagger
            | doc m%"
            *beta* tags images with the git tag or commit of the artifact's workspace.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  ignoreChanges = predicates.isType '"Bool",
                  prefix = predicates.isType '"String",
                  variant = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [
                          "Tags",
                          "CommitSha",
                          "AbbrevCommitSha",
                          "TreeSha",
                          "AbbrevTreeSha"
                        ]
                      ],
                }
                {  }
                false
                predicates.never
              ],
          GoogleCloudBuild
            | doc m%"
            *beta* describes how to do a remote build on [Google Cloud Build](https://cloud.google.com/cloud-build/docs/). Docker and Jib artifacts can be built on Cloud Build. The `projectId` needs to be provided and the currently logged in user should be given permissions to trigger new builds.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  concurrency = predicates.isType 'Integer,
                  diskSizeGb = predicates.isType 'Integer,
                  dockerImage = predicates.isType '"String",
                  gradleImage = predicates.isType '"String",
                  kanikoImage = predicates.isType '"String",
                  koImage = predicates.isType '"String",
                  logStreamingOption = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [ "STREAM_DEFAULT", "STREAM_ON", "STREAM_OFF" ]
                      ],
                  logging = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [ "LOGGING_UNSPECIFIED", "LEGACY", "GCS_ONLY" ]
                      ],
                  machineType = predicates.isType '"String",
                  mavenImage = predicates.isType '"String",
                  packImage = predicates.isType '"String",
                  platformEmulatorInstallStep =
                    definitions.predicate.PlatformEmulatorInstallStep,
                  projectId = predicates.isType '"String",
                  region = predicates.isType '"String",
                  serviceAccount = predicates.isType '"String",
                  timeout = predicates.isType '"String",
                  workerPool = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Helm
            | doc m%"
            defines the manifests from helm releases.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "releases" ],
                predicates.records.record
                {
                  flags = definitions.predicate.HelmDeployFlags,
                  releases = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.HelmRelease
                      ],
                }
                {  }
                false
                predicates.never
              ],
          HelmConventionConfig
            | doc m%"
            image config in the syntax of image.repository and image.tag.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { explicitRegistry = predicates.isType '"Bool", }
                {  }
                false
                predicates.never
              ],
          HelmDeployFlags
            | doc m%"
            additional option flags that are passed on the command line to `helm`.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  global = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  install = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  upgrade = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          HelmFQNConfig
            | doc m%"
            image config to use the FullyQualifiedImageName as param to set.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { property = predicates.isType '"String", }
                {  }
                false
                predicates.never
              ],
          HelmImageConfig
            | doc m%"
            describes an image configuration.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  fqn = definitions.predicate.HelmFQNConfig,
                  helm = definitions.predicate.HelmConventionConfig,
                }
                {  }
                false
                predicates.never
              ],
          HelmPackaged
            | doc m%"
            parameters for packaging helm chart (`helm package`).
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  appVersion = predicates.isType '"String",
                  version = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          HelmRelease
            | doc m%"
            describes a helm release to be deployed.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  chartPath = predicates.isType '"String",
                  createNamespace = predicates.isType '"Bool",
                  name = predicates.isType '"String",
                  namespace = predicates.isType '"String",
                  overrides = predicates.always,
                  packaged = definitions.predicate.HelmPackaged,
                  recreatePods = predicates.isType '"Bool",
                  remoteChart = predicates.isType '"String",
                  repo = predicates.isType '"String",
                  setFiles = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  setValueTemplates = predicates.always,
                  setValues = predicates.always,
                  skipBuildDependencies = predicates.isType '"Bool",
                  upgradeOnChange = predicates.isType '"Bool",
                  useHelmSecrets = predicates.isType '"Bool",
                  valuesFiles = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  version = predicates.isType '"String",
                  wait = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          HostHook
            | doc m%"
            describes a lifecycle hook definition to execute on the host machine.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "command" ],
                predicates.records.record
                {
                  command = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  dir = predicates.isType '"String",
                  os = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          InputDigest
            | doc m%"
            *beta* tags hashes the image content.
            "%
            = predicates.isType 'Record,
          JSONParseConfig
            | doc m%"
            defines the rules for parsing/outputting json logs.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  fields = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          JSONPatch
            | doc m%"
            patch to be applied by a profile.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "path" ],
                predicates.records.record
                {
                  from = predicates.isType '"String",
                  op = predicates.isType '"String",
                  path = predicates.isType '"String",
                  value = predicates.always,
                }
                {  }
                false
                predicates.never
              ],
          JibArtifact
            | doc m%"
            builds images using the [Jib plugins for Maven and Gradle](https://github.com/GoogleContainerTools/jib/).
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  args = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  fromImage = predicates.isType '"String",
                  project = predicates.isType '"String",
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "maven", "gradle" ]
                      ],
                }
                {  }
                false
                predicates.never
              ],
          KanikoArtifact
            | doc m%"
            describes an artifact built from a Dockerfile, with kaniko.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  buildArgs = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  cache = definitions.predicate.KanikoCache,
                  cleanup = predicates.isType '"Bool",
                  contextSubPath = predicates.isType '"String",
                  digestFile = predicates.isType '"String",
                  dockerfile = predicates.isType '"String",
                  env = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf predicates.always
                      ],
                  "force" = predicates.isType '"Bool",
                  image = predicates.isType '"String",
                  imageFSExtractRetry = predicates.isType '"String",
                  imageNameWithDigestFile = predicates.isType '"String",
                  initImage = predicates.isType '"String",
                  insecure = predicates.isType '"Bool",
                  insecurePull = predicates.isType '"Bool",
                  insecureRegistry = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  label = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  logFormat = predicates.isType '"String",
                  logTimestamp = predicates.isType '"Bool",
                  noPush = predicates.isType '"Bool",
                  ociLayoutPath = predicates.isType '"String",
                  pushRetry = predicates.isType '"String",
                  registryCertificate = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  registryMirror = predicates.isType '"String",
                  reproducible = predicates.isType '"Bool",
                  singleSnapshot = predicates.isType '"Bool",
                  skipTLS = predicates.isType '"Bool",
                  skipTLSVerifyPull = predicates.isType '"Bool",
                  skipTLSVerifyRegistry = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  skipUnusedStages = predicates.isType '"Bool",
                  snapshotMode = predicates.isType '"String",
                  tarPath = predicates.isType '"String",
                  target = predicates.isType '"String",
                  useNewRun = predicates.isType '"Bool",
                  verbosity = predicates.isType '"String",
                  volumeMounts = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf predicates.always
                      ],
                  whitelistVarRun = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          KanikoCache
            | doc m%"
            configures Kaniko caching. If a cache is specified, Kaniko will use a remote cache which will speed up builds.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  cacheCopyLayers = predicates.isType '"Bool",
                  hostPath = predicates.isType '"String",
                  repo = predicates.isType '"String",
                  ttl = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          KoArtifact
            | doc m%"
            builds images using [ko](https://github.com/google/ko).
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  dependencies = definitions.predicate.KoDependencies,
                  dir = predicates.isType '"String",
                  env = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  flags = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  fromImage = predicates.isType '"String",
                  labels = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  ldflags = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  main = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          KoDependencies
            | doc m%"
            used to specify dependencies for an artifact built by ko.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  ignore = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  paths = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          KptDeploy
            | doc m%"
            contains all the configuration needed by the deploy steps.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  applyFlags = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  defaultNamespace = predicates.isType '"String",
                  dir = predicates.isType '"String",
                  "false" = predicates.isType '"Bool",
                  flags = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  inventoryID = predicates.isType '"String",
                  name = predicates.isType '"String",
                  namespace = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          KubectlDeploy
            | doc m%"
            *beta* uses a client side `kubectl apply` to deploy manifests. You'll need a `kubectl` CLI version installed that's compatible with your cluster.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  defaultNamespace = predicates.isType '"String",
                  flags = definitions.predicate.KubectlFlags,
                  hooks = definitions.predicate.DeployHooks,
                  remoteManifests = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          KubectlFlags
            | doc m%"
            additional flags passed on the command line to kubectl either on every command (Global), on creations (Apply) or deletions (Delete).
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  apply = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  delete = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  disableValidation = predicates.isType '"Bool",
                  global = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          Kustomize
            | doc m%"
            defines the paths to be modified with kustomize, along with extra flags to be passed to kustomize.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  buildArgs = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  paths = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          LegacyHelmDeploy
            | doc m%"
            *beta* uses the `helm` CLI to apply the charts to the cluster.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  flags = definitions.predicate.HelmDeployFlags,
                  hooks = definitions.predicate.DeployHooks,
                  releases = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.HelmRelease
                      ],
                }
                {  }
                false
                predicates.never
              ],
          LocalBuild
            | doc m%"
            *beta* describes how to do a build on the local docker daemon and optionally push to a repository.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  concurrency = predicates.isType 'Integer,
                  push = predicates.isType '"Bool",
                  tryImportMissing = predicates.isType '"Bool",
                  useBuildkit = predicates.isType '"Bool",
                  useDockerCLI = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          LogsConfig
            | doc m%"
            configures how container logs are printed as a result of a deployment.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  jsonParse = definitions.predicate.JSONParseConfig,
                  prefix = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [ "container", "podAndContainer", "auto", "none" ]
                      ],
                }
                {  }
                false
                predicates.never
              ],
          Metadata
            | doc m%"
            holds an optional name of the project.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  annotations = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  labels = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  name = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          NamedContainerHook
            | doc m%"
            describes a lifecycle hook definition to execute on a named container.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "command", "podName" ],
                predicates.records.record
                {
                  command = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  containerName = predicates.isType '"String",
                  podName = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          PlatformEmulatorInstallStep
            | doc m%"
            specifies a pre-build step to install the required tooling for QEMU emulation on the GoogleCloudBuild containers. This enables performing cross-platform builds on GoogleCloudBuild.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "image" ],
                predicates.records.record
                {
                  args = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  entrypoint = predicates.isType '"String",
                  image = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          PortForwardResource
            | doc m%"
            describes a resource to port forward.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  address = predicates.isType '"String",
                  localPort = predicates.isType 'Integer,
                  namespace = predicates.isType '"String",
                  port = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType 'Integer
                      ],
                  resourceName = predicates.isType '"String",
                  resourceType = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Profile
            | doc m%"
            used to override any `build`, `test` or `deploy` configuration.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  activation = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.Activation
                      ],
                  build = definitions.predicate.BuildConfig,
                  deploy = definitions.predicate.DeployConfig,
                  manifests = definitions.predicate.RenderConfig,
                  name = predicates.isType '"String",
                  patches = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.JSONPatch
                      ],
                  portForward = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.PortForwardResource
                      ],
                  requiresAllActivations = predicates.isType '"Bool",
                  resourceSelector =
                    definitions.predicate.ResourceSelectorConfig,
                  test = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.TestCase
                      ],
                  verify = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.VerifyTestCase
                      ],
                }
                {  }
                false
                predicates.never
              ],
          ProfileDependency
            | doc m%"
            describes a mapping from referenced config profiles to the current config profiles. If the current config is activated with a profile in this mapping then the dependency configs are also activated with the corresponding mapped profiles.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  activatedBy = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  name = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          RenderConfig
            | doc m%"
            contains all the configuration needed by the render steps.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  helm = definitions.predicate.Helm,
                  hooks = definitions.predicate.RenderHooks,
                  kpt = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  kustomize = definitions.predicate.Kustomize,
                  output = predicates.isType '"String",
                  rawYaml = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  transform = predicates.always,
                  validate = predicates.always,
                }
                {  }
                false
                predicates.never
              ],
          RenderHookItem
            | doc m%"
            describes a single lifecycle hook to execute before or after each deployer step.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { host = definitions.predicate.HostHook, }
                {  }
                false
                predicates.never
              ],
          RenderHooks
            | doc m%"
            describes the list of lifecycle hooks to execute before and after each render step.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  after = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.RenderHookItem
                      ],
                  before = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.RenderHookItem
                      ],
                }
                {  }
                false
                predicates.never
              ],
          ResourceFilter
            | doc m%"
            contains definition to filter which resource to transform.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "groupKind" ],
                predicates.records.record
                {
                  groupKind = predicates.isType '"String",
                  image = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  labels = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  podSpec = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          ResourceRequirement
            | doc m%"
            stores the CPU/Memory requirements for the pod.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  cpu = predicates.isType '"String",
                  ephemeralStorage = predicates.isType '"String",
                  memory = predicates.isType '"String",
                  resourceStorage = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          ResourceRequirements
            | doc m%"
            describes the resource requirements for the kaniko pod.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  limits = definitions.predicate.ResourceRequirement,
                  requests = definitions.predicate.ResourceRequirement,
                }
                {  }
                false
                predicates.never
              ],
          ResourceSelectorConfig
            | doc m%"
            contains all the configuration needed by the deploy steps.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  allow = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.ResourceFilter
                      ],
                  deny = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.ResourceFilter
                      ],
                }
                {  }
                false
                predicates.never
              ],
          ResourceType
            | doc m%"
            describes the Kubernetes resource types used for port forwarding.
            "%
            = predicates.isType '"String",
          ShaTagger
            | doc m%"
            *beta* tags images with their sha256 digest.
            "%
            = predicates.isType 'Record,
          SkaffoldConfig
            | doc m%"
            holds the fields parsed from the Skaffold configuration file (skaffold.yaml).
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "apiVersion", "kind" ],
                predicates.records.record
                {
                  apiVersion = predicates.isType '"String",
                  build = definitions.predicate.BuildConfig,
                  deploy = definitions.predicate.DeployConfig,
                  kind = predicates.isType '"String",
                  manifests = definitions.predicate.RenderConfig,
                  metadata = definitions.predicate.Metadata,
                  portForward = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.PortForwardResource
                      ],
                  profiles = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Profile
                      ],
                  requires = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.ConfigDependency
                      ],
                  resourceSelector =
                    definitions.predicate.ResourceSelectorConfig,
                  test = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.TestCase
                      ],
                  verify = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.VerifyTestCase
                      ],
                }
                {  }
                false
                predicates.never
              ],
          Sync
            | doc m%"
            *beta* specifies what files to sync into the container. This is a list of sync rules indicating the intent to sync for source files. If no files are listed, sync all the files and infer the destination.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  auto = predicates.isType '"Bool",
                  hooks = definitions.predicate.SyncHooks,
                  infer = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  manual = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.SyncRule
                      ],
                }
                {  }
                false
                predicates.never
              ],
          SyncHookItem
            | doc m%"
            describes a single lifecycle hook to execute before or after each artifact sync step.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  container = definitions.predicate.ContainerHook,
                  host = definitions.predicate.HostHook,
                }
                {  }
                false
                predicates.never
              ],
          SyncHooks
            | doc m%"
            describes the list of lifecycle hooks to execute before and after each artifact sync step.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  after = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.SyncHookItem
                      ],
                  before = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.SyncHookItem
                      ],
                }
                {  }
                false
                predicates.never
              ],
          SyncRule
            | doc m%"
            specifies which local files to sync to remote folders.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "dest", "src" ],
                predicates.records.record
                {
                  dest = predicates.isType '"String",
                  src = predicates.isType '"String",
                  strip = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          TagPolicy
            | doc m%"
            contains all the configuration for the tagging step.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  customTemplate = definitions.predicate.CustomTemplateTagger,
                  dateTime = definitions.predicate.DateTimeTagger,
                  envTemplate = definitions.predicate.EnvTemplateTagger,
                  gitCommit = definitions.predicate.GitTagger,
                  inputDigest = definitions.predicate.InputDigest,
                  sha256 = definitions.predicate.ShaTagger,
                }
                {  }
                false
                predicates.never
              ],
          TaggerComponent
            | doc m%"
            *beta* a component of CustomTemplateTagger.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.anyOf
                [
                  predicates.records.record
                  { name = predicates.isType '"String", }
                  {  }
                  false
                  predicates.never,
                  predicates.records.record
                  {
                    gitCommit = definitions.predicate.GitTagger,
                    name = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never,
                  predicates.records.record
                  {
                    name = predicates.isType '"String",
                    sha256 = definitions.predicate.ShaTagger,
                  }
                  {  }
                  false
                  predicates.never,
                  predicates.records.record
                  {
                    envTemplate = definitions.predicate.EnvTemplateTagger,
                    name = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never,
                  predicates.records.record
                  {
                    dateTime = definitions.predicate.DateTimeTagger,
                    name = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never,
                  predicates.records.record
                  {
                    customTemplate = definitions.predicate.CustomTemplateTagger,
                    name = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never,
                  predicates.records.record
                  {
                    inputDigest = definitions.predicate.InputDigest,
                    name = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ]
              ],
          TestCase
            | doc m%"
            a list of tests to run on images that Skaffold builds.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "image" ],
                predicates.records.record
                {
                  context = predicates.isType '"String",
                  custom = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.CustomTest
                      ],
                  image = predicates.isType '"String",
                  structureTests = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  structureTestsArgs = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          Transformer
            | doc m%"
            describes the supported kpt transformers.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  configMap = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  name = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Validator
            | doc m%"
            describes the supported kpt validators.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  configMap = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  name = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          VerifyTestCase
            | doc m%"
            a list of tests to run on images that Skaffold builds.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  container = predicates.always,
                  name = predicates.isType '"String",
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
[ predicates.isType 'Record, definitions.predicate.SkaffoldConfig ])