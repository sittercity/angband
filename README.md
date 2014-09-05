
Rack middleware that renders the Gherkin features of your API endpoints.

### Configuration

1. Specify the applicable feature files:

   ```ruby
   require 'api-documentation'

   use Documentation::ApiDocumentor do |docs|
     docs.configure Dir['features/**/*.feature']
   end
   ```

2. Annotate your features with the URI path to which they apply:

   ```gherkin
   @/api/status
   Feature: Status of the API
   ```

   Use regular expressions to match variable paths:

   ```gherkin
   @/api/message/\d+
   Feature: Read a single message
   ```

3. Configure your application to respond successfully to an HTTP `OPTIONS` request.

While this middleware sets the response `Content-Type` and body, any other headers
[should be added by the application](http://tools.ietf.org/html/rfc7231#section-4.3.7),
e.g. the [`Allow` header](http://tools.ietf.org/html/rfc7231#section-7.4.1).
