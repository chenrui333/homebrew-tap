class Kumo < Formula
  desc "Lightweight AWS service emulator written in Go"
  homepage "https://github.com/sivchari/kumo"
  url "https://github.com/sivchari/kumo/archive/refs/tags/v0.26.0.tar.gz"
  sha256 "3a601caace35221319c19d22347f4972a2a6d3d73c85d16631b0dc1d5cb6533e"
  license "MIT"
  head "https://github.com/sivchari/kumo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5aa55d4780dc665e992395f7d065a1372cb0ca678414a824a17c4f908ef9deb0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5aa55d4780dc665e992395f7d065a1372cb0ca678414a824a17c4f908ef9deb0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5aa55d4780dc665e992395f7d065a1372cb0ca678414a824a17c4f908ef9deb0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8af8cf75e9c18343ad7fabb91fb11d993b014068f485ee1378b346f574074dba"
    sha256 cellar: :any,                 x86_64_linux:  "dbd945109e99507577cae8dfadb916674a3bfa7d81bbe0164502df2b4e9cc8e2"
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
