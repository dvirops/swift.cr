module Swift
  class Client
    # Defines methods related to release.
    #
    # See [https://appscode.com/products/swift/0.11.0/guides/api/](https://appscode.com/products/swift/0.11.0/guides/api/)
    module Release
      # Retrieves a list of all releases.
      #
      # - option params [Bool] :all true | false
      # - option params [String] :filter A regular expression used to filter which releases should be listed. Anything that matches the regexp will be included in the results.
      # - option params [Int64] :limit The maximum number of releases to be returned
      # - option params [String] :namespace [name of namespace] | EMPTY (for all namespaces)
      # - option params [String] :offset Offset is the last release name that was seen. The next listing operation will start with the name after this one. Example: If list one returns albert, bernie, carl, and sets 'next: dennis'. dennis is the offset. Supplying 'dennis' for the next request should cause the next batch to return a set of results starting with 'dennis'.
      # - option params [String] :sort_by UNKNOWN | NAME | LAST_RELEASED
      # - option params [String] :sort_order ASC | DESC
      # - option params [String] :status_codes UNKNOWN | DEPLOYED | DELETED | SUPERSEDED | FAILED | DELETING
      # - return [JSON::Any] List of all releases.
      #
      # ```
      # client.releases
      # client.releases(params: {namespace: "development", all: true})
      # client.releases(params: {sort_order: "ASC", status_codes: "DEPLOYED"})
      # ```
      def releases(params : (Hash(String, _) | NamedTuple)? = nil) : JSON::Any
        get("/tiller/v2/releases/json", params: params).parse
      end

      # Retrieves status information for the specified release.
      #
      # - release [String] The name of the release.
      # - option params [String] :version Version of the release.
      # - return [JSON::Any] Status information for the specified release.
      #
      # ```
      # client.release_status("release_x")
      # ```
      def release_status(release : String, params : (Hash(String, _) | NamedTuple)? = nil) : {JSON::Any, JSON::Any | Nil}
        status_response = get("/tiller/v2/releases/#{release}/status/json", params: params).parse
        return status_response, parse_status_resources(status_response)
      end

      # Retrieves the release content (chart + value) for the specified release.
      #
      # - release [String] The name of the release.
      # - option params [Bool] :format_values_as_json Format release config and values to JSON string.
      # - option params [String] :version Version of the release.
      # - return [JSON::Any] Release content (chart + value) for the specified release.
      #
      # ```
      # client.release("release_x")
      # ```
      def release_content(release : String, params : (Hash(String, _) | NamedTuple)? = nil) : JSON::Any
        get("/tiller/v2/releases/#{release}/content/json", params: params).parse
      end

      # Retrieves a releasse's history.
      #
      # - release [String] The name of the release.
      # - option params [Int32] :max The maximum number of releases to include. defaults to 20.
      # - return [JSON::Any] Releasse's history.
      #
      # ```
      # client.release("release_x")
      # ```
      def release_history(release : String, params : (Hash(String, _) | NamedTuple)? = nil) : JSON::Any
        get("/tiller/v2/releases/#{release}/json", params: params).parse
      end

      # Rolls back a release to a previous version
      #
      # - release [String] The name of the release.
      # - option params [Bool] :disable_hooks Causes the server to skip running any hooks for the rollback.
      # - option params [Bool] :dry_run If true, will run through the release logic but no create.
      # - option params [Bool] :force Force resource update through delete/recreate if needed.
      # - option params [Bool] :recreate Performs pods restart for resources if applicable.
      # - option params [Int64] :timeout Specifies the max amount of time any kubernetes client command can run.
      # - option params [Int32] :version the version of the release to deploy.
      # - option params [Bool] :wait if true, will wait until all Pods, PVCs, and Services are in a ready state before marking the release as successful. It will wait for as long as timeout.
      # - return [JSON::Any] Release content (chart + value) for the specified release.
      #
      # ```
      # client.rollback_release("release_x")
      # client.rollback_release("release_x", params: {dry_run: true, force: true})
      # client.rollback_release("release_x", params: {timeout: 1000, recreate: true})
      # ```
      def rollback_release(release : String, params : (Hash(String, _) | NamedTuple)? = nil) : JSON::Any
        get("/tiller/v2/releases/#{release}/rollback/json", params: params).parse
      end

      # Requests installation of a chart as a new release.
      #
      # - release [String] The name of the release.
      # - json [String] :ca_bundle PEM encoded CA bundle used to sign server certificate of chart repository.
      # - json [String] :chart A helm package that contains metadata, a default config, zero or more. optionally parameterizable templates, and zero or more charts (dependencies).
      # - json [String] :chart_url URL to download chart archive.
      # - json [String] :client_certificate PEM-encoded data passed as a client cert to chart repository.
      # - json [String] :client_key PEM-encoded data passed as a client key to chart repository.
      # - json [Bool] :disable_hooks Causes the server to skip running any hooks for the install.
      # - json [Bool] :dry_run if true, will run through the release logic, but neither create a release object nor deploy to Kubernetes. The release object returned in the response will be fake.
      # - json [Bool] :insecure_skip_verify Skip certificate verification for chart repository.
      # - json [String] :namespace The kubernetes namespace of the release.
      # - json [String] :password The password for basic authentication to the chart repository.
      # - json [Bool] :reuse_name Requests that Tiller re-uses a name, instead of erroring out.
      # - json [Int64] :timeout Specifies the max amount of time any kubernetes client command can run.
      # - json [String] :token The bearer token for authentication to the chart repository.
      # - json [String] :username The username for basic authentication to the chart repository.
      # - json [Hash] :values Supplies values to the parametrizable templates of a chart.
      # - json [Bool] :wait if true, will wait until all Pods, PVCs, and Services are in a ready state before marking the release as successful. It will wait for as long as timeout.
      # - return [JSON::Any] Release content (chart + value) for the specified release.
      #
      # ```
      # client.install_release("release_x", form: {"chart_url" => "https://github.com/tamalsaha/test-chart/raw/master/test-chart-0.1.0.tgz"})
      # client.install_release("release_x", form: {"chart_url" => "https://chartmuseum.com/my-release/test-chart-0.1.0.tgz", "username" => "user_x", "password" => "xxx"}) # username and password are for the private chartmuseum
      # client.install_release("release_x", form: {"chart_url" => "stable/fluent-bit"})
      # client.install_release("release_x", form: {"chart_url" => "stable/fluent-bit/0.1.2"})
      # ```
      def install_release(release : String, form : (Hash(String, _) | NamedTuple)) : JSON::Any
        post("/tiller/v2/releases/#{release}/json", json: form).parse
      end

      # Updates release content.
      #
      # - release [String] The name of the release.
      # - json [String] :ca_bundle PEM encoded CA bundle used to sign server certificate of chart repository.
      # - json [String] :chart A helm package that contains metadata, a default config, zero or more. optionally parameterizable templates, and zero or more charts (dependencies).
      # - json [String] :chart_url URL to download chart archive.
      # - json [String] :client_certificate PEM-encoded data passed as a client cert to chart repository.
      # - json [String] :client_key PEM-encoded data passed as a client key to chart repository.
      # - json [Bool] :disable_hooks Causes the server to skip running any hooks for the upgrade.
      # - json [Bool] :dry_run if true, will run through the release logic, but neither create a release object nor deploy to Kubernetes. The release object returned in the response will be fake.
      # - json [Bool] :insecure_skip_verify Skip certificate verification for chart repository.
      # - json [String] :namespace The kubernetes namespace of the release.
      # - json [String] :password The password for basic authentication to the chart repository.
      # - json [Bool] :reuse_name Requests that Tiller re-uses a name, instead of erroring out.
      # - json [Int64] :timeout Specifies the max amount of time any kubernetes client command can run.
      # - json [String] :token The bearer token for authentication to the chart repository.
      # - json [String] :username The username for basic authentication to the chart repository.
      # - json [Hash] :values Supplies values to the parametrizable templates of a chart.
      # - json [Bool] :wait if true, will wait until all Pods, PVCs, and Services are in a ready state before marking the release as successful. It will wait for as long as timeout.
      # - json [JSON] JSON Body to send to Tiller.
      # - return [JSON::Any] Release content (chart + value) for the specified release.
      #
      # ```
      # client.update_release("release_x", form: {"chart_url" => "https://github.com/tamalsaha/test-chart/raw/master/test-chart-0.1.0.tgz"})
      # client.update_release("release_x", form: {"chart_url" => "https://chartmuseum.com/my-release/test-chart-0.1.0.tgz", "username" => "user_x", "password" => "xxx"}) # username and password are for the private chartmuseum
      # client.update_release("release_x", form: {"chart_url" => "stable/fluent-bit"})
      # client.update_release("release_x", form: {"chart_url" => "stable/fluent-bit/0.1.2"})
      # ```
      def update_release(release : String, form : (Hash(String, _) | NamedTuple)) : JSON::Any
        put("/tiller/v2/releases/#{release}/json", json: form).parse
      end

      # Requests deletion of a named release
      #
      # - release [String] The name of the release.
      # - option params [Bool] :disable_hooks causes the server to skip running any hooks for the uninstall.
      # - option params [Bool] :purge Removes the release from the store and make its name free for later use.
      # - option params [Int64] :timeout Specifies the max amount of time any kubernetes client command can run.
      # - return [JSON::Any] Release content (chart + value) for the specified release.
      #
      # ```
      # client.uninstall_release("release_x", params: {"purge" => true, "disable_hooks" => true, "timeout" => 50})
      # ```
      def uninstall_release(release : String, params : (Hash(String, _) | NamedTuple)? = nil) : JSON::Any
        delete("/tiller/v2/releases/#{release}/json", params: params).parse
      end

      def parse_status_resources(status_response)
        if !status_response["info"]["status"]["resources"]?.nil?
          array = Hash(String, Array(NamedTuple(name: String, status: String, restarts: String))).new
          resources = status_response["info"]["status"]["resources"].to_s.split("\n\n")
          if resources.size > 1
            resources.each do |section|
              lines = section.split("\n")
              name = ""
              lines.each do |line|
                line = line.split("\n")[0]
                if line
                  if line.starts_with?("==>")
                    name = line[4...line.size].split("(")[0]
                  end

                  if !line.starts_with?("NAME") && !line.starts_with?("==>")
                    trimmed_line = line.split
                    if trimmed_line.size > 2
                      hash = NamedTuple.new(name: trimmed_line[0], status: trimmed_line[2], restarts: trimmed_line[3])
                      if array.has_key?(name)
                        array[name] << hash
                      else
                        array[name] = [hash]
                      end
                    end
                  end
                end
              end
            end
            JSON.parse(array.to_json)
          else
            JSON.parse("{}")
          end
        else
          JSON.parse("{}")
        end
      end
    end
  end
end
