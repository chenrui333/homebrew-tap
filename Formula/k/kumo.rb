class Kumo < Formula
  desc "Lightweight AWS service emulator written in Go"
  homepage "https://github.com/sivchari/kumo"
  url "https://github.com/sivchari/kumo/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "878dce52862bd0ae97de985d231954611918df6b11157f5aa616faea5f334863"
  license "MIT"
  head "https://github.com/sivchari/kumo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a192756968eee24dbd280f025c4a12bd4244e6bb13564a64fd6767998500d4c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a192756968eee24dbd280f025c4a12bd4244e6bb13564a64fd6767998500d4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a192756968eee24dbd280f025c4a12bd4244e6bb13564a64fd6767998500d4c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d6377939038c8a1476eeb4c840a8c54f43d82474d0eabe1de5a6582667e4058"
    sha256 cellar: :any,                 x86_64_linux:  "a73c105edc9b4bd4b38cb90ee095bfda690e029cdff8128e5ed92f4148f3a945"
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
