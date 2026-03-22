class Tmmpr < Formula
  desc "Terminal mind mapper"
  homepage "https://github.com/tanciaku/tmmpr"
  url "https://github.com/tanciaku/tmmpr/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "e15eb43872484147c2c9b54f618c8fb8a96d0d013e120d06e9d80a25ea0d42ec"
  license "MIT"
  head "https://github.com/tanciaku/tmmpr.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f477d4cf4f3de7b41e1229de29d942cc643c8ae4c03debbe41719244d3e9fff5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7904848bbf88f0a852d844612506da9f9005bb3342a1e28e4d26cd0399da3a31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "afcf3cc25e44e65b78c0bf5833c7da66c71f429d07111f63572754f067bed77b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4209599296d84ff79b9f3f0c4dfa5e226c987dda38da78af9c221b7e4124af6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e0b5804943a2b0d05577165f769912c3f61f3686b2eb50ff97e2f42ad69a74d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output_log = testpath/"tmmpr.log"
    pid = if OS.mac?
      spawn "script", "-q", File::NULL, bin/"tmmpr", [:out, :err] => output_log.to_s
    else
      spawn "script", "-q", "-c", bin/"tmmpr", File::NULL, [:out, :err] => output_log.to_s
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
