class Floci < Formula
  desc "Open-source local AWS emulator"
  homepage "https://github.com/floci-io/floci"
  url "https://github.com/floci-io/floci/archive/refs/tags/1.5.12.tar.gz"
  sha256 "7edce9f19eb5c60df6e6a080ae7bbc2dfb3a6add3c4050abf65932ab27587ccd"
  license "MIT"
  head "https://github.com/floci-io/floci.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e2b576c7c2b68252a8e1943dfd059812425ba39a182e5b548b3403e9a9ecb00b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90c3b7500aaec846c5cd3f52a61c27be64886de4425fadfbb7a64b81ef1341ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d725f744bab01f127901ab00459dcbc7cb5afb54c0111334e838fecef47087f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11aecaf55f99802f05170b7d266566e2c092e3aa46146ca1c8d4b2b1a5a74f83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "869d8b9912bce02c4fb9fdb0b46c1182c2091a9b968157a3b2d3fc4a1602dbd4"
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
