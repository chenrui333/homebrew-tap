class Kumo < Formula
  desc "Lightweight AWS service emulator written in Go"
  homepage "https://github.com/sivchari/kumo"
  url "https://github.com/sivchari/kumo/archive/refs/tags/v0.33.1.tar.gz"
  sha256 "1c6aad78d914fa886713ad4a0d78d25075ff7c0aaa22364e8214503148e20d37"
  license "MIT"
  head "https://github.com/sivchari/kumo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b9de4bbe41c21a4d351f4195e240e781c95e5c4694071c0947ef2e5bff0d44ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9de4bbe41c21a4d351f4195e240e781c95e5c4694071c0947ef2e5bff0d44ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f8f46c69c5acaf2d5b92a3a8d8c028c8ed77387890011cb6d50db6a2d374e97"
    sha256 cellar: :any,                 x86_64_linux:  "357df0a37cc5d0000d65adfb4f84cf0a38ebce5f475820acc163f57b8d49f28e"
  end

  depends_on "go" => :build

  # kumo is a local AWS emulator server; the test checks its loopback health endpoint.
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    (var/"kumo").mkpath

    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/kumo"
  end

  service do
    run [opt_bin/"kumo"]
    keep_alive true
    working_dir var/"kumo"
    environment_variables KUMO_DATA_DIR: var/"kumo"
  end

  test do
    log_file = testpath/"kumo.log"
    data_dir = testpath/"data"

    pid = spawn({ "KUMO_DATA_DIR" => data_dir.to_s },
                bin/"kumo",
                [:out, :err] => log_file.to_s)

    begin
      15.times do
        break if quiet_system "curl", "-fsS", "http://127.0.0.1:4566/health"

        sleep 1
      end

      assert_match '{"status":"healthy"}', shell_output("curl -fsS http://127.0.0.1:4566/health")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
