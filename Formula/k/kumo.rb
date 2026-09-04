class Kumo < Formula
  desc "Lightweight AWS service emulator written in Go"
  homepage "https://github.com/sivchari/kumo"
  url "https://github.com/sivchari/kumo/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "53bdf4c857eb6e37330a652a6c3074ebcf739b1a1f6a7a15611867a45d812457"
  license "MIT"
  head "https://github.com/sivchari/kumo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ba873052a8450f190f55c89607a69755e39602bfd7cbb9b536385fd82aecfde"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ba873052a8450f190f55c89607a69755e39602bfd7cbb9b536385fd82aecfde"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ba873052a8450f190f55c89607a69755e39602bfd7cbb9b536385fd82aecfde"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e9fbcb9da893c558cf29ff763b60f5dd6dac1f09d5ddb3f04adafa76ecf6525"
    sha256 cellar: :any,                 x86_64_linux:  "6e60ed14b02519cf0131be5f73737449f6de35a9345e17dbbcaaa07440395717"
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
