class Lazycli < Formula
  desc "Turn static CLI commands into TUIs with ease"
  homepage "https://github.com/jesseduffield/lazycli"
  url "https://github.com/jesseduffield/lazycli/archive/refs/tags/v0.1.15.tar.gz"
  sha256 "66f4c4c5bedf4d3ceb35aebc1d7f18663c7250ac47241fea18108c0741bf2019"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "24d70a01cebfb8a71b0094990e3c5565a2b9c4ff7d6bcdb75fc4ff5b47266708"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af7004b94f866a54f2bfcfc865134d9c664017184fe5ac7dd5464fb8c3cef9f3"
    sha256 cellar: :any,                 arm64_linux:   "9ed883c3d8a61c2630875727fd081b7db6a4ba07a68f3e044f1dae2e09611f6f"
    sha256 cellar: :any,                 x86_64_linux:  "ed0efb981374aedb8c142b71102b336b0924556c84865bcee5afc338e66ee132"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.major_minor.to_s, shell_output("#{bin}/lazycli --version")

    # Fails in Linux CI with `No such device or address`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"lazycli", "--", "ls", "-l", testpath, [:out, :err] => output_log.to_s
      sleep 1
      assert_match "No profile selected", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
