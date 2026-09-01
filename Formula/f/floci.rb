class Floci < Formula
  desc "Open-source local AWS emulator"
  homepage "https://github.com/floci-io/floci"
  url "https://github.com/floci-io/floci/archive/refs/tags/2.0.1.tar.gz"
  sha256 "29afee4c39be26990e88c38d7dd01aff90d6f418805528d0ab782d54fab028f7"
  license "MIT"
  head "https://github.com/floci-io/floci.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb9c89192543e94aaca3c1d7acbdb69a4aa143a8d35c49947abb31b54331afb6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2951a2a2cfbceb4605093e79549f3c52366e184107a89e2e695453e4b8956e26"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e613758ad00d39f4db71db5ec54d22380db8007ba7d3e2b85354bca37511de9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b7b277341540a6948ae3e7067b5905c613acc6a16349c39f5bec9bf3cc7453c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8521b00ce6b9f824a2af3d0b95447cd845bc9bfd3f982b3f593bf2e8f6f5d73b"
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
