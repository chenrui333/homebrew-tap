class Floci < Formula
  desc "Open-source local AWS emulator"
  homepage "https://github.com/floci-io/floci"
  url "https://github.com/floci-io/floci/archive/refs/tags/2.4.0.tar.gz"
  sha256 "78bef604d3e913afd4a71541615b593de65657ba958f96e96e478790ae3b0736"
  license "MIT"
  head "https://github.com/floci-io/floci.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "203ddfc9c3f2b913eabab4d5b1307c441b4cc016cf2d9025ea8342cac11a0a83"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "203ddfc9c3f2b913eabab4d5b1307c441b4cc016cf2d9025ea8342cac11a0a83"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f23afd5dbba587936066dd1e3e023d75d8aa9b9d5a1ddc997ce3ebe57bc9ee9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f23afd5dbba587936066dd1e3e023d75d8aa9b9d5a1ddc997ce3ebe57bc9ee9"
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
