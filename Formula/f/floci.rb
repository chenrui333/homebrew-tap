class Floci < Formula
  desc "Open-source local AWS emulator"
  homepage "https://github.com/floci-io/floci"
  url "https://github.com/floci-io/floci/archive/refs/tags/2.2.0.tar.gz"
  sha256 "9f577157debed49156cb5d55007d9ebe028fb6bcbb84842eec8a715942a88c10"
  license "MIT"
  head "https://github.com/floci-io/floci.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "45259e276d0257ede52e6ae4815d7ce03b16ae331e67469d421f26d96396fb28"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45259e276d0257ede52e6ae4815d7ce03b16ae331e67469d421f26d96396fb28"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "87027c76ebb06fccd31d2c3853840c63116b1ba2f9da9e74df5cffd7e8ea16df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87027c76ebb06fccd31d2c3853840c63116b1ba2f9da9e74df5cffd7e8ea16df"
  end

  depends_on "maven" => :build
  depends_on "openjdk@25"

  allow_network_access! :test

  def fetch
    ENV["JAVA_HOME"] = Language::Java.java_home("25")

    system formula_opt_bin("maven")/"mvn", "--batch-mode", "-DskipTests", "package"
  end

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("25")

    (var/"floci/data").mkpath

    system formula_opt_bin("maven")/"mvn", "--batch-mode", "--offline", "-DskipTests", "package"

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
