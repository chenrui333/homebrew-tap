class Pproftui < Formula
  desc "TUI for Go pprof data"
  homepage "https://github.com/Oloruntobi1/pproftui"
  url "https://github.com/Oloruntobi1/pproftui/archive/d94a02c55dcdfc0bd2617acc9a1b98079bf990d8.tar.gz"
  version "0.0.1"
  sha256 "1538131099b317c33c7b0864aee888dd2c8af18e330734a751d3b22d0c81c379"
  license "MIT"
  head "https://github.com/Oloruntobi1/pproftui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "25c3fb18edd058546efef9406060aac9d3df6266a9e896b9bc99f4819f2a109f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25c3fb18edd058546efef9406060aac9d3df6266a9e896b9bc99f4819f2a109f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25c3fb18edd058546efef9406060aac9d3df6266a9e896b9bc99f4819f2a109f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d64a4cf7fd6e7fd3a04ad0246017f80150ca6eda5cca47908ba9871d6408edc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b938a312c73a373f47853c0533cf14154ddcf00f55a610e1f84b7bcffa9e809f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "Usage of", shell_output("#{bin}/pproftui -h 2>&1")

    resource "test_profile" do
      url "https://github.com/parca-dev/parca/raw/refs/heads/main/pkg/symbolizer/testdata/normal-cpu.stripped.pprof"
      sha256 "6e6087cf6a592f40a669aa7f96c38a2220cf5fc4006d6f89848666a859dad39b"
    end

    testpath.install resource("test_profile")

    output_log = testpath/"output.log"
    pid = if OS.mac?
      spawn "script", "-q", File::NULL,
            bin/"pproftui", testpath/"normal-cpu.stripped.pprof",
            [:out, :err] => output_log.to_s
    else
      spawn "script", "-q", "-c", "#{bin}/pproftui #{testpath}/normal-cpu.stripped.pprof", File::NULL,
            [:out, :err] => output_log.to_s
    end

    sleep 2
    Process.kill("TERM", pid) if Process.waitpid(pid, Process::WNOHANG).nil?
    Process.wait(pid)

    output = output_log.read
    assert_match "\e[?1049h", output
    refute_match "No such device or address", output
  rescue Errno::ESRCH
    output = output_log.exist? ? output_log.read : ""
    assert_match "\e[?1049h", output
    refute_match "No such device or address", output
  end
end
