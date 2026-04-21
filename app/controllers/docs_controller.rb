class DocsController < ApplicationController
     def user_documentation
          send_markdown_file!("user_documentation.md")
     end

     def technical_documentation
          send_markdown_file!("technical_documentation.md")
     end

  private

       def send_markdown_file!(filename)
            path = Rails.root.join("docs", filename)
            raise ActionController::RoutingError, "Not Found" unless File.exist?(path)

            send_file path, type: "text/markdown; charset=utf-8", disposition: "inline"
       end
end
