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
          "//" = predicates.contract_from_predicate definitions.predicate."//",
          refComplete = {
                ref
                  | String
                  | doc m%"
                  A reference to another property value. e.g. `styles.color.text`
                  "%
                  | optional,
                ..
              },
          settingsBlocksPropertiesComplete = predicates.contract_from_predicate
              definitions.predicate.settingsBlocksPropertiesComplete,
          settingsCustomAdditionalProperties =
            predicates.contract_from_predicate
              definitions.predicate.settingsCustomAdditionalProperties,
          settingsProperties = predicates.contract_from_predicate
              definitions.predicate.settingsProperties,
          settingsPropertiesAppearanceTools = {
                appearanceTools
                  | Bool
                  | doc m%"
                  Setting that enables the following UI tools:
                  
                  - background: backgroundImage
                  - border: color, radius, style, width
                  - color: link
                  - dimensions: minHeight
                  - position: sticky
                  - spacing: blockGap, margin, padding
                  - typography: lineHeight
                  "%
                  | optional,
                ..
              },
          settingsPropertiesBackground = {
                background
                  | {
                    backgroundImage
                      | Bool
                      | doc m%"
                      Allow users to set a background image.
                      "%
                      | optional,
                  }
                  | doc m%"
                  Settings related to background.
                  "%
                  | optional,
                ..
              },
          settingsPropertiesBorder = {
                border
                  | {
                    color
                      | Bool
                      | doc m%"
                      Allow users to set custom border colors.
                      "%
                      | optional,
                    radius
                      | Bool
                      | doc m%"
                      Allow users to set custom border radius.
                      "%
                      | optional,
                    style
                      | Bool
                      | doc m%"
                      Allow users to set custom border styles.
                      "%
                      | optional,
                    width
                      | Bool
                      | doc m%"
                      Allow users to set custom border widths.
                      "%
                      | optional,
                  }
                  | doc m%"
                  Settings related to borders.
                  "%
                  | optional,
                ..
              },
          settingsPropertiesColor = {
                color
                  | {
                    background
                      | Bool
                      | doc m%"
                      Allow users to set background colors.
                      "%
                      | optional,
                    custom
                      | Bool
                      | doc m%"
                      Allow users to select custom colors.
                      "%
                      | optional,
                    customDuotone
                      | Bool
                      | doc m%"
                      Allow users to create custom duotone filters.
                      "%
                      | optional,
                    customGradient
                      | Bool
                      | doc m%"
                      Allow users to create custom gradients.
                      "%
                      | optional,
                    defaultDuotone
                      | Bool
                      | doc m%"
                      Allow users to choose filters from the default duotone filter presets.
                      "%
                      | optional,
                    defaultGradients
                      | Bool
                      | doc m%"
                      Allow users to choose colors from the default gradients.
                      "%
                      | optional,
                    defaultPalette
                      | Bool
                      | doc m%"
                      Allow users to choose colors from the default palette.
                      "%
                      | optional,
                    duotone
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.required
                          [ "colors", "name", "slug" ],
                          predicates.records.record
                          {
                            colors = predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.isType '"String")
                                ],
                            name = predicates.isType '"String",
                            slug = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never
                        ])
                      ])
                      | doc m%"
                      Duotone presets for the duotone picker.
                      Doesn't generate classes or properties.
                      "%
                      | optional,
                    gradients
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.required
                          [ "gradient", "name", "slug" ],
                          predicates.records.record
                          {
                            gradient = predicates.isType '"String",
                            name = predicates.isType '"String",
                            slug = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never
                        ])
                      ])
                      | doc m%"
                      Gradient presets for the gradient picker.
                      Generates a single class (`.has-{slug}-background`) and custom property (`--wp--preset--gradient--{slug}`) per preset value.
                      "%
                      | optional,
                    link
                      | Bool
                      | doc m%"
                      Allow users to set link colors.
                      "%
                      | optional,
                    palette
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.required
                          [ "color", "name", "slug" ],
                          predicates.records.record
                          {
                            color = predicates.isType '"String",
                            name = predicates.isType '"String",
                            slug = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never
                        ])
                      ])
                      | doc m%"
                      Color palette presets for the color picker.
                      Generates three classes (`.has-{slug}-color`, `.has-{slug}-background-color`, and `.has-{slug}-border-color`) and a single custom property (`--wp--preset--color--{slug}`) per preset value.
                      "%
                      | optional,
                    text
                      | Bool
                      | doc m%"
                      Allow users to set text colors.
                      "%
                      | optional,
                  }
                  | doc m%"
                  Settings related to colors.
                  "%
                  | optional,
                ..
              },
          settingsPropertiesComplete = predicates.contract_from_predicate
              definitions.predicate.settingsPropertiesComplete,
          settingsPropertiesCustom = {
                custom
                  | definitions.contract.settingsCustomAdditionalProperties
                  | doc m%"
                  Generate custom CSS custom properties of the form `--wp--custom--{key}--{nested-key}: {value};`. `camelCased` keys are transformed to `kebab-case` as to follow the CSS property naming schema. Keys at different depth levels are separated by `--`, so keys should not include `--` in the name.
                  "%
                  | optional,
                ..
              },
          settingsPropertiesDimensions = {
                dimensions
                  | {
                    minHeight
                      | Bool
                      | doc m%"
                      Allow users to set custom minimum height.
                      "%
                      | optional,
                  }
                  | doc m%"
                  Settings related to dimensions.
                  "%
                  | optional,
                ..
              },
          settingsPropertiesLayout = {
                layout
                  | {
                    allowEditing
                      | Bool
                      | doc m%"
                      Disable the layout UI controls.
                      "%
                      | optional,
                    contentSize
                      | String
                      | doc m%"
                      Sets the max-width of the content.
                      "%
                      | optional,
                    wideSize
                      | String
                      | doc m%"
                      Sets the max-width of wide (`.alignwide`) content. Also used as the maximum viewport when calculating fluid font sizes
                      "%
                      | optional,
                  }
                  | doc m%"
                  Settings related to layout.
                  "%
                  | optional,
                ..
              },
          settingsPropertiesLightbox = {
                lightbox
                  | {
                    allowEditing
                      | Bool
                      | doc m%"
                      Defines whether to show the Lightbox UI in the block editor. If set to `false`, the user won't be able to change the lightbox settings in the block editor.
                      "%
                      | optional,
                    enabled
                      | Bool
                      | doc m%"
                      Defines whether the lightbox is enabled or not.
                      "%
                      | optional,
                  }
                  | doc m%"
                  Settings related to the lightbox.
                  "%
                  | optional,
                ..
              },
          settingsPropertiesPosition = {
                position
                  | {
                    sticky
                      | Bool
                      | doc m%"
                      Allow users to set sticky position.
                      "%
                      | optional,
                  }
                  | doc m%"
                  Settings related to position.
                  "%
                  | optional,
                ..
              },
          settingsPropertiesShadow = {
                shadow
                  | {
                    defaultPresets
                      | Bool
                      | doc m%"
                      Allow users to choose shadows from the default shadow presets.
                      "%
                      | optional,
                    presets
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.required
                          [ "name", "shadow", "slug" ],
                          predicates.records.record
                          {
                            name = predicates.isType '"String",
                            shadow = predicates.isType '"String",
                            slug = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never
                        ])
                      ])
                      | doc m%"
                      Shadow presets for the shadow picker.
                      Generates a single custom property (`--wp--preset--shadow--{slug}`) per preset value.
                      "%
                      | optional,
                  }
                  | doc m%"
                  Settings related to shadows.
                  "%
                  | optional,
                ..
              },
          settingsPropertiesSpacing = {
                spacing
                  | {
                    blockGap
                      | predicates.contract_from_predicate
                      (predicates.oneOf
                      [ predicates.isType '"Bool", predicates.isType 'Null ])
                      | doc m%"
                      Enables `--wp--style--block-gap` to be generated from styles.spacing.blockGap.
                      A value of `null` instead of `false` further disables layout styles from being generated.
                      "%
                      | optional,
                    customSpacingSize
                      | Bool
                      | doc m%"
                      Allow users to set custom space sizes.
                      "%
                      | optional,
                    margin
                      | Bool
                      | doc m%"
                      Allow users to set a custom margin.
                      "%
                      | optional,
                    padding
                      | Bool
                      | doc m%"
                      Allow users to set a custom padding.
                      "%
                      | optional,
                    spacingScale
                      | {
                        increment
                          | Number
                          | doc m%"
                          The amount to increment each step by.
                          "%
                          | optional,
                        mediumStep
                          | Number
                          | doc m%"
                          The value to medium setting in the scale.
                          "%
                          | optional,
                        operator
                          | std.enum.TagOrString
                          | [| '"*", '"+" |]
                          | doc m%"
                          With + or * depending on whether scale is generated by increment or multiplier.
                          "%
                          | optional,
                        steps
                          | std.number.Integer
                          | doc m%"
                          Number of steps to generate in scale.
                          "%
                          | optional,
                        unit
                          | std.enum.TagOrString
                          | [|
                            'dvmax,
                            'lvmax,
                            'svmax,
                            'vmax,
                            'dvmin,
                            'lvmin,
                            'svmin,
                            'vmin,
                            'dvb,
                            'lvb,
                            'svb,
                            'vb,
                            'dvi,
                            'lvi,
                            'svi,
                            'vi,
                            'dvh,
                            'lvh,
                            'svh,
                            'vh,
                            'dvw,
                            'lvw,
                            'svw,
                            'vw,
                            '"%",
                            'rem,
                            'em,
                            'px
                          |]
                          | doc m%"
                          Unit that the scale uses, eg. rem, em, px.
                          "%
                          | optional,
                      }
                      | doc m%"
                      Settings to auto-generate space size presets for the space size selector.
                      Generates a custom property (--wp--preset--spacing--{slug}`) per preset value.
                      "%
                      | optional,
                    spacingSizes
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
                            name = predicates.isType '"String",
                            size = predicates.isType '"String",
                            slug = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never
                        ])
                      ])
                      | doc m%"
                      Space size presets for the space size selector.
                      Generates a custom property (`--wp--preset--spacing--{slug}`) per preset value.
                      "%
                      | optional,
                    units
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ])
                      | doc m%"
                      List of units the user can use for spacing values.
                      "%
                      | optional,
                  }
                  | doc m%"
                  Settings related to spacing.
                  "%
                  | optional,
                ..
              },
          settingsPropertiesTypography = {
                typography
                  | {
                    customFontSize
                      | Bool
                      | doc m%"
                      Allow users to set custom font sizes.
                      "%
                      | optional,
                    dropCap
                      | Bool
                      | doc m%"
                      Enable drop cap.
                      "%
                      | optional,
                    fluid
                      | predicates.contract_from_predicate
                      (predicates.oneOf
                      [
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            maxViewportWidth = predicates.isType '"String",
                            minFontSize = predicates.isType '"String",
                            minViewportWidth = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never
                        ],
                        predicates.isType '"Bool"
                      ])
                      | doc m%"
                      Enables fluid typography and allows users to set global fluid typography parameters.
                      "%
                      | optional,
                    fontFamilies
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
                            fontFace = predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.required
                                    [ "fontFamily", "src" ],
                                    predicates.records.record
                                    {
                                      ascentOverride = predicates.isType
                                          '"String",
                                      descentOverride = predicates.isType
                                          '"String",
                                      fontDisplay = predicates.allOf
                                          [
                                            predicates.isType '"String",
                                            predicates.enum
                                            [
                                              "auto",
                                              "block",
                                              "fallback",
                                              "swap",
                                              "optional"
                                            ]
                                          ],
                                      fontFamily = predicates.isType '"String",
                                      fontFeatureSettings = predicates.isType
                                          '"String",
                                      fontStretch = predicates.isType '"String",
                                      fontStyle = predicates.isType '"String",
                                      fontVariant = predicates.isType '"String",
                                      fontVariationSettings = predicates.isType
                                          '"String",
                                      fontWeight = predicates.oneOf
                                          [
                                            predicates.isType '"String",
                                            predicates.isType 'Integer
                                          ],
                                      lineGapOverride = predicates.isType
                                          '"String",
                                      sizeAdjust = predicates.isType '"String",
                                      src = predicates.oneOf
                                          [
                                            predicates.isType '"String",
                                            predicates.allOf
                                            [
                                              predicates.isType '"Array",
                                              predicates.arrays.arrayOf
                                              (predicates.isType '"String")
                                            ]
                                          ],
                                      unicodeRange = predicates.isType
                                          '"String",
                                    }
                                    {  }
                                    false
                                    predicates.never
                                  ])
                                ],
                            fontFamily = predicates.isType '"String",
                            name = predicates.isType '"String",
                            slug = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never
                        ])
                      ])
                      | doc m%"
                      Font family presets for the font family selector.
                      Generates a single custom property (`--wp--preset--font-family--{slug}`) per preset value.
                      "%
                      | optional,
                    fontSizes
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
                            fluid = predicates.oneOf
                                [
                                  predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.record
                                    {
                                      max = predicates.isType '"String",
                                      min = predicates.isType '"String",
                                    }
                                    {  }
                                    false
                                    predicates.never
                                  ],
                                  predicates.isType '"Bool"
                                ],
                            name = predicates.isType '"String",
                            size = predicates.isType '"String",
                            slug = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never
                        ])
                      ])
                      | doc m%"
                      Font size presets for the font size selector.
                      Generates a single class (`.has-{slug}-color`) and custom property (`--wp--preset--font-size--{slug}`) per preset value.
                      "%
                      | optional,
                    fontStyle
                      | Bool
                      | doc m%"
                      Allow users to set custom font styles.
                      "%
                      | optional,
                    fontWeight
                      | Bool
                      | doc m%"
                      Allow users to set custom font weights.
                      "%
                      | optional,
                    letterSpacing
                      | Bool
                      | doc m%"
                      Allow users to set custom letter spacing.
                      "%
                      | optional,
                    lineHeight
                      | Bool
                      | doc m%"
                      Allow users to set custom line height.
                      "%
                      | optional,
                    textColumns
                      | Bool
                      | doc m%"
                      Allow users to set the number of text columns.
                      "%
                      | optional,
                    textDecoration
                      | Bool
                      | doc m%"
                      Allow users to set custom text decorations.
                      "%
                      | optional,
                    textTransform
                      | Bool
                      | doc m%"
                      Allow users to set custom text transforms.
                      "%
                      | optional,
                    writingMode
                      | Bool
                      | doc m%"
                      Allow users to set the writing mode.
                      "%
                      | optional,
                  }
                  | doc m%"
                  Settings related to typography.
                  "%
                  | optional,
                ..
              },
          settingsPropertiesUseRootPaddingAwareAlignments =
            predicates.contract_from_predicate
              definitions.predicate.settingsPropertiesUseRootPaddingAwareAlignments,
          stylesBlocksPropertiesComplete = predicates.contract_from_predicate
              definitions.predicate.stylesBlocksPropertiesComplete,
          stylesElementsPropertiesComplete = {
                button
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.allOf
                    [
                      definitions.predicate.stylesProperties,
                      predicates.records.record
                      {
                        ":active" =
                          definitions.predicate.stylesPropertiesComplete,
                        ":any-link" =
                          definitions.predicate.stylesPropertiesComplete,
                        ":focus" =
                          definitions.predicate.stylesPropertiesComplete,
                        ":hover" =
                          definitions.predicate.stylesPropertiesComplete,
                        ":link" =
                          definitions.predicate.stylesPropertiesComplete,
                        ":visited" =
                          definitions.predicate.stylesPropertiesComplete,
                        border = predicates.always,
                        color = predicates.always,
                        css = predicates.always,
                        filter = predicates.always,
                        outline = predicates.always,
                        shadow = predicates.always,
                        spacing = predicates.always,
                        typography = predicates.always,
                      }
                      {  }
                      false
                      predicates.never
                    ]
                  ])
                  | optional,
                caption
                  | definitions.contract.stylesPropertiesComplete
                  | optional,
                cite | definitions.contract.stylesPropertiesComplete | optional,
                h1 | definitions.contract.stylesPropertiesComplete | optional,
                h2 | definitions.contract.stylesPropertiesComplete | optional,
                h3 | definitions.contract.stylesPropertiesComplete | optional,
                h4 | definitions.contract.stylesPropertiesComplete | optional,
                h5 | definitions.contract.stylesPropertiesComplete | optional,
                h6 | definitions.contract.stylesPropertiesComplete | optional,
                heading
                  | definitions.contract.stylesPropertiesComplete
                  | optional,
                link
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.allOf
                    [
                      definitions.predicate.stylesProperties,
                      predicates.records.record
                      {
                        ":active" =
                          definitions.predicate.stylesPropertiesComplete,
                        ":any-link" =
                          definitions.predicate.stylesPropertiesComplete,
                        ":focus" =
                          definitions.predicate.stylesPropertiesComplete,
                        ":hover" =
                          definitions.predicate.stylesPropertiesComplete,
                        ":link" =
                          definitions.predicate.stylesPropertiesComplete,
                        ":visited" =
                          definitions.predicate.stylesPropertiesComplete,
                        border = predicates.always,
                        color = predicates.always,
                        spacing = predicates.always,
                        typography = predicates.always,
                      }
                      {  }
                      false
                      predicates.never
                    ]
                  ])
                  | optional,
              },
          stylesProperties = {
                border
                  | {
                    bottom
                      | {
                        color
                          | predicates.contract_from_predicate
                          (predicates.oneOf
                          [
                            predicates.isType '"String",
                            definitions.predicate.refComplete
                          ])
                          | doc m%"
                          Sets the `border-bottom-color` CSS property.
                          "%
                          | optional,
                        style
                          | predicates.contract_from_predicate
                          (predicates.oneOf
                          [
                            predicates.isType '"String",
                            definitions.predicate.refComplete
                          ])
                          | doc m%"
                          Sets the `border-bottom-style` CSS property.
                          "%
                          | optional,
                        width
                          | predicates.contract_from_predicate
                          (predicates.oneOf
                          [
                            predicates.isType '"String",
                            definitions.predicate.refComplete
                          ])
                          | doc m%"
                          Sets the `border-bottom-width` CSS property.
                          "%
                          | optional,
                      }
                      | optional,
                    color
                      | predicates.contract_from_predicate
                      (predicates.oneOf
                      [
                        predicates.isType '"String",
                        definitions.predicate.refComplete
                      ])
                      | doc m%"
                      Sets the `border-color` CSS property.
                      "%
                      | optional,
                    left
                      | {
                        color
                          | predicates.contract_from_predicate
                          (predicates.oneOf
                          [
                            predicates.isType '"String",
                            definitions.predicate.refComplete
                          ])
                          | doc m%"
                          Sets the `border-left-color` CSS property.
                          "%
                          | optional,
                        style
                          | predicates.contract_from_predicate
                          (predicates.oneOf
                          [
                            predicates.isType '"String",
                            definitions.predicate.refComplete
                          ])
                          | doc m%"
                          Sets the `border-left-style` CSS property.
                          "%
                          | optional,
                        width
                          | predicates.contract_from_predicate
                          (predicates.oneOf
                          [
                            predicates.isType '"String",
                            definitions.predicate.refComplete
                          ])
                          | doc m%"
                          Sets the `border-left-width` CSS property.
                          "%
                          | optional,
                      }
                      | optional,
                    radius
                      | predicates.contract_from_predicate
                      (predicates.anyOf
                      [
                        predicates.isType '"String",
                        definitions.predicate.refComplete,
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            bottomLeft = predicates.oneOf
                                [
                                  predicates.isType '"String",
                                  definitions.predicate.refComplete
                                ],
                            bottomRight = predicates.oneOf
                                [
                                  predicates.isType '"String",
                                  definitions.predicate.refComplete
                                ],
                            topLeft = predicates.oneOf
                                [
                                  predicates.isType '"String",
                                  definitions.predicate.refComplete
                                ],
                            topRight = predicates.oneOf
                                [
                                  predicates.isType '"String",
                                  definitions.predicate.refComplete
                                ],
                          }
                          {  }
                          true
                          predicates.always
                        ]
                      ])
                      | doc m%"
                      Sets the `border-radius` CSS property.
                      "%
                      | optional,
                    right
                      | {
                        color
                          | predicates.contract_from_predicate
                          (predicates.oneOf
                          [
                            predicates.isType '"String",
                            definitions.predicate.refComplete
                          ])
                          | doc m%"
                          Sets the `border-right-color` CSS property.
                          "%
                          | optional,
                        style
                          | predicates.contract_from_predicate
                          (predicates.oneOf
                          [
                            predicates.isType '"String",
                            definitions.predicate.refComplete
                          ])
                          | doc m%"
                          Sets the `border-right-style` CSS property.
                          "%
                          | optional,
                        width
                          | predicates.contract_from_predicate
                          (predicates.oneOf
                          [
                            predicates.isType '"String",
                            definitions.predicate.refComplete
                          ])
                          | doc m%"
                          Sets the `border-right-width` CSS property.
                          "%
                          | optional,
                      }
                      | optional,
                    style
                      | predicates.contract_from_predicate
                      (predicates.oneOf
                      [
                        predicates.isType '"String",
                        definitions.predicate.refComplete
                      ])
                      | doc m%"
                      Sets the `border-style` CSS property.
                      "%
                      | optional,
                    top
                      | {
                        color
                          | predicates.contract_from_predicate
                          (predicates.oneOf
                          [
                            predicates.isType '"String",
                            definitions.predicate.refComplete
                          ])
                          | doc m%"
                          Sets the `border-top-color` CSS property.
                          "%
                          | optional,
                        style
                          | predicates.contract_from_predicate
                          (predicates.oneOf
                          [
                            predicates.isType '"String",
                            definitions.predicate.refComplete
                          ])
                          | doc m%"
                          Sets the `border-top-style` CSS property.
                          "%
                          | optional,
                        width
                          | predicates.contract_from_predicate
                          (predicates.oneOf
                          [
                            predicates.isType '"String",
                            definitions.predicate.refComplete
                          ])
                          | doc m%"
                          Sets the `border-top-width` CSS property.
                          "%
                          | optional,
                      }
                      | optional,
                    width
                      | predicates.contract_from_predicate
                      (predicates.oneOf
                      [
                        predicates.isType '"String",
                        definitions.predicate.refComplete
                      ])
                      | doc m%"
                      Sets the `border-width` CSS property.
                      "%
                      | optional,
                  }
                  | doc m%"
                  Border styles.
                  "%
                  | optional,
                color
                  | {
                    background
                      | predicates.contract_from_predicate
                      (predicates.oneOf
                      [
                        predicates.isType '"String",
                        definitions.predicate.refComplete
                      ])
                      | doc m%"
                      Sets the `background-color` CSS property.
                      "%
                      | optional,
                    gradient
                      | predicates.contract_from_predicate
                      (predicates.oneOf
                      [
                        predicates.isType '"String",
                        definitions.predicate.refComplete
                      ])
                      | doc m%"
                      Sets the `background` CSS property.
                      "%
                      | optional,
                    text
                      | predicates.contract_from_predicate
                      (predicates.oneOf
                      [
                        predicates.isType '"String",
                        definitions.predicate.refComplete
                      ])
                      | doc m%"
                      Sets the `color` CSS property.
                      "%
                      | optional,
                  }
                  | doc m%"
                  Color styles.
                  "%
                  | optional,
                css
                  | String
                  | doc m%"
                  Sets custom CSS to apply styling not covered by other theme.json properties.
                  "%
                  | optional,
                dimensions
                  | {
                    minHeight
                      | predicates.contract_from_predicate
                      (predicates.oneOf
                      [
                        predicates.isType '"String",
                        definitions.predicate.refComplete
                      ])
                      | doc m%"
                      Sets the `min-height` CSS property.
                      "%
                      | optional,
                    ..
                  }
                  | doc m%"
                  Dimensions styles
                  "%
                  | optional,
                filter
                  | {
                    duotone
                      | predicates.contract_from_predicate
                      (predicates.oneOf
                      [
                        predicates.isType '"String",
                        definitions.predicate.refComplete
                      ])
                      | doc m%"
                      Sets the duotone filter.
                      "%
                      | optional,
                  }
                  | doc m%"
                  CSS and SVG filter styles.
                  "%
                  | optional,
                outline
                  | {
                    color
                      | predicates.contract_from_predicate
                      (predicates.oneOf
                      [
                        predicates.isType '"String",
                        definitions.predicate.refComplete
                      ])
                      | doc m%"
                      Sets the `outline-color` CSS property.
                      "%
                      | optional,
                    offset
                      | predicates.contract_from_predicate
                      (predicates.oneOf
                      [
                        predicates.isType '"String",
                        definitions.predicate.refComplete
                      ])
                      | doc m%"
                      Sets the `outline-offset` CSS property.
                      "%
                      | optional,
                    style
                      | predicates.contract_from_predicate
                      (predicates.oneOf
                      [
                        predicates.isType '"String",
                        definitions.predicate.refComplete
                      ])
                      | doc m%"
                      Sets the `outline-style` CSS property.
                      "%
                      | optional,
                    width
                      | predicates.contract_from_predicate
                      (predicates.oneOf
                      [
                        predicates.isType '"String",
                        definitions.predicate.refComplete
                      ])
                      | doc m%"
                      Sets the `outline-width` CSS property.
                      "%
                      | optional,
                  }
                  | doc m%"
                  Outline styles.
                  "%
                  | optional,
                shadow
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    predicates.isType '"String",
                    definitions.predicate.refComplete
                  ])
                  | doc m%"
                  Box shadow styles.
                  "%
                  | optional,
                spacing
                  | {
                    blockGap
                      | predicates.contract_from_predicate
                      (predicates.oneOf
                      [
                        predicates.isType '"String",
                        definitions.predicate.refComplete
                      ])
                      | doc m%"
                      Sets the `--wp--style--block-gap` CSS custom property when settings.spacing.blockGap is true.
                      "%
                      | optional,
                    margin
                      | {
                        bottom
                          | predicates.contract_from_predicate
                          (predicates.oneOf
                          [
                            predicates.isType '"String",
                            definitions.predicate.refComplete
                          ])
                          | doc m%"
                          Sets the `margin-bottom` CSS property.
                          "%
                          | optional,
                        left
                          | predicates.contract_from_predicate
                          (predicates.oneOf
                          [
                            predicates.isType '"String",
                            definitions.predicate.refComplete
                          ])
                          | doc m%"
                          Sets the `margin-left` CSS property.
                          "%
                          | optional,
                        right
                          | predicates.contract_from_predicate
                          (predicates.oneOf
                          [
                            predicates.isType '"String",
                            definitions.predicate.refComplete
                          ])
                          | doc m%"
                          Sets the `margin-right` CSS property.
                          "%
                          | optional,
                        top
                          | predicates.contract_from_predicate
                          (predicates.oneOf
                          [
                            predicates.isType '"String",
                            definitions.predicate.refComplete
                          ])
                          | doc m%"
                          Sets the `margin-top` CSS property.
                          "%
                          | optional,
                      }
                      | doc m%"
                      Margin styles.
                      "%
                      | optional,
                    padding
                      | {
                        bottom
                          | predicates.contract_from_predicate
                          (predicates.oneOf
                          [
                            predicates.isType '"String",
                            definitions.predicate.refComplete
                          ])
                          | doc m%"
                          Sets the `padding-bottom` CSS property.
                          "%
                          | optional,
                        left
                          | predicates.contract_from_predicate
                          (predicates.oneOf
                          [
                            predicates.isType '"String",
                            definitions.predicate.refComplete
                          ])
                          | doc m%"
                          Sets the `padding-left` CSS property.
                          "%
                          | optional,
                        right
                          | predicates.contract_from_predicate
                          (predicates.oneOf
                          [
                            predicates.isType '"String",
                            definitions.predicate.refComplete
                          ])
                          | doc m%"
                          Sets the `padding-right` CSS property.
                          "%
                          | optional,
                        top
                          | predicates.contract_from_predicate
                          (predicates.oneOf
                          [
                            predicates.isType '"String",
                            definitions.predicate.refComplete
                          ])
                          | doc m%"
                          Sets the `padding-top` CSS property.
                          "%
                          | optional,
                      }
                      | doc m%"
                      Padding styles.
                      "%
                      | optional,
                  }
                  | doc m%"
                  Spacing styles.
                  "%
                  | optional,
                typography
                  | {
                    fontFamily
                      | predicates.contract_from_predicate
                      (predicates.oneOf
                      [
                        predicates.isType '"String",
                        definitions.predicate.refComplete
                      ])
                      | doc m%"
                      Sets the `font-family` CSS property.
                      "%
                      | optional,
                    fontSize
                      | predicates.contract_from_predicate
                      (predicates.oneOf
                      [
                        predicates.isType '"String",
                        definitions.predicate.refComplete
                      ])
                      | doc m%"
                      Sets the `font-size` CSS property.
                      "%
                      | optional,
                    fontStyle
                      | predicates.contract_from_predicate
                      (predicates.oneOf
                      [
                        predicates.isType '"String",
                        definitions.predicate.refComplete
                      ])
                      | doc m%"
                      Sets the `font-style` CSS property.
                      "%
                      | optional,
                    fontWeight
                      | predicates.contract_from_predicate
                      (predicates.oneOf
                      [
                        predicates.isType '"String",
                        definitions.predicate.refComplete
                      ])
                      | doc m%"
                      Sets the `font-weight` CSS property.
                      "%
                      | optional,
                    letterSpacing
                      | predicates.contract_from_predicate
                      (predicates.oneOf
                      [
                        predicates.isType '"String",
                        definitions.predicate.refComplete
                      ])
                      | doc m%"
                      Sets the `letter-spacing` CSS property.
                      "%
                      | optional,
                    lineHeight
                      | predicates.contract_from_predicate
                      (predicates.oneOf
                      [
                        predicates.isType '"String",
                        definitions.predicate.refComplete
                      ])
                      | doc m%"
                      Sets the `line-height` CSS property.
                      "%
                      | optional,
                    textColumns
                      | String
                      | doc m%"
                      Sets the `column-count` CSS property.
                      "%
                      | optional,
                    textDecoration
                      | predicates.contract_from_predicate
                      (predicates.oneOf
                      [
                        predicates.isType '"String",
                        definitions.predicate.refComplete
                      ])
                      | doc m%"
                      Sets the `text-decoration` CSS property.
                      "%
                      | optional,
                    textTransform
                      | predicates.contract_from_predicate
                      (predicates.oneOf
                      [
                        predicates.isType '"String",
                        definitions.predicate.refComplete
                      ])
                      | doc m%"
                      Sets the `text-transform` CSS property.
                      "%
                      | optional,
                    writingMode
                      | predicates.contract_from_predicate
                      (predicates.oneOf
                      [
                        predicates.isType '"String",
                        definitions.predicate.refComplete
                      ])
                      | doc m%"
                      Sets the `writing-mode` CSS property.
                      "%
                      | optional,
                  }
                  | doc m%"
                  Typography styles.
                  "%
                  | optional,
                ..
              },
          stylesPropertiesAndElementsComplete =
            predicates.contract_from_predicate
              definitions.predicate.stylesPropertiesAndElementsComplete,
          stylesPropertiesComplete = predicates.contract_from_predicate
              definitions.predicate.stylesPropertiesComplete,
          stylesVariationPropertiesComplete = predicates.contract_from_predicate
              definitions.predicate.stylesVariationPropertiesComplete,
        },
    predicate = {
          "//" = predicates.always,
          refComplete = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record { ref = predicates.isType '"String", }
                {  }
                true
                predicates.always
              ],
          settingsBlocksPropertiesComplete = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "core/archives" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/audio" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/avatar" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/block" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/button" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/buttons" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/calendar" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/categories" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/code" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/column" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/columns" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/comment-author-avatar" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/comment-author-name" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/comment-content" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/comment-date" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/comment-edit-link" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/comment-reply-link" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/comment-template" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/comments" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/comments-pagination" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/comments-pagination-next" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/comments-pagination-numbers" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/comments-pagination-previous" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/comments-title" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/cover" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/details" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/embed" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/file" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/freeform" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/gallery" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/group" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/heading" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/home-link" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/html" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/image" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/latest-comments" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/latest-posts" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/legacy-widget" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/list" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/list-item" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/loginout" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/media-text" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/missing" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/more" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/navigation" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/navigation-link" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/navigation-submenu" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/nextpage" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/page-list" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/page-list-item" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/paragraph" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/post-author" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/post-author-biography" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/post-author-name" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/post-comment" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/post-comments-count" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/post-comments-form" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/post-comments-link" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/post-content" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/post-date" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/post-excerpt" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/post-featured-image" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/post-navigation-link" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/post-template" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/post-terms" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/post-time-to-read" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/post-title" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/preformatted" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/pullquote" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/query" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/query-no-results" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/query-pagination" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/query-pagination-next" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/query-pagination-numbers" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/query-pagination-previous" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/query-title" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/quote" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/read-more" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/rss" = definitions.predicate.settingsPropertiesComplete,
                  "core/search" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/separator" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/shortcode" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/site-logo" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/site-tagline" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/site-title" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/social-link" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/social-links" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/spacer" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/table" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/table-of-contents" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/tag-cloud" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/template-part" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/term-description" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/text-columns" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/verse" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/video" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/widget-area" =
                    definitions.predicate.settingsPropertiesComplete,
                  "core/widget-group" =
                    definitions.predicate.settingsPropertiesComplete,
                }
                {
                  "^[a-z][a-z0-9-]*/[a-z][a-z0-9-]*$" =
                    definitions.predicate.settingsPropertiesComplete,
                }
                false
                predicates.never
              ],
          settingsCustomAdditionalProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  } {  } true
                (predicates.oneOf
                [
                  predicates.isType '"String",
                  predicates.isType '"Number",
                  definitions.predicate.settingsCustomAdditionalProperties
                ])
              ],
          settingsProperties = predicates.allOf
              [
                definitions.predicate.settingsPropertiesAppearanceTools,
                definitions.predicate.settingsPropertiesBackground,
                definitions.predicate.settingsPropertiesBorder,
                definitions.predicate.settingsPropertiesColor,
                definitions.predicate.settingsPropertiesDimensions,
                definitions.predicate.settingsPropertiesShadow,
                definitions.predicate.settingsPropertiesLayout,
                definitions.predicate.settingsPropertiesLightbox,
                definitions.predicate.settingsPropertiesPosition,
                definitions.predicate.settingsPropertiesSpacing,
                definitions.predicate.settingsPropertiesTypography,
                definitions.predicate.settingsPropertiesCustom
              ],
          settingsPropertiesAppearanceTools = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { appearanceTools = predicates.isType '"Bool", }
                {  }
                true
                predicates.always
              ],
          settingsPropertiesBackground = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  background = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        { backgroundImage = predicates.isType '"Bool", }
                        {  }
                        false
                        predicates.never
                      ],
                }
                {  }
                true
                predicates.always
              ],
          settingsPropertiesBorder = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  border = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          color = predicates.isType '"Bool",
                          radius = predicates.isType '"Bool",
                          style = predicates.isType '"Bool",
                          width = predicates.isType '"Bool",
                        }
                        {  }
                        false
                        predicates.never
                      ],
                }
                {  }
                true
                predicates.always
              ],
          settingsPropertiesColor = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  color = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          background = predicates.isType '"Bool",
                          custom = predicates.isType '"Bool",
                          customDuotone = predicates.isType '"Bool",
                          customGradient = predicates.isType '"Bool",
                          defaultDuotone = predicates.isType '"Bool",
                          defaultGradients = predicates.isType '"Bool",
                          defaultPalette = predicates.isType '"Bool",
                          duotone = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.required
                                  [ "colors", "name", "slug" ],
                                  predicates.records.record
                                  {
                                    colors = predicates.allOf
                                        [
                                          predicates.isType '"Array",
                                          predicates.arrays.arrayOf
                                          (predicates.isType '"String")
                                        ],
                                    name = predicates.isType '"String",
                                    slug = predicates.isType '"String",
                                  }
                                  {  }
                                  false
                                  predicates.never
                                ])
                              ],
                          gradients = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.required
                                  [ "gradient", "name", "slug" ],
                                  predicates.records.record
                                  {
                                    gradient = predicates.isType '"String",
                                    name = predicates.isType '"String",
                                    slug = predicates.isType '"String",
                                  }
                                  {  }
                                  false
                                  predicates.never
                                ])
                              ],
                          link = predicates.isType '"Bool",
                          palette = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.required
                                  [ "color", "name", "slug" ],
                                  predicates.records.record
                                  {
                                    color = predicates.isType '"String",
                                    name = predicates.isType '"String",
                                    slug = predicates.isType '"String",
                                  }
                                  {  }
                                  false
                                  predicates.never
                                ])
                              ],
                          text = predicates.isType '"Bool",
                        }
                        {  }
                        false
                        predicates.never
                      ],
                }
                {  }
                true
                predicates.always
              ],
          settingsPropertiesComplete = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.settingsProperties,
                  predicates.records.record
                  {
                    appearanceTools = predicates.always,
                    background = predicates.always,
                    border = predicates.always,
                    color = predicates.always,
                    custom = predicates.always,
                    dimensions = predicates.always,
                    layout = predicates.always,
                    lightbox = predicates.always,
                    position = predicates.always,
                    shadow = predicates.always,
                    spacing = predicates.always,
                    typography = predicates.always,
                  }
                  {  }
                  false
                  predicates.never
                ]
              ],
          settingsPropertiesCustom = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  custom =
                    definitions.predicate.settingsCustomAdditionalProperties,
                }
                {  }
                true
                predicates.always
              ],
          settingsPropertiesDimensions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  dimensions = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        { minHeight = predicates.isType '"Bool", }
                        {  }
                        false
                        predicates.never
                      ],
                }
                {  }
                true
                predicates.always
              ],
          settingsPropertiesLayout = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  layout = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          allowEditing = predicates.isType '"Bool",
                          contentSize = predicates.isType '"String",
                          wideSize = predicates.isType '"String",
                        }
                        {  }
                        false
                        predicates.never
                      ],
                }
                {  }
                true
                predicates.always
              ],
          settingsPropertiesLightbox = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  lightbox = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          allowEditing = predicates.isType '"Bool",
                          enabled = predicates.isType '"Bool",
                        }
                        {  }
                        false
                        predicates.never
                      ],
                }
                {  }
                true
                predicates.always
              ],
          settingsPropertiesPosition = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  position = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        { sticky = predicates.isType '"Bool", }
                        {  }
                        false
                        predicates.never
                      ],
                }
                {  }
                true
                predicates.always
              ],
          settingsPropertiesShadow = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  shadow = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          defaultPresets = predicates.isType '"Bool",
                          presets = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.required
                                  [ "name", "shadow", "slug" ],
                                  predicates.records.record
                                  {
                                    name = predicates.isType '"String",
                                    shadow = predicates.isType '"String",
                                    slug = predicates.isType '"String",
                                  }
                                  {  }
                                  false
                                  predicates.never
                                ])
                              ],
                        }
                        {  }
                        false
                        predicates.never
                      ],
                }
                {  }
                true
                predicates.always
              ],
          settingsPropertiesSpacing = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  spacing = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          blockGap = predicates.oneOf
                              [
                                predicates.isType '"Bool",
                                predicates.isType 'Null
                              ],
                          customSpacingSize = predicates.isType '"Bool",
                          margin = predicates.isType '"Bool",
                          padding = predicates.isType '"Bool",
                          spacingScale = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  increment = predicates.isType '"Number",
                                  mediumStep = predicates.isType '"Number",
                                  operator = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum [ "+", "*" ]
                                      ],
                                  steps = predicates.isType 'Integer,
                                  unit = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.enum
                                        [
                                          "px",
                                          "em",
                                          "rem",
                                          "%",
                                          "vw",
                                          "svw",
                                          "lvw",
                                          "dvw",
                                          "vh",
                                          "svh",
                                          "lvh",
                                          "dvh",
                                          "vi",
                                          "svi",
                                          "lvi",
                                          "dvi",
                                          "vb",
                                          "svb",
                                          "lvb",
                                          "dvb",
                                          "vmin",
                                          "svmin",
                                          "lvmin",
                                          "dvmin",
                                          "vmax",
                                          "svmax",
                                          "lvmax",
                                          "dvmax"
                                        ]
                                      ],
                                }
                                {  }
                                false
                                predicates.never
                              ],
                          spacingSizes = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    name = predicates.isType '"String",
                                    size = predicates.isType '"String",
                                    slug = predicates.isType '"String",
                                  }
                                  {  }
                                  false
                                  predicates.never
                                ])
                              ],
                          units = predicates.allOf
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
                }
                {  }
                true
                predicates.always
              ],
          settingsPropertiesTypography = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  typography = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          customFontSize = predicates.isType '"Bool",
                          dropCap = predicates.isType '"Bool",
                          fluid = predicates.oneOf
                              [
                                predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    maxViewportWidth = predicates.isType
                                        '"String",
                                    minFontSize = predicates.isType '"String",
                                    minViewportWidth = predicates.isType
                                        '"String",
                                  }
                                  {  }
                                  false
                                  predicates.never
                                ],
                                predicates.isType '"Bool"
                              ],
                          fontFamilies = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    fontFace = predicates.allOf
                                        [
                                          predicates.isType '"Array",
                                          predicates.arrays.arrayOf
                                          (predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.required
                                            [ "fontFamily", "src" ],
                                            predicates.records.record
                                            {
                                              ascentOverride = predicates.isType
                                                  '"String",
                                              descentOverride =
                                                predicates.isType '"String",
                                              fontDisplay = predicates.allOf
                                                  [
                                                    predicates.isType '"String",
                                                    predicates.enum
                                                    [
                                                      "auto",
                                                      "block",
                                                      "fallback",
                                                      "swap",
                                                      "optional"
                                                    ]
                                                  ],
                                              fontFamily = predicates.isType
                                                  '"String",
                                              fontFeatureSettings =
                                                predicates.isType '"String",
                                              fontStretch = predicates.isType
                                                  '"String",
                                              fontStyle = predicates.isType
                                                  '"String",
                                              fontVariant = predicates.isType
                                                  '"String",
                                              fontVariationSettings =
                                                predicates.isType '"String",
                                              fontWeight = predicates.oneOf
                                                  [
                                                    predicates.isType '"String",
                                                    predicates.isType 'Integer
                                                  ],
                                              lineGapOverride =
                                                predicates.isType '"String",
                                              sizeAdjust = predicates.isType
                                                  '"String",
                                              src = predicates.oneOf
                                                  [
                                                    predicates.isType '"String",
                                                    predicates.allOf
                                                    [
                                                      predicates.isType
                                                      '"Array",
                                                      predicates.arrays.arrayOf
                                                      (predicates.isType
                                                      '"String")
                                                    ]
                                                  ],
                                              unicodeRange = predicates.isType
                                                  '"String",
                                            }
                                            {  }
                                            false
                                            predicates.never
                                          ])
                                        ],
                                    fontFamily = predicates.isType '"String",
                                    name = predicates.isType '"String",
                                    slug = predicates.isType '"String",
                                  }
                                  {  }
                                  false
                                  predicates.never
                                ])
                              ],
                          fontSizes = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    fluid = predicates.oneOf
                                        [
                                          predicates.allOf
                                          [
                                            predicates.isType 'Record,
                                            predicates.records.record
                                            {
                                              max = predicates.isType '"String",
                                              min = predicates.isType '"String",
                                            }
                                            {  }
                                            false
                                            predicates.never
                                          ],
                                          predicates.isType '"Bool"
                                        ],
                                    name = predicates.isType '"String",
                                    size = predicates.isType '"String",
                                    slug = predicates.isType '"String",
                                  }
                                  {  }
                                  false
                                  predicates.never
                                ])
                              ],
                          fontStyle = predicates.isType '"Bool",
                          fontWeight = predicates.isType '"Bool",
                          letterSpacing = predicates.isType '"Bool",
                          lineHeight = predicates.isType '"Bool",
                          textColumns = predicates.isType '"Bool",
                          textDecoration = predicates.isType '"Bool",
                          textTransform = predicates.isType '"Bool",
                          writingMode = predicates.isType '"Bool",
                        }
                        {  }
                        false
                        predicates.never
                      ],
                }
                {  }
                true
                predicates.always
              ],
          settingsPropertiesUseRootPaddingAwareAlignments =
            predicates.records.record
              { useRootPaddingAwareAlignments = predicates.isType '"Bool", }
              {  }
              true
              predicates.always,
          stylesBlocksPropertiesComplete = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "core/archives" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/audio" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/avatar" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/block" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/button" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/buttons" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/calendar" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/categories" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/code" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/column" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/columns" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/comment-author-avatar" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/comment-author-name" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/comment-content" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/comment-date" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/comment-edit-link" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/comment-reply-link" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/comment-template" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/comments" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/comments-pagination" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/comments-pagination-next" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/comments-pagination-numbers" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/comments-pagination-previous" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/comments-title" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/cover" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/details" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/embed" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/file" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/freeform" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/gallery" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/group" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/heading" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/home-link" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/html" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/image" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/latest-comments" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/latest-posts" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/legacy-widget" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/list" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/list-item" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/loginout" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/media-text" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/missing" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/more" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/navigation" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/navigation-link" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/navigation-submenu" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/nextpage" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/page-list" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/page-list-item" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/paragraph" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/post-author" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/post-author-biography" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/post-author-name" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/post-comment" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/post-comments-count" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/post-comments-form" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/post-comments-link" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/post-content" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/post-date" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/post-excerpt" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/post-featured-image" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/post-navigation-link" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/post-template" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/post-terms" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/post-time-to-read" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/post-title" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/preformatted" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/pullquote" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/query" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/query-no-results" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/query-pagination" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/query-pagination-next" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/query-pagination-numbers" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/query-pagination-previous" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/query-title" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/quote" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/read-more" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/rss" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/search" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/separator" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/shortcode" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/site-logo" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/site-tagline" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/site-title" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/social-link" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/social-links" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/spacer" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/table" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/table-of-contents" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/tag-cloud" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/template-part" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/term-description" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/text-columns" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/verse" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/video" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/widget-area" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                  "core/widget-group" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                }
                {
                  "^[a-z][a-z0-9-]*/[a-z][a-z0-9-]*$" =
                    definitions.predicate.stylesPropertiesAndElementsComplete,
                }
                false
                predicates.never
              ],
          stylesElementsPropertiesComplete = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  button = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.allOf
                        [
                          definitions.predicate.stylesProperties,
                          predicates.records.record
                          {
                            ":active" =
                              definitions.predicate.stylesPropertiesComplete,
                            ":any-link" =
                              definitions.predicate.stylesPropertiesComplete,
                            ":focus" =
                              definitions.predicate.stylesPropertiesComplete,
                            ":hover" =
                              definitions.predicate.stylesPropertiesComplete,
                            ":link" =
                              definitions.predicate.stylesPropertiesComplete,
                            ":visited" =
                              definitions.predicate.stylesPropertiesComplete,
                            border = predicates.always,
                            color = predicates.always,
                            css = predicates.always,
                            filter = predicates.always,
                            outline = predicates.always,
                            shadow = predicates.always,
                            spacing = predicates.always,
                            typography = predicates.always,
                          }
                          {  }
                          false
                          predicates.never
                        ]
                      ],
                  caption = definitions.predicate.stylesPropertiesComplete,
                  cite = definitions.predicate.stylesPropertiesComplete,
                  h1 = definitions.predicate.stylesPropertiesComplete,
                  h2 = definitions.predicate.stylesPropertiesComplete,
                  h3 = definitions.predicate.stylesPropertiesComplete,
                  h4 = definitions.predicate.stylesPropertiesComplete,
                  h5 = definitions.predicate.stylesPropertiesComplete,
                  h6 = definitions.predicate.stylesPropertiesComplete,
                  heading = definitions.predicate.stylesPropertiesComplete,
                  link = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.allOf
                        [
                          definitions.predicate.stylesProperties,
                          predicates.records.record
                          {
                            ":active" =
                              definitions.predicate.stylesPropertiesComplete,
                            ":any-link" =
                              definitions.predicate.stylesPropertiesComplete,
                            ":focus" =
                              definitions.predicate.stylesPropertiesComplete,
                            ":hover" =
                              definitions.predicate.stylesPropertiesComplete,
                            ":link" =
                              definitions.predicate.stylesPropertiesComplete,
                            ":visited" =
                              definitions.predicate.stylesPropertiesComplete,
                            border = predicates.always,
                            color = predicates.always,
                            spacing = predicates.always,
                            typography = predicates.always,
                          }
                          {  }
                          false
                          predicates.never
                        ]
                      ],
                }
                {  }
                false
                predicates.never
              ],
          stylesProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  border = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          bottom = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  color = predicates.oneOf
                                      [
                                        predicates.isType '"String",
                                        definitions.predicate.refComplete
                                      ],
                                  style = predicates.oneOf
                                      [
                                        predicates.isType '"String",
                                        definitions.predicate.refComplete
                                      ],
                                  width = predicates.oneOf
                                      [
                                        predicates.isType '"String",
                                        definitions.predicate.refComplete
                                      ],
                                }
                                {  }
                                false
                                predicates.never
                              ],
                          color = predicates.oneOf
                              [
                                predicates.isType '"String",
                                definitions.predicate.refComplete
                              ],
                          left = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  color = predicates.oneOf
                                      [
                                        predicates.isType '"String",
                                        definitions.predicate.refComplete
                                      ],
                                  style = predicates.oneOf
                                      [
                                        predicates.isType '"String",
                                        definitions.predicate.refComplete
                                      ],
                                  width = predicates.oneOf
                                      [
                                        predicates.isType '"String",
                                        definitions.predicate.refComplete
                                      ],
                                }
                                {  }
                                false
                                predicates.never
                              ],
                          radius = predicates.anyOf
                              [
                                predicates.isType '"String",
                                definitions.predicate.refComplete,
                                predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    bottomLeft = predicates.oneOf
                                        [
                                          predicates.isType '"String",
                                          definitions.predicate.refComplete
                                        ],
                                    bottomRight = predicates.oneOf
                                        [
                                          predicates.isType '"String",
                                          definitions.predicate.refComplete
                                        ],
                                    topLeft = predicates.oneOf
                                        [
                                          predicates.isType '"String",
                                          definitions.predicate.refComplete
                                        ],
                                    topRight = predicates.oneOf
                                        [
                                          predicates.isType '"String",
                                          definitions.predicate.refComplete
                                        ],
                                  }
                                  {  }
                                  true
                                  predicates.always
                                ]
                              ],
                          right = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  color = predicates.oneOf
                                      [
                                        predicates.isType '"String",
                                        definitions.predicate.refComplete
                                      ],
                                  style = predicates.oneOf
                                      [
                                        predicates.isType '"String",
                                        definitions.predicate.refComplete
                                      ],
                                  width = predicates.oneOf
                                      [
                                        predicates.isType '"String",
                                        definitions.predicate.refComplete
                                      ],
                                }
                                {  }
                                false
                                predicates.never
                              ],
                          style = predicates.oneOf
                              [
                                predicates.isType '"String",
                                definitions.predicate.refComplete
                              ],
                          top = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  color = predicates.oneOf
                                      [
                                        predicates.isType '"String",
                                        definitions.predicate.refComplete
                                      ],
                                  style = predicates.oneOf
                                      [
                                        predicates.isType '"String",
                                        definitions.predicate.refComplete
                                      ],
                                  width = predicates.oneOf
                                      [
                                        predicates.isType '"String",
                                        definitions.predicate.refComplete
                                      ],
                                }
                                {  }
                                false
                                predicates.never
                              ],
                          width = predicates.oneOf
                              [
                                predicates.isType '"String",
                                definitions.predicate.refComplete
                              ],
                        }
                        {  }
                        false
                        predicates.never
                      ],
                  color = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          background = predicates.oneOf
                              [
                                predicates.isType '"String",
                                definitions.predicate.refComplete
                              ],
                          gradient = predicates.oneOf
                              [
                                predicates.isType '"String",
                                definitions.predicate.refComplete
                              ],
                          text = predicates.oneOf
                              [
                                predicates.isType '"String",
                                definitions.predicate.refComplete
                              ],
                        }
                        {  }
                        false
                        predicates.never
                      ],
                  css = predicates.isType '"String",
                  dimensions = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          minHeight = predicates.oneOf
                              [
                                predicates.isType '"String",
                                definitions.predicate.refComplete
                              ],
                        }
                        {  }
                        true
                        predicates.always
                      ],
                  filter = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          duotone = predicates.oneOf
                              [
                                predicates.isType '"String",
                                definitions.predicate.refComplete
                              ],
                        }
                        {  }
                        false
                        predicates.never
                      ],
                  outline = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          color = predicates.oneOf
                              [
                                predicates.isType '"String",
                                definitions.predicate.refComplete
                              ],
                          offset = predicates.oneOf
                              [
                                predicates.isType '"String",
                                definitions.predicate.refComplete
                              ],
                          style = predicates.oneOf
                              [
                                predicates.isType '"String",
                                definitions.predicate.refComplete
                              ],
                          width = predicates.oneOf
                              [
                                predicates.isType '"String",
                                definitions.predicate.refComplete
                              ],
                        }
                        {  }
                        false
                        predicates.never
                      ],
                  shadow = predicates.oneOf
                      [
                        predicates.isType '"String",
                        definitions.predicate.refComplete
                      ],
                  spacing = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          blockGap = predicates.oneOf
                              [
                                predicates.isType '"String",
                                definitions.predicate.refComplete
                              ],
                          margin = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  bottom = predicates.oneOf
                                      [
                                        predicates.isType '"String",
                                        definitions.predicate.refComplete
                                      ],
                                  left = predicates.oneOf
                                      [
                                        predicates.isType '"String",
                                        definitions.predicate.refComplete
                                      ],
                                  right = predicates.oneOf
                                      [
                                        predicates.isType '"String",
                                        definitions.predicate.refComplete
                                      ],
                                  top = predicates.oneOf
                                      [
                                        predicates.isType '"String",
                                        definitions.predicate.refComplete
                                      ],
                                }
                                {  }
                                false
                                predicates.never
                              ],
                          padding = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  bottom = predicates.oneOf
                                      [
                                        predicates.isType '"String",
                                        definitions.predicate.refComplete
                                      ],
                                  left = predicates.oneOf
                                      [
                                        predicates.isType '"String",
                                        definitions.predicate.refComplete
                                      ],
                                  right = predicates.oneOf
                                      [
                                        predicates.isType '"String",
                                        definitions.predicate.refComplete
                                      ],
                                  top = predicates.oneOf
                                      [
                                        predicates.isType '"String",
                                        definitions.predicate.refComplete
                                      ],
                                }
                                {  }
                                false
                                predicates.never
                              ],
                        }
                        {  }
                        false
                        predicates.never
                      ],
                  typography = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          fontFamily = predicates.oneOf
                              [
                                predicates.isType '"String",
                                definitions.predicate.refComplete
                              ],
                          fontSize = predicates.oneOf
                              [
                                predicates.isType '"String",
                                definitions.predicate.refComplete
                              ],
                          fontStyle = predicates.oneOf
                              [
                                predicates.isType '"String",
                                definitions.predicate.refComplete
                              ],
                          fontWeight = predicates.oneOf
                              [
                                predicates.isType '"String",
                                definitions.predicate.refComplete
                              ],
                          letterSpacing = predicates.oneOf
                              [
                                predicates.isType '"String",
                                definitions.predicate.refComplete
                              ],
                          lineHeight = predicates.oneOf
                              [
                                predicates.isType '"String",
                                definitions.predicate.refComplete
                              ],
                          textColumns = predicates.isType '"String",
                          textDecoration = predicates.oneOf
                              [
                                predicates.isType '"String",
                                definitions.predicate.refComplete
                              ],
                          textTransform = predicates.oneOf
                              [
                                predicates.isType '"String",
                                definitions.predicate.refComplete
                              ],
                          writingMode = predicates.oneOf
                              [
                                predicates.isType '"String",
                                definitions.predicate.refComplete
                              ],
                        }
                        {  }
                        false
                        predicates.never
                      ],
                }
                {  }
                true
                predicates.always
              ],
          stylesPropertiesAndElementsComplete = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.stylesProperties,
                  predicates.records.record
                  {
                    border = predicates.always,
                    color = predicates.always,
                    css = predicates.always,
                    dimensions = predicates.always,
                    elements =
                      definitions.predicate.stylesElementsPropertiesComplete,
                    filter = predicates.always,
                    outline = predicates.always,
                    shadow = predicates.always,
                    spacing = predicates.always,
                    typography = predicates.always,
                    variations =
                      definitions.predicate.stylesVariationPropertiesComplete,
                  }
                  {  }
                  false
                  predicates.never
                ]
              ],
          stylesPropertiesComplete = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.allOf
                [
                  definitions.predicate.stylesProperties,
                  predicates.records.record
                  {
                    border = predicates.always,
                    color = predicates.always,
                    css = predicates.always,
                    dimensions = predicates.always,
                    filter = predicates.always,
                    outline = predicates.always,
                    shadow = predicates.always,
                    spacing = predicates.always,
                    typography = predicates.always,
                  }
                  {  }
                  false
                  predicates.never
                ]
              ],
          stylesVariationPropertiesComplete = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  }
                {
                  "^[a-z][a-z0-9-]*$" =
                    definitions.predicate.stylesPropertiesComplete,
                }
                true
                predicates.always
              ],
        },
  }
in

{
  "$schema"
    | String
    | doc m%"
    JSON schema URI for theme.json.
    "%
    | optional,
  customTemplates
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf
      (predicates.allOf
      [
        predicates.isType 'Record,
        predicates.records.required [ "name", "title" ],
        predicates.records.record
        {
          name = predicates.isType '"String",
          postTypes = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf (predicates.isType '"String")
              ],
          title = predicates.isType '"String",
        }
        {  }
        false
        predicates.never
      ])
    ])
    | doc m%"
    Additional metadata for custom templates defined in the templates folder.
    "%
    | optional,
  description
    | String
    | doc m%"
    Description of the global styles variation.
    "%
    | optional,
  patterns
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    An array of pattern slugs to be registered from the Pattern Directory.
    "%
    | optional,
  settings
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType 'Record,
      predicates.allOf
      [
        definitions.predicate.settingsProperties,
        predicates.records.record
        {
          appearanceTools = predicates.always,
          background = predicates.always,
          blocks = definitions.predicate.settingsBlocksPropertiesComplete,
          border = predicates.always,
          color = predicates.always,
          custom = predicates.always,
          dimensions = predicates.always,
          layout = predicates.always,
          lightbox = predicates.always,
          position = predicates.always,
          shadow = predicates.always,
          spacing = predicates.always,
          typography = predicates.always,
          useRootPaddingAwareAlignments =
            definitions.predicate."settingsPropertiesUseRootPaddingAwareAlignments/properties/useRootPaddingAwareAlignments",
        }
        {  }
        false
        predicates.never
      ]
    ])
    | doc m%"
    Settings for the block editor and individual blocks. These include things like:
    - Which customization options should be available to the user. 
    - The default colors, font sizes... available to the user. 
    - CSS custom properties and class names used in styles.
    - And the default layout of the editor (widths and available alignments).
    "%
    | optional,
  styles
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType 'Record,
      predicates.allOf
      [
        definitions.predicate.stylesProperties,
        predicates.records.record
        {
          blocks = definitions.predicate.stylesBlocksPropertiesComplete,
          border = predicates.always,
          color = predicates.always,
          css = predicates.always,
          elements = definitions.predicate.stylesElementsPropertiesComplete,
          filter = predicates.always,
          outline = predicates.always,
          shadow = predicates.always,
          spacing = predicates.always,
          typography = predicates.always,
        }
        {  }
        false
        predicates.never
      ]
    ])
    | doc m%"
    Organized way to set CSS properties. Styles in the top-level will be added in the `body` selector.
    "%
    | optional,
  templateParts
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
          area = predicates.isType '"String",
          name = predicates.isType '"String",
          title = predicates.isType '"String",
        }
        {  }
        false
        predicates.never
      ])
    ])
    | doc m%"
    Additional metadata for template parts defined in the parts folder.
    "%
    | optional,
  title
    | String
    | doc m%"
    Title of the global styles variation. If not defined, the file name will be used.
    "%
    | optional,
  version
    | predicates.contract_from_predicate
    (predicates.allOf [ predicates.isType 'Integer, predicates.enum [ 2 ] ])
    | doc m%"
    Version of theme.json to use.
    "%,
}