class Kdash < Formula
  desc "Simple and fast dashboard for Kubernetes"
  homepage "https://kdash.cli.rs/"
  url "https://github.com/kdash-rs/kdash/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "2f856914fc2612857c880a0f2f76ecf458a845874a11c6d4bf6527155f96b44e"
  license "MIT"
  head "https://github.com/kdash-rs/kdash.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "875dde9d048b9addfed192f22a0d6df0278c45fc801c00d28c507046fee41f0f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "059fbe2da24e2aa7ce7a93d75c045d2852cff6d0983624b8c1119c9a49372dc7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c58928197274588c71239465f9cbc82ea953644a4c8cea05efe3f1ff8052f0ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d383713ca5330504ee28709174566042dc7fc0e9c233a29aad72c5d506895b81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5de271beab2f20845ee29b744c0d9d16946af6211d15dbcceabaeeaf904d0a8a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kdash --version")

    # failed with Linux CI, `No such device or address (os error 6)` error
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"kdash", [:out, :err] => output_log.to_s
      sleep 1
      output = output_log.read.gsub(%r{\e\[[\d;?]*[ -/]*[@-~]}, "")
      assert_match "Active Context", output
      assert_match "Resources", output
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
