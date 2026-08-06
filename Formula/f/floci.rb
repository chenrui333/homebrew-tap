class Floci < Formula
  desc "Open-source local AWS emulator"
  homepage "https://github.com/floci-io/floci"
  url "https://github.com/floci-io/floci/archive/refs/tags/1.6.0.tar.gz"
  sha256 "d3f41d9d24405b5ccc30cf5c85fa5be214ee4983cabe756ba1a70502967f06a2"
  license "MIT"
  head "https://github.com/floci-io/floci.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9741061c923a842ce2e2c3a4acc018817d298f43510df46cc69129be6ab46a4e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11d46c0c7864ac53e9fb0d1afc72861ad9bab09770d56c3ff9373ad06fee4e7d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2fc2656d0fe979df14dea08d9de05301d4192ea5ee257076b0417d046e21c699"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3c9d53ba1bf90610f9e4487c1e01524982019f22174a343be56fb33dbbd9b66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "536912fced0c051555f10479cb73e0967d1951d9406c4c531a03ebec8b07e78b"
  end

  depends_on "maven" => :build
  depends_on "openjdk@25"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("25")

    (var/"floci/data").mkpath

    system formula_opt_bin("maven")/"mvn", "--batch-mode", "-DskipTests", "package"

    libexec.install Dir["target/quarkus-app/*"]
    (bin/"floci").write <<~SH
      #!/bin/bash
      export FLOCI_VERSION="#{version}"
      export JAVA_HOME="#{Language::Java.overridable_java_home_env("25")[:JAVA_HOME]}"
      exec "${JAVA_HOME}/bin/java" ${JAVA_OPTS:-} -jar "#{libexec}/quarkus-run.jar" "$@"
    SH
  end

  service do
    run [opt_bin/"floci"]
    keep_alive true
    working_dir var/"floci"
    log_path var/"log/floci.log"
    error_log_path var/"log/floci.log"
    environment_variables FLOCI_BASE_URL:                "http://localhost:4566",
                          FLOCI_STORAGE_MODE:            "persistent",
                          FLOCI_STORAGE_PERSISTENT_PATH: var/"floci/data",
                          QUARKUS_HTTP_PORT:             "4566"
  end

  test do
    port = free_port
    data_dir = testpath/"data"
    log = testpath/"floci.log"

    pid = spawn({ "FLOCI_BASE_URL"                => "http://127.0.0.1:#{port}",
                  "FLOCI_STORAGE_MODE"            => "persistent",
                  "FLOCI_STORAGE_PERSISTENT_PATH" => data_dir.to_s,
                  "QUARKUS_HTTP_PORT"             => port.to_s },
                bin/"floci",
                [:out, :err] => log.to_s)

    begin
      started = false
      60.times do
        started = quiet_system "curl", "-fsS", "http://127.0.0.1:#{port}/_floci/health"
        break if started

        sleep 1
      end
      unless started
        assert_path_exists log
        flunk log.read
      end

      output = shell_output("curl -fsS http://127.0.0.1:#{port}/_floci/health")
      assert_match "\"edition\":\"community\"", output
      assert_match "\"original_edition\":\"floci-always-free\"", output
      assert_match "\"version\":\"#{version}\"", output
      assert_match "\"s3\":\"running\"", output
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
