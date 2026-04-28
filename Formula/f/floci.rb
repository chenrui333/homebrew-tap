class Floci < Formula
  desc "Open-source local AWS emulator"
  homepage "https://github.com/floci-io/floci"
  url "https://github.com/floci-io/floci/archive/refs/tags/1.5.9.tar.gz"
  sha256 "43eb3862880eae3208b5ffbb0359d98b3d657b58dcf82774c62ee213a5c9d03a"
  license "MIT"
  head "https://github.com/floci-io/floci.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe4288962f56f500f20b7ca8d8cfa2be4323dc6ca8b58855707d0307fa28f311"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "381f8c781d778806ec73be8923522455139f33b700d0254a03ed1b870d15f73b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61e65336afa84a0e7e513de6a8e6b65aa63141ebfb6e66ced66ffa7cd3d33769"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b101e75f5d38852f28bd5d18ebfb93edd50601ae0f66967cd6816b77e098318"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb267518a8a55a97585b12c8a5cb64376a3fcfee78485d4e0e90574a6c021b38"
  end

  depends_on "maven" => :build
  depends_on "openjdk"

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
      20.times do
        break if quiet_system "curl", "-fsS", "http://127.0.0.1:#{port}/_floci/health"

        sleep 1
      end

      output = shell_output("curl -fsS http://127.0.0.1:#{port}/_floci/health")
      assert_match "\"edition\":\"floci-always-free\"", output
      assert_match "\"version\":\"#{version}\"", output
      assert_match "\"s3\":\"running\"", output
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
