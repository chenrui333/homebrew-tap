class Kumo < Formula
  desc "Lightweight AWS service emulator written in Go"
  homepage "https://github.com/sivchari/kumo"
  url "https://github.com/sivchari/kumo/archive/refs/tags/v0.26.0.tar.gz"
  sha256 "3a601caace35221319c19d22347f4972a2a6d3d73c85d16631b0dc1d5cb6533e"
  license "MIT"
  head "https://github.com/sivchari/kumo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b02a2964b1391fbe5dc08775ff83d37196ee578018132ef5afb4a7ee013cee17"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b02a2964b1391fbe5dc08775ff83d37196ee578018132ef5afb4a7ee013cee17"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b02a2964b1391fbe5dc08775ff83d37196ee578018132ef5afb4a7ee013cee17"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8faca7ee6f54a7434306c18d7ce030c5f3a77a1de2564f62e9f80c8205d28c6"
    sha256 cellar: :any,                 x86_64_linux:  "cbefb4adcb1f0170f1068cc59550156d5897f3888dc7214df3d256fd9ae8d34c"
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
