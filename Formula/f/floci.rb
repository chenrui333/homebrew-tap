class Floci < Formula
  desc "Open-source local AWS emulator"
  homepage "https://github.com/floci-io/floci"
  url "https://github.com/floci-io/floci/archive/refs/tags/1.5.23.tar.gz"
  sha256 "0d0112cd80a4e1ff9f6575431a5759071d4e810f32e4e02751bfd858b3dbe26c"
  license "MIT"
  head "https://github.com/floci-io/floci.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "57ac73704fb117e7510ebb5a60302e0a17b2d1073f158171b80203ef8a2195c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73eecca6520e381d996bd1da32096002d2999e2f439d9a678028a3739e716bfd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2fbf52e3941119dd93b56bbb96cb1795cc47955f79f9593d29eb45eb123b7cfb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e8c3788786a18890503bde667630d58221d66ffb0c3c1a398a16fdcc455c52a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4d43a4005bc65a6d63b88735de4c73b6aa193903ac4d2be91de20cf2655db79"
  end

  depends_on "maven" => :build
  depends_on "openjdk@25"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("25")

    (var/"floci/data").mkpath

    system Formula["maven"].opt_bin/"mvn", "--batch-mode", "-DskipTests", "package"

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
