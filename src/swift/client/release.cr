module Swift
  class Client
    # Defines methods related to release.
    #
    # See [https://appscode.com/products/swift/0.11.0/guides/api/](https://appscode.com/products/swift/0.11.0/guides/api/)
    module Release
      # Gets a list of all releases.
      #
      # - option params [String] :namespace [name of namespace] | EMPTY (for all namespaces)
      # - option params [String] :sort_by UNKNOWN | NAME | LAST_RELEASED
      # - option params [Bool] :all true | false
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
      # - return [JSON::Any] Status information for the specified release.
      #
      # ```
      # client.release_status("release_x")
      # ```
      def release_status(release : String) : JSON::Any
        get("/tiller/v2/releases/#{release}/status/json").parse
      end

      # Retrieves the release content (chart + value) for the specified release.
      #
      # - release [String] The name of the release.
      # - return [JSON::Any] Release content (chart + value) for the specified release.
      #
      # ```
      # client.release("release_x")
      # ```
      def release_content(release : String, format_values_as_json : Bool? = true, version : String? = nil) : JSON::Any
        get("/tiller/v2/releases/#{release}/content/json?format_values_as_json=#{format_values_as_json}&version=#{version}").parse
      end

      # Retrieves a releasse's history.
      #
      # - release [String] The name of the release.
      # - option max [Int32] The maximum number of releases to include.
      # - return [JSON::Any] Releasse's history.
      #
      # ```
      # client.release("release_x")
      # ```
      def release_history(release : String, max : Int32? = 20) : JSON::Any
        get("/tiller/v2/releases/#{release}/json?max=#{max}").parse
      end

      # Rolls back a release to a previous version
      #
      # - release [String] The name of the release.
      # - option params [Bool] :dry_run true | false
      # - option params [Bool] :disable_hooks true | false
      # - option params [Int32] :version the version of the release to deploy.
      # - option params [Bool] :recreate true | false
      # - option params [Bool] :wait true | false
      # - option params [Bool] :force true | false
      # - option params [Int64] :timeout true | false
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

      # Requests installation of a chart as a new release
      #
      # - release [String] The name of the release.
      # - json [JSON] JSON Body to send to Tiller.
      # - return [JSON::Any] Release content (chart + value) for the specified release.
      #
      # ```
      # client.install_release("release_x", "version_1")
      # ```
      def install_release(release : String, json : JSON::Any) : JSON::Any
        post("/tiller/v2/releases/#{release}/json", json: json).parse
      end

      # Updates release content.
      #
      # - release [String] The name of the release.
      # - json [JSON] JSON Body to send to Tiller.
      # - return [JSON::Any] Release content (chart + value) for the specified release.
      #
      # ```
      # client.update_release("release_x", "version_1")
      # ```
      def update_release(release : String, json : JSON::Any) : JSON::Any
        put("/tiller/v2/releases/#{release}/json", json: json).parse
      end

      # Requests deletion of a named release
      #
      # - release [String] The name of the release.
      # - option purge [Bool] removes the release from the store and make its name free for later use
      # - return [JSON::Any] Release content (chart + value) for the specified release.
      #
      # ```
      # client.uninstall_release("release_x", true)
      # ```
      def uninstall_release(release : String, purge : Bool? = nil) : JSON::Any
        delete("/tiller/v2/releases/#{release}/json?purge=#{purge}").parse
      end
    end
  end
end
