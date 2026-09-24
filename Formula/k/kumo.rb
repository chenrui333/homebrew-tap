class Kumo < Formula
  desc "Lightweight AWS service emulator written in Go"
  homepage "https://github.com/sivchari/kumo"
  url "https://github.com/sivchari/kumo/archive/refs/tags/v0.30.0.tar.gz"
  sha256 "a9ccd8872e68032a7a6071fe7c3230d78159262af30a34f3206e924e59c685eb"
  license "MIT"
  head "https://github.com/sivchari/kumo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "28f90c4af8c5d580a266b4fa5407076744ac4bb7e55d7c21750a3ace5b6a7fff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28f90c4af8c5d580a266b4fa5407076744ac4bb7e55d7c21750a3ace5b6a7fff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13082d6337db450bdd8bffa81c4cb63906e27f891c53c9dddb25b44a71e65aba"
    sha256 cellar: :any,                 x86_64_linux:  "85f9b50d6bdc7deeb77325389cd63a51a430d7e8b3ece5a808279b3bee4e8935"
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
