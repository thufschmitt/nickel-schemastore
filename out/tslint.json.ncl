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
          rule = predicates.contract_from_predicate definitions.predicate.rule,
          rules = predicates.contract_from_predicate
              definitions.predicate.rules,
          tsRules = predicates.contract_from_predicate
              definitions.predicate.tsRules,
        },
    predicate = {
          rule = predicates.allOf
              [
                predicates.anyOf
                [
                  predicates.isType '"Bool",
                  predicates.isType 'Record,
                  predicates.isType '"Array"
                ],
                predicates.arrays.minItems 1,
                predicates.records.record
                {
                  severity = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [ "default", "error", "warning", "warn", "off", "none" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          rules = predicates.records.record
              {
                align = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems
                        definitions.predicate."rules/properties/align/definitions/options/items"
                        1,
                        predicates.arrays.maxItems 6,
                        predicates.arrays.uniqueItems,
                        predicates.records.record
                        {
                          options = predicates.oneOf
                              [
                                definitions.predicate."rules/properties/align/definitions/options",
                                definitions.predicate."rules/properties/align/definitions/options/items"
                              ],
                          severity = predicates.always,
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                arrow-parens = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems
                        definitions.predicate."rules/properties/arrow-parens/definitions/options/items"
                        1,
                        predicates.arrays.maxItems 2,
                        predicates.records.record
                        {
                          options = predicates.oneOf
                              [
                                definitions.predicate."rules/properties/arrow-parens/definitions/options",
                                definitions.predicate."rules/properties/arrow-parens/definitions/options/items"
                              ],
                          severity = predicates.always,
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                arrow-return-shorthand = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems
                        definitions.predicate."rules/properties/arrow-return-shorthand/definitions/options/items"
                        1,
                        predicates.arrays.maxItems 2,
                        predicates.records.record
                        {
                          options = predicates.oneOf
                              [
                                definitions.predicate."rules/properties/arrow-return-shorthand/definitions/options",
                                definitions.predicate."rules/properties/arrow-return-shorthand/definitions/options/items"
                              ],
                          severity = predicates.always,
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                ban = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems
                        definitions.predicate."rules/properties/ban/definitions/options/items"
                        1,
                        predicates.arrays.uniqueItems,
                        predicates.records.record
                        {
                          options = predicates.oneOf
                              [
                                definitions.predicate."rules/properties/ban/definitions/options",
                                definitions.predicate."rules/properties/ban/definitions/options/items"
                              ],
                          severity = predicates.always,
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                ban-comma-operator = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record
                        { severity = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                binary-expression-operand-order = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record
                        { severity = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                class-name = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record
                        { severity = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                comment-format = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems
                        definitions.predicate."rules/properties/comment-format/definitions/options/items"
                        1,
                        predicates.arrays.maxItems 5,
                        predicates.arrays.uniqueItems,
                        predicates.records.record
                        {
                          options = predicates.oneOf
                              [
                                definitions.predicate."rules/properties/comment-format/definitions/options",
                                definitions.predicate."rules/properties/comment-format/definitions/options/items"
                              ],
                          severity = predicates.always,
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                completed-docs = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems
                        definitions.predicate."rules/properties/completed-docs/definitions/options/items"
                        1,
                        predicates.arrays.maxItems 11,
                        predicates.arrays.uniqueItems,
                        predicates.records.record
                        {
                          options = predicates.oneOf
                              [
                                definitions.predicate."rules/properties/completed-docs/definitions/options",
                                definitions.predicate."rules/properties/completed-docs/definitions/options/items"
                              ],
                          severity = predicates.always,
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                curly = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems
                        definitions.predicate."rules/properties/curly/definitions/options/items"
                        1,
                        predicates.records.record
                        {
                          options = predicates.oneOf
                              [
                                definitions.predicate."rules/properties/curly/definitions/options",
                                definitions.predicate."rules/properties/curly/definitions/options/items"
                              ],
                          severity = predicates.always,
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                cyclomatic-complexity = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems
                        definitions.predicate."rules/properties/cyclomatic-complexity/definitions/options/items"
                        1,
                        predicates.arrays.maxItems 2,
                        predicates.records.record
                        {
                          options = predicates.oneOf
                              [
                                definitions.predicate."rules/properties/cyclomatic-complexity/definitions/options",
                                definitions.predicate."rules/properties/cyclomatic-complexity/definitions/options/items"
                              ],
                          severity = predicates.always,
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                deprecation = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record
                        { severity = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                encoding = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record
                        { severity = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                eofline = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record
                        { severity = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                file-header = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems
                        definitions.predicate."rules/properties/file-header/definitions/options/items"
                        1,
                        predicates.arrays.maxItems 3,
                        predicates.records.record
                        {
                          options = predicates.oneOf
                              [
                                definitions.predicate."rules/properties/file-header/definitions/options",
                                definitions.predicate."rules/properties/file-header/definitions/options/items"
                              ],
                          severity = predicates.always,
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                file-name-casing = predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.items
                      [
                        predicates.isType '"Bool",
                        predicates.oneOf
                        [
                          definitions.predicate."rules/properties/file-name-casing/definitions/file-name-cases",
                          predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.minProperties 1,
                            predicates.records.record {  } {  } true
                            definitions.predicate."rules/properties/file-name-casing/definitions/file-name-cases"
                          ]
                        ]
                      ],
                      predicates.arrays.minItems 2
                    ],
                forin = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record
                        { severity = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                import-blacklist = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems
                        definitions.predicate."rules/properties/import-blacklist/definitions/options/items"
                        1,
                        predicates.arrays.uniqueItems,
                        predicates.records.record
                        {
                          options = predicates.oneOf
                              [
                                definitions.predicate."rules/properties/import-blacklist/definitions/options",
                                definitions.predicate."rules/properties/import-blacklist/definitions/options/items"
                              ],
                          severity = predicates.always,
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                import-spacing = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record
                        { severity = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                indent = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items
                        [
                          predicates.isType '"Bool",
                          definitions.predicate."rules/properties/indent/definitions/options/items/0",
                          definitions.predicate."rules/properties/indent/definitions/options/items/1"
                        ],
                        predicates.arrays.maxItems 3,
                        predicates.records.record
                        {
                          options = predicates.oneOf
                              [
                                definitions.predicate."rules/properties/indent/definitions/options",
                                definitions.predicate."rules/properties/indent/definitions/options/items/0"
                              ],
                          severity = predicates.always,
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                jsdoc-format = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems
                        definitions.predicate."rules/properties/jsdoc-format/definitions/options/items"
                        1,
                        predicates.records.record
                        {
                          options = predicates.oneOf
                              [
                                definitions.predicate."rules/properties/jsdoc-format/definitions/options",
                                definitions.predicate."rules/properties/jsdoc-format/definitions/options/items"
                              ],
                          severity = predicates.always,
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                label-position = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record
                        { severity = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                linebreak-style = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems
                        definitions.predicate."rules/properties/linebreak-style/definitions/options/items"
                        1,
                        predicates.arrays.maxItems 2,
                        predicates.records.record
                        {
                          options = predicates.oneOf
                              [
                                definitions.predicate."rules/properties/linebreak-style/definitions/options",
                                definitions.predicate."rules/properties/linebreak-style/definitions/options/items"
                              ],
                          severity = predicates.always,
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                max-classes-per-file = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items
                        [
                          predicates.isType '"Bool",
                          definitions.predicate."rules/properties/max-classes-per-file/definitions/options/items/0",
                          definitions.predicate."rules/properties/max-classes-per-file/definitions/options/items/1"
                        ],
                        predicates.arrays.additionalItems predicates.never 3,
                        predicates.arrays.maxItems 3,
                        predicates.arrays.minItems 2,
                        predicates.records.record
                        {
                          options = predicates.oneOf
                              [
                                definitions.predicate."rules/properties/max-classes-per-file/definitions/options",
                                definitions.predicate."rules/properties/max-classes-per-file/definitions/options/items/0"
                              ],
                          severity = predicates.always,
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                max-file-line-count = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems
                        definitions.predicate."rules/properties/max-file-line-count/definitions/options/items"
                        1,
                        predicates.arrays.maxItems 2,
                        predicates.records.record
                        {
                          options = predicates.oneOf
                              [
                                definitions.predicate."rules/properties/max-file-line-count/definitions/options",
                                definitions.predicate."rules/properties/max-file-line-count/definitions/options/items"
                              ],
                          severity = predicates.always,
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                max-line-length = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems
                        definitions.predicate."rules/properties/max-line-length/definitions/options/items"
                        1,
                        predicates.arrays.maxItems 2,
                        predicates.records.record
                        {
                          options = predicates.oneOf
                              [
                                definitions.predicate."rules/properties/max-line-length/definitions/options",
                                definitions.predicate."rules/properties/max-line-length/definitions/options/items"
                              ],
                          severity = predicates.always,
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                member-ordering = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems
                        definitions.predicate."rules/properties/member-ordering/definitions/options/items"
                        1,
                        predicates.arrays.maxItems 2,
                        predicates.records.record
                        {
                          options = predicates.oneOf
                              [
                                definitions.predicate."rules/properties/member-ordering/definitions/options",
                                definitions.predicate."rules/properties/member-ordering/definitions/options/items"
                              ],
                          severity = predicates.always,
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                new-parens = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record
                        { severity = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                newline-before-return = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record
                        { severity = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                newline-per-chained-call = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record
                        { severity = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                no-arg = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record
                        { severity = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                no-async-without-await = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record {  } {  } false
                        predicates.never
                      ]
                    ],
                no-bitwise = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record
                        { severity = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                no-conditional-assignment = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record
                        { severity = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                no-consecutive-blank-lines = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems
                        definitions.predicate."rules/properties/no-consecutive-blank-lines/definitions/options/items"
                        1,
                        predicates.arrays.maxItems 2,
                        predicates.records.record
                        {
                          options = predicates.oneOf
                              [
                                definitions.predicate."rules/properties/no-consecutive-blank-lines/definitions/options",
                                definitions.predicate."rules/properties/no-consecutive-blank-lines/definitions/options/items"
                              ],
                          severity = predicates.always,
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                no-console = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems
                        definitions.predicate."rules/properties/no-console/definitions/options/items"
                        1,
                        predicates.arrays.uniqueItems,
                        predicates.records.record
                        {
                          options = predicates.oneOf
                              [
                                definitions.predicate."rules/properties/no-console/definitions/options",
                                definitions.predicate."rules/properties/no-console/definitions/options/items"
                              ],
                          severity = predicates.always,
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                no-construct = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record
                        { severity = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                no-debugger = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record
                        { severity = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                no-default-export = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record
                        { severity = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                no-duplicate-imports = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items
                        [
                          predicates.isType '"Bool",
                          definitions.predicate."rules/properties/no-duplicate-imports/definitions/options"
                        ],
                        predicates.arrays.maxItems 2,
                        predicates.records.record
                        {
                          options = predicates.oneOf
                              [
                                definitions.predicate."rules/properties/no-duplicate-imports/definitions/options"
                              ],
                          severity = predicates.always,
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                no-duplicate-super = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record
                        { severity = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                no-duplicate-switch-case = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record
                        { severity = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                no-duplicate-variable = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems
                        definitions.predicate."rules/properties/no-duplicate-variable/definitions/options/items"
                        1,
                        predicates.arrays.maxItems 2,
                        predicates.records.record
                        {
                          options = predicates.oneOf
                              [
                                definitions.predicate."rules/properties/no-duplicate-variable/definitions/options",
                                definitions.predicate."rules/properties/no-duplicate-variable/definitions/options/items"
                              ],
                          severity = predicates.always,
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                no-dynamic-delete = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record
                        { severity = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                no-empty = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems
                        definitions.predicate."rules/properties/no-empty/definitions/options/items"
                        1,
                        predicates.arrays.maxItems 3,
                        predicates.arrays.uniqueItems,
                        predicates.records.record
                        {
                          options = predicates.oneOf
                              [
                                definitions.predicate."rules/properties/no-empty/definitions/options",
                                definitions.predicate."rules/properties/no-empty/definitions/options/items"
                              ],
                          severity = predicates.always,
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                no-eval = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record
                        { severity = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                no-for-in = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record {  } {  } false
                        predicates.never
                      ]
                    ],
                no-for-in-array = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record
                        { severity = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                no-implicit-dependencies = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems
                        (predicates.allOf
                        [
                          definitions.predicate."rules/properties/no-implicit-dependencies/definitions/options/items/0",
                          definitions.predicate."rules/properties/no-implicit-dependencies/definitions/options/items/1"
                        ])
                        1,
                        predicates.arrays.maxItems 3,
                        predicates.records.record
                        {
                          options = predicates.oneOf
                              [
                                definitions.predicate."rules/properties/no-implicit-dependencies/definitions/options",
                                definitions.predicate."rules/properties/no-implicit-dependencies/definitions/options/items/0",
                                definitions.predicate."rules/properties/no-implicit-dependencies/definitions/options/items/1"
                              ],
                          severity = predicates.always,
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                no-import-side-effect = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems
                        definitions.predicate."rules/properties/no-import-side-effect/definitions/options/items"
                        1,
                        predicates.arrays.maxItems 2,
                        predicates.records.record
                        {
                          options = predicates.oneOf
                              [
                                definitions.predicate."rules/properties/no-import-side-effect/definitions/options",
                                definitions.predicate."rules/properties/no-import-side-effect/definitions/options/items"
                              ],
                          severity = predicates.always,
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                no-invalid-template-strings = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record
                        { severity = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                no-invalid-this = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems
                        definitions.predicate."rules/properties/no-invalid-this/definitions/options/items"
                        1,
                        predicates.arrays.maxItems 2,
                        predicates.records.record
                        {
                          options = predicates.oneOf
                              [
                                definitions.predicate."rules/properties/no-invalid-this/definitions/options",
                                definitions.predicate."rules/properties/no-invalid-this/definitions/options/items"
                              ],
                          severity = predicates.always,
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                no-irregular-whitespace = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record
                        { severity = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                no-magic-numbers = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems
                        definitions.predicate."rules/properties/no-magic-numbers/definitions/options/items"
                        1,
                        predicates.arrays.uniqueItems,
                        predicates.records.record
                        {
                          options = predicates.oneOf
                              [
                                definitions.predicate."rules/properties/no-magic-numbers/definitions/options",
                                definitions.predicate."rules/properties/no-magic-numbers/definitions/options/items"
                              ],
                          severity = predicates.always,
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                no-null-keyword = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record
                        { severity = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                no-null-undefined-union = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record {  } {  } false
                        predicates.never
                      ]
                    ],
                no-parameter-reassignment = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record
                        { severity = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                no-reference = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record
                        { severity = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                no-require-imports = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record
                        { severity = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                no-return-await = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record
                        { severity = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                no-shadowed-variable = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems
                        definitions.predicate."rules/properties/no-shadowed-variable/definitions/options/items"
                        1,
                        predicates.arrays.maxItems 2,
                        predicates.records.record
                        {
                          options = predicates.oneOf
                              [
                                definitions.predicate."rules/properties/no-shadowed-variable/definitions/options",
                                definitions.predicate."rules/properties/no-shadowed-variable/definitions/options/items"
                              ],
                          severity = predicates.always,
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                no-sparse-arrays = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record
                        { severity = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                no-string-literal = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record
                        { severity = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                no-string-throw = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record
                        { severity = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                no-submodule-imports = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems
                        definitions.predicate."rules/properties/no-submodule-imports/definitions/options/items"
                        1,
                        predicates.arrays.uniqueItems,
                        predicates.records.record
                        {
                          options = predicates.oneOf
                              [
                                definitions.predicate."rules/properties/no-submodule-imports/definitions/options",
                                definitions.predicate."rules/properties/no-submodule-imports/definitions/options/items"
                              ],
                          severity = predicates.always,
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                no-switch-case-fall-through = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record
                        { severity = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                no-this-assignment = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems
                        definitions.predicate."rules/properties/no-this-assignment/definitions/options/items"
                        1,
                        predicates.arrays.maxItems 2,
                        predicates.records.record
                        {
                          options = predicates.oneOf
                              [
                                definitions.predicate."rules/properties/no-this-assignment/definitions/options",
                                definitions.predicate."rules/properties/no-this-assignment/definitions/options/items"
                              ],
                          severity = predicates.always,
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                no-trailing-whitespace = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems
                        definitions.predicate."rules/properties/no-trailing-whitespace/definitions/options/items"
                        1,
                        predicates.arrays.maxItems 5,
                        predicates.arrays.uniqueItems,
                        predicates.records.record
                        {
                          options = predicates.oneOf
                              [
                                definitions.predicate."rules/properties/no-trailing-whitespace/definitions/options",
                                definitions.predicate."rules/properties/no-trailing-whitespace/definitions/options/items"
                              ],
                          severity = predicates.always,
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                no-unnecessary-callback-wrapper = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record
                        { severity = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                no-unnecessary-class = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems
                        definitions.predicate."rules/properties/no-unnecessary-class/definitions/options/items"
                        1,
                        predicates.arrays.maxItems 4,
                        predicates.records.record
                        {
                          options = predicates.oneOf
                              [
                                definitions.predicate."rules/properties/no-unnecessary-class/definitions/options",
                                definitions.predicate."rules/properties/no-unnecessary-class/definitions/options/items"
                              ],
                          severity = predicates.always,
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                no-unnecessary-initializer = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record
                        { severity = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                no-unsafe-finally = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record
                        { severity = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                no-unused-expression = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems
                        definitions.predicate."rules/properties/no-unused-expression/definitions/options/items"
                        1,
                        predicates.arrays.maxItems 4,
                        predicates.arrays.uniqueItems,
                        predicates.records.record
                        {
                          options = predicates.oneOf
                              [
                                definitions.predicate."rules/properties/no-unused-expression/definitions/options",
                                definitions.predicate."rules/properties/no-unused-expression/definitions/options/items"
                              ],
                          severity = predicates.always,
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                no-use-before-declare = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record
                        { severity = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                no-var-keyword = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record
                        { severity = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                no-void-expression = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems
                        definitions.predicate."rules/properties/no-void-expression/definitions/options/items"
                        1,
                        predicates.arrays.maxItems 2,
                        predicates.records.record
                        {
                          options = predicates.oneOf
                              [
                                definitions.predicate."rules/properties/no-void-expression/definitions/options",
                                definitions.predicate."rules/properties/no-void-expression/definitions/options/items"
                              ],
                          severity = predicates.always,
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                number-literal-format = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record
                        { severity = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                object-literal-key-quotes = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems
                        definitions.predicate."rules/properties/object-literal-key-quotes/definitions/options/items"
                        1,
                        predicates.arrays.maxItems 2,
                        predicates.records.record
                        {
                          options = predicates.oneOf
                              [
                                definitions.predicate."rules/properties/object-literal-key-quotes/definitions/options",
                                definitions.predicate."rules/properties/object-literal-key-quotes/definitions/options/items"
                              ],
                          severity = predicates.always,
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                object-literal-shorthand = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems
                        definitions.predicate."rules/properties/object-literal-shorthand/definitions/options/items"
                        1,
                        predicates.records.record
                        {
                          options = predicates.oneOf
                              [
                                definitions.predicate."rules/properties/object-literal-shorthand/definitions/options",
                                definitions.predicate."rules/properties/object-literal-shorthand/definitions/options/items"
                              ],
                          severity = predicates.always,
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                object-literal-sort-keys = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems
                        definitions.predicate."rules/properties/object-literal-sort-keys/definitions/options/items"
                        1,
                        predicates.arrays.maxItems 5,
                        predicates.arrays.uniqueItems,
                        predicates.records.record
                        {
                          options = predicates.oneOf
                              [
                                definitions.predicate."rules/properties/object-literal-sort-keys/definitions/options",
                                definitions.predicate."rules/properties/object-literal-sort-keys/definitions/options/items"
                              ],
                          severity = predicates.always,
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                one-line = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems
                        definitions.predicate."rules/properties/one-line/definitions/options/items"
                        1,
                        predicates.arrays.maxItems 6,
                        predicates.arrays.uniqueItems,
                        predicates.records.record
                        {
                          options = predicates.oneOf
                              [
                                definitions.predicate."rules/properties/one-line/definitions/options",
                                definitions.predicate."rules/properties/one-line/definitions/options/items"
                              ],
                          severity = predicates.always,
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                one-variable-per-declaration = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems
                        definitions.predicate."rules/properties/one-variable-per-declaration/definitions/options/items"
                        1,
                        predicates.arrays.maxItems 2,
                        predicates.records.record
                        {
                          options = predicates.oneOf
                              [
                                definitions.predicate."rules/properties/one-variable-per-declaration/definitions/options",
                                definitions.predicate."rules/properties/one-variable-per-declaration/definitions/options/items"
                              ],
                          severity = predicates.always,
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                only-arrow-functions = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems
                        definitions.predicate."rules/properties/only-arrow-functions/definitions/options/items"
                        1,
                        predicates.arrays.maxItems 3,
                        predicates.arrays.uniqueItems,
                        predicates.records.record
                        {
                          options = predicates.oneOf
                              [
                                definitions.predicate."rules/properties/only-arrow-functions/definitions/options",
                                definitions.predicate."rules/properties/only-arrow-functions/definitions/options/items"
                              ],
                          severity = predicates.always,
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                ordered-imports = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems
                        definitions.predicate."rules/properties/ordered-imports/definitions/options/items"
                        1,
                        predicates.arrays.maxItems 2,
                        predicates.records.record
                        {
                          options = predicates.oneOf
                              [
                                definitions.predicate."rules/properties/ordered-imports/definitions/options",
                                definitions.predicate."rules/properties/ordered-imports/definitions/options/items"
                              ],
                          severity = predicates.always,
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                prefer-conditional-expression = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems
                        definitions.predicate."rules/properties/prefer-conditional-expression/definitions/options/items"
                        1,
                        predicates.arrays.maxItems 2,
                        predicates.records.record
                        {
                          options = predicates.oneOf
                              [
                                definitions.predicate."rules/properties/prefer-conditional-expression/definitions/options",
                                definitions.predicate."rules/properties/prefer-conditional-expression/definitions/options/items"
                              ],
                          severity = predicates.always,
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                prefer-const = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems
                        definitions.predicate."rules/properties/prefer-const/definitions/options/items"
                        1,
                        predicates.arrays.maxItems 2,
                        predicates.records.record
                        {
                          options = predicates.oneOf
                              [
                                definitions.predicate."rules/properties/prefer-const/definitions/options",
                                definitions.predicate."rules/properties/prefer-const/definitions/options/items"
                              ],
                          severity = predicates.always,
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                prefer-for-of = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record
                        { severity = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                prefer-function-over-method = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems
                        definitions.predicate."rules/properties/prefer-function-over-method/definitions/options/items"
                        1,
                        predicates.arrays.maxItems 3,
                        predicates.arrays.uniqueItems,
                        predicates.records.record
                        {
                          options = predicates.oneOf
                              [
                                definitions.predicate."rules/properties/prefer-function-over-method/definitions/options",
                                definitions.predicate."rules/properties/prefer-function-over-method/definitions/options/items"
                              ],
                          severity = predicates.always,
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                prefer-method-signature = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record
                        { severity = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                prefer-object-spread = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record
                        { severity = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                prefer-switch = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems
                        definitions.predicate."rules/properties/prefer-switch/definitions/options/items"
                        1,
                        predicates.arrays.maxItems 2,
                        predicates.records.record
                        {
                          options = predicates.oneOf
                              [
                                definitions.predicate."rules/properties/prefer-switch/definitions/options",
                                definitions.predicate."rules/properties/prefer-switch/definitions/options/items"
                              ],
                          severity = predicates.always,
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                prefer-template = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems
                        definitions.predicate."rules/properties/prefer-template/definitions/options/items"
                        1,
                        predicates.arrays.maxItems 2,
                        predicates.records.record
                        {
                          options = predicates.oneOf
                              [
                                definitions.predicate."rules/properties/prefer-template/definitions/options",
                                definitions.predicate."rules/properties/prefer-template/definitions/options/items"
                              ],
                          severity = predicates.always,
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                prefer-while = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record {  } {  } false
                        predicates.never
                      ]
                    ],
                promise-function-async = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record
                        { severity = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                quotemark = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems
                        definitions.predicate."rules/properties/quotemark/definitions/options/items"
                        1,
                        predicates.arrays.maxItems 5,
                        predicates.arrays.uniqueItems,
                        predicates.records.record
                        {
                          options = predicates.oneOf
                              [
                                definitions.predicate."rules/properties/quotemark/definitions/options",
                                definitions.predicate."rules/properties/quotemark/definitions/options/items"
                              ],
                          severity = predicates.always,
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                radix = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record
                        { severity = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                restrict-plus-operands = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record
                        { severity = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                return-undefined = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record
                        { severity = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                semicolon = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items
                        [
                          predicates.isType '"Bool",
                          definitions.predicate."rules/properties/semicolon/definitions/options/items/0",
                          definitions.predicate."rules/properties/semicolon/definitions/options/items/1"
                        ],
                        predicates.arrays.maxItems 3,
                        predicates.records.record
                        {
                          options = predicates.oneOf
                              [
                                definitions.predicate."rules/properties/semicolon/definitions/options",
                                definitions.predicate."rules/properties/semicolon/definitions/options/items/0"
                              ],
                          severity = predicates.always,
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                space-before-function-paren = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems
                        definitions.predicate."rules/properties/space-before-function-paren/definitions/options/items"
                        1,
                        predicates.arrays.maxItems 2,
                        predicates.records.record
                        {
                          options = predicates.oneOf
                              [
                                definitions.predicate."rules/properties/space-before-function-paren/definitions/options",
                                definitions.predicate."rules/properties/space-before-function-paren/definitions/options/items"
                              ],
                          severity = predicates.always,
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                space-within-parens = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems
                        definitions.predicate."rules/properties/space-within-parens/definitions/options/items"
                        1,
                        predicates.arrays.maxItems 2,
                        predicates.records.record
                        {
                          options = predicates.oneOf
                              [
                                definitions.predicate."rules/properties/space-within-parens/definitions/options",
                                definitions.predicate."rules/properties/space-within-parens/definitions/options/items"
                              ],
                          severity = predicates.always,
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                switch-default = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record
                        { severity = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                switch-final-break = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems
                        definitions.predicate."rules/properties/switch-final-break/definitions/options/items"
                        1,
                        predicates.arrays.maxItems 2,
                        predicates.records.record
                        {
                          options = predicates.oneOf
                              [
                                definitions.predicate."rules/properties/switch-final-break/definitions/options",
                                definitions.predicate."rules/properties/switch-final-break/definitions/options/items"
                              ],
                          severity = predicates.always,
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                trailing-comma = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems
                        definitions.predicate."rules/properties/trailing-comma/definitions/options/items"
                        1,
                        predicates.arrays.maxItems 2,
                        predicates.records.record
                        {
                          options = predicates.oneOf
                              [
                                definitions.predicate."rules/properties/trailing-comma/definitions/options",
                                definitions.predicate."rules/properties/trailing-comma/definitions/options/items"
                              ],
                          severity = predicates.always,
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                triple-equals = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems
                        definitions.predicate."rules/properties/triple-equals/definitions/options/items"
                        1,
                        predicates.arrays.maxItems 3,
                        predicates.arrays.uniqueItems,
                        predicates.records.record
                        {
                          options = predicates.oneOf
                              [
                                definitions.predicate."rules/properties/triple-equals/definitions/options",
                                definitions.predicate."rules/properties/triple-equals/definitions/options/items"
                              ],
                          severity = predicates.always,
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                typeof-compare = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record
                        { severity = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                use-isnan = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record
                        { severity = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                variable-name = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems
                        definitions.predicate."rules/properties/variable-name/definitions/options/items"
                        1,
                        predicates.arrays.maxItems 7,
                        predicates.arrays.uniqueItems,
                        predicates.records.record
                        {
                          options = predicates.oneOf
                              [
                                definitions.predicate."rules/properties/variable-name/definitions/options",
                                definitions.predicate."rules/properties/variable-name/definitions/options/items"
                              ],
                          severity = predicates.always,
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                whitespace = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems
                        definitions.predicate."rules/properties/whitespace/definitions/options/items"
                        1,
                        predicates.records.record
                        {
                          options = predicates.oneOf
                              [
                                definitions.predicate."rules/properties/whitespace/definitions/options",
                                definitions.predicate."rules/properties/whitespace/definitions/options/items"
                              ],
                          severity = predicates.always,
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
              }
              {  }
              true
              predicates.always,
          tsRules = predicates.records.record
              {
                adjacent-overload-signatures = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record
                        { severity = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                array-type = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems
                        definitions.predicate."tsRules/properties/array-type/definitions/options/items"
                        1,
                        predicates.arrays.maxItems 2,
                        predicates.records.record
                        {
                          options = predicates.oneOf
                              [
                                definitions.predicate."tsRules/properties/array-type/definitions/options",
                                definitions.predicate."tsRules/properties/array-type/definitions/options/items"
                              ],
                          severity = predicates.always,
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                await-promise = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems
                        definitions.predicate."tsRules/properties/await-promise/definitions/options/items"
                        1,
                        predicates.arrays.uniqueItems,
                        predicates.records.record
                        {
                          options = predicates.oneOf
                              [
                                definitions.predicate."tsRules/properties/await-promise/definitions/options",
                                definitions.predicate."tsRules/properties/await-promise/definitions/options/items"
                              ],
                          severity = predicates.always,
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                ban-ts-ignore = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record {  } {  } false
                        predicates.never
                      ]
                    ],
                ban-types = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems
                        definitions.predicate."tsRules/properties/ban-types/definitions/options/items"
                        1,
                        predicates.arrays.uniqueItems,
                        predicates.records.record
                        {
                          options = predicates.oneOf
                              [
                                definitions.predicate."tsRules/properties/ban-types/definitions/options",
                                definitions.predicate."tsRules/properties/ban-types/definitions/options/items"
                              ],
                          severity = predicates.always,
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                callable-types = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record
                        { severity = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                function-constructor = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record {  } {  } false
                        predicates.never
                      ]
                    ],
                interface-name = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems
                        definitions.predicate."tsRules/properties/interface-name/definitions/options/items"
                        1,
                        predicates.arrays.maxItems 2,
                        predicates.records.record
                        {
                          options = predicates.oneOf
                              [
                                definitions.predicate."tsRules/properties/interface-name/definitions/options",
                                definitions.predicate."tsRules/properties/interface-name/definitions/options/items"
                              ],
                          severity = predicates.always,
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                interface-over-type-literal = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record
                        { severity = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                match-default-export-name = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record
                        { severity = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                member-access = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems
                        definitions.predicate."tsRules/properties/member-access/definitions/options/items"
                        1,
                        predicates.arrays.maxItems 4,
                        predicates.arrays.uniqueItems,
                        predicates.records.record
                        {
                          options = predicates.oneOf
                              [
                                definitions.predicate."tsRules/properties/member-access/definitions/options",
                                definitions.predicate."tsRules/properties/member-access/definitions/options/items"
                              ],
                          severity = predicates.always,
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                no-angle-bracket-type-assertion = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record
                        { severity = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                no-any = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items
                        [
                          predicates.isType '"Bool",
                          predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.record
                            { ignore-rest-args = predicates.isType '"Bool", }
                            {  }
                            true
                            predicates.always
                          ]
                        ],
                        predicates.arrays.additionalItems predicates.never 2,
                        predicates.records.record
                        { severity = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                no-boolean-literal-compare = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record
                        { severity = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                no-empty-interface = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record
                        { severity = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                no-floating-promises = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems
                        definitions.predicate."tsRules/properties/no-floating-promises/definitions/options/items"
                        1,
                        predicates.arrays.uniqueItems,
                        predicates.records.record
                        {
                          options = predicates.oneOf
                              [
                                definitions.predicate."tsRules/properties/no-floating-promises/definitions/options",
                                definitions.predicate."tsRules/properties/no-floating-promises/definitions/options/items"
                              ],
                          severity = predicates.always,
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                no-inferrable-types = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems
                        definitions.predicate."tsRules/properties/no-inferrable-types/definitions/options/items"
                        1,
                        predicates.arrays.maxItems 3,
                        predicates.arrays.uniqueItems,
                        predicates.records.record
                        {
                          options = predicates.oneOf
                              [
                                definitions.predicate."tsRules/properties/no-inferrable-types/definitions/options",
                                definitions.predicate."tsRules/properties/no-inferrable-types/definitions/options/items"
                              ],
                          severity = predicates.always,
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                no-inferred-empty-object-type = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record
                        { severity = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                no-internal-module = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record
                        { severity = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                no-mergeable-namespace = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record
                        { severity = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                no-misused-new = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record
                        { severity = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                no-namespace = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems
                        definitions.predicate."tsRules/properties/no-namespace/definitions/options/items"
                        1,
                        predicates.arrays.maxItems 2,
                        predicates.records.record
                        {
                          options = predicates.oneOf
                              [
                                definitions.predicate."tsRules/properties/no-namespace/definitions/options",
                                definitions.predicate."tsRules/properties/no-namespace/definitions/options/items"
                              ],
                          severity = predicates.always,
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                no-non-null-assertion = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record
                        { severity = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                no-object-literal-type-assertion = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record
                        { severity = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                no-parameter-properties = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record
                        { severity = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                no-redundant-jsdoc = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record
                        { severity = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                no-reference-import = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record
                        { severity = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                no-unbound-method = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems
                        definitions.predicate."tsRules/properties/no-unbound-method/definitions/options/items"
                        1,
                        predicates.arrays.maxItems 2,
                        predicates.records.record
                        {
                          options = predicates.oneOf
                              [
                                definitions.predicate."tsRules/properties/no-unbound-method/definitions/options",
                                definitions.predicate."tsRules/properties/no-unbound-method/definitions/options/items"
                              ],
                          severity = predicates.always,
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                no-unnecessary-qualifier = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record
                        { severity = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                no-unnecessary-type-assertion = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems
                        definitions.predicate."tsRules/properties/no-unnecessary-type-assertion/definitions/options/items"
                        1,
                        predicates.arrays.uniqueItems,
                        predicates.records.record
                        {
                          options = predicates.oneOf
                              [
                                definitions.predicate."tsRules/properties/no-unnecessary-type-assertion/definitions/options",
                                definitions.predicate."tsRules/properties/no-unnecessary-type-assertion/definitions/options/items"
                              ],
                          severity = predicates.always,
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                no-unsafe-any = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record
                        { severity = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                no-unused-variable = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems
                        definitions.predicate."tsRules/properties/no-unused-variable/definitions/options/items"
                        1,
                        predicates.arrays.maxItems 3,
                        predicates.arrays.uniqueItems,
                        predicates.records.record
                        {
                          options = predicates.oneOf
                              [
                                definitions.predicate."tsRules/properties/no-unused-variable/definitions/options",
                                definitions.predicate."tsRules/properties/no-unused-variable/definitions/options/items"
                              ],
                          severity = predicates.always,
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                no-var-requires = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record
                        { severity = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                prefer-readonly = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems
                        definitions.predicate."tsRules/properties/prefer-readonly/definitions/options/items"
                        1,
                        predicates.arrays.maxItems 2,
                        predicates.records.record
                        {
                          options = predicates.oneOf
                              [
                                definitions.predicate."tsRules/properties/prefer-readonly/definitions/options",
                                definitions.predicate."tsRules/properties/prefer-readonly/definitions/options/items"
                              ],
                          severity = predicates.always,
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                strict-boolean-expressions = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems
                        definitions.predicate."tsRules/properties/strict-boolean-expressions/definitions/options/items"
                        1,
                        predicates.arrays.maxItems 6,
                        predicates.arrays.uniqueItems,
                        predicates.records.record
                        {
                          options = predicates.oneOf
                              [
                                definitions.predicate."tsRules/properties/strict-boolean-expressions/definitions/options",
                                definitions.predicate."tsRules/properties/strict-boolean-expressions/definitions/options/items"
                              ],
                          severity = predicates.always,
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                strict-type-predicates = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record
                        { severity = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                type-literal-delimiter = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items
                        [
                          predicates.isType '"Bool",
                          predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.record
                            {
                              singleLine = predicates.allOf
                                  [
                                    predicates.isType '"String",
                                    predicates.enum [ "always", "never" ]
                                  ],
                            }
                            {  }
                            true
                            predicates.always
                          ]
                        ],
                        predicates.arrays.additionalItems predicates.never 2,
                        predicates.records.record
                        { severity = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                typedef = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems
                        definitions.predicate."tsRules/properties/typedef/definitions/options/items"
                        1,
                        predicates.arrays.maxItems 10,
                        predicates.arrays.uniqueItems,
                        predicates.records.record
                        {
                          options = predicates.oneOf
                              [
                                definitions.predicate."tsRules/properties/typedef/definitions/options",
                                definitions.predicate."tsRules/properties/typedef/definitions/options/items"
                              ],
                          severity = predicates.always,
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                typedef-whitespace = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items
                        [
                          predicates.isType '"Bool",
                          definitions.predicate."tsRules/properties/typedef-whitespace/definitions/options/items/0",
                          definitions.predicate."tsRules/properties/typedef-whitespace/definitions/options/items/1"
                        ],
                        predicates.arrays.maxItems 3,
                        predicates.records.record
                        {
                          options = predicates.oneOf
                              [
                                definitions.predicate."tsRules/properties/typedef-whitespace/definitions/options",
                                definitions.predicate."tsRules/properties/typedef-whitespace/definitions/options/items/0"
                              ],
                          severity = predicates.always,
                        }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                unified-signatures = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record
                        { severity = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
                use-default-type-parameter = predicates.allOf
                    [
                      definitions.predicate.rule,
                      predicates.allOf
                      [
                        predicates.arrays.items [ predicates.isType '"Bool" ],
                        predicates.arrays.additionalItems predicates.never 1,
                        predicates.records.record
                        { severity = predicates.always, }
                        {  }
                        false
                        predicates.never
                      ]
                    ],
              }
              {  }
              true
              predicates.always,
        },
  }
in

{
  defaultSeverity
    | std.enum.TagOrString
    | [| 'none, 'off, 'warn, 'warning, 'error |]
    | doc m%"
    The severity level used when a rule specifies "default" as its severity level. If undefined, "error" is used.
    "%
    | optional,
  extends
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"String", predicates.isType '"Array" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    The name of a built-in configuration preset, or a path or array of paths to other configuration files which are extended by this configuration. These values are handled using node module resolution semantics.
    "%
    | optional,
  jsRules
    | definitions.contract.rules
    | doc m%"
    A map of rules that will be used to lint JavaScript files. These rules apply to `.js` and `.jsx` files.
    "%
    | optional,
  linterOptions
    | {
      exclude
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf (predicates.isType '"String")
        ])
        | doc m%"
        An array of globs. Any file matching these globs will not be linted. All exclude patterns are relative to the configuration file they were specified in.
        "%
        | optional,
      ..
    }
    | doc m%"
    Additional linter options.
    "%
    | optional,
  rules
    | predicates.contract_from_predicate
    (predicates.allOf
    [ definitions.predicate.tsRules, definitions.predicate.rules ])
    | doc m%"
    A map of rules that will be used to lint TypeScript files. These rules apply to `.ts` and `.tsx` files.
    "%
    | optional,
  rulesDirectory
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType '"String", predicates.isType '"Array" ],
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    A path to a directory or an array of paths to directories of custom rules. These values are handled using node module resolution semantics, if an `index.js` is placed in your rules directory.
    "%
    | optional,
  ..
}