class Kumo < Formula
  desc "Lightweight AWS service emulator written in Go"
  homepage "https://github.com/sivchari/kumo"
  url "https://github.com/sivchari/kumo/archive/refs/tags/v0.31.0.tar.gz"
  sha256 "7b19a95068e1d08646576fcc891002deb7abafda10542d3638228a7d895c1d61"
  license "MIT"
  head "https://github.com/sivchari/kumo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c1ce8d1c894fef3a2531549085a6ade1176801e666fe708721e30c59093b8207"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1ce8d1c894fef3a2531549085a6ade1176801e666fe708721e30c59093b8207"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6137d6504f32fef9e51499c408f2997a4c2626cbdc7f2629fbe370de3f6fe988"
    sha256 cellar: :any,                 x86_64_linux:  "6da42bbb643f823f46c01995f4828a4c037f25146a713f25f1865e298cb33b83"
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
