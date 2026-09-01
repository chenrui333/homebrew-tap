class Kumo < Formula
  desc "Lightweight AWS service emulator written in Go"
  homepage "https://github.com/sivchari/kumo"
  url "https://github.com/sivchari/kumo/archive/refs/tags/v0.28.1.tar.gz"
  sha256 "ef44ca39129efc62df611408fcbff99e0314176588f2b82416a39603c7203922"
  license "MIT"
  head "https://github.com/sivchari/kumo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "275acc988e26070ed0b4b016fb9756b92516024c34a32601986f59dd9552a5bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "275acc988e26070ed0b4b016fb9756b92516024c34a32601986f59dd9552a5bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "275acc988e26070ed0b4b016fb9756b92516024c34a32601986f59dd9552a5bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b35cc56fd479b5eee0101f0ccb3a3282b309a795365ebc25972489fcc041a79"
    sha256 cellar: :any,                 x86_64_linux:  "708f222e98642a4338936f818f3cf5cd14c83831176c6a7da5e78cfc5cfc77af"
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
