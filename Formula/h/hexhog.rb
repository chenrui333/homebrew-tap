class Hexhog < Formula
  desc "Hex viewer/editor"
  homepage "https://github.com/DVDTSB/hexhog"
  url "https://github.com/DVDTSB/hexhog/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "5858dcb32b3f12647784c9a6ba2e107e157b9a82884bcfed3e994a70c7584b29"
  license "MIT"
  head "https://github.com/DVDTSB/hexhog.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9291a845c224cf51cc70230db5099abb7de27a21395c499da5e67f34c4f56301"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76896020751f70a85c76ca49cc79af2fe21c434f443d8712318bb26adbeb1481"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee18f38eda04c08a62c3b952b16a6c3caeb0c01524c4ceef1da1a242529c90ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ef5103ce975b10232559a92e82a5272e0de9061d92d99446d65bcc237606899"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ec533634d5c3bd458e5770dd1499d140dc22fac3d4deafb50001b1b8a109cd3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hexhog --version")

    # Fails in Linux CI with `No such device or address (os error 6)` error
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath/"output.log"

      (testpath/"testfile").write("Hello, Hexhog!")
      pid = spawn bin/"hexhog", testpath/"testfile", [:out, :err] => output_log.to_s
      sleep 1
      assert_match "hexhog", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
