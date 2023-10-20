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
          BackgroundMatcher
            | doc m%"
            A description to track the start and end of a background task.
            "%
            = {
                activeOnStart
                  | Bool
                  | doc m%"
                  If set to true the watcher is in active mode when the task
                  starts. This is equals of issuing a line that matches the
                  beginPattern.
                  "%
                  | optional,
                beginsPattern
                  | String
                  | doc m%"
                  If matched in the output the start of a background task is signaled.
                  "%
                  | optional,
                endsPattern
                  | String
                  | doc m%"
                  If matched in the output the end of a background task is signaled.
                  "%
                  | optional,
                ..
              },
          BaseTaskConfiguration = {
                args
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  The arguments passed to the command. Can be omitted.
                  "%
                  | optional,
                command
                  | String
                  | doc m%"
                  The command to be executed. Can be an external program or a shell
                  command.
                  "%
                  | optional,
                isBackground
                  | Bool
                  | doc m%"
                  Specifies whether a global command is a background task.
                  "%
                  | optional,
                options
                  | definitions.contract.CommandOptions
                  | doc m%"
                  The command options used when the command is executed. Can be omitted.
                  "%
                  | optional,
                presentation
                  | definitions.contract.PresentationOptions
                  | doc m%"
                  The presentation options.
                  "%
                  | optional,
                problemMatcher
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.ProblemMatcher,
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.anyOf
                      [
                        definitions.predicate.ProblemMatcher,
                        predicates.isType '"String"
                      ])
                    ],
                    predicates.isType '"String"
                  ])
                  | doc m%"
                  The problem matcher to be used if a global command is executed (e.g. no tasks
                  are defined). A tasks.json file can either contain a global problemMatcher
                  property or a tasks property but not both.
                  "%
                  | optional,
                tasks
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.TaskDescription
                  ])
                  | doc m%"
                  The configuration of the available tasks. A tasks.json file can either
                  contain a global problemMatcher property or a tasks property but not both.
                  "%
                  | optional,
                type
                  | std.enum.TagOrString
                  | [| 'npm, 'shell, 'process |]
                  | doc m%"
                  The type of a custom task. Tasks of type "shell" are executed
                  inside a shell (e.g. bash, cmd, powershell, ...)
                  "%
                  | optional,
                ..
              },
          CommandOptions
            | doc m%"
            Options to be passed to the external program or shell
            "%
            = {
                cwd
                  | String
                  | doc m%"
                  The current working directory of the executed program or shell.
                  If omitted the current workspace's root is used.
                  "%
                  | optional,
                env
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | doc m%"
                  The environment of the executed program or shell. If omitted
                  the parent process' environment is used.
                  "%
                  | optional,
                shell
                  | {
                    args
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ])
                      | doc m%"
                      The arguments to be passed to the shell executable to run in command mode
                      (e.g ['-c'] for bash or ['/S', '/C'] for cmd.exe).
                      "%
                      | optional,
                    executable
                      | String
                      | doc m%"
                      The shell to use.
                      "%
                      | optional,
                    ..
                  }
                  | doc m%"
                  Configuration of the shell when task type is `shell`
                  "%
                  | optional,
                ..
              },
          PresentationOptions = {
                clear
                  | Bool
                  | doc m%"
                  Controls whether the terminal is cleared before this task is run.
                  Defaults to `false`.
                  "%
                  | optional,
                echo
                  | Bool
                  | doc m%"
                  Controls whether the command associated with the task is echoed
                  in the user interface. Defaults to `true`.
                  "%
                  | optional,
                focus
                  | Bool
                  | doc m%"
                  Controls whether the panel showing the task output is taking focus.
                  Defaults to `false`.
                  "%
                  | optional,
                group
                  | String
                  | doc m%"
                  Controls whether the task is executed in a specific terminal
                  group using split panes. Tasks in the same group (specified by a string value)
                  will use split terminals to present instead of a new terminal panel.
                  "%
                  | optional,
                panel
                  | std.enum.TagOrString
                  | [| 'shared, 'new, 'dedicated |]
                  | doc m%"
                  Controls if the task panel is used for this task only (dedicated),
                  shared between tasks (shared) or if a new panel is created on
                  every task execution (new). Defaults to `shared`.
                  "%
                  | optional,
                reveal
                  | std.enum.TagOrString
                  | [| 'silent, 'never, 'always |]
                  | doc m%"
                  Controls whether the task output is reveal in the user interface.
                  Defaults to `always`.
                  "%
                  | optional,
                showReuseMessage
                  | Bool
                  | doc m%"
                  Controls whether to show the `Terminal will be reused by tasks,
                  press any key to close it` message.
                  "%
                  | optional,
                ..
              },
          ProblemMatcher
            | doc m%"
            A description of a problem matcher that detects problems
            in build output.
            "%
            = {
                background
                  | definitions.contract.BackgroundMatcher
                  | doc m%"
                  Additional information used to detect when a background task (like a watching task in Gulp)
                  is active.
                  "%
                  | optional,
                base
                  | String
                  | doc m%"
                  The name of a base problem matcher to use. If specified the
                  base problem matcher will be used as a template and properties
                  specified here will replace properties of the base problem
                  matcher
                  "%
                  | optional,
                fileLocation
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
                  Defines how filename reported in a problem pattern
                  should be read. Valid values are:
                   - "absolute": the filename is always treated absolute.
                   - "relative": the filename is always treated relative to
                     the current working directory. This is the default.
                   - ["relative", "path value"]: the filename is always
                     treated relative to the given path value.
                   - "autodetect": the filename is treated relative to
                     the current workspace directory, and if the file
                     does not exist, it is treated as absolute.
                   - ["autodetect", "path value"]: the filename is treated
                     relative to the given path value, and if it does not
                     exist, it is treated as absolute.
                  "%
                  | optional,
                owner
                  | String
                  | doc m%"
                  The owner of the produced VS Code problem. This is typically
                  the identifier of a VS Code language service if the problems are
                  to be merged with the one produced by the language service
                  or 'external'. Defaults to 'external' if omitted.
                  "%
                  | optional,
                pattern
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.ProblemPattern,
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      definitions.predicate.ProblemPattern
                    ],
                    predicates.isType '"String"
                  ])
                  | doc m%"
                  The name of a predefined problem pattern, the inline definition
                  of a problem pattern or an array of problem patterns to match
                  problems spread over multiple lines.
                  "%
                  | optional,
                severity
                  | String
                  | doc m%"
                  The severity of the VS Code problem produced by this problem matcher.
                  
                  Valid values are:
                    "error": to produce errors.
                    "warning": to produce warnings.
                    "info": to produce infos.
                  
                  The value is used if a pattern doesn't specify a severity match group.
                  Defaults to "error" if omitted.
                  "%
                  | optional,
                ..
              },
          ProblemPattern = {
                code
                  | Number
                  | doc m%"
                  The match group index of the problem's code.
                  
                  Defaults to undefined. No code is captured.
                  "%
                  | optional,
                column
                  | Number
                  | doc m%"
                  The match group index of the problem's column in the source file.
                  "%
                  | optional,
                endColumn
                  | Number
                  | doc m%"
                  The match group index of the problem's end column in the source file.
                  
                  Defaults to undefined. No end column is captured.
                  "%
                  | optional,
                endLine
                  | Number
                  | doc m%"
                  The match group index of the problem's end line in the source file.
                  
                  Defaults to undefined. No end line is captured.
                  "%
                  | optional,
                file
                  | Number
                  | doc m%"
                  The match group index of the filename.
                  "%
                  | optional,
                kind
                  | std.enum.TagOrString
                  | [| 'location, 'file |]
                  | doc m%"
                  Whether the pattern matches a problem for the whole file or for a location
                  inside a file.
                  
                  Defaults to "location".
                  "%
                  | optional,
                line
                  | Number
                  | doc m%"
                  The match group index of the problem's line in the source file.
                  Can only be omitted if location is specified.
                  "%
                  | optional,
                location
                  | Number
                  | doc m%"
                  The match group index of the problem's location. Valid location
                  patterns are: (line), (line,column) and (startLine,startColumn,endLine,endColumn).
                  If omitted the line and column properties are used.
                  "%
                  | optional,
                loop
                  | Bool
                  | doc m%"
                  Specifies if the last pattern in a multi line problem matcher should
                  loop as long as it does match a line consequently. Only valid on the
                  last problem pattern in a multi line problem matcher.
                  "%
                  | optional,
                message
                  | Number
                  | doc m%"
                  The match group index of the message. Defaults to 0.
                  "%
                  | optional,
                regexp
                  | String
                  | doc m%"
                  The regular expression to find a problem in the console output of an
                  executed task.
                  "%
                  | optional,
                severity
                  | Number
                  | doc m%"
                  The match group index of the problem's severity.
                  
                  Defaults to undefined. In this case the problem matcher's severity
                  is used.
                  "%
                  | optional,
                ..
              },
          RunOptions
            | doc m%"
            A description to when and how run a task.
            "%
            = {
                reevaluateOnRerun
                  | Bool
                  | doc m%"
                  Controls how variables are evaluated when a task is executed through
                  the Rerun Last Task command.
                  The default is `true`, meaning that variables will be re-evaluated when
                  a task is rerun. When set to `false`, the resolved variable values from
                  the previous run of the task will be used.
                  "%
                  | optional,
                runOn
                  | String
                  | doc m%"
                  Specifies when a task is run.
                  
                  Valid values are:
                    "default": The task will only be run when executed through the Run Task command.
                    "folderOpen": The task will be run when the containing folder is opened.
                  "%
                  | optional,
                ..
              },
          TaskDescription
            | doc m%"
            The description of a task.
            "%
            = {
                args
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Additional arguments passed to the command. Should be used if type
                  is "process".
                  "%
                  | optional,
                command
                  | String
                  | doc m%"
                  The command to execute. If the type is "shell" it should be the full
                  command line including any additional arguments passed to the command.
                  "%
                  | optional,
                group
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record
                      {
                        isDefault = predicates.isType '"Bool",
                        kind = predicates.allOf
                            [
                              predicates.isType '"String",
                              predicates.enum [ "build", "test" ]
                            ],
                      }
                      {  }
                      true
                      predicates.always
                    ],
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.enum [ "build", "test" ]
                    ]
                  ])
                  | doc m%"
                  Defines the group to which this task belongs. Also supports to mark
                  a task as the default task in a group.
                  "%
                  | optional,
                isBackground
                  | Bool
                  | doc m%"
                  Whether the executed command is kept alive and runs in the background.
                  "%
                  | optional,
                label
                  | String
                  | doc m%"
                  The task's name
                  "%
                  | optional,
                presentation
                  | definitions.contract.PresentationOptions
                  | doc m%"
                  The presentation options.
                  "%
                  | optional,
                problemMatcher
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.ProblemMatcher,
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.anyOf
                      [
                        definitions.predicate.ProblemMatcher,
                        predicates.isType '"String"
                      ])
                    ],
                    predicates.isType '"String"
                  ])
                  | doc m%"
                  The problem matcher(s) to use to capture problems in the tasks
                  output.
                  "%
                  | optional,
                runOptions
                  | definitions.contract.RunOptions
                  | doc m%"
                  Defines when and how a task is run.
                  "%
                  | optional,
                type
                  | std.enum.TagOrString
                  | [| 'npm, 'shell, 'process |]
                  | doc m%"
                  The type of a custom task. Tasks of type "shell" are executed
                  inside a shell (e.g. bash, cmd, powershell, ...)
                  "%
                  | optional,
                ..
              },
        },
    predicate = {
          BackgroundMatcher
            | doc m%"
            A description to track the start and end of a background task.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  activeOnStart = predicates.isType '"Bool",
                  beginsPattern = predicates.isType '"String",
                  endsPattern = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          BaseTaskConfiguration = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  args = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  command = predicates.isType '"String",
                  isBackground = predicates.isType '"Bool",
                  options = definitions.predicate.CommandOptions,
                  presentation = definitions.predicate.PresentationOptions,
                  problemMatcher = predicates.anyOf
                      [
                        definitions.predicate.ProblemMatcher,
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.anyOf
                          [
                            definitions.predicate.ProblemMatcher,
                            predicates.isType '"String"
                          ])
                        ],
                        predicates.isType '"String"
                      ],
                  tasks = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.TaskDescription
                      ],
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "process", "shell", "npm" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          CommandOptions
            | doc m%"
            Options to be passed to the external program or shell
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  cwd = predicates.isType '"String",
                  env = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  shell = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          args = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.isType '"String")
                              ],
                          executable = predicates.isType '"String",
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
          PresentationOptions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  clear = predicates.isType '"Bool",
                  echo = predicates.isType '"Bool",
                  focus = predicates.isType '"Bool",
                  group = predicates.isType '"String",
                  panel = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "dedicated", "new", "shared" ]
                      ],
                  reveal = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "always", "never", "silent" ]
                      ],
                  showReuseMessage = predicates.isType '"Bool",
                }
                {  }
                true
                predicates.always
              ],
          ProblemMatcher
            | doc m%"
            A description of a problem matcher that detects problems
            in build output.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  background = definitions.predicate.BackgroundMatcher,
                  base = predicates.isType '"String",
                  fileLocation = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                        predicates.isType '"String"
                      ],
                  owner = predicates.isType '"String",
                  pattern = predicates.anyOf
                      [
                        definitions.predicate.ProblemPattern,
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          definitions.predicate.ProblemPattern
                        ],
                        predicates.isType '"String"
                      ],
                  severity = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          ProblemPattern = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  code = predicates.isType '"Number",
                  column = predicates.isType '"Number",
                  endColumn = predicates.isType '"Number",
                  endLine = predicates.isType '"Number",
                  file = predicates.isType '"Number",
                  kind = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "file", "location" ]
                      ],
                  line = predicates.isType '"Number",
                  location = predicates.isType '"Number",
                  loop = predicates.isType '"Bool",
                  message = predicates.isType '"Number",
                  regexp = predicates.isType '"String",
                  severity = predicates.isType '"Number",
                }
                {  }
                true
                predicates.always
              ],
          RunOptions
            | doc m%"
            A description to when and how run a task.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  reevaluateOnRerun = predicates.isType '"Bool",
                  runOn = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          TaskDescription
            | doc m%"
            The description of a task.
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
                  command = predicates.isType '"String",
                  group = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            isDefault = predicates.isType '"Bool",
                            kind = predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.enum [ "build", "test" ]
                                ],
                          }
                          {  }
                          true
                          predicates.always
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "build", "test" ]
                        ]
                      ],
                  isBackground = predicates.isType '"Bool",
                  label = predicates.isType '"String",
                  presentation = definitions.predicate.PresentationOptions,
                  problemMatcher = predicates.anyOf
                      [
                        definitions.predicate.ProblemMatcher,
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.anyOf
                          [
                            definitions.predicate.ProblemMatcher,
                            predicates.isType '"String"
                          ])
                        ],
                        predicates.isType '"String"
                      ],
                  runOptions = definitions.predicate.RunOptions,
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "process", "shell", "npm" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
        },
  }
in

{
  args
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    The arguments passed to the command. Can be omitted.
    "%
    | optional,
  command
    | String
    | doc m%"
    The command to be executed. Can be an external program or a shell
    command.
    "%
    | optional,
  isBackground
    | Bool
    | doc m%"
    Specifies whether a global command is a background task.
    "%
    | optional,
  linux
    | definitions.contract.BaseTaskConfiguration
    | doc m%"
    Linux specific task configuration
    "%
    | optional,
  options
    | definitions.contract.CommandOptions
    | doc m%"
    The command options used when the command is executed. Can be omitted.
    "%
    | optional,
  osx
    | definitions.contract.BaseTaskConfiguration
    | doc m%"
    macOS specific task configuration
    "%
    | optional,
  presentation
    | definitions.contract.PresentationOptions
    | doc m%"
    The presentation options.
    "%
    | optional,
  problemMatcher
    | predicates.contract_from_predicate
    (predicates.anyOf
    [
      definitions.predicate.ProblemMatcher,
      predicates.allOf
      [
        predicates.isType '"Array",
        predicates.arrays.arrayOf
        (predicates.anyOf
        [ definitions.predicate.ProblemMatcher, predicates.isType '"String" ])
      ],
      predicates.isType '"String"
    ])
    | doc m%"
    The problem matcher to be used if a global command is executed (e.g. no tasks
    are defined). A tasks.json file can either contain a global problemMatcher
    property or a tasks property but not both.
    "%
    | optional,
  tasks
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.TaskDescription
    ])
    | doc m%"
    The configuration of the available tasks. A tasks.json file can either
    contain a global problemMatcher property or a tasks property but not both.
    "%
    | optional,
  type
    | std.enum.TagOrString
    | [| 'npm, 'shell, 'process |]
    | doc m%"
    The type of a custom task. Tasks of type "shell" are executed
    inside a shell (e.g. bash, cmd, powershell, ...)
    "%
    | optional,
  version
    | std.enum.TagOrString
    | [| '"2.0.0" |]
    | doc m%"
    The configuration's version number
    "%
    | optional,
  windows
    | definitions.contract.BaseTaskConfiguration
    | doc m%"
    Windows specific task configuration
    "%
    | optional,
  ..
}