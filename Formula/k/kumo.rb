class Kumo < Formula
  desc "Lightweight AWS service emulator written in Go"
  homepage "https://github.com/sivchari/kumo"
  url "https://github.com/sivchari/kumo/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "aeb41bdc7e70a70643512409ab4281981add0078f05aba764c883a170eb74c30"
  license "MIT"
  head "https://github.com/sivchari/kumo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b304f5f705535cddf06df066d09efce99e98bcd173fc229739b06c3afa6630a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b304f5f705535cddf06df066d09efce99e98bcd173fc229739b06c3afa6630a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b304f5f705535cddf06df066d09efce99e98bcd173fc229739b06c3afa6630a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "339dac7b26fe7a3fc56ffd1cbdc47b08cf58f0999364300ab2b6c1c6fcf2faa3"
    sha256 cellar: :any,                 x86_64_linux:  "de713ecc42986483cd858ec34968ed0caf562c106bcac09e404503c15b5f3c3c"
  end

  depends_on "go" => :build

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
