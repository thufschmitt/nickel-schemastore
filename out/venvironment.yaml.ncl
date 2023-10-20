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
          "00571" = predicates.contract_from_predicate
              definitions.predicate."00571",
          "00b39" = predicates.contract_from_predicate
              definitions.predicate."00b39",
          "00f15" = predicates.contract_from_predicate
              definitions.predicate."00f15",
          "015cb" = predicates.contract_from_predicate
              definitions.predicate."015cb",
          "01ff2" = predicates.contract_from_predicate
              definitions.predicate."01ff2",
          "038dc" = predicates.contract_from_predicate
              definitions.predicate."038dc",
          "03ea7" = predicates.contract_from_predicate
              definitions.predicate."03ea7",
          "048e3" = predicates.contract_from_predicate
              definitions.predicate."048e3",
          "04e4b" = predicates.contract_from_predicate
              definitions.predicate."04e4b",
          "05c88" = predicates.contract_from_predicate
              definitions.predicate."05c88",
          "077d5" = predicates.contract_from_predicate
              definitions.predicate."077d5",
          "09338" = predicates.contract_from_predicate
              definitions.predicate."09338",
          "09e40" = predicates.contract_from_predicate
              definitions.predicate."09e40",
          "0a52d" = predicates.contract_from_predicate
              definitions.predicate."0a52d",
          "0b81c" = predicates.contract_from_predicate
              definitions.predicate."0b81c",
          "0cca7" = predicates.contract_from_predicate
              definitions.predicate."0cca7",
          "0cd26" = predicates.contract_from_predicate
              definitions.predicate."0cd26",
          "0d2f3" = predicates.contract_from_predicate
              definitions.predicate."0d2f3",
          "0d894" = predicates.contract_from_predicate
              definitions.predicate."0d894",
          "0e921" = predicates.contract_from_predicate
              definitions.predicate."0e921",
          "0edfe" = predicates.contract_from_predicate
              definitions.predicate."0edfe",
          "0f9b3" = predicates.contract_from_predicate
              definitions.predicate."0f9b3",
          "0fa26" = predicates.contract_from_predicate
              definitions.predicate."0fa26",
          "0fc9e" = predicates.contract_from_predicate
              definitions.predicate."0fc9e",
          "1030e" = predicates.contract_from_predicate
              definitions.predicate."1030e",
          "13e53" = predicates.contract_from_predicate
              definitions.predicate."13e53",
          "159aa" = predicates.contract_from_predicate
              definitions.predicate."159aa",
          "16f14" = predicates.contract_from_predicate
              definitions.predicate."16f14",
          "170b6" = predicates.contract_from_predicate
              definitions.predicate."170b6",
          "172e4" = predicates.contract_from_predicate
              definitions.predicate."172e4",
          "17e6a" = predicates.contract_from_predicate
              definitions.predicate."17e6a",
          "17e74" = predicates.contract_from_predicate
              definitions.predicate."17e74",
          "183d9" = predicates.contract_from_predicate
              definitions.predicate."183d9",
          "1934a" = predicates.contract_from_predicate
              definitions.predicate."1934a",
          "20152" = predicates.contract_from_predicate
              definitions.predicate."20152",
          "21023" = predicates.contract_from_predicate
              definitions.predicate."21023",
          "21f87" = predicates.contract_from_predicate
              definitions.predicate."21f87",
          "22ddc" = predicates.contract_from_predicate
              definitions.predicate."22ddc",
          "23009" = predicates.contract_from_predicate
              definitions.predicate."23009",
          "230ce" = predicates.contract_from_predicate
              definitions.predicate."230ce",
          "23778" = predicates.contract_from_predicate
              definitions.predicate."23778",
          "252f0" = predicates.contract_from_predicate
              definitions.predicate."252f0",
          "26679" = predicates.contract_from_predicate
              definitions.predicate."26679",
          "29b8a" = predicates.contract_from_predicate
              definitions.predicate."29b8a",
          "2ae5f" = predicates.contract_from_predicate
              definitions.predicate."2ae5f",
          "2d92f" = predicates.contract_from_predicate
              definitions.predicate."2d92f",
          "2ffc1" = predicates.contract_from_predicate
              definitions.predicate."2ffc1",
          "3071b" = predicates.contract_from_predicate
              definitions.predicate."3071b",
          "316e0" = predicates.contract_from_predicate
              definitions.predicate."316e0",
          "31725" = predicates.contract_from_predicate
              definitions.predicate."31725",
          "31be0" = predicates.contract_from_predicate
              definitions.predicate."31be0",
          "3200b" = predicates.contract_from_predicate
              definitions.predicate."3200b",
          "34322" = predicates.contract_from_predicate
              definitions.predicate."34322",
          "34d39" = predicates.contract_from_predicate
              definitions.predicate."34d39",
          "375dd" = predicates.contract_from_predicate
              definitions.predicate."375dd",
          "37850" = predicates.contract_from_predicate
              definitions.predicate."37850",
          "37aed" = predicates.contract_from_predicate
              definitions.predicate."37aed",
          "37df6" = predicates.contract_from_predicate
              definitions.predicate."37df6",
          "38e8e" = predicates.contract_from_predicate
              definitions.predicate."38e8e",
          "39ed5" = predicates.contract_from_predicate
              definitions.predicate."39ed5",
          "3a966" = predicates.contract_from_predicate
              definitions.predicate."3a966",
          "3cca7" = predicates.contract_from_predicate
              definitions.predicate."3cca7",
          "3dd98" = predicates.contract_from_predicate
              definitions.predicate."3dd98",
          "3eaba" = predicates.contract_from_predicate
              definitions.predicate."3eaba",
          "3ebec" = predicates.contract_from_predicate
              definitions.predicate."3ebec",
          "405a8" = predicates.contract_from_predicate
              definitions.predicate."405a8",
          "40d65" = predicates.contract_from_predicate
              definitions.predicate."40d65",
          "42d39" = predicates.contract_from_predicate
              definitions.predicate."42d39",
          "45cf9" = predicates.contract_from_predicate
              definitions.predicate."45cf9",
          "46542" = predicates.contract_from_predicate
              definitions.predicate."46542",
          "47aa6" = predicates.contract_from_predicate
              definitions.predicate."47aa6",
          "4909e" = predicates.contract_from_predicate
              definitions.predicate."4909e",
          "497d3" = predicates.contract_from_predicate
              definitions.predicate."497d3",
          "49dc4" = predicates.contract_from_predicate
              definitions.predicate."49dc4",
          "4aae7" = predicates.contract_from_predicate
              definitions.predicate."4aae7",
          "4b905" = predicates.contract_from_predicate
              definitions.predicate."4b905",
          "4b907" = predicates.contract_from_predicate
              definitions.predicate."4b907",
          "4de3d" = predicates.contract_from_predicate
              definitions.predicate."4de3d",
          "4f5d5" = predicates.contract_from_predicate
              definitions.predicate."4f5d5",
          "4fa6d" = predicates.contract_from_predicate
              definitions.predicate."4fa6d",
          "51b90" = predicates.contract_from_predicate
              definitions.predicate."51b90",
          "5349d" = predicates.contract_from_predicate
              definitions.predicate."5349d",
          "535fe" = predicates.contract_from_predicate
              definitions.predicate."535fe",
          "55701" = predicates.contract_from_predicate
              definitions.predicate."55701",
          "568cc" = predicates.contract_from_predicate
              definitions.predicate."568cc",
          "56a0f" = predicates.contract_from_predicate
              definitions.predicate."56a0f",
          "56b2f" = predicates.contract_from_predicate
              definitions.predicate."56b2f",
          "57928" = predicates.contract_from_predicate
              definitions.predicate."57928",
          "58c94" = predicates.contract_from_predicate
              definitions.predicate."58c94",
          "5b3ba" = predicates.contract_from_predicate
              definitions.predicate."5b3ba",
          "5bc6c" = predicates.contract_from_predicate
              definitions.predicate."5bc6c",
          "5cec7" = predicates.contract_from_predicate
              definitions.predicate."5cec7",
          "5d046" = predicates.contract_from_predicate
              definitions.predicate."5d046",
          "5d2a8" = predicates.contract_from_predicate
              definitions.predicate."5d2a8",
          "5e277" = predicates.contract_from_predicate
              definitions.predicate."5e277",
          "5f17a" = predicates.contract_from_predicate
              definitions.predicate."5f17a",
          "60037" = predicates.contract_from_predicate
              definitions.predicate."60037",
          "60f6d" = predicates.contract_from_predicate
              definitions.predicate."60f6d",
          "6101e" = predicates.contract_from_predicate
              definitions.predicate."6101e",
          "619f7" = predicates.contract_from_predicate
              definitions.predicate."619f7",
          "62d94" = predicates.contract_from_predicate
              definitions.predicate."62d94",
          "63c85" = predicates.contract_from_predicate
              definitions.predicate."63c85",
          "64730" = predicates.contract_from_predicate
              definitions.predicate."64730",
          "64979" = predicates.contract_from_predicate
              definitions.predicate."64979",
          "6665e" = predicates.contract_from_predicate
              definitions.predicate."6665e",
          "66666" = predicates.contract_from_predicate
              definitions.predicate."66666",
          "67ea2" = predicates.contract_from_predicate
              definitions.predicate."67ea2",
          "6939d" = predicates.contract_from_predicate
              definitions.predicate."6939d",
          "698c3" = predicates.contract_from_predicate
              definitions.predicate."698c3",
          "69b41" = predicates.contract_from_predicate
              definitions.predicate."69b41",
          "6a522" = predicates.contract_from_predicate
              definitions.predicate."6a522",
          "6b85b" = predicates.contract_from_predicate
              definitions.predicate."6b85b",
          "6c391" = predicates.contract_from_predicate
              definitions.predicate."6c391",
          "6c62c" = predicates.contract_from_predicate
              definitions.predicate."6c62c",
          "6d6c1" = predicates.contract_from_predicate
              definitions.predicate."6d6c1",
          "6d767" = predicates.contract_from_predicate
              definitions.predicate."6d767",
          "6d907" = predicates.contract_from_predicate
              definitions.predicate."6d907",
          "6daff" = predicates.contract_from_predicate
              definitions.predicate."6daff",
          "6f0a1" = predicates.contract_from_predicate
              definitions.predicate."6f0a1",
          "70a7b" = predicates.contract_from_predicate
              definitions.predicate."70a7b",
          "716b3" = predicates.contract_from_predicate
              definitions.predicate."716b3",
          "761e4" = predicates.contract_from_predicate
              definitions.predicate."761e4",
          "779cd" = predicates.contract_from_predicate
              definitions.predicate."779cd",
          "77df9" = predicates.contract_from_predicate
              definitions.predicate."77df9",
          "79394" = predicates.contract_from_predicate
              definitions.predicate."79394",
          "796db" = predicates.contract_from_predicate
              definitions.predicate."796db",
          "799e1" = predicates.contract_from_predicate
              definitions.predicate."799e1",
          "79a89" = predicates.contract_from_predicate
              definitions.predicate."79a89",
          "79d04" = predicates.contract_from_predicate
              definitions.predicate."79d04",
          "7c80e" = predicates.contract_from_predicate
              definitions.predicate."7c80e",
          "7d7e4" = predicates.contract_from_predicate
              definitions.predicate."7d7e4",
          "7f50f" = predicates.contract_from_predicate
              definitions.predicate."7f50f",
          "7ff67" = predicates.contract_from_predicate
              definitions.predicate."7ff67",
          "81058" = predicates.contract_from_predicate
              definitions.predicate."81058",
          "815f9" = predicates.contract_from_predicate
              definitions.predicate."815f9",
          "81bab" = predicates.contract_from_predicate
              definitions.predicate."81bab",
          "828be" = predicates.contract_from_predicate
              definitions.predicate."828be",
          "843bf" = predicates.contract_from_predicate
              definitions.predicate."843bf",
          "844f0" = predicates.contract_from_predicate
              definitions.predicate."844f0",
          "8451c" = predicates.contract_from_predicate
              definitions.predicate."8451c",
          "84972" = predicates.contract_from_predicate
              definitions.predicate."84972",
          "85495" = predicates.contract_from_predicate
              definitions.predicate."85495",
          "85c8a" = predicates.contract_from_predicate
              definitions.predicate."85c8a",
          "863d7" = predicates.contract_from_predicate
              definitions.predicate."863d7",
          "86b88" = predicates.contract_from_predicate
              definitions.predicate."86b88",
          "87cf9" = predicates.contract_from_predicate
              definitions.predicate."87cf9",
          "883aa" = predicates.contract_from_predicate
              definitions.predicate."883aa",
          "896d0" = predicates.contract_from_predicate
              definitions.predicate."896d0",
          "8984d" = predicates.contract_from_predicate
              definitions.predicate."8984d",
          "8ab30" = predicates.contract_from_predicate
              definitions.predicate."8ab30",
          "8ab6a" = predicates.contract_from_predicate
              definitions.predicate."8ab6a",
          "8af01" = predicates.contract_from_predicate
              definitions.predicate."8af01",
          "8b747" = predicates.contract_from_predicate
              definitions.predicate."8b747",
          "8bf53" = predicates.contract_from_predicate
              definitions.predicate."8bf53",
          "8d374" = predicates.contract_from_predicate
              definitions.predicate."8d374",
          "8d971" = predicates.contract_from_predicate
              definitions.predicate."8d971",
          "8d980" = predicates.contract_from_predicate
              definitions.predicate."8d980",
          "8e790" = predicates.contract_from_predicate
              definitions.predicate."8e790",
          "8f64c" = predicates.contract_from_predicate
              definitions.predicate."8f64c",
          "90d4b" = predicates.contract_from_predicate
              definitions.predicate."90d4b",
          "91edd" = predicates.contract_from_predicate
              definitions.predicate."91edd",
          "91f16" = predicates.contract_from_predicate
              definitions.predicate."91f16",
          "952c9" = predicates.contract_from_predicate
              definitions.predicate."952c9",
          "960ef" = predicates.contract_from_predicate
              definitions.predicate."960ef",
          "962c1" = predicates.contract_from_predicate
              definitions.predicate."962c1",
          "974c5" = predicates.contract_from_predicate
              definitions.predicate."974c5",
          "97baf" = predicates.contract_from_predicate
              definitions.predicate."97baf",
          "9a1f9" = predicates.contract_from_predicate
              definitions.predicate."9a1f9",
          "9acfe" = predicates.contract_from_predicate
              definitions.predicate."9acfe",
          "9b42a" = predicates.contract_from_predicate
              definitions.predicate."9b42a",
          "9b94b" = predicates.contract_from_predicate
              definitions.predicate."9b94b",
          "9d23c" = predicates.contract_from_predicate
              definitions.predicate."9d23c",
          "9dce0" = predicates.contract_from_predicate
              definitions.predicate."9dce0",
          a0f9c = predicates.contract_from_predicate
              definitions.predicate.a0f9c,
          a10be = predicates.contract_from_predicate
              definitions.predicate.a10be,
          a19ff = predicates.contract_from_predicate
              definitions.predicate.a19ff,
          a220f = predicates.contract_from_predicate
              definitions.predicate.a220f,
          a23f7 = predicates.contract_from_predicate
              definitions.predicate.a23f7,
          a2b96 = predicates.contract_from_predicate
              definitions.predicate.a2b96,
          a51de = predicates.contract_from_predicate
              definitions.predicate.a51de,
          a53a3 = predicates.contract_from_predicate
              definitions.predicate.a53a3,
          a5fab = predicates.contract_from_predicate
              definitions.predicate.a5fab,
          a665e = predicates.contract_from_predicate
              definitions.predicate.a665e,
          a6ab3 = predicates.contract_from_predicate
              definitions.predicate.a6ab3,
          a7419 = predicates.contract_from_predicate
              definitions.predicate.a7419,
          a8440 = predicates.contract_from_predicate
              definitions.predicate.a8440,
          a9048 = predicates.contract_from_predicate
              definitions.predicate.a9048,
          aad77 = predicates.contract_from_predicate
              definitions.predicate.aad77,
          ac708 = predicates.contract_from_predicate
              definitions.predicate.ac708,
          ad271 = predicates.contract_from_predicate
              definitions.predicate.ad271,
          adad4 = predicates.contract_from_predicate
              definitions.predicate.adad4,
          aebb7 = predicates.contract_from_predicate
              definitions.predicate.aebb7,
          af2c7 = predicates.contract_from_predicate
              definitions.predicate.af2c7,
          b0301 = predicates.contract_from_predicate
              definitions.predicate.b0301,
          b0b65 = predicates.contract_from_predicate
              definitions.predicate.b0b65,
          b1caa = predicates.contract_from_predicate
              definitions.predicate.b1caa,
          b1f6d = predicates.contract_from_predicate
              definitions.predicate.b1f6d,
          b2479 = predicates.contract_from_predicate
              definitions.predicate.b2479,
          b2d82 = predicates.contract_from_predicate
              definitions.predicate.b2d82,
          b3abd = predicates.contract_from_predicate
              definitions.predicate.b3abd,
          b4889 = predicates.contract_from_predicate
              definitions.predicate.b4889,
          b4b72 = predicates.contract_from_predicate
              definitions.predicate.b4b72,
          b509f = predicates.contract_from_predicate
              definitions.predicate.b509f,
          b5d87 = predicates.contract_from_predicate
              definitions.predicate.b5d87,
          b73a4 = predicates.contract_from_predicate
              definitions.predicate.b73a4,
          b88a6 = predicates.contract_from_predicate
              definitions.predicate.b88a6,
          b8a7b = predicates.contract_from_predicate
              definitions.predicate.b8a7b,
          b8d33 = predicates.contract_from_predicate
              definitions.predicate.b8d33,
          ba2d9 = predicates.contract_from_predicate
              definitions.predicate.ba2d9,
          bbbd7 = predicates.contract_from_predicate
              definitions.predicate.bbbd7,
          bbc08 = predicates.contract_from_predicate
              definitions.predicate.bbc08,
          bcf87 = predicates.contract_from_predicate
              definitions.predicate.bcf87,
          bd659 = predicates.contract_from_predicate
              definitions.predicate.bd659,
          bd6e5 = predicates.contract_from_predicate
              definitions.predicate.bd6e5,
          bdaa7 = predicates.contract_from_predicate
              definitions.predicate.bdaa7,
          be294 = predicates.contract_from_predicate
              definitions.predicate.be294,
          bf025 = predicates.contract_from_predicate
              definitions.predicate.bf025,
          bf151 = predicates.contract_from_predicate
              definitions.predicate.bf151,
          c0dc1 = predicates.contract_from_predicate
              definitions.predicate.c0dc1,
          c139b = predicates.contract_from_predicate
              definitions.predicate.c139b,
          c18ab = predicates.contract_from_predicate
              definitions.predicate.c18ab,
          c2452 = predicates.contract_from_predicate
              definitions.predicate.c2452,
          c3b11 = predicates.contract_from_predicate
              definitions.predicate.c3b11,
          c4168 = predicates.contract_from_predicate
              definitions.predicate.c4168,
          c49a5 = predicates.contract_from_predicate
              definitions.predicate.c49a5,
          c4a92 = predicates.contract_from_predicate
              definitions.predicate.c4a92,
          c55d3 = predicates.contract_from_predicate
              definitions.predicate.c55d3,
          c6ecb = predicates.contract_from_predicate
              definitions.predicate.c6ecb,
          c706a = predicates.contract_from_predicate
              definitions.predicate.c706a,
          c9f2a = predicates.contract_from_predicate
              definitions.predicate.c9f2a,
          cacc0 = predicates.contract_from_predicate
              definitions.predicate.cacc0,
          cb1c2 = predicates.contract_from_predicate
              definitions.predicate.cb1c2,
          cb919 = predicates.contract_from_predicate
              definitions.predicate.cb919,
          cd5c2 = predicates.contract_from_predicate
              definitions.predicate.cd5c2,
          cdf60 = predicates.contract_from_predicate
              definitions.predicate.cdf60,
          ce2b5 = predicates.contract_from_predicate
              definitions.predicate.ce2b5,
          ce8a4 = predicates.contract_from_predicate
              definitions.predicate.ce8a4,
          cf195 = predicates.contract_from_predicate
              definitions.predicate.cf195,
          d0551 = predicates.contract_from_predicate
              definitions.predicate.d0551,
          d12ef = predicates.contract_from_predicate
              definitions.predicate.d12ef,
          d1985 = predicates.contract_from_predicate
              definitions.predicate.d1985,
          d1a67 = predicates.contract_from_predicate
              definitions.predicate.d1a67,
          d240d = predicates.contract_from_predicate
              definitions.predicate.d240d,
          d5013 = predicates.contract_from_predicate
              definitions.predicate.d5013,
          d5dc9 = predicates.contract_from_predicate
              definitions.predicate.d5dc9,
          d60a5 = predicates.contract_from_predicate
              definitions.predicate.d60a5,
          d63e6 = predicates.contract_from_predicate
              definitions.predicate.d63e6,
          d6fe8 = predicates.contract_from_predicate
              definitions.predicate.d6fe8,
          d92db = predicates.contract_from_predicate
              definitions.predicate.d92db,
          d9f28 = predicates.contract_from_predicate
              definitions.predicate.d9f28,
          daa86 = predicates.contract_from_predicate
              definitions.predicate.daa86,
          dad40 = predicates.contract_from_predicate
              definitions.predicate.dad40,
          db003 = predicates.contract_from_predicate
              definitions.predicate.db003,
          db0d5 = predicates.contract_from_predicate
              definitions.predicate.db0d5,
          dbb1c = predicates.contract_from_predicate
              definitions.predicate.dbb1c,
          dc7e6 = predicates.contract_from_predicate
              definitions.predicate.dc7e6,
          dd53d = predicates.contract_from_predicate
              definitions.predicate.dd53d,
          decf8 = predicates.contract_from_predicate
              definitions.predicate.decf8,
          dfa4a = predicates.contract_from_predicate
              definitions.predicate.dfa4a,
          dfa5a = predicates.contract_from_predicate
              definitions.predicate.dfa5a,
          e231b = predicates.contract_from_predicate
              definitions.predicate.e231b,
          e2323 = predicates.contract_from_predicate
              definitions.predicate.e2323,
          e391e = predicates.contract_from_predicate
              definitions.predicate.e391e,
          e4921 = predicates.contract_from_predicate
              definitions.predicate.e4921,
          e4b54 = predicates.contract_from_predicate
              definitions.predicate.e4b54,
          e8c0c = predicates.contract_from_predicate
              definitions.predicate.e8c0c,
          e94dc = predicates.contract_from_predicate
              definitions.predicate.e94dc,
          ea732 = predicates.contract_from_predicate
              definitions.predicate.ea732,
          eaee8 = predicates.contract_from_predicate
              definitions.predicate.eaee8,
          ed3cd = predicates.contract_from_predicate
              definitions.predicate.ed3cd,
          ee197 = predicates.contract_from_predicate
              definitions.predicate.ee197,
          ee1ae = predicates.contract_from_predicate
              definitions.predicate.ee1ae,
          efabb = predicates.contract_from_predicate
              definitions.predicate.efabb,
          f06ea = predicates.contract_from_predicate
              definitions.predicate.f06ea,
          f1175 = predicates.contract_from_predicate
              definitions.predicate.f1175,
          f11ad = predicates.contract_from_predicate
              definitions.predicate.f11ad,
          f1384 = predicates.contract_from_predicate
              definitions.predicate.f1384,
          f146b = predicates.contract_from_predicate
              definitions.predicate.f146b,
          f26f2 = predicates.contract_from_predicate
              definitions.predicate.f26f2,
          f276a = predicates.contract_from_predicate
              definitions.predicate.f276a,
          f2cb9 = predicates.contract_from_predicate
              definitions.predicate.f2cb9,
          f4a62 = predicates.contract_from_predicate
              definitions.predicate.f4a62,
          f52d1 = predicates.contract_from_predicate
              definitions.predicate.f52d1,
          f5db4 = predicates.contract_from_predicate
              definitions.predicate.f5db4,
          f6782 = predicates.contract_from_predicate
              definitions.predicate.f6782,
          f9fcb = predicates.contract_from_predicate
              definitions.predicate.f9fcb,
          fa0cd = predicates.contract_from_predicate
              definitions.predicate.fa0cd,
          faf17 = predicates.contract_from_predicate
              definitions.predicate.faf17,
          fb03e = predicates.contract_from_predicate
              definitions.predicate.fb03e,
          fbf90 = predicates.contract_from_predicate
              definitions.predicate.fbf90,
          fe291 = predicates.contract_from_predicate
              definitions.predicate.fe291,
          fe737 = predicates.contract_from_predicate
              definitions.predicate.fe737,
          fe7b6 = predicates.contract_from_predicate
              definitions.predicate.fe7b6,
        },
    predicate = {
          "00571" = predicates.always,
          "00b39" = predicates.always,
          "00f15" = predicates.always,
          "015cb" = predicates.always,
          "01ff2" = predicates.always,
          "038dc" = predicates.always,
          "03ea7" = predicates.always,
          "048e3" = predicates.always,
          "04e4b" = predicates.always,
          "05c88" = predicates.always,
          "077d5" = predicates.always,
          "09338" = predicates.always,
          "09e40" = predicates.always,
          "0a52d" = predicates.always,
          "0b81c" = predicates.always,
          "0cca7" = predicates.always,
          "0cd26" = predicates.always,
          "0d2f3" = predicates.always,
          "0d894" = predicates.always,
          "0e921" = predicates.always,
          "0edfe" = predicates.always,
          "0f9b3" = predicates.always,
          "0fa26" = predicates.always,
          "0fc9e" = predicates.always,
          "1030e" = predicates.always,
          "13e53" = predicates.always,
          "159aa" = predicates.always,
          "16f14" = predicates.always,
          "170b6" = predicates.always,
          "172e4" = predicates.always,
          "17e6a" = predicates.always,
          "17e74" = predicates.always,
          "183d9" = predicates.always,
          "1934a" = predicates.always,
          "20152" = predicates.always,
          "21023" = predicates.always,
          "21f87" = predicates.always,
          "22ddc" = predicates.always,
          "23009" = predicates.always,
          "230ce" = predicates.always,
          "23778" = predicates.always,
          "252f0" = predicates.always,
          "26679" = predicates.always,
          "29b8a" = predicates.always,
          "2ae5f" = predicates.always,
          "2d92f" = predicates.always,
          "2ffc1" = predicates.always,
          "3071b" = predicates.always,
          "316e0" = predicates.always,
          "31725" = predicates.always,
          "31be0" = predicates.always,
          "3200b" = predicates.always,
          "34322" = predicates.always,
          "34d39" = predicates.always,
          "375dd" = predicates.always,
          "37850" = predicates.always,
          "37aed" = predicates.always,
          "37df6" = predicates.always,
          "38e8e" = predicates.always,
          "39ed5" = predicates.always,
          "3a966" = predicates.always,
          "3cca7" = predicates.always,
          "3dd98" = predicates.always,
          "3eaba" = predicates.always,
          "3ebec" = predicates.always,
          "405a8" = predicates.always,
          "40d65" = predicates.always,
          "42d39" = predicates.always,
          "45cf9" = predicates.always,
          "46542" = predicates.always,
          "47aa6" = predicates.always,
          "4909e" = predicates.always,
          "497d3" = predicates.always,
          "49dc4" = predicates.always,
          "4aae7" = predicates.always,
          "4b905" = predicates.always,
          "4b907" = predicates.always,
          "4de3d" = predicates.always,
          "4f5d5" = predicates.always,
          "4fa6d" = predicates.always,
          "51b90" = predicates.always,
          "5349d" = predicates.always,
          "535fe" = predicates.always,
          "55701" = predicates.always,
          "568cc" = predicates.always,
          "56a0f" = predicates.always,
          "56b2f" = predicates.always,
          "57928" = predicates.always,
          "58c94" = predicates.always,
          "5b3ba" = predicates.always,
          "5bc6c" = predicates.always,
          "5cec7" = predicates.always,
          "5d046" = predicates.always,
          "5d2a8" = predicates.always,
          "5e277" = predicates.always,
          "5f17a" = predicates.always,
          "60037" = predicates.always,
          "60f6d" = predicates.always,
          "6101e" = predicates.always,
          "619f7" = predicates.always,
          "62d94" = predicates.always,
          "63c85" = predicates.always,
          "64730" = predicates.always,
          "64979" = predicates.always,
          "6665e" = predicates.always,
          "66666" = predicates.always,
          "67ea2" = predicates.always,
          "6939d" = predicates.always,
          "698c3" = predicates.always,
          "69b41" = predicates.always,
          "6a522" = predicates.always,
          "6b85b" = predicates.always,
          "6c391" = predicates.always,
          "6c62c" = predicates.always,
          "6d6c1" = predicates.always,
          "6d767" = predicates.always,
          "6d907" = predicates.always,
          "6daff" = predicates.always,
          "6f0a1" = predicates.always,
          "70a7b" = predicates.always,
          "716b3" = predicates.always,
          "761e4" = predicates.always,
          "779cd" = predicates.always,
          "77df9" = predicates.always,
          "79394" = predicates.always,
          "796db" = predicates.always,
          "799e1" = predicates.always,
          "79a89" = predicates.always,
          "79d04" = predicates.always,
          "7c80e" = predicates.always,
          "7d7e4" = predicates.always,
          "7f50f" = predicates.always,
          "7ff67" = predicates.always,
          "81058" = predicates.always,
          "815f9" = predicates.always,
          "81bab" = predicates.always,
          "828be" = predicates.always,
          "843bf" = predicates.always,
          "844f0" = predicates.always,
          "8451c" = predicates.always,
          "84972" = predicates.always,
          "85495" = predicates.always,
          "85c8a" = predicates.always,
          "863d7" = predicates.always,
          "86b88" = predicates.always,
          "87cf9" = predicates.always,
          "883aa" = predicates.always,
          "896d0" = predicates.always,
          "8984d" = predicates.always,
          "8ab30" = predicates.always,
          "8ab6a" = predicates.always,
          "8af01" = predicates.always,
          "8b747" = predicates.always,
          "8bf53" = predicates.always,
          "8d374" = predicates.always,
          "8d971" = predicates.always,
          "8d980" = predicates.always,
          "8e790" = predicates.always,
          "8f64c" = predicates.always,
          "90d4b" = predicates.always,
          "91edd" = predicates.always,
          "91f16" = predicates.always,
          "952c9" = predicates.always,
          "960ef" = predicates.always,
          "962c1" = predicates.always,
          "974c5" = predicates.always,
          "97baf" = predicates.always,
          "9a1f9" = predicates.always,
          "9acfe" = predicates.always,
          "9b42a" = predicates.always,
          "9b94b" = predicates.always,
          "9d23c" = predicates.always,
          "9dce0" = predicates.always,
          a0f9c = predicates.always,
          a10be = predicates.always,
          a19ff = predicates.always,
          a220f = predicates.always,
          a23f7 = predicates.always,
          a2b96 = predicates.always,
          a51de = predicates.always,
          a53a3 = predicates.always,
          a5fab = predicates.always,
          a665e = predicates.always,
          a6ab3 = predicates.always,
          a7419 = predicates.always,
          a8440 = predicates.always,
          a9048 = predicates.always,
          aad77 = predicates.always,
          ac708 = predicates.always,
          ad271 = predicates.always,
          adad4 = predicates.always,
          aebb7 = predicates.always,
          af2c7 = predicates.always,
          b0301 = predicates.always,
          b0b65 = predicates.always,
          b1caa = predicates.always,
          b1f6d = predicates.always,
          b2479 = predicates.always,
          b2d82 = predicates.always,
          b3abd = predicates.always,
          b4889 = predicates.always,
          b4b72 = predicates.always,
          b509f = predicates.always,
          b5d87 = predicates.always,
          b73a4 = predicates.always,
          b88a6 = predicates.always,
          b8a7b = predicates.always,
          b8d33 = predicates.always,
          ba2d9 = predicates.always,
          bbbd7 = predicates.always,
          bbc08 = predicates.always,
          bcf87 = predicates.always,
          bd659 = predicates.always,
          bd6e5 = predicates.always,
          bdaa7 = predicates.always,
          be294 = predicates.always,
          bf025 = predicates.always,
          bf151 = predicates.always,
          c0dc1 = predicates.always,
          c139b = predicates.always,
          c18ab = predicates.always,
          c2452 = predicates.always,
          c3b11 = predicates.always,
          c4168 = predicates.always,
          c49a5 = predicates.always,
          c4a92 = predicates.always,
          c55d3 = predicates.always,
          c6ecb = predicates.always,
          c706a = predicates.always,
          c9f2a = predicates.always,
          cacc0 = predicates.always,
          cb1c2 = predicates.always,
          cb919 = predicates.always,
          cd5c2 = predicates.always,
          cdf60 = predicates.always,
          ce2b5 = predicates.always,
          ce8a4 = predicates.always,
          cf195 = predicates.always,
          d0551 = predicates.always,
          d12ef = predicates.always,
          d1985 = predicates.always,
          d1a67 = predicates.always,
          d240d = predicates.always,
          d5013 = predicates.always,
          d5dc9 = predicates.always,
          d60a5 = predicates.always,
          d63e6 = predicates.always,
          d6fe8 = predicates.always,
          d92db = predicates.always,
          d9f28 = predicates.always,
          daa86 = predicates.always,
          dad40 = predicates.always,
          db003 = predicates.always,
          db0d5 = predicates.always,
          dbb1c = predicates.always,
          dc7e6 = predicates.always,
          dd53d = predicates.always,
          decf8 = predicates.always,
          dfa4a = predicates.always,
          dfa5a = predicates.always,
          e231b = predicates.always,
          e2323 = predicates.always,
          e391e = predicates.always,
          e4921 = predicates.always,
          e4b54 = predicates.always,
          e8c0c = predicates.always,
          e94dc = predicates.always,
          ea732 = predicates.always,
          eaee8 = predicates.always,
          ed3cd = predicates.always,
          ee197 = predicates.always,
          ee1ae = predicates.always,
          efabb = predicates.always,
          f06ea = predicates.always,
          f1175 = predicates.always,
          f11ad = predicates.always,
          f1384 = predicates.always,
          f146b = predicates.always,
          f26f2 = predicates.always,
          f276a = predicates.always,
          f2cb9 = predicates.always,
          f4a62 = predicates.always,
          f52d1 = predicates.always,
          f5db4 = predicates.always,
          f6782 = predicates.always,
          f9fcb = predicates.always,
          fa0cd = predicates.always,
          faf17 = predicates.always,
          fb03e = predicates.always,
          fbf90 = predicates.always,
          fe291 = predicates.always,
          fe737 = predicates.always,
          fe7b6 = predicates.always,
        },
  }
in

predicates.contract_from_predicate
(predicates.allOf
[ predicates.isType 'Record, definitions.predicate."b2d82/full" ])